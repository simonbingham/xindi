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
			
	// ------------------------ TESTS ------------------------ //
	
	// public methods
	
	function testGetRSSSummary(){
		CUT.setContent( "'Nullam ac mi nec enim vestibulum scelerisque sit amet at tellus. Phasellus eget quam neque; id luctus lorem. Sed sagittis.'" );
		assertEquals( "&apos;nullam ac mi nec enim vestibulum scelerisque sit amet at tellus. phasellus eget quam neque; id luctus lorem. sed sagittis.&apos;", CUT.getRSSSummary() );
	}
	 
	function testGetSummaryDoesNotAppendHellipIfShort(){
		CUT.setContent( "<p>short page content</p>" );
		assertEquals( "short page content", CUT.getSummary() );
	}

	function testGetSummaryIsPlainText(){
		CUT.setContent( "<p>some <strong class='foo'>page</strong> content</p>" );
		assertEquals( "some page content", CUT.getSummary() );
	}
	
	function testGetSummaryTruncatesAndAppendsHellipIfLong(){
		CUT.setContent( "<p>This is a long description which is over five-hundred characters in length - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ultrices purus non velit adipiscing malesuada. Aliquam sed convallis neque. Praesent vulputate suscipit luctus. Integer nec neque non dolor eleifend commodo. Mauris consectetur, augue ut pretium lobortis, lectus dui mattis velit, quis venenatis arcu leo non ipsum. Quisque sit amet tortor nec orci lobortis aliquet eget ac erat. Cras rhoncus molestie tincidunt. Vestibulum feugiat aliquam sapien id pharetra. Sed viverra turpis a neque molestie sed venenatis turpis sollicitudin. Duis eu nisl in lacus luctus molestie ac nec turpis. Maecenas vel orci eget purus suscipit aliquam ut id enim. Maecenas euismod, arcu et vestibulum laoreet, sem nisl ultrices arcu, vitae elementum leo leo at tortor. Aliquam erat volutpat. Curabitur eu pellentesque lorem. Donec at nisl erat. Mauris ornare posuere dui a sollicitudin. Quisque quis diam ligula, sed feugiat mauris. In hac habitasse platea dictumst. In condimentum, urna id imperdiet lobortis, mauris justo bibendum ante, sed malesuada nulla elit ac quam. In pellentesque, orci et mattis cursus, urna urna tincidunt sapien, sollicitudin molestie libero mi ac eros. Curabitur elementum felis vel nisi fermentum vehicula. Suspendisse vitae suscipit neque. Sed est ipsum, tempor id sodales in, tempus eget dolor. Quisque nulla mi, posuere sit amet porttitor in, adipiscing quis elit. Morbi vitae lectus felis. Fusce bibendum, quam auctor pellentesque faucibus, quam diam bibendum risus, sit amet malesuada enim lectus in nisl. Aenean blandit molestie risus nec vulputate. Morbi nec sodales sapien. Donec varius porttitor leo, ac vehicula turpis ornare sit amet. In hac habitasse platea dictumst.</p>" );
		var result = CUT.getSummary();
		assertTrue( Len( result ) == 503 );
		assertTrue( Right( result, 3 ) == "..." );
	}
	
	function testHasMetaDescription(){
		var Article = EntityLoadByPK( "Article", 1 );
		assertTrue( Article.hasMetaDescription() );
		Article = EntityLoadByPK( "Article", 3 );
		assertFalse( Article.hasMetaDescription() );
	}	

	function testHasMetaKeywords(){
		var Article = EntityLoadByPK( "Article", 1 );
		assertTrue( Article.hasMetaKeywords() );
		Article = EntityLoadByPK( "Article", 3 );
		assertFalse( Article.hasMetaKeywords() );
	}	
	
	function testHasMetaTitle(){
		var Article = EntityLoadByPK( "Article", 1 );
		assertTrue( Article.hasMetaTitle() );
		Article = EntityLoadByPK( "Article", 3 );
		assertFalse( Article.hasMetaTitle() );
	}
	
	function testIsMetaGenerated(){
		var Article = EntityLoadByPK( "Article", 1 );
		assertTrue( Article.isMetaGenerated() );
		Article = EntityLoadByPK( "Article", 3 );
		assertFalse( Article.isMetaGenerated() );
	}		
	
	function testIsNew(){
		CUT.setPublished( Now() );
		assertTrue( CUT.isNew() );
		CUT.setPublished( DateAdd( "ww", -2, Now() ) );
		assertFalse( CUT.isNew() );		
	}
	
	function testIsPersisted(){
		assertFalse( CUT.isPersisted() );
		var Article = EntityLoadByPK( "Article", 1 );
		assertTrue( Article.isPersisted() );		
	}
	
	function testIsPublished(){
		CUT.setPublished( DateAdd( "d", -1, Now() ) );
		assertTrue( CUT.isPublished() );
		CUT.setPublished( DateAdd( "d", 1, Now() ) );
		assertFalse( CUT.isPublished() );	
	}
	
	// private methods	
	
	function testIsUUIDUnique(){
		CUT.setTitle( "Sample Article A" );
		makePublic( CUT, "isUUIDUnique" );
		CUT.setUUID( "" );
		assertTrue( CUT.isUUIDUnique() );
	}	

	function testSetUUIDWhereRecordWithSameTitleExists(){
		CUT.setTitle( "Sample Article A" );
		makePublic( CUT, "setUUID" );
		CUT.setUUID( "" );
		assertEquals( "sample-article-a-", CUT.getUUID() );
	}	

	function testSetUUIDWhereRecordWithSameTitleDoesNotExist(){
		CUT.setTitle( "Sample Article D" );
		makePublic( CUT, "setUUID" );
		CUT.setUUID( "" );
		assertEquals( "sample-article-d", CUT.getUUID() );
	}	
	
	// ------------------------ IMPLICIT ------------------------ //
	
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		CUT = new model.news.Article(); 
	}
	
	/**
	* this will run after every single test in this test case
	*/
	function tearDown(){}
	
	/**
	* this will run once after initialization and before setUp()
	*/
	function beforeTests(){
		var q = new Query();
		q.setSQL( "DROP TABLE Articles;");
		q.execute();		
		ORMReload();
		q = new Query();
		q.setSQL( "
			INSERT INTO articles ( article_id, article_uuid, article_title, article_content, article_metagenerated, article_metatitle, article_metadescription, article_metakeywords, article_published, article_created, article_updated) 
			VALUES
				(1, 'sample-article-a', 'Sample Article A', '<p>Nunc eu auctor mi. Cras porta, augue a fermentum lacinia, enim justo lacinia nibh, eget congue arcu turpis sed neque! Sed enim ligula, dapibus nec molestie non, pellentesque vel leo. Proin feugiat rutrum erat, in porta sem luctus sed? Aenean vel odio erat, ac convallis turpis. Sed tempus posuere laoreet. Nam vel posuere ligula. Duis hendrerit, massa vel molestie ornare, enim felis sollicitudin arcu, quis tincidunt sapien dolor ac tortor. Integer viverra sagittis condimentum. Proin vitae sapien hendrerit nulla volutpat ultrices? Vivamus vitae fringilla odio. Morbi rhoncus suscipit viverra!<br /><br />Duis rhoncus justo quis augue feugiat interdum. In eget eros in orci vestibulum pretium. Nam semper, ipsum ut convallis tincidunt, odio sem pretium leo, sed porta massa tellus aliquam sapien. Quisque dignissim viverra leo luctus viverra. Nulla porta nisl et tortor tempus commodo. Maecenas luctus faucibus ligula, luctus ultricies augue cursus a! Nam quis ipsum ante, nec consequat sem? Proin ac elit nisl. Aliquam erat volutpat. Maecenas consectetur est ut nulla dapibus quis iaculis ante rhoncus? Phasellus lacinia cursus ligula, quis eleifend diam dignissim nec. Phasellus in magna sapien, at mattis diam. Aenean nunc metus, tincidunt quis sodales vel, adipiscing in sapien. Aliquam sollicitudin volutpat lacus, nec consequat quam blandit vel. Lorem ipsum dolor sit amet, consectetur adipiscing elit.<br /><br />Phasellus commodo nisl eget tellus pulvinar eu laoreet velit euismod. Maecenas nisi odio; dignissim in condimentum et, blandit ut est. Nullam lobortis purus quis nisi suscipit sit amet facilisis sem laoreet. In rhoncus mattis arcu, quis lobortis ligula porttitor sed. Aenean ac tortor eu turpis faucibus faucibus. Aliquam elementum condimentum turpis? Phasellus quis leo volutpat turpis lobortis convallis quis dictum est. Vestibulum ornare, sapien non rutrum rhoncus, sem metus scelerisque quam, interdum commodo nisi ligula at lacus. Curabitur auctor est rutrum nibh cursus vitae semper magna lacinia. Aenean eget est orci, nec facilisis urna. Sed pretium felis at felis feugiat facilisis. Quisque ut nisi justo, porta malesuada elit. Donec in libero dignissim nunc tempor lobortis. Donec sed nisi ligula, et elementum sapien.<br />&nbsp;</p>\r\n', true, 'Sample Article A', 'Nunc eu auctor mi. Cras porta, augue a fermentum lacinia, enim justo lacinia nibh, eget congue arcu turpis sed neque! Sed enim ligula, dapibus nec molestie non, pellente', 'Nunc,eu,auctor,mi,Cras,porta,augue,fermentum,lacinia,enim,justo,nibh,eget,congue,arcu,turpis,sed,neque!,ligula,dapibus,nec,molestie,non,pellentesque,vel,leo,Proin,feugia', '2012-05-26 00:00:00', '2012-05-26 12:36:34', '2012-05-26 12:36:34'),
				(2, 'sample-article-b', 'Sample Article B', '<p>Nunc eu auctor mi. Cras porta, augue a fermentum lacinia, enim justo lacinia nibh, eget congue arcu turpis sed neque! Sed enim ligula, dapibus nec molestie non, pellentesque vel leo. Proin feugiat rutrum erat, in porta sem luctus sed? Aenean vel odio erat, ac convallis turpis. Sed tempus posuere laoreet. Nam vel posuere ligula. Duis hendrerit, massa vel molestie ornare, enim felis sollicitudin arcu, quis tincidunt sapien dolor ac tortor. Integer viverra sagittis condimentum. Proin vitae sapien hendrerit nulla volutpat ultrices? Vivamus vitae fringilla odio. Morbi rhoncus suscipit viverra!<br /><br />Duis rhoncus justo quis augue feugiat interdum. In eget eros in orci vestibulum pretium. Nam semper, ipsum ut convallis tincidunt, odio sem pretium leo, sed porta massa tellus aliquam sapien. Quisque dignissim viverra leo luctus viverra. Nulla porta nisl et tortor tempus commodo. Maecenas luctus faucibus ligula, luctus ultricies augue cursus a! Nam quis ipsum ante, nec consequat sem? Proin ac elit nisl. Aliquam erat volutpat. Maecenas consectetur est ut nulla dapibus quis iaculis ante rhoncus? Phasellus lacinia cursus ligula, quis eleifend diam dignissim nec. Phasellus in magna sapien, at mattis diam. Aenean nunc metus, tincidunt quis sodales vel, adipiscing in sapien. Aliquam sollicitudin volutpat lacus, nec consequat quam blandit vel. Lorem ipsum dolor sit amet, consectetur adipiscing elit.<br /><br />Phasellus commodo nisl eget tellus pulvinar eu laoreet velit euismod. Maecenas nisi odio; dignissim in condimentum et, blandit ut est. Nullam lobortis purus quis nisi suscipit sit amet facilisis sem laoreet. In rhoncus mattis arcu, quis lobortis ligula porttitor sed. Aenean ac tortor eu turpis faucibus faucibus. Aliquam elementum condimentum turpis? Phasellus quis leo volutpat turpis lobortis convallis quis dictum est. Vestibulum ornare, sapien non rutrum rhoncus, sem metus scelerisque quam, interdum commodo nisi ligula at lacus. Curabitur auctor est rutrum nibh cursus vitae semper magna lacinia. Aenean eget est orci, nec facilisis urna. Sed pretium felis at felis feugiat facilisis. Quisque ut nisi justo, porta malesuada elit. Donec in libero dignissim nunc tempor lobortis. Donec sed nisi ligula, et elementum sapien.<br />&nbsp;</p>\r\n', true, 'Sample Article B', 'Nunc eu auctor mi. Cras porta, augue a fermentum lacinia, enim justo lacinia nibh, eget congue arcu turpis sed neque! Sed enim ligula, dapibus nec molestie non, pellente', 'Nunc,eu,auctor,mi,Cras,porta,augue,fermentum,lacinia,enim,justo,nibh,eget,congue,arcu,turpis,sed,neque!,ligula,dapibus,nec,molestie,non,pellentesque,vel,leo,Proin,feugia', '2012-06-26 00:00:00', '2012-06-26 12:36:42', '2012-06-26 12:36:42'),
				(3, 'sample-article-c', 'Sample Article C', '<p>Nunc eu auctor mi. Cras porta, augue a fermentum lacinia, enim justo lacinia nibh, eget congue arcu turpis sed neque! Sed enim ligula, dapibus nec molestie non, pellentesque vel leo. Proin feugiat rutrum erat, in porta sem luctus sed? Aenean vel odio erat, ac convallis turpis. Sed tempus posuere laoreet. Nam vel posuere ligula. Duis hendrerit, massa vel molestie ornare, enim felis sollicitudin arcu, quis tincidunt sapien dolor ac tortor. Integer viverra sagittis condimentum. Proin vitae sapien hendrerit nulla volutpat ultrices? Vivamus vitae fringilla odio. Morbi rhoncus suscipit viverra!<br /><br />Duis rhoncus justo quis augue feugiat interdum. In eget eros in orci vestibulum pretium. Nam semper, ipsum ut convallis tincidunt, odio sem pretium leo, sed porta massa tellus aliquam sapien. Quisque dignissim viverra leo luctus viverra. Nulla porta nisl et tortor tempus commodo. Maecenas luctus faucibus ligula, luctus ultricies augue cursus a! Nam quis ipsum ante, nec consequat sem? Proin ac elit nisl. Aliquam erat volutpat. Maecenas consectetur est ut nulla dapibus quis iaculis ante rhoncus? Phasellus lacinia cursus ligula, quis eleifend diam dignissim nec. Phasellus in magna sapien, at mattis diam. Aenean nunc metus, tincidunt quis sodales vel, adipiscing in sapien. Aliquam sollicitudin volutpat lacus, nec consequat quam blandit vel. Lorem ipsum dolor sit amet, consectetur adipiscing elit.<br /><br />Phasellus commodo nisl eget tellus pulvinar eu laoreet velit euismod. Maecenas nisi odio; dignissim in condimentum et, blandit ut est. Nullam lobortis purus quis nisi suscipit sit amet facilisis sem laoreet. In rhoncus mattis arcu, quis lobortis ligula porttitor sed. Aenean ac tortor eu turpis faucibus faucibus. Aliquam elementum condimentum turpis? Phasellus quis leo volutpat turpis lobortis convallis quis dictum est. Vestibulum ornare, sapien non rutrum rhoncus, sem metus scelerisque quam, interdum commodo nisi ligula at lacus. Curabitur auctor est rutrum nibh cursus vitae semper magna lacinia. Aenean eget est orci, nec facilisis urna. Sed pretium felis at felis feugiat facilisis. Quisque ut nisi justo, porta malesuada elit. Donec in libero dignissim nunc tempor lobortis. Donec sed nisi ligula, et elementum sapien.<br />&nbsp;</p>\r\n', false, '', '', '', '2012-06-26 00:00:00', '2012-06-26 12:36:51', '2012-06-26 12:36:51');
		" );
		q.execute();
	}
	
	/**
	* this will run once after all tests have been run
	*/
	function afterTests(){}

}