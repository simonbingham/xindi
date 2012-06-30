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
	
	function testGenerateMetaDescription()
	{
		var result = CUT.generateMetaDescription( "The Hoff and I are going to the beach. The Hoff said he would like an ice cream.", 100 );
		assertEquals( "The Hoff and I are going to the beach. The Hoff said he would like an ice cream.", result );		
	}

	function testGenerateMetaKeywords()
	{
		var result = CUT.generateMetaKeywords( "The Hoff and I are going to the beach. The Hoff said he would like an ice cream.", 100 );
		assertEquals( "hoff,going,beach,said,he,would,like,ice,cream", result );		
	}

	function testGeneratePageTitle()
	{
		var result = CUT.generatePageTitle( "The Hoff", "Ice Cream", 100 );
		assertEquals( "Ice Cream | The Hoff", result );		
	}
	
	function testListDeleteDuplicatesNoCase()
	{
		var result = CUT.listDeleteDuplicatesNoCase( "The,Hoff,and,I,are,going,to,the,beach.,The,Hoff,said,he,would,like,an,ice,cream." );
		assertEquals( "the,hoff,and,i,are,going,to,beach,said,he,would,like,an,ice,cream", result );
	}	
	
	function testRemoveNonKeywords()
	{
		var result = CUT.removeNonKeywords( "The Hoff and I are going to the beach. The Hoff said he would like an ice cream." );
		assertEquals( "hoff going beach hoff said he would like ice cream", result  );
	}
	
	function testRemoveUnrequiredCharacters()
	{
		var result = CUT.removeUnrequiredCharacters( "
		The  Hoff 
		
		and   I are    
		
		going to    the beach. The Hoff said he would like an ice cream.		
		" );
		assertEquals( "the  hoff       and   i are          going to    the beach. the hoff said he would like an ice cream.", result );		
	}	
	
	function testReplaceMultipleSpacesWithSingleSpace()
	{
		var result = CUT.replaceMultipleSpacesWithSingleSpace( "The Hoff and I     are going to the beach. The Hoff said  he would like    an ice cream." );
		assertEquals( "the hoff and i are going to the beach. the hoff said he would like an ice cream.", result );
	}

	function testStripHTML()
	{
		var result = CUT.stripHTML( "<p>The Hoff and I are going to the beach. The Hoff said he would like an ice cream.</p>" );
		assertEquals( "The Hoff and I are going to the beach. The Hoff said he would like an ice cream.", result );
	}
	
	// ------------------------ IMPLICIT ------------------------ // 
	
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		// initialise component under test
		CUT = new model.content.MetaData(); 
	}
	
	/**
	* this will run after every single test in this test case
	*/
	function tearDown(){}
	
	/**
	* this will run once after initialization and before setUp()
	*/
	function beforeTests(){}
	
	/**
	* this will run once after all tests have been run
	*/
	function afterTests(){}
	
}