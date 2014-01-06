component extends="mxunit.framework.TestCase" {

	// ------------------------ UNIT TESTS ------------------------ //

	function testDeletePage() {
		var pages = EntityLoad("Page");
		var result = ArrayLen(pages);
		assertEquals(13, result);
		var Page = EntityLoadByPK("Page", 13);
		transaction{
			CUT.deletePage(Page);
		}
		pages = EntityLoad("Page");
		result = ArrayLen(pages);
		assertEquals(12, result);
	}

	function testFindContentBySearchTerm() {
		var result = CUT.findContentBySearchTerm(searchterm='xindi');
		assertEquals(3, result.recordcount);
		// check weighting (word in title should rank higher than in content)
		assertEquals('Title contains Xindi', result.title[1]);
		assertEquals('title', result.title[3]);
	}

	function testFindContentBySearchTermWithLimit() {
		var result = CUT.findContentBySearchTerm(searchterm='xindi', maxresults=1);
		assertEquals(1, result.recordcount);
		// check weighting (word in title should rank higher than in content)
		assertEquals('Title contains Xindi', result.title[1]);
	}

	function testGetChildren() {
		var result = CUT.getChildren(left=1, right=18);
		assertEquals(2, result.recordcount); // note: 2 as only returns direct descendants
	}

	function testGetChildrenClearCache() {
		var result = CUT.getChildren(left=1, right=18,clearcache=true);
		assertEquals(2, result.recordcount);
	}

	function testGetNavigation() {
		var result = CUT.getNavigation();
		assertEquals(13, result.recordcount);
	}

	function testGetNavigationClearCache() {
		var result = CUT.getNavigation(clearcache=true);
		assertEquals(13, result.recordcount);
	}

	function testGetNavigationLeft() {
		var result = CUT.getNavigation(left=1);
		assertEquals(12, result.recordcount);
	}

	function testGetNavigationLeftRight() {
		var result = CUT.getNavigation(left=1, right=13);
		assertEquals(5, result.recordcount);
	}

	function testGetNavigationPath() {
		var result = CUT.getNavigationPath(5);
		assertEquals(2, result.recordcount);
		assertEquals(1, result.pageid[1]);
		assertEquals(2, result.pageid[2]);
	}

	function testGetPageWherePageDoesNotExists() {
		var Page = CUT.getPage(14);
		var result = Page.isPersisted();
		assertFalse(result);
	}

	function testGetPageWherePageExists() {
		var Page = CUT.getPage(1);
		var result = Page.isPersisted();
		assertTrue(result);
	}

	function testGetPageBySlugWherePageDoesNotExist() {
		var Page = CUT.getPageBySlug("foo");
		var result = Page.isPersisted();
		assertFalse(result);
	}

	function testGetPageSlugWherePageExists() {
		var Page = CUT.getPageBySlug("home");
		var result = Page.isPersisted();
		assertTrue(result);
	}

	function testGetPages() {
		var pages = CUT.getPages();
		var result = ArrayLen(pages);
		assertEquals(13, result);
	}

	function testGetPagesBySearchTerm() {
		var pages = CUT.getPages(searchterm="home");
		var result = ArrayLen(pages);
		assertEquals(1, result);
	}

	function testGetPagesBySortOrder() {
		var pages = CUT.getPages(sortorder="pageid");
		var result = pages[1].getSlug();
		assertEquals("home", result);
	}

	function testGetPagesBySortOrderDescending() {
		var pages = CUT.getPages(sortorder="pageid desc");
		var result = pages[1].getSlug();
		assertEquals("title--/title-----------", result);
	}

	function testGetPagesWithMaxResults() {
		var pages = CUT.getPages(maxresults=5);
		var result = ArrayLen(pages);
		assertEquals(5, result);
	}

	function testGetRoot() {
		var Page = CUT.getRoot();
		var result = Page.getLeftValue();
		assertEquals(1, result);
	}

	function testIsSlugUniqueWhereSlugDoesNotExist() {
		makePublic(CUT, "isSlugUnique");
		var result = CUT.isSlugUnique("foobar");
		assertTrue(result);
	}

	function testIsSlugUniqueWhereSlugExists() {
		makePublic(CUT, "isSlugUnique");
		var result = CUT.isSlugUnique("title");
		assertFalse(result);
	}

	function testSavePage() {
		var pages = EntityLoad("Page");
		var result = ArrayLen(pages);
		assertEquals(13, result);
		var Page = EntityNew("Page");
		Page.setTitle("foo");
		Page.setContent("bar");
		CUT.savePage(Page, 1, "home");
		pages = EntityLoad("Page");
		result = ArrayLen(pages);
		assertEquals(14, result);
	}

	function testShiftPages() {
		CUT.ShiftPages(affectedpages="1,2,3", shift=0);
	}

	// ------------------------ IMPLICIT ------------------------ //

	/**
	* this will run before every single test in this test case
	*/
	function setUp() {
		// initialise component under test
		CUT = new model.content.ContentGateway();

		// reinitialise ORM for the application (create database table)
		ORMReload();

		// insert test data into database
		var q = new Query();
		q.setSQL("
			INSERT INTO pages (page_slug, page_left, page_right, page_ancestorid, page_depth, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated)
			VALUES ('home', 1, 26, 0, 1, 'Home', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'Home', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120422', '20120619');
			INSERT INTO pages (page_slug, page_left, page_right, page_ancestorid, page_depth, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated)
			VALUES ('title', 2, 9, 1, 2, 'Xindi in Title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619');
			INSERT INTO pages (page_slug, page_left, page_right, page_ancestorid, page_depth, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated)
			VALUES ('title-', 10, 17, 1, 2, 'Title contains Xindi', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619');
			INSERT INTO pages (page_slug, page_left, page_right, page_ancestorid, page_depth, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated)
			VALUES ('title--', 18, 25, 1, 2, 'title', '<p>Xindi Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619');
			INSERT INTO pages (page_slug, page_left, page_right, page_ancestorid, page_depth, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated)
			VALUES ('title/title---', 3, 4, 2, 3, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619');
			INSERT INTO pages (page_slug, page_left, page_right, page_ancestorid, page_depth, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated)
			VALUES ('title/title----', 5, 6, 2, 3, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619');
			INSERT INTO pages (page_slug, page_left, page_right, page_ancestorid, page_depth, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated)
			VALUES ('title/title-----', 7, 8, 2, 3, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619');
			INSERT INTO pages (page_slug, page_left, page_right, page_ancestorid, page_depth, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated)
			VALUES ('title-/title------', 11, 12, 3, 3, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619');
			INSERT INTO pages (page_slug, page_left, page_right, page_ancestorid, page_depth, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated)
			VALUES ('title-/title-------', 13, 14, 3, 3, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619');
			INSERT INTO pages (page_slug, page_left, page_right, page_ancestorid, page_depth, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated)
			VALUES ('title-/title--------', 15, 16, 3, 3, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619');
			INSERT INTO pages (page_slug, page_left, page_right, page_ancestorid, page_depth, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated)
			VALUES ('title--/title---------', 19, 20, 4, 3, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619');
			INSERT INTO pages (page_slug, page_left, page_right, page_ancestorid, page_depth, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated)
			VALUES ('title--/title----------', 21, 22, 4, 3, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 1, 'title', 'Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vi', 'Integer,tincidunt,porta,ipsum,euismod,ultricies,Maecenas,mattis,vehicula,iaculis,Morbi,eu,risus,erat,nunc,ligula,semper,venenatis,viverra,non,nisl,Vivamus,at,felis,turpi', '20120619', '20120619');
			INSERT INTO pages (page_slug, page_left, page_right, page_ancestorid, page_depth, page_title, page_content, page_metagenerated, page_metatitle, page_metadescription, page_metakeywords, page_created, page_updated)
			VALUES ('title--/title-----------', 23, 24, 4, 3, 'title', '<p>Integer tincidunt porta ipsum euismod ultricies. Maecenas mattis vehicula iaculis. Morbi eu risus erat. In nunc ligula, semper venenatis viverra non, viverra in nisl. Vivamus at felis turpis. Maecenas metus nisl, tincidunt vitae mattis dapibus, tempor eu libero. Donec elementum leo vitae neque consectetur elementum. Donec semper varius dui, quis ullamcorper enim mollis sed. Maecenas ac quam sem. Phasellus vitae ante ante. Sed urna tellus, aliquet facilisis tempor et; mollis eu nisi.</p>""<p>Aliquam lectus risus; auctor at tincidunt adipiscing, dignissim sit amet lorem? Fusce ut est sed elit laoreet consectetur! Suspendisse mauris est, scelerisque nec lacinia eu, consequat feugiat dolor. Nullam nec leo et mauris volutpat consectetur! Vestibulum nec augue id mi blandit vulputate sit amet sed justo. Suspendisse potenti. Cras ultricies nibh quis augue imperdiet nec tincidunt metus pretium.</p>""<p>Ut ut tellus justo, in placerat nibh. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque convallis augue in nibh vestibulum luctus. Aliquam sed sem nisi. Aenean ac nisl quis libero fermentum cursus eu in dolor. Donec sit amet ullamcorper risus. Morbi suscipit turpis sed sapien porta sed mattis orci auctor. Sed condimentum ultricies mollis. Mauris feugiat metus sed justo tincidunt nec pharetra nunc ultrices. Pellentesque varius libero eu nibh suscipit faucibus. Cras consectetur, lectus vel faucibus rhoncus; massa risus adipiscing erat, in malesuada ligula purus in ligula. Vestibulum suscipit arcu eget nisl iaculis vestibulum tristique eros tristique. Nullam elementum erat at tellus placerat ut vehicula quam ornare.</p>""', 0, '', '', '', '20120619', '20120619');
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
