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

component accessors="true" 
{
	
	/*
	 * Properties
	 */	
	
	property name="metatitle";
	property name="metakeywords";
	property name="metadescription";

	/*
	 * Public methods
	 */
	 	
	function init()
	{
		variables.metatitle = "";
		variables.metakeywords = "";
		variables.metadescription = "";
		return this;
	}

	string function generateMetaDescription( required string description )
	{
		return Left( Trim( replaceMultipleSpacesWithSingleSpace( removeUnrequiredCharacters( stripHTML( arguments.description ) ) ) ), 169 );
	}

	string function generateMetaKeywords( required string keywords )
	{
		return Left( replaceMultipleSpacesWithSingleSpace( removeUnrequiredCharacters( listDeleteDuplicatesNoCase( ListChangeDelims( removeNonKeywords( stripHTML( arguments.keywords ) ), ",", " ." ) ) ) ), 169 );
	}

	string function generatePageTitle( required string websitetitle, required string pagetitle )
	{
		return Left( stripHTML( arguments.pagetitle ) & " | " & stripHTML( arguments.websitetitle ), 69 );
	}

	string function listDeleteDuplicatesNoCase( required string thelist, string delimiter="," ) {
		var elements = ListToArray( arguments.thelist, arguments.delimiter );
		var listnoduplicates = "";
		for( element in elements ) 
		{
			if( !ListFindNoCase( listnoduplicates, element, arguments.delimiter ) )
			{
				listnoduplicates = ListAppend( listnoduplicates, element, arguments.delimiter );
			} 
		}
		return Trim( Replace( listnoduplicates, ".", "", "all" ) );
	}

	string function removeNonKeywords( required string thestring ) {
		var elements = ListToArray( arguments.thestring, " " );
		var newstring = "";
		for( element in elements ) 
		{
			if( !ListFindNoCase( "&,a,an,and,are,as,i,if,in,is,it,that,the,this,it,to,of,on,or,us,we", element ) ) 
			{
				newstring = ListAppend( newstring, element, " " );
			} 
		}
		return Trim( Replace( newstring, ".", "", "all" ) );
	}
	
	string function removeUnrequiredCharacters( required string thestring ) {
		return Trim( REReplaceNoCase( arguments.thestring, "([#Chr(09)#-#Chr(30)#])", " ", "all" ) );
	}	

	string function replaceMultipleSpacesWithSingleSpace( required string thestring ) {
		return Trim( REReplaceNoCase( arguments.thestring, "\s{2,}", " ", "all" ) );
	}
	
	string function stripHTML( required string thestring ) {
		return Trim( replaceMultipleSpacesWithSingleSpace( REReplaceNoCase( arguments.thestring, "<[^>]{1,}>", " ", "all" ) ) );
	}
	
}