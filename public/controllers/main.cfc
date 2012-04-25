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

	/*
	 * Dependency injection
	 */	

	property name="ContentService" setter="true" getter="false";
	
	/*
	 * Public methods
	 */		
	
	void function init( required any fw )
	{
		variables.fw = arguments.fw;
	}

	void function default( required struct rc ) {
		rc.Page = variables.ContentService.getRoot();
	}
	
	void function sitemap( required struct rc ) {
		rc.MetaData.setMetaTitle( "Site Map" ); 
		rc.MetaData.setMetaDescription( "" );
		rc.MetaData.setMetaKeywords( "" );		
		rc.Pages = variables.ContentService.getPages();
	}	
	
}