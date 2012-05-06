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
		return Left( Trim( REReplaceNoCase( REReplaceNoCase( stripHTML( arguments.description ), "([#Chr(09)#-#Chr(30)#])", " ", "all" ), "( ){2,}", " ", "all" ) ), 200 );
	}
		
	string function generateMetaKeywords( required string keywords )
	{
		return Left( Trim( listDeleteDuplicatesNoCase( ListChangeDelims( metaExclude( arguments.keywords ), ",", " ." ) ) ), 200 );
	}
	
	/*
	 * Private methods
	 */

	private string function listDeleteDuplicatesNoCase( required string list ) {
		var local = StructNew();
		if( ArrayLen( arguments ) eq 2 ) local.delimiter = arguments[ 2 ];
		else local.delimiter = ",";
		local.elements = ListToArray( arguments.list, local.delimiter );
		local.listnoduplicates = "";
		for( local.i=1; local.i lte ArrayLen( local.elements ); local.i=local.i+1 ) 
		{
			if( !ListFindNoCase( local.listnoduplicates, local.elements[ local.i ], local.delimiter ) )
			{
				if( Len( local.listnoduplicates ) ) local.listnoduplicates = local.listnoduplicates & local.delimiter & local.elements[ local.i ];
				else local.listnoduplicates = local.elements[ local.i ];
			}
		}
		return Trim( local.listnoduplicates );
	}
	
	private string function metaExclude( required string thestring ) {
		return Trim( REReplaceNoCase(" " & REReplace( stripHTML( arguments.thestring ), "[ *]{1,}", "  ", "all"), "[ ]{1}(a|an|and|is|it|that|the|this|to|or)[ ]{1}", " ", "all" ) );
	}
	
	private string function stripHTML( required string thestring ) {
		return REReplaceNoCase( Trim( arguments.thestring ), "<[^>]{1,}>", " ", "all" );
	}	
	
}