/*
   Copyright 2012, Simon Bingham

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

component accessors="true" 
{
	
	property name="metatitle";
	property name="metakeywords";
	property name="metadescription";
	
	function init()
	{
		variables.metatitle = "";
		variables.metakeywords = "";
		variables.metadescription = "";
		return this;
	}
	
	string function generateMetaKeywords( required string keywords )
	{
		return Left( Trim( listDeleteDuplicatesNoCase( ListChangeDelims( metaExclude( arguments.keywords ), ",", " ." ) ) ), 200 );
	}
	
	string function generateMetaDescription( required string description )
	{
		return Left( Trim( ReReplaceNoCase( ReReplaceNoCase( stripHTML( arguments.description ), "([#Chr(09)#-#Chr(30)#])", " ", "all" ), "( ){2,}", " ", "all" ) ), 200 );
	}
	
	string function stripHTML( required string s ) {
		return ReReplaceNoCase( Trim( arguments.s ), "<[^>]{1,}>", " ", "all" );
	}

	private string function metaExclude( required string s ) {
		return Trim( ReReplaceNoCase(" " & ReReplace( stripHtml( arguments.s ), "[ *]{1,}", "  ", "all"), "[ ]{1}(a|an|and|is|it|that|the|this|to|or)[ ]{1}", " ", "all" ) );
	}
	
	private string function listDeleteDuplicatesNoCase( required string list ) {
		var local = StructNew();
		if( ArrayLen( arguments ) eq 2 ) local.delimiter = arguments[ 2 ];
		else local.delimiter = ",";
		local.aryElements = ListToArray( arguments.list, local.delimiter );
		local.lstNoDuplicates = "";
		for( local.i=1; local.i lte ArrayLen( local.aryElements ); local.i=local.i+1) 
		{
			if( Not ListFindNoCase( local.lstNoDuplicates, local.aryElements[ local.i ], local.delimiter ) )
			{
				if( Len( local.lstNoDuplicates ) ) local.lstNoDuplicates = local.lstNoDuplicates & local.delimiter & local.aryElements[ local.i ];
				else local.lstNoDuplicates = local.aryElements[ local.i ];
			}
		}
		return Trim( local.lstNoDuplicates );
	}
		
}