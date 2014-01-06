component extends="mxunit.framework.TestCase" {

	// ------------------------ UNIT TESTS ------------------------ //

	function testDeleteArticle() {
		var articles = EntityLoad("Article");
		var result = ArrayLen(articles);
		assertEquals(3, result);
		var Article = EntityLoadByPK("Article", 1);
		transaction{
			CUT.deleteArticle(Article);
		}
		articles = EntityLoad("Article");
		result = ArrayLen(articles);
		assertEquals(2, result);
	}

	function testGetArticleWhereArticleDoesNotExist() {
		var Article = CUT.getArticle(100);
		var result = Article.isPersisted();
		assertFalse(result);
	}

	function testGetArticleWhereArticleExists() {
		var Article = CUT.getArticle(1);
		var result = Article.isPersisted();
		assertTrue(result);
	}

	function testGetArticleBySlugWhereArticleDoesNotExist() {
		var Article = CUT.getArticleBySlug("foobar");
		var result = Article.isPersisted();
		assertFalse(result);
	}

	function testGetArticleBySlugWhereArticleExists() {
		var Article = CUT.getArticleBySlug("sample-article-a");
		var result = Article.isPersisted();
		assertTrue(result);
	}

	function testGetArticleCount() {
		var result = CUT.getArticleCount();
		assertEquals(3, result);
	}

	function testGetArticles() {
		var articles = CUT.getArticles();
		var result = ArrayLen(articles);
		assertEquals(3, result);
	}

	function testGetArticlesBySearchTerm() {
		var articles = CUT.getArticles(searchterm="Sample Article A");
		var result = ArrayLen(articles);
		assertEquals(1, result);
	}

	function testGetArticlesSortedByArticleID() {
		var articles = CUT.getArticles(sortorder="articleid");
		var result = articles[1].getSlug();
		assertEquals("sample-article-a", result);
	}

	function testGetArticlesWithMaxResultsParameter() {
		var articles = CUT.getArticles(maxresults=2);
		var result = ArrayLen(articles);
		assertEquals(2, result);
	}

	function testSaveArticle() {
		var articles = EntityLoad("Article");
		var result = ArrayLen(articles);
		assertEquals(3, result);
		var Article = EntityNew("Article");
		Article.setTitle("foo");
		Article.setPublished(Now());
		Article.setContent("bar");
		transaction{
			CUT.saveArticle(Article);
		}
		articles = EntityLoad("Article");
		result = ArrayLen(articles);
		assertEquals(4, result);
	}

	// ------------------------ IMPLICIT ------------------------ //

	/**
	* this will run before every single test in this test case
	*/
	function setUp() {
		// initialise component under test
		CUT = new model.news.NewsGateway();

		// reinitialise ORM for the application (create database table)
		ORMReload();

		// insert test data into database
		var q = new Query();
		q.setSQL("
			INSERT INTO articles (article_slug, article_title, article_content, article_metagenerated, article_metatitle, article_metadescription, article_metakeywords, article_author, article_published, article_created, article_updated)
			VALUES ('sample-article-a', 'Sample Article A', '<p>Nunc eu auctor mi. Cras porta, augue a fermentum lacinia, enim justo lacinia nibh, eget congue arcu turpis sed neque! Sed enim ligula, dapibus nec molestie non, pellentesque vel leo. Proin feugiat rutrum erat, in porta sem luctus sed? Aenean vel odio erat, ac convallis turpis. Sed tempus posuere laoreet. Nam vel posuere ligula. Duis hendrerit, massa vel molestie ornare, enim felis sollicitudin arcu, quis tincidunt sapien dolor ac tortor. Integer viverra sagittis condimentum. Proin vitae sapien hendrerit nulla volutpat ultrices? Vivamus vitae fringilla odio. Morbi rhoncus suscipit viverra!<br /><br />Duis rhoncus justo quis augue feugiat interdum. In eget eros in orci vestibulum pretium. Nam semper, ipsum ut convallis tincidunt, odio sem pretium leo, sed porta massa tellus aliquam sapien. Quisque dignissim viverra leo luctus viverra. Nulla porta nisl et tortor tempus commodo. Maecenas luctus faucibus ligula, luctus ultricies augue cursus a! Nam quis ipsum ante, nec consequat sem? Proin ac elit nisl. Aliquam erat volutpat. Maecenas consectetur est ut nulla dapibus quis iaculis ante rhoncus? Phasellus lacinia cursus ligula, quis eleifend diam dignissim nec. Phasellus in magna sapien, at mattis diam. Aenean nunc metus, tincidunt quis sodales vel, adipiscing in sapien. Aliquam sollicitudin volutpat lacus, nec consequat quam blandit vel. Lorem ipsum dolor sit amet, consectetur adipiscing elit.<br /><br />Phasellus commodo nisl eget tellus pulvinar eu laoreet velit euismod. Maecenas nisi odio; dignissim in condimentum et, blandit ut est. Nullam lobortis purus quis nisi suscipit sit amet facilisis sem laoreet. In rhoncus mattis arcu, quis lobortis ligula porttitor sed. Aenean ac tortor eu turpis faucibus faucibus. Aliquam elementum condimentum turpis? Phasellus quis leo volutpat turpis lobortis convallis quis dictum est. Vestibulum ornare, sapien non rutrum rhoncus, sem metus scelerisque quam, interdum commodo nisi ligula at lacus. Curabitur auctor est rutrum nibh cursus vitae semper magna lacinia. Aenean eget est orci, nec facilisis urna. Sed pretium felis at felis feugiat facilisis. Quisque ut nisi justo, porta malesuada elit. Donec in libero dignissim nunc tempor lobortis. Donec sed nisi ligula, et elementum sapien.<br />&nbsp;</p>\r\n', 1, 'Sample Article A', 'Nunc eu auctor mi. Cras porta, augue a fermentum lacinia, enim justo lacinia nibh, eget congue arcu turpis sed neque! Sed enim ligula, dapibus nec molestie non, pellente', 'Nunc,eu,auctor,mi,Cras,porta,augue,fermentum,lacinia,enim,justo,nibh,eget,congue,arcu,turpis,sed,neque!,ligula,dapibus,nec,molestie,non,pellentesque,vel,leo,Proin,feugia', 'Simon Bingham', '20120526', '20120526', '20120526');
			INSERT INTO articles (article_slug, article_title, article_content, article_metagenerated, article_metatitle, article_metadescription, article_metakeywords, article_author, article_published, article_created, article_updated)
			VALUES ('sample-article-b', 'Sample Article B', '<p>Nunc eu auctor mi. Cras porta, augue a fermentum lacinia, enim justo lacinia nibh, eget congue arcu turpis sed neque! Sed enim ligula, dapibus nec molestie non, pellentesque vel leo. Proin feugiat rutrum erat, in porta sem luctus sed? Aenean vel odio erat, ac convallis turpis. Sed tempus posuere laoreet. Nam vel posuere ligula. Duis hendrerit, massa vel molestie ornare, enim felis sollicitudin arcu, quis tincidunt sapien dolor ac tortor. Integer viverra sagittis condimentum. Proin vitae sapien hendrerit nulla volutpat ultrices? Vivamus vitae fringilla odio. Morbi rhoncus suscipit viverra!<br /><br />Duis rhoncus justo quis augue feugiat interdum. In eget eros in orci vestibulum pretium. Nam semper, ipsum ut convallis tincidunt, odio sem pretium leo, sed porta massa tellus aliquam sapien. Quisque dignissim viverra leo luctus viverra. Nulla porta nisl et tortor tempus commodo. Maecenas luctus faucibus ligula, luctus ultricies augue cursus a! Nam quis ipsum ante, nec consequat sem? Proin ac elit nisl. Aliquam erat volutpat. Maecenas consectetur est ut nulla dapibus quis iaculis ante rhoncus? Phasellus lacinia cursus ligula, quis eleifend diam dignissim nec. Phasellus in magna sapien, at mattis diam. Aenean nunc metus, tincidunt quis sodales vel, adipiscing in sapien. Aliquam sollicitudin volutpat lacus, nec consequat quam blandit vel. Lorem ipsum dolor sit amet, consectetur adipiscing elit.<br /><br />Phasellus commodo nisl eget tellus pulvinar eu laoreet velit euismod. Maecenas nisi odio; dignissim in condimentum et, blandit ut est. Nullam lobortis purus quis nisi suscipit sit amet facilisis sem laoreet. In rhoncus mattis arcu, quis lobortis ligula porttitor sed. Aenean ac tortor eu turpis faucibus faucibus. Aliquam elementum condimentum turpis? Phasellus quis leo volutpat turpis lobortis convallis quis dictum est. Vestibulum ornare, sapien non rutrum rhoncus, sem metus scelerisque quam, interdum commodo nisi ligula at lacus. Curabitur auctor est rutrum nibh cursus vitae semper magna lacinia. Aenean eget est orci, nec facilisis urna. Sed pretium felis at felis feugiat facilisis. Quisque ut nisi justo, porta malesuada elit. Donec in libero dignissim nunc tempor lobortis. Donec sed nisi ligula, et elementum sapien.<br />&nbsp;</p>\r\n', 1, 'Sample Article B', 'Nunc eu auctor mi. Cras porta, augue a fermentum lacinia, enim justo lacinia nibh, eget congue arcu turpis sed neque! Sed enim ligula, dapibus nec molestie non, pellente', 'Nunc,eu,auctor,mi,Cras,porta,augue,fermentum,lacinia,enim,justo,nibh,eget,congue,arcu,turpis,sed,neque!,ligula,dapibus,nec,molestie,non,pellentesque,vel,leo,Proin,feugia', 'Simon Bingham', '20120626', '20120626', '20120626');
			INSERT INTO articles (article_slug, article_title, article_content, article_metagenerated, article_metatitle, article_metadescription, article_metakeywords, article_author, article_published, article_created, article_updated)
			VALUES ('sample-article-c', 'Sample Article C', '<p>Nunc eu auctor mi. Cras porta, augue a fermentum lacinia, enim justo lacinia nibh, eget congue arcu turpis sed neque! Sed enim ligula, dapibus nec molestie non, pellentesque vel leo. Proin feugiat rutrum erat, in porta sem luctus sed? Aenean vel odio erat, ac convallis turpis. Sed tempus posuere laoreet. Nam vel posuere ligula. Duis hendrerit, massa vel molestie ornare, enim felis sollicitudin arcu, quis tincidunt sapien dolor ac tortor. Integer viverra sagittis condimentum. Proin vitae sapien hendrerit nulla volutpat ultrices? Vivamus vitae fringilla odio. Morbi rhoncus suscipit viverra!<br /><br />Duis rhoncus justo quis augue feugiat interdum. In eget eros in orci vestibulum pretium. Nam semper, ipsum ut convallis tincidunt, odio sem pretium leo, sed porta massa tellus aliquam sapien. Quisque dignissim viverra leo luctus viverra. Nulla porta nisl et tortor tempus commodo. Maecenas luctus faucibus ligula, luctus ultricies augue cursus a! Nam quis ipsum ante, nec consequat sem? Proin ac elit nisl. Aliquam erat volutpat. Maecenas consectetur est ut nulla dapibus quis iaculis ante rhoncus? Phasellus lacinia cursus ligula, quis eleifend diam dignissim nec. Phasellus in magna sapien, at mattis diam. Aenean nunc metus, tincidunt quis sodales vel, adipiscing in sapien. Aliquam sollicitudin volutpat lacus, nec consequat quam blandit vel. Lorem ipsum dolor sit amet, consectetur adipiscing elit.<br /><br />Phasellus commodo nisl eget tellus pulvinar eu laoreet velit euismod. Maecenas nisi odio; dignissim in condimentum et, blandit ut est. Nullam lobortis purus quis nisi suscipit sit amet facilisis sem laoreet. In rhoncus mattis arcu, quis lobortis ligula porttitor sed. Aenean ac tortor eu turpis faucibus faucibus. Aliquam elementum condimentum turpis? Phasellus quis leo volutpat turpis lobortis convallis quis dictum est. Vestibulum ornare, sapien non rutrum rhoncus, sem metus scelerisque quam, interdum commodo nisi ligula at lacus. Curabitur auctor est rutrum nibh cursus vitae semper magna lacinia. Aenean eget est orci, nec facilisis urna. Sed pretium felis at felis feugiat facilisis. Quisque ut nisi justo, porta malesuada elit. Donec in libero dignissim nunc tempor lobortis. Donec sed nisi ligula, et elementum sapien.<br />&nbsp;</p>\r\n', 0, '', '', '', '', '20120626', '20120626', '20120626');
		");
		q.execute();
	}

	/**
	* this will run after every single test in this test case
	*/
	function tearDown() {
		// destroy test data
		var q = new Query();
		q.setSQL("
			DROP TABLE Articles;
			DROP TABLE Enquiries;
			DROP TABLE Pages;
			DROP TABLE Users;
		");
		q.execute();

		// clear first level cache and remove any unsaved objects
		ORMClearSession();
	}

	/**
	* this will run once after initialization and before setUp()
	*/
	function beforeTests() {}

	/**
	* this will run once after all tests have been run
	*/
	function afterTests() {}

}

