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

	function testDeletePage(){
		var pages = EntityLoad( "Page" );
		var result = ArrayLen( pages );
		assertEquals( 13, result );
		var Page = EntityLoadByPK( "Page", 13 );
		transaction{
			CUT.deletePage( Page );
		}
		pages = EntityLoad( "Page" );
		result = ArrayLen( pages );
		assertEquals( 12, result );
	}
	
	// test should only pass in MySQL where weighting is applied
	function testFindContentBySearchTerm(){
		var result = CUT.findContentBySearchTerm( searchterm='xindi', thedatasource='xindi_testsuite' );
		assertEquals( 3, result.recordcount );
		// check weighting (word in title should rank higher than in content)
		assertEquals( 'Title contains Xindi', result.title[1] );
		assertEquals( 'title', result.title[3] );
	}
	
	// test should only pass in MySQL where weighting is applied
	function testFindContentBySearchTermWithLimit(){
		var result = CUT.findContentBySearchTerm( searchterm='xindi', thedatasource='xindi_testsuite', maxresults=1 );
		assertEquals( 1, result.recordcount );
		// check weighting (word in title should rank higher than in content)
		assertEquals( 'Title contains Xindi', result.title[1] );
	}
	
	function testGetNavigation(){
		var result = CUT.getNavigation();
		assertEquals( 13, result.recordcount );
	}
	
	function testGetNavigationPath(){
		var result = CUT.getNavigationPath(5);
		assertEquals( 2, result.recordcount );
		assertEquals( 1, result.pageid[1] );
		assertEquals( 2, result.pageid[2] );
	}

	function testGetPageWherePageDoesNotExists(){
		var Page = CUT.getPage( 14 );
		var result = Page.isPersisted();
		assertFalse( result );		
	}
	
	function testGetPageWherePageExists(){
		var Page = CUT.getPage( 1 );
		var result = Page.isPersisted();
		assertTrue( result );
	}

	function testGetPageBySlugWherePageDoesNotExist(){
		var Page = CUT.getPageBySlug( "foo" );
		var result = Page.isPersisted();
		assertFalse( result );
	}
	
	function testGetPageSlugWherePageExists(){
		var Page = CUT.getPageBySlug( "home" );
		var result = Page.isPersisted();
		assertTrue( result );
	}
	
	function testGetPages(){
		var pages = CUT.getPages();
		var result = ArrayLen( pages );
		assertEquals( 13, result );
	}
	
	function testGetPagesBySearchTerm(){
		var pages = CUT.getPages( searchterm="home" );
		var result = ArrayLen( pages );
		assertEquals( 1, result );
	}
	
	function testGetPagesBySortOrder(){
		var pages = CUT.getPages( sortorder="pageid" );
		var result = pages[ 1 ].getSlug();
		assertEquals( "", result );
	}

	function testGetPagesBySortOrderDescending(){
		var pages = CUT.getPages( sortorder="pageid desc" );
		var result = pages[ 1 ].getSlug();
		assertEquals( "title--/title-----------", result );
	}

	function testGetPagesWithMaxResults(){
		var pages = CUT.getPages( maxresults=5 );
		var result = ArrayLen( pages );
		assertEquals( 5, result );
	}

	function testGetRoot(){
		var Page = CUT.getRoot();
		var result = Page.getLeftValue();
		assertEquals( 1, result );
	}

	function testMovePageDown(){
		var Page = EntityLoadByPK( "Page", 12 );
		var result = Page.getLeftValue();
		assertEquals( 21, result );
		Page = CUT.movePage( Page, "down" );
		result = Page.getLeftValue();
		assertEquals( 23, result );
	}

	function testMovePageUp(){
		var Page = EntityLoadByPK( "Page", 7 );
		var result = Page.getLeftValue();
		assertEquals( 7, result );
		Page = CUT.movePage( Page, "up" );
		result = Page.getLeftValue();
		assertEquals( 5, result );

	}

	function testSavePage(){
		var pages = EntityLoad( "Page" );
		var result = ArrayLen( pages );
		assertEquals( 13, result );		
		var Page = EntityNew( "Page" );
		Page.setTitle( "foo" );
		Page.setContent( "bar" );
		CUT.savePage( Page, 1 );
		pages = EntityLoad( "Page" );
		result = ArrayLen( pages );
		assertEquals( 14, result );
	}

	// ------------------------ IMPLICIT ------------------------ // 
	
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		// initialise component under test
		CUT = new model.content.ContentGateway(); 
		
		// reinitialise ORM for the application (create database table)
		ORMReload();
		
		// insert test data into database
		var q = new Query();
		q.setSQL( "
			INSERT INTO pages ( page_slug, page_left, page_right, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated ) 
			VALUES ( 'home', 1, 26, 'Home', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'Home', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120422', '20120619' );
			INSERT INTO pages ( page_slug, page_left, page_right, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated )
			VALUES ( 'title', 2, 9, 'Xindi in Title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619' );
			INSERT INTO pages ( page_slug, page_left, page_right, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated )
			VALUES ( 'title-', 10, 17, 'Title contains Xindi', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619' );
			INSERT INTO pages ( page_slug, page_left, page_right, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated )
			VALUES ( 'title--', 18, 25, 'title', '<p>Xindi Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619' );
			INSERT INTO pages ( page_slug, page_left, page_right, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated )
			VALUES ( 'title---', 3, 4, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619' );
			INSERT INTO pages ( page_slug, page_left, page_right, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated )
			VALUES ( 'title----', 5, 6, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619' );
			INSERT INTO pages ( page_slug, page_left, page_right, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated )
			VALUES ( 'title-----', 7, 8, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619' );
			INSERT INTO pages ( page_slug, page_left, page_right, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated )
			VALUES ( 'title------', 11, 12, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619' );
			INSERT INTO pages ( page_slug, page_left, page_right, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated )
			VALUES ( 'title-------', 13, 14, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619' );
			INSERT INTO pages ( page_slug, page_left, page_right, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated )
			VALUES ( 'title--------', 15, 16, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619' );
			INSERT INTO pages ( page_slug, page_left, page_right, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated )
			VALUES ( 'title---------', 19, 20, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619' );
			INSERT INTO pages ( page_slug, page_left, page_right, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated )
			VALUES ( 'title----------', 21, 22, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619' );
			INSERT INTO pages ( page_slug, page_left, page_right, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated )
			VALUES ( 'title-----------', 23, 24, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 0, '', '', '', '20120619', '20120619' );
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