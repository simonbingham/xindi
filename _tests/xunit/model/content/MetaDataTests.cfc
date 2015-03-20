component extends = "tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function setup() {
		super.setup("model.content.MetaData");
	}

	// Tests

	// generateMetaDescription() tests

	function test_generateMetaDescription_returns_expected_result() {
		local.content = "Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn’t commit. These men promptly escaped from a maximum security stockade to the Los Angeles underground. Today, still wanted by the government, they survive as soldiers of fortune.";
		local.expected = "Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn’t commit. These men promptly escaped from a maximum security stockade to the Los Angeles underground. T";
		local.actual = variables.CUT.generateMetaDescription(content = local.content);
		$assert.isEqual(local.expected, local.actual);
	}

	// generateMetaKeywords() tests

	function test_generateMetaKeywords_returns_simple_value() {
		local.content = "Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn’t commit. These men promptly escaped from a maximum security stockade to the Los Angeles underground. Today, still wanted by the government, they survive as soldiers of fortune.";
		local.actual = variables.CUT.generateMetaKeywords(content = local.content);
		$assert.isTrue(issimplevalue(local.actual));
	}

	// generatePageTitle() tests

	function test_generatePageTitle_returns_expected_result() {
		local.expected = "the page title | the website title";
		local.actual = variables.CUT.generatePageTitle(websiteTitle = "the website title", pageTitle = "the page title");
		$assert.isEqual(local.expected, local.actual);
	}

	// hasMetaAuthor() tests

	function test_hasMetaAuthor_returns_true_when_author_exists() {
		variables.CUT.$property(propertyName = "metaAuthor", propertyScope = "variables", mock = "the author");
		local.actual = variables.CUT.hasMetaAuthor();
		$assert.isTrue(local.actual);
	}

	// hasMetaAuthor() tests

	function test_hasMetaAuthor_returns_false_when_author_does_not_exist() {
		variables.CUT.$property(propertyName = "metaAuthor", propertyScope = "variables", mock = "");
		local.actual = variables.CUT.hasMetaAuthor();
		$assert.isFalse(local.actual);
	}

}
