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
S = require('string');

var newsPlugin = {};
var pluginName = "nodebb-plugin-news";

newsPlugin.init = function(params, callback) {
	console.log(pluginName + ":init");
	var router = params.router;
	var middleware = params.middleware;
	router.get('/news', middleware.buildHeader, newsPlugin.render);
	router.get('/api/news', newsPlugin.render);
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
	var stop = (parseInt(meta.config.topicsPerList, 10) || 20) - 1;
	async.waterfall([function (next) {
		topics.getTopicsFromSet('topics:news', req.uid, 0, stop, next);
	},
	function (data, next) {
		if (!Array.isArray(data.topics) || !data.topics.length) {
			return callback(null, data);
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
	}], function (err, data) {
		if (err) {
			return next(err);
		}
		// console.log("data: " + JSON.stringify(data));
		// data['feeds:disableRSS'] = false;
		if (req.path.startsWith('/api/news') || req.path.startsWith('/news')) {
			data.breadcrumbs = helpers.buildBreadcrumbs([{text: 'News'}]);
			data.title = "News";
		}
		res.render('news', data);
	});
};

newsPlugin.addThreadTools = function(data, callback) {
	var isNews = parseInt(data.topic.isNews, 10);
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
			"icon": "fa-star-o"
		});
	}
	callback(null, data);
};

function handleSocketIO() {
	SocketPlugins.News = {};
	SocketPlugins.News.toggleMarkNews = function(socket, data, callback) {
		privileges.topics.canEdit(data.tid, socket.uid, function(err, canEdit) {
			if (!canEdit) {
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
