component extends="mxunit.framework.TestCase" {

	// ------------------------ UNIT TESTS ------------------------ //

	function testGenerateMetaDescription()
	{
		var result = CUT.generateMetaDescription("Morbi at felis quis metus scelerisque venenatis. Curabitur ut tellus nec massa eleifend vestibulum! In non lectus sem; ut lacinia.");
		assertEquals("Morbi at felis quis metus scelerisque venenatis. Curabitur ut tellus nec massa eleifend vestibulum! In non lectus sem; ut lacinia.", result);
	}

	function testGenerateMetaKeywords()
	{
		var result = CUT.generateMetaKeywords("Morbi at felis quis metus scelerisque venenatis. Curabitur ut tellus nec massa eleifend vestibulum! In non lectus sem; ut lacinia.");
		assertEquals("metus,curabitur,sem;,venenatis,at,ut,quis,massa,non,scelerisque,felis,lacinia,tellus,lectus,morbi,eleifend,nec,vestibulum!", result);
	}

	function testGeneratePageTitle()
	{
		var result = CUT.generatePageTitle("foo", "bar");
		assertEquals("bar | foo", result);
	}

	function testListDeleteDuplicatesNoCase()
	{
		var result = CUT.listDeleteDuplicatesNoCase("foo,bar,foo,bar");
		assertEquals("foo,bar", result);
	}

	function testRemoveNonKeywords()
	{
		var result = CUT.removeNonKeywords("Morbi at felis quis metus scelerisque venenatis. Curabitur ut tellus nec massa eleifend vestibulum! In non lectus sem; ut lacinia.");
		assertEquals("morbi at felis quis metus scelerisque venenatis curabitur ut tellus nec massa eleifend vestibulum! non lectus sem; ut lacinia", result );
	}

	function testRemoveUnrequiredCharacters()
	{
		var result = CUT.removeUnrequiredCharacters("
		Morbi at felis quis

		metus scelerisque venenatis.

		Curabitur ut tellus nec massa eleifend

		vestibulum! In non lectus sem; ut lacinia.
		");
		assertEquals("morbi at felis quis metus scelerisque venenatis. curabitur ut tellus nec massa eleifend vestibulum! in non lectus sem; ut lacinia.", result);
	}

	function testReplaceMultipleSpacesWithSingleSpace()
	{
		var result = CUT.replaceMultipleSpacesWithSingleSpace("Morbi at felis quis metus   scelerisque venenatis. Curabitur ut tellus nec massa eleifend   vestibulum! In non lectus sem; ut lacinia.");
		assertEquals("Morbi at felis quis metus scelerisque venenatis. Curabitur ut tellus nec massa eleifend vestibulum! In non lectus sem; ut lacinia.", result);
	}

	function testStripHTML()
	{
		var result = CUT.stripHTML("<p>Morbi at felis quis metus scelerisque venenatis. Curabitur ut tellus nec massa eleifend vestibulum! In non lectus sem; ut lacinia.</p>");
		assertEquals("Morbi at felis quis metus scelerisque venenatis. Curabitur ut tellus nec massa eleifend vestibulum! In non lectus sem; ut lacinia.", result);
	}

	// ------------------------ IMPLICIT ------------------------ //

	/**
	* this will run before every single test in this test case
	*/
	function setUp() {
		// initialise component under test
		CUT = new model.content.MetaData();
	}

	/**
	* this will run after every single test in this test case
	*/
	function tearDown() {}

	/**
	* this will run once after initialization and before setUp()
	*/
	function beforeTests() {}

	/**
	* this will run once after all tests have been run
	*/
	function afterTests() {}

}
