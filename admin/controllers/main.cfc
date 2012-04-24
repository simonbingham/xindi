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
	property name="SecurityService" setter="true" getter="false";
	
	void function init( required any fw )
	{
		variables.fw = arguments.fw;
	}

	void function default( required rc )
	{
		var securearea = true; 
		var whitelist = "^admin:security,^public:";
		rc.loggedin = variables.SecurityService.hasCurrentUser();
		if ( !rc.loggedin )
		{
			for ( var unsecured in ListToArray( whitelist ) )
			{
				if ( ReFindNoCase( unsecured, variables.fw.getFullyQualifiedAction() ) )
				{
					securearea = false;
					break;
				}
			}
			if ( securearea ) variables.fw.redirect( "admin:security" );
		}
	}
  
}