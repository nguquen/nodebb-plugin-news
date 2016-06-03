"use strict";

/*global socket, config, ajaxify, app*/

$('document').ready(function() {
	$(window).on('action:ajaxify.end', function(err, data) {
		console.log(JSON.stringify(data));
		if (data.url === '' || data.url.match(/^news\//)) {
			$(window).trigger('action:topic.loaded');
		}
	});

	$(window).on('action:topic.tools.load', addHandlers);

	function addHandlers() {
		$('.toggle-mark-news').on('click', toggleMarkNews);
	}

	function toggleMarkNews() {
		var tid = ajaxify.data.tid;
		callToggleMarkNews(tid);
	}

	function callToggleMarkNews(tid) {
		socket.emit('plugins.News.toggleMarkNews', {tid: tid}, function(err, data) {
			app.alertSuccess(data.isNews ? 'Topic has been marked as a news' : 'Topic is now a regular thread');
			ajaxify.refresh();
		});
	}
});