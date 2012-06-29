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
	
	function testDeletePage(){
		var $ContentGateway = mock().deletePage( pageid="numeric" ).returns( {} );
		CUT.setContentGateway( $ContentGateway );
		var result = CUT.deletePage( pageid=1 );
		assertTrue( IsStruct( result ) );	
	}
	
	function testGetPageByID(){
		var $ContentGateway = mock().testGetPageByID( pageid="numeric" ).returns( mock() );
		CUT.setContentGateway( $ContentGateway );
		var Page = CUT.getPageByID( pageid=1 );
		assertTrue( IsObject( Page ) );	
	}
	
	function testGetPageSlug(){
		var $ContentGateway = mock().testGetPageSlug( slug="string" ).returns( mock() );
		CUT.setContentGateway( $ContentGateway );
		var Page = CUT.getPageByID( pageid=1 );
		assertTrue( IsObject( Page ) );			
	}

	function testGetPages(){
		var $ContentGateway = mock().getPages( searchterm="{string}", sortorder="{string}", maxresults="{numeric}" ).returns( [] );
		CUT.setContentGateway( $ContentGateway );
		var pages = CUT.getPages();
		assertTrue( IsArray( pages ) );
	}

	function testGetRoot(){
		var $ContentGateway = mock().getRoot().returns( mock() );
		CUT.setContentGateway( $ContentGateway );
		assertTrue( IsObject( CUT.getRoot() ) );
	}

	function testGetValidator(){
		var $ContentGateway = mock().getValidator( Page="{any}" ).returns( mock() );
		CUT.setContentGateway( $ContentGateway );
		var Validator = CUT.getValidator( mock() );
		assertTrue( IsObject( Validator ) );
	}

	function testMovePage(){
		var $ContentGateway = mock().movePage( pageid="{numeric}", direction="{string}" ).returns( {} );
		CUT.setContentGateway( $ContentGateway );
		var result = CUT.movePage( pageid=1, direction="" );
		assertTrue( isStruct( result ) );
	}

	function testSavePage(){
		var $ContentGateway = mock().savePage( properties="{struct}", ancestorid="{numeric}", context="{string}" ).returns( {} );
		CUT.setContentGateway( $ContentGateway );
		var result = CUT.savePage( properties={}, ancestorid=1, context="" );
		assertTrue( IsStruct( result ) );
	}
	
	// ------------------------ IMPLICIT ------------------------ // 
	
	/**
	* this will run before every single test in this test case
	*/
	function setUp(){
		CUT = new model.content.ContentService();
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