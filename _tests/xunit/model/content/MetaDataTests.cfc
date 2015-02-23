component extends="tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function setup() {
		super.setup("model.content.MetaData");
	}

	// Tests

	function test_generateMetaDescription_returns_expected_result() {
		local.content = "Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn’t commit. These men promptly escaped from a maximum security stockade to the Los Angeles underground. Today, still wanted by the government, they survive as soldiers of fortune.";
		local.expected = "Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn’t commit. These men promptly escaped from a maximum security stockade to the Los Angeles underground. T";
		local.actual = variables.CUT.generateMetaDescription(description = local.content);
		$assert.isEqual(local.expected, local.actual);
	}

	function test_generateMetaKeywords_returns_expected_result() {
		local.content = "Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn’t commit. These men promptly escaped from a maximum security stockade to the Los Angeles underground. Today, still wanted by the government, they survive as soldiers of fortune.";
		local.expected = "stockade,ago,for,commit,soldiers,Angeles,years,crack,commando,security,government,didn’t,by,men,promptly,military,crime,from,prison,they,still,survive,fortune,was,court,sent,escaped,Los,unit,Today,The";
		local.actual = variables.CUT.generateMetaKeywords(keywords = local.content);
		$assert.isEqual(local.expected, local.actual);
	}

	function test_generatePageTitle_returns_expected_result() {
		local.expected = "the page title | the website title";
		local.actual = variables.CUT.generatePageTitle(websiteTitle = "the website title", pageTitle = "the page title");
		$assert.isEqual(local.expected, local.actual);
	}

	function test_hasMetaAuthor_returns_true_when_author_exists() {
		variables.CUT.$property(propertyName = "metaAuthor", propertyScope = "variables", mock = "the author");
		local.actual = variables.CUT.hasMetaAuthor();
		$assert.isTrue(local.actual);
	}

	function test_hasMetaAuthor_returns_false_when_author_does_not_exist() {
		variables.CUT.$property(propertyName = "metaAuthor", propertyScope = "variables", mock = "");
		local.actual = variables.CUT.hasMetaAuthor();
		$assert.isFalse(local.actual);
	}

}
