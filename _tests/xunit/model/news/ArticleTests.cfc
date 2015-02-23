component extends="tests.xunit.BaseTest" {

	// Testcase Lifecycle Methods

	function setup() {
		super.setup("model.news.Article");
	}

	// Tests

	function test_getRSSSummary_returns_expected_result() {
		local.content = "Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn’t commit. These men promptly escaped from a maximum security stockade to the Los Angeles underground. Today, still wanted by the government, they survive as soldiers of fortune.";
		variables.CUT.$property(propertyName = "content", propertyScope = "variables", mock = local.content);
		local.expected = "Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn’t commit. These men promptly escaped from a maximum security stockade to the Los Angeles underground. Today, still wanted by the government, they survive as soldiers of fortune.";
		local.actual = variables.CUT.getRSSSummary();
		$assert.isEqual(local.expected, local.actual);
	}

	function test_getRSSSummary_returns_expected_result_when_content_is_longer_than_500_characters() {
		local.content = "Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn’t commit. These men promptly escaped from a maximum security stockade to the Los Angeles underground. Today, still wanted by the government, they survive as soldiers of fortune. Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn’t commit. These men promptly escaped from a maximum security stockade to the Los Angeles underground. Today, still wanted by the government, they survive as soldiers of fortune.";
		variables.CUT.$property(propertyName = "content", propertyScope = "variables", mock = local.content);
		local.expected = "Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn’t commit. These men promptly escaped from a maximum security stockade to the Los Angeles underground. Today, still wanted by the government, they survive as soldiers of fortune. Ten years ago a crack commando unit was sent to prison by a military court for a crime they didn’t commit. These men promptly escaped from a maximum security stockade to the Los Angeles underground. Today, still wanted by the...";
		local.actual = variables.CUT.getRSSSummary();
		$assert.isEqual(local.expected, local.actual);
	}

	function test_hasAuthor_returns_true_when_author_exists() {
		variables.CUT.$property(propertyName = "author", propertyScope = "variables", mock = "the author");
		local.actual = variables.CUT.hasAuthor();
		$assert.isTrue(local.actual);
	}

	function test_hasAuthor_returns_false_when_author_does_not_exist() {
		variables.CUT.$property(propertyName = "author", propertyScope = "variables", mock = "");
		local.actual = variables.CUT.hasAuthor();
		$assert.isFalse(local.actual);
	}

	function test_hasMetaDescription_returns_true_when_meta_description_exists() {
		variables.CUT.$property(propertyName = "metaDescription", propertyScope = "variables", mock = "the meta description");
		local.actual = variables.CUT.hasMetaDescription();
		$assert.isTrue(local.actual);
	}

	function test_hasMetaDescription_returns_false_when_no_meta_description_exists() {
		variables.CUT.$property(propertyName = "metaDescription", propertyScope = "variables", mock = "");
		local.actual = variables.CUT.hasMetaDescription();
		$assert.isFalse(local.actual);
	}

	function test_hasMetaKeywords_returns_true_when_meta_keywords_exist() {
		variables.CUT.$property(propertyName = "metaKeywords", propertyScope = "variables", mock = "the meta keywords");
		local.actual = variables.CUT.hasMetaKeywords();
		$assert.isTrue(local.actual);
	}

	function test_hasMetaKeywords_returns_false_when_no_meta_keywords_exist() {
		variables.CUT.$property(propertyName = "metaKeywords", propertyScope = "variables", mock = "");
		local.actual = variables.CUT.hasMetaKeywords();
		$assert.isFalse(local.actual);
	}

	function test_hasMetaTitle_returns_true_when_meta_title_exists() {
		variables.CUT.$property(propertyName = "metaTitle", propertyScope = "variables", mock = "the meta title");
		local.actual = variables.CUT.hasMetaTitle();
		$assert.isTrue(local.actual);
	}

	function test_hasMetaTitle_returns_false_when_no_meta_title_exists() {
		variables.CUT.$property(propertyName = "metaTitle", propertyScope = "variables", mock = "");
		local.actual = variables.CUT.hasMetaTitle();
		$assert.isFalse(local.actual);
	}

	function test_isMetaGenerated_returns_true_when_meta_data_is_generated() {
		variables.CUT.$property(propertyName = "metaGenerated", propertyScope = "variables", mock = TRUE);
		local.actual = variables.CUT.isMetaGenerated();
		$assert.isTrue(local.actual);
	}

	function test_isMetaGenerated_returns_false_when_meta_data_is_not_generated() {
		variables.CUT.$property(propertyName = "metaGenerated", propertyScope = "variables", mock = FALSE);
		local.actual = variables.CUT.isMetaGenerated();
		$assert.isFalse(local.actual);
	}

	function test_isNew_returns_true_when_published_date_is_less_than_one_week_in_the_past() {
		variables.CUT.$property(propertyName = "published", propertyScope = "variables", mock = DateAdd("d", -6, Now()));
		local.actual = variables.CUT.isNew();
		$assert.isTrue(local.actual);
	}

	function test_isNew_returns_false_when_published_date_is_more_than_one_week_in_the_past() {
		variables.CUT.$property(propertyName = "published", propertyScope = "variables", mock = DateAdd("d", -8, Now()));
		local.actual = variables.CUT.isNew();
		$assert.isFalse(local.actual);
	}

	function test_isPersisted_returns_true_when_article_is_persisted() {
		variables.CUT.$property(propertyName = "articleId", propertyScope = "variables", mock = 111);
		local.actual = variables.CUT.isPersisted();
		$assert.isTrue(local.actual);
	}

	function test_isPublished_returns_true_when_published_date_is_in_the_past() {
		variables.CUT.$property(propertyName = "published", propertyScope = "variables", mock = DateAdd("d", -1, Now()));
		local.actual = variables.CUT.isPublished();
		$assert.isTrue(local.actual);
	}

	function test_isPublished_returns_false_when_published_date_is_in_the_future() {
		variables.CUT.$property(propertyName = "published", propertyScope = "variables", mock = DateAdd("d", 1, Now()));
		local.actual = variables.CUT.isPublished();
		$assert.isFalse(local.actual);
	}

	function test_preInsert_calls_setSlug_once() {
		variables.CUT
			.$("setSlug")
			.preInsert();
		$assert.isTrue(variables.CUT.$once("setSlug"));
	}

	function test_setSlug_sets_slug_when_slug_is_unique() {
		variables.CUT
			.$("isSlugUnique", TRUE)
			.$property(propertyName = "title", propertyScope = "variables", mock = "the title")
			.$property(propertyName = "slug", propertyScope = "variables", mock = "")
			.setSlug();
		local.expected = "the-title";
		local.actual = variables.CUT.$getProperty(name = "slug", scope = "variables");
		$assert.isEqual(local.expected, local.actual);
	}

	function test_setSlug_sets_slug_when_slug_is_not_unique() {
		variables.CUT
			.$("isSlugUnique").$results(FALSE, TRUE)
			.$property(propertyName = "title", propertyScope = "variables", mock = "the title")
			.$property(propertyName = "slug", propertyScope = "variables", mock = "")
			.setSlug();
		local.expected = "the-title-";
		local.actual = variables.CUT.$getProperty(name = "slug", scope = "variables");
		$assert.isEqual(local.expected, local.actual);
	}

}
