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
			<h1 component="post/header" class="hidden-xs" itemprop="name">
				<!-- IF !topics.noAnchor -->
				<a href="{config.relative_path}/topic/{topics.slug}<!-- IF topics.bookmark -->/{topics.bookmark}<!-- ENDIF topics.bookmark -->" itemprop="url">{topics.title}</a><br />
				<!-- ELSE -->
				{topics.title}<br />
				<!-- ENDIF !topics.noAnchor -->
			</h1>
			<hr class="visible-xs" />
			<li component="post" class="<!-- IF topics.deleted -->deleted<!-- ENDIF topics.deleted -->"data-index="1" data-pid="{topics.mainPid}" data-uid="{topics.uid}" data-username="{topics.user.username}" data-userslug="{topics.user.userslug}" itemscope itemtype="http://schema.org/Comment">
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
							<i component="user/status" class="fa fa-circle status {topics.user.status}" title="[[global:{topics.user.status}]]"></i>

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
			</li>
			<!-- END topics -->
		</ul>
	</div>
</div>