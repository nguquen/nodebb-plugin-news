<!-- Recent Cards plugin -->
<ul class="categories">
	<p>Recent Topics</p>
</ul>

<div class="row recent-cards" itemscope itemtype="http://www.schema.org/ItemList">
	<!-- BEGIN recentTopics -->
	<div component="categories/category" class="<!-- IF recentTopics.category.class -->{recentTopics.category.class}<!-- ELSE -->col-md-3 col-sm-6 col-xs-12<!-- ENDIF recentTopics.category.class --> category-item" data-cid="{recentTopics.category.cid}" data-numRecentReplies="{recentTopics.category.numRecentReplies}" style="text-shadow:{recentCards.textShadow};">
		<meta itemprop="name" content="{recentTopics.category.name}">

		<div class="category-icon">
			<div class="bg" style="opacity:{recentCards.opacity};<!-- IF recentTopics.category.backgroundImage -->background-image: url({recentTopics.category.backgroundImage});<!-- ELSE --><!-- IF recentTopics.category.bgColor -->background-color: {recentTopics.category.bgColor};<!-- ENDIF recentTopics.category.bgColor --><!-- ENDIF recentTopics.category.backgroundImage -->"></div>
			<a style="color: {recentTopics.category.color};" href="{config.relative_path}/topic/{recentTopics.slug}" itemprop="url">
				<div
					id="category-{recentTopics.category.cid}" class="category-header category-header-image-{recentTopics.category.imageClass}"
					style="color: {recentTopics.category.color};"
				>
					<!-- IF recentTopics.category.icon -->
					<div><i class="fa {recentTopics.category.icon} fa-4x hidden-xs"></i></div>
					<!-- ENDIF recentTopics.category.icon -->
				</div>
			</a>

			<div class="category-box">
				<div class="category-info" style="color: {recentTopics.category.color};">
					<a href="{config.relative_path}/topic/{recentTopics.slug}" itemprop="url" style="color: {recentTopics.category.color};">
						<h4><!-- IF recentTopics.category.icon --><i class="fa {recentTopics.category.icon} visible-xs-inline"></i> <!-- ENDIF recentTopics.category.icon -->{recentTopics.title}</h4>
						<div class="description" itemprop="description"><strong>{recentTopics.category.name}</strong> <span class="timeago" title="{recentTopics.teaser.timestampISO}"></span></div>
					</a>
				</div>
			</div>

			<span class="post-count" style="color: {recentTopics.category.color};">{recentTopics.postcount}</span>
		</div>
	</div>
	<!-- END recentTopics -->
</div>
<hr />

<!-- IF breadcrumbs.length -->
<ol class="breadcrumb">
	<!-- BEGIN breadcrumbs -->
	<li<!-- IF @last --> component="breadcrumb/current"<!-- ENDIF @last --> itemscope="itemscope" itemtype="http://data-vocabulary.org/Breadcrumb" <!-- IF @last -->class="active"<!-- ENDIF @last -->>
		<!-- IF !@last --><a href="{breadcrumbs.url}" itemprop="url"><!-- ENDIF !@last -->
			<span itemprop="title">
				{breadcrumbs.text}
				<!-- IF @last -->
				<!-- IF !feeds:disableRSS -->
				<!-- IF rssFeedUrl --><a target="_blank" href="{rssFeedUrl}"><i class="fa fa-rss-square"></i></a><!-- ENDIF rssFeedUrl --><!-- ENDIF !feeds:disableRSS -->
				<!-- ENDIF @last -->
			</span>
		<!-- IF !@last --></a><!-- ENDIF !@last -->
	</li>
	<!-- END breadcrumbs -->
</ol>
<!-- ENDIF breadcrumbs.length -->
<h1 class="categories-title">News</h1>
<hr />
<div class="row">
	<div class="topic col-lg-12">

		<!-- IF !topics.length -->
		<div class="alert alert-warning" id="category-no-topics">[[recent:no_recent_topics]]</div>
		<!-- ENDIF !topics.length -->

		<ul component="topic" class="posts" data-tid="{tid}" itemscope itemtype="http://www.schema.org/ItemList" data-nextstart="{nextStart}">
			<!-- BEGIN topics -->
			<li component="post" class="<!-- IF topics.deleted -->deleted<!-- ENDIF topics.deleted -->"data-index="1" data-pid="{topics.mainPid}" data-uid="{topics.uid}" data-username="{topics.user.username}" data-userslug="{topics.user.userslug}" itemscope itemtype="http://schema.org/Comment">
				<h1 component="post/header" itemprop="name">
					<!-- IF !topics.noAnchor -->
					<a href="{config.relative_path}/topic/{topics.slug}<!-- IF topics.bookmark -->/{topics.bookmark}<!-- ENDIF topics.bookmark -->" itemprop="url">{topics.title}</a><br />
					<!-- ELSE -->
					{topics.title}<br />
					<!-- ENDIF !topics.noAnchor -->
				</h1>
				<hr class="visible-xs" />
				<a component="post/anchor" data-index="1" name="1"></a>
				<meta itemprop="datePublished" content="{topics.timestampISO}">
				<div class="clearfix">
					<div class="icon pull-left">
						<a href="<!-- IF topics.user.userslug -->{config.relative_path}/user/{topics.user.userslug}<!-- ELSE -->#<!-- ENDIF topics.user.userslug -->">
							<!-- IF topics.user.picture -->
							<img component="user/picture" data-uid="{topics.user.uid}" src="{topics.user.picture}" align="left" itemprop="image" />
							<!-- ELSE -->
							<div component="user/picture" data-uid="{topics.user.uid}" class="user-icon" style="background-color: {topics.user.icon:bgColor};">{topics.user.icon:text}</div>
							<!-- ENDIF topics.user.picture -->
						</a>
					</div>

					<small class="pull-left">
						<strong>
							<a href="<!-- IF topics.user.userslug -->{config.relative_path}/user/{topics.user.userslug}<!-- ELSE -->#<!-- ENDIF topics.user.userslug -->" itemprop="author" data-username="{topics.user.username}" data-uid="{topics.user.uid}">{topics.user.username}</a>
						</strong>

						<!-- IF topics.user.banned -->
						<span class="label label-danger">[[user:banned]]</span>
						<!-- ENDIF topics.user.banned -->

						<div class="visible-xs-inline-block visible-sm-inline-block visible-md-inline-block visible-lg-inline-block">
							<a class="permalink" href="{config.relative_path}/topic/{slug}/{function.getBookmarkFromIndex}"><span class="timeago" title="{topics.timestampISO}"></span></a>
						</div>
						<span class="bookmarked"><i class="fa fa-bookmark-o"></i></span>
					</small>
				</div>

				<br />
				<div class="content" component="post/content" itemprop="text">
					{topics.mainPost.content}
				</div>
				<hr />
				<div class="clearfix">
					<div class="tags pull-left">
						<!-- BEGIN tags -->
						<a href="{config.relative_path}/tags/{tags.value}">
						<span class="tag-item" data-tag="{topics.tags.value}" style="<!-- IF topics.tags.color -->color: {topics.tags.color};<!-- ENDIF topics.tags.color --><!-- IF topics.tags.bgColor -->background-color: {topics.tags.bgColor};<!-- ENDIF topics.tags.bgColor -->">{topics.tags.value}</span>
						<span class="tag-topic-count human-readable-number" title="{topics.tags.score}">{topics.tags.score}</span></a>
						<!-- END tags -->
					</div>
					<div class="topic-main-buttons pull-right">
						<div class="stats hidden-xs">
							<span component="topic/post-count" class="human-readable-number" title="{topics.postcount}">{topics.postcount}</span><br />
							<small>[[global:posts]]</small>
						</div>
						<div class="stats hidden-xs">
							<span class="human-readable-number" title="{topics.viewcount}">{topics.viewcount}</span><br />
							<small>[[global:views]]</small>
						</div>
						<div class="btn-group action-bar">
							<a class="btn btn-primary" href="{config.relative_path}/topic/{topics.slug}<!-- IF topics.bookmark -->/{topics.bookmark}<!-- ENDIF topics.bookmark -->" itemprop="url">Read More</a>
						</div>
					</div>
				</div>
				<hr />
			</li>
			<!-- END topics -->
		</ul>
	</div>
</div>
<div class="section sectionMain">
	<div class="PageNav">
		<nav>

			<!-- IF prevPage -->
			<a href="/news/{prevPage}" class="btn btn-default">&lt;&lt; Previous</a>
			<!-- ENDIF prevPage -->
			<!-- BEGIN pages -->
			<a href="/news/{pages.number}" class="btn <!-- IF pages.currentPage -->btn-primary<!-- ELSE -->btn-default<!-- ENDIF pages.currentPage -->">{pages.number}</a>
			<!-- END pages -->
			<!-- IF nextPage -->
			<a href="/news/{nextPage}" class="btn btn-default">Next &gt;&gt;</a>
			<!-- ENDIF nextPage -->

		</nav>
	</div>
</div>