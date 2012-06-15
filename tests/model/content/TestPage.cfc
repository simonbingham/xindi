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
	 
	function testGetAncestor(){
		var Page = EntityLoadByPK( "Page", 2 );
		var Ancestor = Page.getAncestor();
		assertEquals( 1, Ancestor.getPageID() );
	}
	
	function testGetDescendentPageIDList(){
		var Page = EntityLoadByPK( "Page", 1 );
		var descendentpageidlist = Page.getDescendentPageIDList();
		assertEquals( "2,3,4,5,6", descendentpageidlist );		
	}
	
	function testGetLevel(){
		var Page = EntityLoadByPK( "Page", 1 );
		assertEquals( 0, Page.getLevel() );
		var Page = EntityLoadByPK( "Page", 2 );
		assertEquals( 1, Page.getLevel() );
	}

	function testGetNextSibling(){
		fail( "test not yet implemented" );
	}

	function testGetPath(){
		fail( "test not yet implemented" );
	}

	function testGetPreviousSibling(){
		fail( "test not yet implemented" );
	}

	function testGetSlug(){
		fail( "test not yet implemented" );
	}

	function testGetSummary(){
		fail( "test not yet implemented" );
	}

	function testHasChild(){
		fail( "test not yet implemented" );
	}

	function testHasNextSibling(){
		fail( "test not yet implemented" );
	}

	function testHasMetaDescription(){
		fail( "test not yet implemented" );
	}

	function testHasMetaKeywords(){
		fail( "test not yet implemented" );
	}

	function testHasMetaTitle(){
		fail( "test not yet implemented" );
	}

	function testHasPageIDInPath(){
		fail( "test not yet implemented" );
	}

	function testHasPreviousSibling(){
		fail( "test not yet implemented" );
	}

	function testHasRoute(){
		fail( "test not yet implemented" );
	}

	function testIsLeaf(){
		fail( "test not yet implemented" );
	}

	function testIsMetaGenerated(){
		fail( "test not yet implemented" );
	}

	function testIsPersisted(){
		fail( "test not yet implemented" );
	}

	function testIsRoot(){
		fail( "test not yet implemented" );
	}

	// private methods
	
	function testGetDescendentCount(){
		fail( "test not yet implemented" );
	}
	
	function testGetDescendents(){
		fail( "test not yet implemented" );
	}

	function testGetFirstChild(){
		fail( "test not yet implemented" );
	}

	function testGetLastChild(){
		fail( "test not yet implemented" );
	}

	function testHasContent(){
		fail( "test not yet implemented" );
	}

	function testHasDescendents(){
		fail( "test not yet implemented" );
	}

	function testIsChild(){
		fail( "test not yet implemented" );
	}
	
	function testUUIDUnique(){
		fail( "test not yet implemented" );
	}
	
	function testSetUUID(){
		fail( "test not yet implemented" );
	}
	 
	// ------------------------ IMPLICIT ------------------------ // 
	
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){}
	
	/**
	* this will run after every single test in this test case
	*/
	function tearDown(){}
	
	/**
	* this will run once after initialization and before setUp()
	*/
	function beforeTests(){
		var q = new Query();
		q.setSQL( "DROP TABLE Pages;");
		q.execute();		
		
		ORMReload();
		
		q = new Query();
		q.setSQL( "
			INSERT INTO pages ( page_id, page_uuid, page_left, page_right, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated ) 
			VALUES
				( 1, 'home', 1, 12, 'Home', '<div class=""page-header""><h1>Welcome to Xindi</h1></div><p><img align=""right"" alt="""" border=""2"" src=""_clientfiles/home/xindi-logo.gif"" style=""padding:5px;margin-left: 5px;"" /><strong>You have successfully installed Xindi!</strong></p><p>	This is the public facing site which you can customise with your own design. <a href=""./admin"" target=""_blank"">You can access the content management system here</a>. The default username and password are &##39;admin&##39;.</p><p>	If you need support you can:</p><ul>	<li>		<a href=""https://github.com/simonbingham/xindi"">View our Wiki and Issue Tracker</a></li>	<li>		<a href=""https://groups.google.com/forum/?hl=en&amp;fromgroups##!forum/getxindi"">Join our Google Group</a></li>	<li>		Email us at <a href=""mailto:enquiries@getxindi.com"">enquiries@getxindi.com</a></li>	<li>		Tweet us <a href=""https://twitter.com/##!/getxindi"">@getxindi</a></li></ul><p>	To keep up to date with the latest Xindi news:</p><ul>	<li>		<a href=""http://www.getxindi.com/"">Visit our website</a></li>	<li>		<a href=""https://twitter.com/##!/getxindi"">Follow us on Twitter</a></li>	<li>		<a href=""http://www.facebook.com/getxindi"">Find us on Facebook</a></li>	<li>		<a href=""https://plus.google.com/112798469896267857099/posts"">Find us on Google+</a></li></ul><p>	We very much welcome contributions to Xindi. If you would like to contribute some code please <a href=""http://github.com/simonbingham/xindi"">fork the project on GitHub and send us a pull request</a>.</p><p>	Finally, although Xindi is an open source project and completely free to use, we also offer a range of paid services including design, programming, hosting and promotion. For more information please email us at <a href=""mailto:enquiries@getxindi.com"">enquiries@getxindi.com</a>.</p>', true, 'Welcome to Xindi', 'Welcome to Xindi You have successfully installed Xindi! This is the public facing site which you can customise with your own design. You can access the content managemen', 'Welcome,Xindi,You,have,successfully,installed,Xindi!,public,facing,site,which,can,customise,with,your,own,design,access,content,management,system,here,default,username,p', '2012-04-22 00:00:00', '2012-05-30 12:38:09' ),
				( 2, 'design', 2, 3, 'Design', '<div class=""page-header""><h1>Design</h1></div><p>Nullam egestas accumsan vestibulum! Sed id lectus vitae nunc venenatis venenatis vitae eu sem. Nam sit amet augue vitae mi ornare bibendum feugiat sed erat. Mauris risus neque; aliquam non rutrum ac, molestie consequat mi. Fusce vitae mauris nec tortor pretium rutrum. In hac habitasse platea dictumst. Maecenas volutpat porttitor pellentesque. Duis sapien neque, cursus interdum ultrices non, lacinia vel lorem. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Ut a leo eget purus congue gravida. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam vulputate bibendum arcu non luctus. Curabitur pretium felis ac ipsum pellentesque nec tempus arcu malesuada.<br /><br />Integer eleifend sem ullamcorper felis gravida gravida. Integer orci arcu, feugiat vitae condimentum sed, commodo et nisl. Donec nibh nisi; gravida a pulvinar vitae, placerat cursus augue. Integer et libero id velit ullamcorper auctor. Nullam dictum scelerisque fringilla. Praesent fringilla lorem a elit dictum vel suscipit nisl egestas. Nullam eget arcu lacus. Praesent scelerisque, augue ut condimentum sagittis, arcu eros facilisis purus, malesuada fermentum neque velit quis dui. Aliquam fermentum hendrerit metus ac sollicitudin. Vestibulum varius, urna at ultricies scelerisque, libero orci aliquet mi, a molestie purus massa et lectus! Aenean nulla sem, venenatis vel pulvinar non, volutpat in dui! In id risus arcu. Vivamus at ipsum erat, in fringilla massa. Sed accumsan lacinia fringilla.<br /><br />In posuere porttitor purus. Fusce mi lorem; pretium ut feugiat id, tincidunt consectetur enim. Aenean feugiat arcu sed tellus scelerisque eget luctus turpis sodales. Integer in felis orci. Curabitur ultricies mi non nibh condimentum ac commodo turpis adipiscing. Mauris sapien lorem, dignissim ac ultrices vitae, scelerisque a turpis. Praesent et nunc nec magna euismod ultrices. Proin eget scelerisque elit. Etiam rutrum ipsum id mauris tincidunt feugiat. Suspendisse lectus ante, porta vitae tempor et, sagittis sit amet mauris. Phasellus sed leo eu magna viverra consectetur id non purus. Nam placerat varius purus, sed ullamcorper lacus porta tristique.<br />&nbsp;</p>', true, 'Design', 'Design Nullam egestas accumsan vestibulum! Sed id lectus vitae nunc venenatis venenatis vitae eu sem. Nam sit amet augue vitae mi ornare bibendum feugiat sed erat. Mauri', 'Design,Nullam,egestas,accumsan,vestibulum!,Sed,id,lectus,vitae,nunc,venenatis,eu,sem,Nam,sit,amet,augue,mi,ornare,bibendum,feugiat,erat,Mauris,risus,neque;,aliquam,non,r', '2012-05-09 17:13:06', '2012-06-08 10:07:49' ),
				( 3, 'consulting', 4, 5, 'Consulting', '<div class=""page-header""><h1>Consulting</h1></div><p>Nullam egestas accumsan vestibulum! Sed id lectus vitae nunc venenatis venenatis vitae eu sem. Nam sit amet augue vitae mi ornare bibendum feugiat sed erat. Mauris risus neque; aliquam non rutrum ac, molestie consequat mi. Fusce vitae mauris nec tortor pretium rutrum. In hac habitasse platea dictumst. Maecenas volutpat porttitor pellentesque. Duis sapien neque, cursus interdum ultrices non, lacinia vel lorem. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Ut a leo eget purus congue gravida. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam vulputate bibendum arcu non luctus. Curabitur pretium felis ac ipsum pellentesque nec tempus arcu malesuada.<br /><br />Integer eleifend sem ullamcorper felis gravida gravida. Integer orci arcu, feugiat vitae condimentum sed, commodo et nisl. Donec nibh nisi; gravida a pulvinar vitae, placerat cursus augue. Integer et libero id velit ullamcorper auctor. Nullam dictum scelerisque fringilla. Praesent fringilla lorem a elit dictum vel suscipit nisl egestas. Nullam eget arcu lacus. Praesent scelerisque, augue ut condimentum sagittis, arcu eros facilisis purus, malesuada fermentum neque velit quis dui. Aliquam fermentum hendrerit metus ac sollicitudin. Vestibulum varius, urna at ultricies scelerisque, libero orci aliquet mi, a molestie purus massa et lectus! Aenean nulla sem, venenatis vel pulvinar non, volutpat in dui! In id risus arcu. Vivamus at ipsum erat, in fringilla massa. Sed accumsan lacinia fringilla.<br /><br />In posuere porttitor purus. Fusce mi lorem; pretium ut feugiat id, tincidunt consectetur enim. Aenean feugiat arcu sed tellus scelerisque eget luctus turpis sodales. Integer in felis orci. Curabitur ultricies mi non nibh condimentum ac commodo turpis adipiscing. Mauris sapien lorem, dignissim ac ultrices vitae, scelerisque a turpis. Praesent et nunc nec magna euismod ultrices. Proin eget scelerisque elit. Etiam rutrum ipsum id mauris tincidunt feugiat. Suspendisse lectus ante, porta vitae tempor et, sagittis sit amet mauris. Phasellus sed leo eu magna viverra consectetur id non purus. Nam placerat varius purus, sed ullamcorper lacus porta tristique.<br />&nbsp;</p>', true, 'Consulting', 'Consulting Nullam egestas accumsan vestibulum! Sed id lectus vitae nunc venenatis venenatis vitae eu sem. Nam sit amet augue vitae mi ornare bibendum feugiat sed erat. M', 'Consulting,Nullam,egestas,accumsan,vestibulum!,Sed,id,lectus,vitae,nunc,venenatis,eu,sem,Nam,sit,amet,augue,mi,ornare,bibendum,feugiat,erat,Mauris,risus,neque;,aliquam,n', '2012-05-09 17:13:15', '2012-06-08 10:08:04' ),
				( 4, 'training', 6, 7, 'Training', '<div class=""page-header""><h1>Training</h1></div><p>Nullam egestas accumsan vestibulum! Sed id lectus vitae nunc venenatis venenatis vitae eu sem. Nam sit amet augue vitae mi ornare bibendum feugiat sed erat. Mauris risus neque; aliquam non rutrum ac, molestie consequat mi. Fusce vitae mauris nec tortor pretium rutrum. In hac habitasse platea dictumst. Maecenas volutpat porttitor pellentesque. Duis sapien neque, cursus interdum ultrices non, lacinia vel lorem. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Ut a leo eget purus congue gravida. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam vulputate bibendum arcu non luctus. Curabitur pretium felis ac ipsum pellentesque nec tempus arcu malesuada.<br /><br />Integer eleifend sem ullamcorper felis gravida gravida. Integer orci arcu, feugiat vitae condimentum sed, commodo et nisl. Donec nibh nisi; gravida a pulvinar vitae, placerat cursus augue. Integer et libero id velit ullamcorper auctor. Nullam dictum scelerisque fringilla. Praesent fringilla lorem a elit dictum vel suscipit nisl egestas. Nullam eget arcu lacus. Praesent scelerisque, augue ut condimentum sagittis, arcu eros facilisis purus, malesuada fermentum neque velit quis dui. Aliquam fermentum hendrerit metus ac sollicitudin. Vestibulum varius, urna at ultricies scelerisque, libero orci aliquet mi, a molestie purus massa et lectus! Aenean nulla sem, venenatis vel pulvinar non, volutpat in dui! In id risus arcu. Vivamus at ipsum erat, in fringilla massa. Sed accumsan lacinia fringilla.<br /><br />In posuere porttitor purus. Fusce mi lorem; pretium ut feugiat id, tincidunt consectetur enim. Aenean feugiat arcu sed tellus scelerisque eget luctus turpis sodales. Integer in felis orci. Curabitur ultricies mi non nibh condimentum ac commodo turpis adipiscing. Mauris sapien lorem, dignissim ac ultrices vitae, scelerisque a turpis. Praesent et nunc nec magna euismod ultrices. Proin eget scelerisque elit. Etiam rutrum ipsum id mauris tincidunt feugiat. Suspendisse lectus ante, porta vitae tempor et, sagittis sit amet mauris. Phasellus sed leo eu magna viverra consectetur id non purus. Nam placerat varius purus, sed ullamcorper lacus porta tristique.<br />&nbsp;</p>', true, 'Training', 'Training Nullam egestas accumsan vestibulum! Sed id lectus vitae nunc venenatis venenatis vitae eu sem. Nam sit amet augue vitae mi ornare bibendum feugiat sed erat. Mau', 'Training,Nullam,egestas,accumsan,vestibulum!,Sed,id,lectus,vitae,nunc,venenatis,eu,sem,Nam,sit,amet,augue,mi,ornare,bibendum,feugiat,erat,Mauris,risus,neque;,aliquam,non', '2012-05-09 17:13:25', '2012-06-08 10:08:18' ),
				( 5, 'news', 8, 9, 'News', '<div class=""page-header""><h1>News</h1></div><p><a href=""https://github.com/simonbingham/xindi/wiki/2.-Frequently-Asked-Questions"">Follow the instructions on our wiki</a> to make this page redirect to the news feature.</p><p>	Alternatively, you can access the news feature at <a href=""index.cfm/news"">index.cfm/news</a>.</p>', true, 'News', 'News You can follow the instructions on our wiki to make this page redirect to the news feature. You can also access the news feature at index.cfm/news .', 'News,You,can,follow,instructions,our,wiki,make,page,redirect,feature,also,access,at,indexcfm/news', '2012-05-09 17:13:34', '2012-05-29 19:53:34' ),
				( 6, 'enquiry', 10, 11, 'Contact', '<div class=""page-header""><h1>Contact</h1></div><p><a href=""https://github.com/simonbingham/xindi/wiki/2.-Frequently-Asked-Questions"">Follow the instructions on our wiki</a> to make this page redirect to the contact form feature.</p><p>	Alternatively, you can access the contact form feature at <a href=""index.cfm/enquiry"">index.cfm/enquiry</a>.</p>', true, 'Contact', 'Contact Follow the instructions on our wiki to make this page redirect to the contact form feature. Alternatively, you can access the contact form feature at index.cfm/e', 'Contact,Follow,instructions,our,wiki,make,page,redirect,form,feature,Alternatively,you,can,access,at,indexcfm/enquiry', '2012-05-09 17:13:43', '2012-05-29 20:00:17' );
		" );
		q.execute();
	}
	
	/**
	* this will run once after all tests have been run
	*/
	function afterTests(){}
	
}