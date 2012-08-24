/*
	Xindi - http://www.getxindi.com/
	
	Copyright (c) 2012, Simon Bingham
	
	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, 
	modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
	is furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

component extends="mxunit.framework.TestCase"{
			
	// ------------------------ UNIT TESTS ------------------------ //
	
	function testGetRSSSummary(){
		CUT.setContent( "'Nullam ac mi nec enim vestibulum scelerisque sit amet at tellus. Phasellus eget quam neque; id luctus lorem. Sed sagittis.'" );
		var result = CUT.getRSSSummary();
		assertEquals( "&apos;nullam ac mi nec enim vestibulum scelerisque sit amet at tellus. phasellus eget quam neque; id luctus lorem. sed sagittis.&apos;", result );
	}
	 
	function testGetSummaryDoesNotAppendHellipIfShort(){
		CUT.setContent( "<p>short page content</p>" );
		var result = CUT.getSummary();
		assertEquals( "short page content", result );
	}

	function testGetSummaryIsPlainText(){
		CUT.setContent( "<p>some <strong class='foo'>page</strong> content</p>" );
		var result = CUT.getSummary();
		assertEquals( "some page content", result );
	}
	
	function testGetSummaryTruncatesAndAppendsHellipIfLong(){
		CUT.setContent( "<p>This is a long description which is over five-hundred characters in length - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ultrices purus non velit adipiscing malesuada. Aliquam sed convallis neque. Praesent vulputate suscipit luctus. Integer nec neque non dolor eleifend commodo. Mauris consectetur, augue ut pretium lobortis, lectus dui mattis velit, quis venenatis arcu leo non ipsum. Quisque sit amet tortor nec orci lobortis aliquet eget ac erat. Cras rhoncus molestie tincidunt. Vestibulum feugiat aliquam sapien id pharetra. Sed viverra turpis a neque molestie sed venenatis turpis sollicitudin. Duis eu nisl in lacus luctus molestie ac nec turpis. Maecenas vel orci eget purus suscipit aliquam ut id enim. Maecenas euismod, arcu et vestibulum laoreet, sem nisl ultrices arcu, vitae elementum leo leo at tortor. Aliquam erat volutpat. Curabitur eu pellentesque lorem. Donec at nisl erat. Mauris ornare posuere dui a sollicitudin. Quisque quis diam ligula, sed feugiat mauris. In hac habitasse platea dictumst. In condimentum, urna id imperdiet lobortis, mauris justo bibendum ante, sed malesuada nulla elit ac quam. In pellentesque, orci et mattis cursus, urna urna tincidunt sapien, sollicitudin molestie libero mi ac eros. Curabitur elementum felis vel nisi fermentum vehicula. Suspendisse vitae suscipit neque. Sed est ipsum, tempor id sodales in, tempus eget dolor. Quisque nulla mi, posuere sit amet porttitor in, adipiscing quis elit. Morbi vitae lectus felis. Fusce bibendum, quam auctor pellentesque faucibus, quam diam bibendum risus, sit amet malesuada enim lectus in nisl. Aenean blandit molestie risus nec vulputate. Morbi nec sodales sapien. Donec varius porttitor leo, ac vehicula turpis ornare sit amet. In hac habitasse platea dictumst.</p>" );
		var result = Len( CUT.getSummary() ) == 503;
		assertTrue( result );
		result = Right( CUT.getSummary(), 3 ) == "...";
		assertTrue( result );
	}
	
	function testHasMetaDescription(){
		var Article = EntityLoadByPK( "Article", 1 );
		var result = Article.hasMetaDescription();
		assertTrue( result );
		Article = EntityLoadByPK( "Article", 3 );
		result = Article.hasMetaDescription();
		assertFalse( result );
	}	

	function testHasMetaKeywords(){
		var Article = EntityLoadByPK( "Article", 1 );
		var result = Article.hasMetaKeywords();
		assertTrue( result );
		Article = EntityLoadByPK( "Article", 3 );
		result = Article.hasMetaKeywords();
		assertFalse( result );
	}
	
	function testHasMetaTitle(){
		var Article = EntityLoadByPK( "Article", 1 );
		var result = Article.hasMetaTitle();
		assertTrue( result );
		Article = EntityLoadByPK( "Article", 3 );
		result = Article.hasMetaTitle();
		assertFalse( result );
	}
	
	function testIsMetaGenerated(){
		var Article = EntityLoadByPK( "Article", 1 );
		var result = Article.isMetaGenerated();
		assertTrue( result );
		Article = EntityLoadByPK( "Article", 3 );
		result = Article.isMetaGenerated();
		assertFalse( result );
	}		
	
	function testIsNew(){
		CUT.setPublished( Now() );
		var result = CUT.isNew();
		assertTrue( result );
		CUT.setPublished( DateAdd( "ww", -2, Now() ) );
		result = CUT.isNew();
		assertFalse( result );		
	}
	
	function testIsPersisted(){
		var result = CUT.isPersisted();
		assertFalse( result );
		var Article = EntityLoadByPK( "Article", 1 );
		result = Article.isPersisted();
		assertTrue( result );		
	}
	
	function testIsPublished(){
		CUT.setPublished( DateAdd( "d", -1, Now() ) );
		var result = CUT.isPublished();
		assertTrue( result );
		CUT.setPublished( DateAdd( "d", 1, Now() ) );
		result = CUT.isPublished();
		assertFalse( result );
	}

	function testIsSlugUnique(){
		CUT.setTitle( "Sample Article A" );
		makePublic( CUT, "isSlugUnique" );
		var result = CUT.isSlugUnique();
		assertTrue( result );
	}
	
	function testSetSlugWhereRecordWithSameTitleDoesNotExist(){
		CUT.setTitle( "Sample Article D" );
		makePublic( CUT, "setSlug" );
		CUT.setSlug();
		var result = CUT.getSlug();
		assertEquals( "sample-article-d", result );
	}	
	
	function testSetSlugWhereRecordWithSameTitleExists(){
		CUT.setTitle( "Sample Article A" );
		makePublic( CUT, "setSlug" );
		CUT.setSlug();
		var result = CUT.getSlug();
		assertEquals( "sample-article-a-", result );
	}	

	// ------------------------ IMPLICIT ------------------------ //
	
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		// initialise component under test
		CUT = new model.news.Article();
		
		// reinitialise ORM for the application (create database table)
		ORMReload();
		
		// insert test data into database
		var q = new Query();
		q.setSQL( "
			INSERT INTO articles ( article_slug, article_title, article_content, article_metagenerated, article_metatitle, article_metadescription, article_metakeywords, article_published, article_created, article_updated ) 
			VALUES ( 'sample-article-a', 'Sample Article A', '<p>Nunc eu auctor mi. Cras porta, augue a fermentum lacinia, enim justo lacinia nibh, eget congue arcu turpis sed neque! Sed enim ligula, dapibus nec molestie non, pellentesque vel leo. Proin feugiat rutrum erat, in porta sem luctus sed? Aenean vel odio erat, ac convallis turpis. Sed tempus posuere laoreet. Nam vel posuere ligula. Duis hendrerit, massa vel molestie ornare, enim felis sollicitudin arcu, quis tincidunt sapien dolor ac tortor. Integer viverra sagittis condimentum. Proin vitae sapien hendrerit nulla volutpat ultrices? Vivamus vitae fringilla odio. Morbi rhoncus suscipit viverra!<br /><br />Duis rhoncus justo quis augue feugiat interdum. In eget eros in orci vestibulum pretium. Nam semper, ipsum ut convallis tincidunt, odio sem pretium leo, sed porta massa tellus aliquam sapien. Quisque dignissim viverra leo luctus viverra. Nulla porta nisl et tortor tempus commodo. Maecenas luctus faucibus ligula, luctus ultricies augue cursus a! Nam quis ipsum ante, nec consequat sem? Proin ac elit nisl. Aliquam erat volutpat. Maecenas consectetur est ut nulla dapibus quis iaculis ante rhoncus? Phasellus lacinia cursus ligula, quis eleifend diam dignissim nec. Phasellus in magna sapien, at mattis diam. Aenean nunc metus, tincidunt quis sodales vel, adipiscing in sapien. Aliquam sollicitudin volutpat lacus, nec consequat quam blandit vel. Lorem ipsum dolor sit amet, consectetur adipiscing elit.<br /><br />Phasellus commodo nisl eget tellus pulvinar eu laoreet velit euismod. Maecenas nisi odio; dignissim in condimentum et, blandit ut est. Nullam lobortis purus quis nisi suscipit sit amet facilisis sem laoreet. In rhoncus mattis arcu, quis lobortis ligula porttitor sed. Aenean ac tortor eu turpis faucibus faucibus. Aliquam elementum condimentum turpis? Phasellus quis leo volutpat turpis lobortis convallis quis dictum est. Vestibulum ornare, sapien non rutrum rhoncus, sem metus scelerisque quam, interdum commodo nisi ligula at lacus. Curabitur auctor est rutrum nibh cursus vitae semper magna lacinia. Aenean eget est orci, nec facilisis urna. Sed pretium felis at felis feugiat facilisis. Quisque ut nisi justo, porta malesuada elit. Donec in libero dignissim nunc tempor lobortis. Donec sed nisi ligula, et elementum sapien.<br />&nbsp;</p>\r\n', 1, 'Sample Article A', 'Nunc eu auctor mi. Cras porta, augue a fermentum lacinia, enim justo lacinia nibh, eget congue arcu turpis sed neque! Sed enim ligula, dapibus nec molestie non, pellente', 'Nunc,eu,auctor,mi,Cras,porta,augue,fermentum,lacinia,enim,justo,nibh,eget,congue,arcu,turpis,sed,neque!,ligula,dapibus,nec,molestie,non,pellentesque,vel,leo,Proin,feugia', '20120526', '20120526', '20120526' );
			INSERT INTO articles ( article_slug, article_title, article_content, article_metagenerated, article_metatitle, article_metadescription, article_metakeywords, article_published, article_created, article_updated ) 
			VALUES ( 'sample-article-b', 'Sample Article B', '<p>Nunc eu auctor mi. Cras porta, augue a fermentum lacinia, enim justo lacinia nibh, eget congue arcu turpis sed neque! Sed enim ligula, dapibus nec molestie non, pellentesque vel leo. Proin feugiat rutrum erat, in porta sem luctus sed? Aenean vel odio erat, ac convallis turpis. Sed tempus posuere laoreet. Nam vel posuere ligula. Duis hendrerit, massa vel molestie ornare, enim felis sollicitudin arcu, quis tincidunt sapien dolor ac tortor. Integer viverra sagittis condimentum. Proin vitae sapien hendrerit nulla volutpat ultrices? Vivamus vitae fringilla odio. Morbi rhoncus suscipit viverra!<br /><br />Duis rhoncus justo quis augue feugiat interdum. In eget eros in orci vestibulum pretium. Nam semper, ipsum ut convallis tincidunt, odio sem pretium leo, sed porta massa tellus aliquam sapien. Quisque dignissim viverra leo luctus viverra. Nulla porta nisl et tortor tempus commodo. Maecenas luctus faucibus ligula, luctus ultricies augue cursus a! Nam quis ipsum ante, nec consequat sem? Proin ac elit nisl. Aliquam erat volutpat. Maecenas consectetur est ut nulla dapibus quis iaculis ante rhoncus? Phasellus lacinia cursus ligula, quis eleifend diam dignissim nec. Phasellus in magna sapien, at mattis diam. Aenean nunc metus, tincidunt quis sodales vel, adipiscing in sapien. Aliquam sollicitudin volutpat lacus, nec consequat quam blandit vel. Lorem ipsum dolor sit amet, consectetur adipiscing elit.<br /><br />Phasellus commodo nisl eget tellus pulvinar eu laoreet velit euismod. Maecenas nisi odio; dignissim in condimentum et, blandit ut est. Nullam lobortis purus quis nisi suscipit sit amet facilisis sem laoreet. In rhoncus mattis arcu, quis lobortis ligula porttitor sed. Aenean ac tortor eu turpis faucibus faucibus. Aliquam elementum condimentum turpis? Phasellus quis leo volutpat turpis lobortis convallis quis dictum est. Vestibulum ornare, sapien non rutrum rhoncus, sem metus scelerisque quam, interdum commodo nisi ligula at lacus. Curabitur auctor est rutrum nibh cursus vitae semper magna lacinia. Aenean eget est orci, nec facilisis urna. Sed pretium felis at felis feugiat facilisis. Quisque ut nisi justo, porta malesuada elit. Donec in libero dignissim nunc tempor lobortis. Donec sed nisi ligula, et elementum sapien.<br />&nbsp;</p>\r\n', 1, 'Sample Article B', 'Nunc eu auctor mi. Cras porta, augue a fermentum lacinia, enim justo lacinia nibh, eget congue arcu turpis sed neque! Sed enim ligula, dapibus nec molestie non, pellente', 'Nunc,eu,auctor,mi,Cras,porta,augue,fermentum,lacinia,enim,justo,nibh,eget,congue,arcu,turpis,sed,neque!,ligula,dapibus,nec,molestie,non,pellentesque,vel,leo,Proin,feugia', '20120626', '20120626', '20120626' );
			INSERT INTO articles ( article_slug, article_title, article_content, article_metagenerated, article_metatitle, article_metadescription, article_metakeywords, article_published, article_created, article_updated ) 
			VALUES ( 'sample-article-c', 'Sample Article C', '<p>Nunc eu auctor mi. Cras porta, augue a fermentum lacinia, enim justo lacinia nibh, eget congue arcu turpis sed neque! Sed enim ligula, dapibus nec molestie non, pellentesque vel leo. Proin feugiat rutrum erat, in porta sem luctus sed? Aenean vel odio erat, ac convallis turpis. Sed tempus posuere laoreet. Nam vel posuere ligula. Duis hendrerit, massa vel molestie ornare, enim felis sollicitudin arcu, quis tincidunt sapien dolor ac tortor. Integer viverra sagittis condimentum. Proin vitae sapien hendrerit nulla volutpat ultrices? Vivamus vitae fringilla odio. Morbi rhoncus suscipit viverra!<br /><br />Duis rhoncus justo quis augue feugiat interdum. In eget eros in orci vestibulum pretium. Nam semper, ipsum ut convallis tincidunt, odio sem pretium leo, sed porta massa tellus aliquam sapien. Quisque dignissim viverra leo luctus viverra. Nulla porta nisl et tortor tempus commodo. Maecenas luctus faucibus ligula, luctus ultricies augue cursus a! Nam quis ipsum ante, nec consequat sem? Proin ac elit nisl. Aliquam erat volutpat. Maecenas consectetur est ut nulla dapibus quis iaculis ante rhoncus? Phasellus lacinia cursus ligula, quis eleifend diam dignissim nec. Phasellus in magna sapien, at mattis diam. Aenean nunc metus, tincidunt quis sodales vel, adipiscing in sapien. Aliquam sollicitudin volutpat lacus, nec consequat quam blandit vel. Lorem ipsum dolor sit amet, consectetur adipiscing elit.<br /><br />Phasellus commodo nisl eget tellus pulvinar eu laoreet velit euismod. Maecenas nisi odio; dignissim in condimentum et, blandit ut est. Nullam lobortis purus quis nisi suscipit sit amet facilisis sem laoreet. In rhoncus mattis arcu, quis lobortis ligula porttitor sed. Aenean ac tortor eu turpis faucibus faucibus. Aliquam elementum condimentum turpis? Phasellus quis leo volutpat turpis lobortis convallis quis dictum est. Vestibulum ornare, sapien non rutrum rhoncus, sem metus scelerisque quam, interdum commodo nisi ligula at lacus. Curabitur auctor est rutrum nibh cursus vitae semper magna lacinia. Aenean eget est orci, nec facilisis urna. Sed pretium felis at felis feugiat facilisis. Quisque ut nisi justo, porta malesuada elit. Donec in libero dignissim nunc tempor lobortis. Donec sed nisi ligula, et elementum sapien.<br />&nbsp;</p>\r\n', 0, '', '', '', '20120626', '20120626', '20120626' );
		" );
		q.execute();
	}
	
	/**
	* this will run after every single test in this test case
	*/
	function tearDown(){
		// destroy test data
		var q = new Query();
		q.setSQL( "
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
	function beforeTests(){}
	
	/**
	* this will run once after all tests have been run
	*/
	function afterTests(){}

}
