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

component 
{
	
	void function preInsert()
	{
		var timestamp = Now();
		setCreated( timestamp );
		setUpdated( timestamp );
	}
	
	void function preUpdate()
	{
		setUpdated( Now() );
	}	
	
	// this method was sourced from https://gist.github.com/947636
	void function populate( required struct memento, boolean trustedSetter=false, string include="", string exclude="", string disallowConversionToNull="" )
	{
		var object = this;
		var key = "";
		var populate = true;
		for( key in arguments.memento )
		{
			populate = true;
			if( Len( arguments.include ) && !ListFindNoCase( arguments.include, key ) ) populate = false;
			if( Len( arguments.exclude ) && ListFindNoCase( arguments.exclude, key ) ) populate = false;
			if( populate )
			{
				if( StructKeyExists( object, "set" & key ) || arguments.trustedSetter )
				{
					if( IsSimpleValue( arguments.memento[ key ] ) && Trim( arguments.memento[ key ] ) == "" )
					{
						if( Len( arguments.disallowConversionToNull ) && !ListFindNoCase( arguments.disallowConversionToNull, key ) ) Evaluate( "object.set#key#(arguments.memento[key])" );
						else Evaluate( 'object.set#key#(javacast("null",""))' );
					}
					else 
					{
						Evaluate( "object.set#key#(arguments.memento[key])" );
					}
				}
			}
		}
	}
		
}