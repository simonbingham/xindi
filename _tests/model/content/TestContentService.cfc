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
			
	// ------------------------ INTEGRATION TESTS ------------------------ //
	
	function testDeletePageWherePageDoesNotExist(){
		var deletepageresult = CUT.deletePage( 100 );
		var result = deletepageresult.getIsSuccess();
		assertFalse( result );
	}
	
	function testDeletePageWherePageExists(){
		var deletepageresult = CUT.deletePage( 13 );
		var result = deletepageresult.getIsSuccess();
		assertTrue( result );
	}

	function testGetPageWherePageDoesNotExist(){
		var Page = CUT.getPage( 14 );
		var result = Page.isPersisted();
		assertFalse( result );
	}
	
	function testGetPageWherePageExists(){
		var Page = CUT.getPage( 1 );
		var result = Page.isPersisted();
		assertTrue( result );
	}

	function testGetPageSlugWherePageDoesNotExist(){
		var Page = CUT.getPageBySlug( "foobar" );
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
		var result = pages[ 1 ].getLabel();
		assertEquals( "home", result );
	}

	function testGetPagesBySortOrderDescending(){
		var pages = CUT.getPages( sortorder="pageid desc" );
		var result = pages[ 1 ].getLabel();
		assertEquals( "title-----------", result );
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

	function testGetValidator(){
		var Page = CUT.getRoot();
		var result = IsObject( CUT.getValidator( Page ) );
		assertTrue( result );
	}

	function testMovePageWherePageCanBeMovedDown(){
		var movepageresult = CUT.movePage( 12, "down" );
		var result = movepageresult.getIsSuccess();
		assertTrue( result );
		result = movepageresult.getTheObject().getLeftValue();
		assertEquals( 23, result );
		result = movepageresult.getTheObject().getRightValue();
		assertEquals( 24, result );
	}

	function testMovePageWherePageCanBeMovedUp(){
		var movepageresult = CUT.movePage( 7, "up" );
		var result = movepageresult.getIsSuccess();
		assertTrue( result );
		result = movepageresult.getTheObject().getLeftValue();
		assertEquals( 5, result );
		result = movepageresult.getTheObject().getRightValue();
		assertEquals( 6, result );
	}

	function testMovePageWherePageCannotBeMovedDown(){
		var movepageresult = CUT.movePage( 13, "down" );
		var result = movepageresult.getIsSuccess();
		assertFalse( result );
	}

	function testMovePageWherePageCannotBeMovedUp(){
		var movepageresult = CUT.movePage( 11, "up" );
		var result = movepageresult.getIsSuccess();
		assertFalse( result );
	}

	function testSavePageWherePageIsInvalid(){
		var savepageresult = CUT.savePage( { title="", content="" }, 1, "create" );
		var result = savepageresult.getIsSuccess();
		assertFalse( result );
	}
	 
	function testSavePageWherePageIsValid(){
		var savepageresult = CUT.savePage( { title="foo", content="bar" }, 1, "create" );
		var result = savepageresult.getIsSuccess();
		assertTrue( result );
	}
	
	// ------------------------ IMPLICIT ------------------------ // 
	
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		// initialise component under test
		CUT = new model.content.ContentService();
		var ContentGateway = new model.content.ContentGateway();
		CUT.setContentGateway( ContentGateway );
		var validatorconfig = { definitionPath="/model/", JSIncludes=false, resultPath="model.utility.ValidatorResult" };
		Validator = new ValidateThis.ValidateThis( validatorconfig );
		CUT.setValidator( Validator );
		var MetaData = new model.content.MetaData();
		CUT.setMetaData( MetaData );
		
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