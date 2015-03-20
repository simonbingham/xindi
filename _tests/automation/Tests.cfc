/*
	To run the test suite browse to the following url:
	http://localhost/xindi/_tests/automation/Tests.cfc?method=runRemote
*/

component extends = "testbox.system.BaseSpec" {

	// Testcase Lifecycle Methods

	function beforeTests() {
		browserURL = "http://#CGI.HTTP_HOST#/xindi";
		browserStartCommand = "*firefox";

		selenium = createobject("component", "CFSelenium.selenium").init();
		selenium.start(browserUrl, browserStartCommand);

		timeout = 60000;

		httpService = new http();
		httpService.setUrl(browserURL & "/index.cfm?rebuild=true");
		httpService.send();
	}

	function afterTests() {
		selenium.stop();
		selenium.stopServer();
	}

	// Tests

	function test_home_page_loads() {
		selenium.open(browserUrl);
		selenium.waitForPageToLoad(timeout);
		$assert.isEqual("Home", selenium.getTitle());
	}

	function test_show_page() {
		selenium.open(browserURL);
		selenium.waitForPageToLoad(timeout);
		selenium.click("link=Design");
		selenium.waitForPageToLoad(timeout);
		$assert.isEqual("Design", selenium.getTitle());
	}

	function test_show_article() {
		selenium.open(browserURL);
		selenium.waitForPageToLoad(timeout);
		selenium.click("link=News");
		selenium.waitForPageToLoad(timeout);
		selenium.click("link=exact:Sample Article A");
		selenium.waitForPageToLoad(timeout);
		$assert.isEqual("Sample Article A", selenium.getTitle());
	}

	function test_contact_form() {
		selenium.open(browserURL & "/index.cfm/enquiry");
		selenium.waitForPageToLoad(timeout);
		selenium.type("id=name", "test");
		selenium.type("id=email", "test@example.com");
		selenium.type("id=message", "test");
		selenium.click("id=submit");
		selenium.waitForPageToLoad(timeout);

		// we expect a fail because no mail server is configured
		$assert.isTrue(selenium.isTextPresent("Oops!"));
	}

	function test_search_form() {
		selenium.open(browserURL);
		selenium.waitForPageToLoad(timeout);
		selenium.submit("id=search");
		selenium.waitForPageToLoad(timeout);
		$assert.isEqual("Search Results", selenium.getTitle());
	}

	function test_sitemap() {
		selenium.open(browserURL);
		selenium.waitForPageToLoad(timeout);
		selenium.click("link=Site Map");
		selenium.waitForPageToLoad(timeout);
		$assert.isEqual("Site Map", selenium.getTitle());
	}

	function test_invalid_login() {
		selenium.open(browserURL & "/index.cfm/admin:security");
		selenium.waitForPageToLoad(timeout);
		selenium.type("id=email", "foo");
		selenium.type("id=password", "bar");
		selenium.click("id=login");
		selenium.waitForPageToLoad(timeout);
		$assert.isTrue(selenium.isTextPresent("Sorry, your login details have not been recognised."));
	}

	function test_valid_login() {
		doLogin();
		$assert.isTrue(selenium.isTextPresent("Welcome Default User. You have been logged in."));
		doLogout();
	}

	function test_add_edit_delete_page() {
		doLogin();

		// add page
		selenium.open(browserURL & "/index.cfm/admin:pages");
		selenium.waitForPageToLoad(timeout);
		selenium.click("css=i.glyphicon-plus-sign");
		selenium.waitForPageToLoad(timeout);
		selenium.type("id=title", "test");

		// use JavaScript to enter content into CKEditor
		selenium.runScript("CKEDITOR.instances['page-content'].setData('<p>test</p>');");
		selenium.runScript("document.getElementById('page-form').onsubmit=function() {CKEDITOR.instances['page-content'].updateElement();};");
		selenium.click("xpath=(//input[@name='submit'])[2]");
		selenium.waitForPageToLoad(timeout);
		$assert.isTrue(selenium.isTextPresent("regexp:(The page "".*"" has been saved.)"));

		// edit page
		selenium.click("//div[@id='container']/table/tbody/tr[10]/td[6]/a/i");
		selenium.waitForPageToLoad(timeout);
		selenium.type("id=title", "test edit");
		selenium.click("xpath=(//input[@name='submit'])[2]");
		selenium.waitForPageToLoad(timeout);
		$assert.isTrue(selenium.isTextPresent("regexp:(The page "".*"" has been saved.)"));

		// delete page
		selenium.click("//div[@id='container']/table/tbody/tr[10]/td[7]/a/i");
		selenium.waitForPageToLoad(timeout);

		// when we delete a record a confirmation dialog appears
		// calling the getConfirmation method forces the Ok button to be clicked in the dialog
		selenium.getConfirmation();
		$assert.isTrue(selenium.isTextPresent("regexp:(The page "".*"" has been deleted.)"));
		doLogout();
	}

	function test_add_edit_delete_article() {
		doLogin();

		// add article
		selenium.open(browserURL & "/index.cfm/admin:news");
		selenium.waitForPageToLoad(timeout);
		selenium.click("link=Add article");
		selenium.waitForPageToLoad(timeout);
		selenium.type("id=title", "test");
		selenium.type("id=published", "01/07/2012");

		// use JavaScript to enter content into CKEditor
		selenium.runScript("CKEDITOR.instances['article-content'].setData('<p>test</p>');");
		selenium.runScript("document.getElementById('article-form').onsubmit=function() {CKEDITOR.instances['article-content'].updateElement();};");
		selenium.click("id=submit");
		selenium.waitForPageToLoad(timeout);
		$assert.isTrue(selenium.isTextPresent("regexp:(The article "".*"" has been saved.)"));

		// edit article
		selenium.click("//div[@id='container']/table/tbody/tr[4]/td[5]/a/i");
		selenium.waitForPageToLoad(timeout);
		selenium.type("id=title", "test edit");
		selenium.click("id=submit");
		selenium.waitForPageToLoad(timeout);
		$assert.isTrue(selenium.isTextPresent("regexp:(The article "".*"" has been saved.)"));

		// delete article
		selenium.click("//div[@id='container']/table/tbody/tr[4]/td[6]/a/i");

		// when we delete a record a confirmation dialog appears
		// the getConfirmation method forces the Ok button to be clicked in the dialog
		selenium.getConfirmation();
		selenium.waitForPageToLoad(timeout);
		$assert.isTrue(selenium.isTextPresent("regexp:(The article "".*"" has been deleted.)"));
		doLogout();
	}

	function test_view_enquiry() {
		doLogin();
		selenium.open(browserURL & "/index.cfm/admin:enquiries");
		selenium.waitForPageToLoad(timeout);
		selenium.click("css=i.glyphicon-eye-open");
		selenium.waitForPageToLoad(timeout);
		$assert.isTrue(selenium.isTextPresent("Cupcake ipsum dolor sit amet brownie sugar plum jelly beans."));
		doLogout();
	}

	function test_delete_enquiry() {
		doLogin();
		selenium.open(browserURL & "/index.cfm/admin:enquiries");
		selenium.waitForPageToLoad(timeout);
		selenium.click("//div[@id='container']/table/tbody/tr[3]/td[4]/a/i");

		// when we delete a record a confirmation dialog appears
		// the getConfirmation method forces the Ok button to be clicked in the dialog
		selenium.getConfirmation();
		selenium.waitForPageToLoad(timeout);
		$assert.isTrue(selenium.isTextPresent("regexp:(The enquiry from "".*"" has been deleted.)"));
		doLogout();
	}

	function test_add_edit_delete_user() {
		doLogin();

		// add user
		selenium.open(browserURL & "/index.cfm/admin:users");
		selenium.waitForPageToLoad(timeout);
		selenium.click("link=Add user");
		selenium.waitForPageToLoad(timeout);
		selenium.type("id=name", "test");
		selenium.type("id=email", "test@example.com");
		selenium.type("id=password", "test1234");
		selenium.click("id=submit");
		selenium.waitForPageToLoad(timeout);
		$assert.isTrue(selenium.isTextPresent("regexp:(The user "".*"" has been saved.)"));

		// edit user
		selenium.click("//div[@id='container']/table/tbody/tr[2]/td[4]/a/i");
		selenium.waitForPageToLoad(timeout);
		selenium.type("id=name", "test edit");
		selenium.click("id=submit");
		selenium.waitForPageToLoad(timeout);
		$assert.isTrue(selenium.isTextPresent("regexp:(The user "".*"" has been saved.)"));

		// delete user
		selenium.click("//div[@id='container']/table/tbody/tr[2]/td[5]/a/i");

		// when we delete a record a confirmation dialog appears
		// the getConfirmation method forces the Ok button to be clicked in the dialog
		selenium.getConfirmation();
		selenium.waitForPageToLoad(timeout);
		$assert.isTrue(selenium.isTextPresent("regexp:(The user "".*"" has been deleted.)"));
		doLogout();
	}

	function test_logout() {
		doLogin();
		doLogout();
		$assert.isTrue(selenium.isTextPresent("You have been logged out."));
	}

	// Helper Methods

	private function doLogin() {
		selenium.open(browserURL & "/index.cfm/admin:security");
		selenium.waitForPageToLoad(timeout);
		selenium.type("id=email", "admin@getxindi.com");
		selenium.type("id=password", "password");
		selenium.click("id=login");
		selenium.waitForPageToLoad(timeout);
	}

	private function doLogout() {
		selenium.open(browserURL & "/index.cfm/admin:security/logout");
		selenium.waitForPageToLoad(timeout);
	}

}
