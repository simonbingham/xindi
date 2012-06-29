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
			
	// ------------------------ TESTS ------------------------ //
	
	function testDeleteArticle(){
		var $NewsGateway = mock().deleteArticle( articleid="numeric" ).returns( {} );
		CUT.setNewsGateway( $NewsGateway );
		var result = CUT.deleteArticle( articleid=1 );
		assertTrue( IsStruct( result ) );
	}

	function testGetArticleByID(){
		var $NewsGateway = mock().getArticleByID( articleid="numeric" ).returns( {} );
		CUT.setNewsGateway( $NewsGateway );		
		var result = CUT.getArticleByID( articleid=1 );
		assertTrue( IsObject( result ) );
	}
	
	function testGetArticleByUUID(){
		var $NewsGateway = mock().getArticleByUUID( uuid="string" ).returns( {} );
		CUT.setNewsGateway( $NewsGateway );			
		var result = CUT.getArticleByUUID( uuid="sample-article-a" );
		assertTrue( IsObject( result ) );
	}
	
	function testGetArticleCount(){
		var $NewsGateway = mock().getArticleCount().returns( 0 );
		CUT.setNewsGateway( $NewsGateway );
		var result = CUT.getArticleCount();		
		assertTrue( IsNumeric( result ) );
	}
	
	function testGetArticles(){
		var $NewsGateway = mock().getArticles( searchterm="{string}", sortorder="{string}", published="{boolean}", maxresults="{numeric}", offset="{numeric}" ).returns( [] );
		CUT.setNewsGateway( $NewsGateway );		
		var result = CUT.getArticles();
		assertTrue( IsArray( result ) );			
	}
	
	function testGetValidator(){
		var $NewsGateway = mock().getValidator( Article="{any}" ).returns( mock() );
		CUT.setNewsGateway( $NewsGateway );
		var result = CUT.getValidator( mock() );
		assertTrue( IsObject( result ) );
	}
	
	function testSaveArticle(){
		var $NewsGateway = mock().saveArticle( properties="{struct}" ).returns( {} );
		CUT.setNewsGateway( $NewsGateway );
		var result = CUT.saveArticle( properties={ title="foo", published="27/6/2012", content="bar" } );
		assertTrue( IsStruct( result ) );
	}
	
	// ------------------------ IMPLICIT ------------------------ // 
	
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		CUT = new model.news.NewsService();
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