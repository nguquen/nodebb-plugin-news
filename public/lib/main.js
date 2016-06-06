"use strict";

/*global socket, config, ajaxify, app*/

$('document').ready(function() {
	$(window).on('action:ajaxify.end', function(err, data) {
		if (data.url === '' || data.url.match(/^news/)) {
			$(window).trigger('action:topic.loaded');
			$(window).trigger('action:news.loaded');
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

	require(['components'], function(components) {
		$(window).on('action:news.loaded', function() {
			loadImages(components);
		});
	});

	function loadImages(components) {
		var images = components.get('post/content').find('img:not(.not-responsive)');

		images.each(function() {
			$(this).attr('data-state', 'loaded');
		});
	}
});