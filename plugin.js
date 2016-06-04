SocketPlugins = module.parent.require('./socket.io/plugins');
topics = module.parent.require('./topics');
posts = module.parent.require('./posts');
user = module.parent.require('./user');
db = module.parent.require('./database');
privileges = module.parent.require('./privileges');
async = module.parent.require('async');
meta = module.parent.require('./meta');
helpers = module.parent.require('./controllers/helpers');
utils = module.parent.require('../public/src/utils');
translator = require.main.require('./public/src/modules/translator');
S = require('string');

var newsPlugin = {};
var pluginName = "nodebb-plugin-news";

newsPlugin.init = function(params, callback) {
	console.log(pluginName + ":init");
	var router = params.router;
	var middleware = params.middleware;
	router.get('/news', middleware.buildHeader, newsPlugin.render);
	router.get('/news/:page', middleware.buildHeader, newsPlugin.render);
	router.get('/api/news', newsPlugin.render);
	router.get('/api/news/:page', newsPlugin.render);
	handleSocketIO();
	callback();
};

newsPlugin.activate = function(id) {
	if (id === pluginName) {
		console.log(pluginName + ":activate");
	}
};

newsPlugin.deactivate = function(id) {
	if (id === pluginName) {
		console.log(pluginName + ":deactivate");
	}
};

newsPlugin.renderHomepage = function(params) {
	newsPlugin.render(params.req, params.res, params.next);
};

newsPlugin.render = function(req, res, next) {
	var topicsPerPage = parseInt(meta.config.topicsPerList, 10) || 20;
	var currentPage = parseInt(req.params.page, 10) || 1;
	var nextPage = 1;
	var prevPage = 1;
	var pages = [];
	async.waterfall([function (next) {
		db.sortedSetCount('topics:news', '-inf', '+inf', next);
	},
	function (topicCount, next) {
		var pageCount = Math.max(1, Math.ceil(topicCount / topicsPerPage));
		if (currentPage < 1) {
			currentPage = 1;
		}
		if (currentPage > pageCount) {
			currentPage = pageCount;
		}
		var start = (currentPage - 1) * topicsPerPage;
		var stop = currentPage * topicsPerPage - 1;
		nextPage = currentPage === pageCount ? false : currentPage + 1;
		prevPage = currentPage === 1 ? false : currentPage - 1;
		if (pageCount > 1) {
			for (var number = 1; number <= pageCount; number++) {
				var _page = {number: number};
				if (number === currentPage) _page.currentPage = true;
				pages.push(_page);
			}
		}
		topics.getTopicsFromSet('topics:news', req.uid, start, stop, next);
	},
	function (data, next) {
		if (!Array.isArray(data.topics) || !data.topics.length) {
			return next(null, data);
		}
		var mainPids = [];
		data.topics.forEach(function(topic) {
			if (topic) {
				mainPids.push(topic.mainPid);
			}
		});
		posts.getPostsByPids(mainPids, req.uid, function (err, posts) {
			if (err) {
				return next(err);
			}
			for (var i = 0; i < data.topics.length; ++i) {
				if (data.topics[i]) {
					data.topics[i].mainPost = posts[i];
				}
			}
			next(null, data);
		});
	},
	function (data, next) {
		translator.translate('[[global:home]]', function(translated) {
			data.title = translated;
			next(null, data);
		});
	}], function (err, data) {
		if (err) {
			return next(err);
		}
		data.nextPage = nextPage;
		data.prevPage = prevPage;
		data.pages = pages;
		res.render('news', data);
	});
};

newsPlugin.addThreadTools = function(data, callback) {
	privileges.topics.isAdminOrMod(data.topic.tid, data.uid, function(err, isAdminOrMod) {
		var isNews = parseInt(data.topic.isNews, 10);
		if (isAdminOrMod) {
			if (isNews) {
				data.tools.push({
					"title": "Remove News",
					"class": "toggle-mark-news",
					"icon": "fa-star-o"
				});
			} else {
				data.tools.push({
					"title": "Mark News",
					"class": "toggle-mark-news",
					"icon": "fa-star"
				});
			}
		}
		callback(null, data);
	});
};

function handleSocketIO() {
	SocketPlugins.News = {};
	SocketPlugins.News.toggleMarkNews = function(socket, data, callback) {
		privileges.topics.isAdminOrMod(data.tid, socket.uid, function(err, isAdminOrMod) {
			if (!isAdminOrMod) {
				return callback(new Error('[[error:no-privileges]]'));
			}

			toggleMarkNews(data.tid, callback);
		});
	};
}

function toggleMarkNews(tid, callback) {
	topics.getTopicField(tid, 'isNews', function(err, isNews) {
		isNews = parseInt(isNews, 10) === 1;

		async.parallel([
			function(next) {
				topics.setTopicField(tid, 'isNews', isNews ? 0 : 1, next);
			},
			function(next) {
				// toggle
				if (isNews) {
					db.sortedSetRemove('topics:news', tid, next);
				} else {
					db.sortedSetAdd('topics:news', Date.now(), tid, next);
				}
			}
		], function(err) {
			callback(err, {isNews: !isNews});
		});
	});
}

module.exports = newsPlugin;
