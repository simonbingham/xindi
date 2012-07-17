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
	
	function testGetAncestor(){
		var Page = EntityLoadByPK( "Page", 1 );
		var Ancestor = Page.getAncestor();
		var result = IsNull( Ancestor );
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 2 );
		Ancestor = Page.getAncestor();
		result = Ancestor.getPageID();
		assertEquals( 1, result );
		Page = EntityLoadByPK( "Page", 5 );
		Ancestor = Page.getAncestor();
		result = Ancestor.getPageID();
		assertEquals( 2, result );
	}
	
	function testGetDescendentCount(){
		var Page = EntityLoadByPK( "Page", 1 );
		makePublic( Page, "getDescendentCount" );
		var result = Page.getDescendentCount();
		assertEquals( 12, result );
		Page = EntityLoadByPK( "Page", 2 );
		makePublic( Page, "getDescendentCount" );
		result = Page.getDescendentCount();
		assertEquals( 3, result );
		Page = EntityLoadByPK( "Page", 5 );
		makePublic( Page, "getDescendentCount" );
		result = Page.getDescendentCount();
		assertEquals( 0, result );
	}	
	
	function testGetDescendentPageIDList(){
		var Page = EntityLoadByPK( "Page", 1 );
		var result = Page.getDescendentPageIDList();
		assertEquals( "2,3,4,5,6,7,8,9,10,11,12,13", result );		
		Page = EntityLoadByPK( "Page", 2 );
		result = Page.getDescendentPageIDList();
		assertEquals( "5,6,7", result );		
		Page = EntityLoadByPK( "Page", 5 );
		result = Page.getDescendentPageIDList();
		assertEquals( "", result );		
	}
	
	function testGetDescendents(){
		var Page = EntityLoadByPK( "Page", 1 );
		makePublic( Page, "getDescendents" );
		var result = ArrayLen( Page.getDescendents() );
		assertEquals( 12, result );
		Page = EntityLoadByPK( "Page", 2 );
		makePublic( Page, "getDescendents" );
		result = ArrayLen( Page.getDescendents() );
		assertEquals( 3, result );
		Page = EntityLoadByPK( "Page", 5 );
		makePublic( Page, "getDescendents" );
		result = ArrayLen( Page.getDescendents() );
		assertEquals( 0, result );
	}	
	
	function testGetFirstChild(){
		var Page = EntityLoadByPK( "Page", 1 );
		makePublic( Page, "getFirstChild" );
		var FirstChild = Page.getFirstChild();
		var result = FirstChild.getPageID();
		assertEquals( 2, result );
		Page = EntityLoadByPK( "Page", 2 );
		makePublic( Page, "getFirstChild" );
		FirstChild = Page.getFirstChild();
		result = FirstChild.getPageID();
		assertEquals( 5, result );
		Page = EntityLoadByPK( "Page", 5 );
		makePublic( Page, "getFirstChild" );
		FirstChild = Page.getFirstChild();
		result = IsNull( FirstChild );
		assertTrue( result );
	}	
	
	function testGetLastChild(){
		var Page = EntityLoadByPK( "Page", 1 );
		makePublic( Page, "getLastChild" );
		var LastChild = Page.getLastChild();
		var result = LastChild.getPageID();
		assertEquals( 4, result );
		Page = EntityLoadByPK( "Page", 2 );
		makePublic( Page, "getLastChild" );
		LastChild = Page.getLastChild();
		result = LastChild.getPageID();
		assertEquals( 7, result );
		Page = EntityLoadByPK( "Page", 5 );
		makePublic( Page, "getLastChild" );
		LastChild = Page.getLastChild();
		result = IsNull( LastChild );
		assertTrue( result );
	}	
	
	function testGetLevel(){
		var Page = EntityLoadByPK( "Page", 1 );
		var result = Page.getLevel();
		assertEquals( 0, result );
		Page = EntityLoadByPK( "Page", 2 );
		result = Page.getLevel();
		assertEquals( 1, result );
		Page = EntityLoadByPK( "Page", 5 );
		result = Page.getLevel();
		assertEquals( 2, result );
	}

	function testGetNextSibling(){
		var Page = EntityLoadByPK( "Page", 1 );
		var NextSibling = Page.getNextSibling();
		var result = IsNull( NextSibling );
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 2 );
		NextSibling = Page.getNextSibling();
		result = NextSibling.getPageID();
		assertEquals( 3, result );		
		Page = EntityLoadByPK( "Page", 5 );
		NextSibling = Page.getNextSibling();
		result = NextSibling.getPageID();
		assertEquals( 6, result );		
	}

	function testGetPath(){
		var Page = EntityLoadByPK( "Page", 5 );
		var result = ArrayLen( Page.getPath() );
		assertEquals( 2, result );
		Page = EntityLoadByPK( "Page", 2 );
		result = ArrayLen( Page.getPath() );
		assertEquals( 1, result );
		Page = EntityLoadByPK( "Page", 1 );
		result = ArrayLen( Page.getPath() );
		assertEquals( 0, result );
	}

	function testGetPreviousSibling(){
		var Page = EntityLoadByPK( "Page", 1 );
		var PreviousSibling = Page.getPreviousSibling();
		var result = IsNull( PreviousSibling );
		assertTrue( result );		
		Page = EntityLoadByPK( "Page", 3 );
		PreviousSibling = Page.getPreviousSibling();
		result = PreviousSibling.getPageID();
		assertEquals( 2, result );
	}

	function testGetSlug(){
		var Page = EntityLoadByPK( "Page", 1 );
		var result = Page.getSlug();
		assertEquals( "", result );	
		Page = EntityLoadByPK( "Page", 2 );
		result = Page.getSlug();
		assertEquals( "title", result );	
		Page = EntityLoadByPK( "Page", 5 );
		result = Page.getSlug();
		assertEquals( "title/title---", result );	
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

	function testHasChild(){
		var Page = EntityLoadByPK( "Page", 1 );
		var result = Page.hasChild();
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 2 );
		result = Page.hasChild();
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 5 );
		result = Page.hasChild();
		assertFalse( result );
	}

	function testHasContent(){
		var Page = EntityLoadByPK( "Page", 1 );
		makePublic( Page, "hasContent" );
		var result = Page.hasContent();
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 2 );
		makePublic( Page, "hasContent" );
		result = Page.hasContent();
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 5 );
		makePublic( Page, "hasContent" );
		result = Page.hasContent();
		assertTrue( result );
	}
	
	function testHasDescendents(){
		var Page = EntityLoadByPK( "Page", 1 );
		makePublic( Page, "hasDescendents" );
		var result = Page.hasDescendents();
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 2 );
		makePublic( Page, "hasDescendents" );
		result = Page.hasDescendents();
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 5 );
		makePublic( Page, "hasDescendents" );
		result = Page.hasDescendents();
		assertFalse( result );
	}	

	function testHasNextSibling(){
		var Page = EntityLoadByPK( "Page", 1 );
		var result = Page.hasNextSibling();
		assertFalse( result );
		Page = EntityLoadByPK( "Page", 2 );
		result = Page.hasNextSibling();
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 5 );
		result = Page.hasNextSibling();
		assertTrue( result );
	}

	function testHasMetaDescription(){
		var Page = EntityLoadByPK( "Page", 1 );
		var result = Page.hasMetaDescription();
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 13 );
		result = Page.hasMetaDescription();
		assertFalse( result );
	}

	function testHasMetaKeywords(){
		var Page = EntityLoadByPK( "Page", 1 );
		var result = Page.hasMetaKeywords();
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 13 );
		result = Page.hasMetaKeywords();
		assertFalse( result );
	}

	function testHasMetaTitle(){
		var Page = EntityLoadByPK( "Page", 1 );
		var result = Page.hasMetaTitle();
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 13 );
		result = Page.hasMetaTitle();
		assertFalse( result );
	}

	function testHasPageIDInPath(){
		var Page = EntityLoadByPK( "Page", 1 );
		var result = Page.hasPageIDInPath( 3 );
		assertFalse( result );
		Page = EntityLoadByPK( "Page", 3 );
		result = Page.hasPageIDInPath( 1 );
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 6 );
		result = Page.hasPageIDInPath( 2 );
		assertTrue( result );
	}

	function testHasPreviousSibling(){
		var Page = EntityLoadByPK( "Page", 1 );
		var result = Page.hasPreviousSibling();
		assertFalse( result );
		Page = EntityLoadByPK( "Page", 3 );
		result = Page.hasPreviousSibling();
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 6 );
		result = Page.hasPreviousSibling();
		assertTrue( result );
	}

	function testHasRoute(){
		var routes = [ { hint="", title="title" } ];
		var Page = EntityLoadByPK( "Page", 1 );
		var result = Page.hasRoute( routes );
		assertFalse( result );
		Page = EntityLoadByPK( "Page", 2 );
		result = Page.hasRoute( routes );
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 6 );
		result = Page.hasRoute( routes );
		assertFalse( result );
	}

	function testIsChild(){
		var Page = EntityLoadByPK( "Page", 1 );
		makePublic( Page, "isChild" );
		var result = Page.isChild();
		assertFalse( result );
		Page = EntityLoadByPK( "Page", 2 );
		makePublic( Page, "isChild" );
		result = Page.isChild();
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 5 );
		makePublic( Page, "isChild" );
		result = Page.isChild();
		assertTrue( result );
	}

	function testIsLabelUniqueWhereLabelDoesNotExist(){
		CUT.setTitle( "foobar" );
		makePublic( CUT, "setLabel" );
		makePublic( CUT, "isLabelUnique" );
		CUT.setLabel();
		var result = CUT.isLabelUnique();
		assertTrue( result );
	}
	
	function testIsLabelUniqueWhereLabelExists(){
		CUT.setTitle( "title" );
		makePublic( CUT, "setLabel" );
		makePublic( CUT, "isLabelUnique" );
		CUT.setLabel();
		var result = CUT.isLabelUnique();
		assertTrue( result );
	}	

	function testIsLeaf(){
		var Page = EntityLoadByPK( "Page", 1 );
		var result = Page.isLeaf();
		assertFalse( result );
		Page = EntityLoadByPK( "Page", 6 );
		result = Page.isLeaf();
		assertTrue( result );		
		Page = EntityLoadByPK( "Page", 7 );
		result = Page.isLeaf();
		assertTrue( result );		
	}

	function testIsMetaGenerated(){
		var Page = EntityLoadByPK( "Page", 1 );
		var result = Page.isMetaGenerated();
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 13 );
		result = Page.isMetaGenerated();
		assertFalse( result );
	}

	function testIsPersisted(){
		var Page = EntityLoadByPK( "Page", 1 );
		var result = Page.isPersisted();
		assertTrue( result );
		Page = EntityNew( "Page" );
		result = Page.isPersisted();
		assertFalse( result );
	}

	function testIsRoot(){
		var Page = EntityLoadByPK( "Page", 1 );
		var result = Page.isRoot();
		assertTrue( result );
		Page = EntityLoadByPK( "Page", 13 );
		result = Page.isRoot();
		assertFalse( result );
	}
	
	function testSetLabel(){
		var Page = EntityNew( "Page" );
		Page.setTitle( "this is a unique id" ); // setLabel uses value returned by getTitle
		makePublic( Page, "setLabel" );
		Page.setLabel();
		var result = Page.getLabel();
		assertEquals( "this-is-a-unique-id", result );
	}

	// ------------------------ IMPLICIT ------------------------ // 
	
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		// initialise component under test
		CUT = new model.content.Page();

		// reinitialise ORM for the application (create database table)
		ORMReload();
		
		// insert test data into database
		var q = new Query();
		q.setSQL( "
			INSERT INTO pages ( page_id, page_label, page_left, page_right, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated ) 
			VALUES
				( 1, 'home', 1, 26, 'Home', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', true, 'Home', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '2012-04-22 00:00:00', '2012-06-19 17:09:11' ),
				( 2, 'title', 2, 9, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', true, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '2012-06-19 17:08:57', '2012-06-19 17:08:57' ),
				( 3, 'title-', 10, 17, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', true, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '2012-06-19 17:09:30', '2012-06-19 17:09:30' ),
				( 4, 'title--', 18, 25, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', true, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '2012-06-19 17:09:43', '2012-06-19 17:09:43' ),
				( 5, 'title---', 3, 4, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', true, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '2012-06-19 17:10:00', '2012-06-19 17:10:00' ),
				( 6, 'title----', 5, 6, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', true, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '2012-06-19 17:10:12', '2012-06-19 17:10:12' ),
				( 7, 'title-----', 7, 8, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', true, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '2012-06-19 17:10:26', '2012-06-19 17:10:26' ),
				( 8, 'title------', 11, 12, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', true, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '2012-06-19 17:10:38', '2012-06-19 17:10:38' ),
				( 9, 'title-------', 13, 14, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', true, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '2012-06-19 17:10:49', '2012-06-19 17:10:49' ),
				( 10, 'title--------', 15, 16, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', true, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '2012-06-19 17:11:00', '2012-06-19 17:11:00' ),
				( 11, 'title---------', 19, 20, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', true, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '2012-06-19 17:11:11', '2012-06-19 17:11:11' ),
				( 12, 'title----------', 21, 22, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', true, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '2012-06-19 17:11:24', '2012-06-19 17:11:24' ),
				( 13, 'title-----------', 23, 24, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', false, '', '', '', '2012-06-19 17:11:36', '2012-06-19 17:11:36' );
		" );
		q.execute();
	}
	
	/**
	* this will run after every single test in this test case
	*/
	function tearDown(){
		// destroy test data
		var q = new Query();
		q.setSQL( "DROP TABLE Pages;");
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