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
<cfcomponent output="false">

	<cfscript>
	// ------------------------ CONSTRUCTOR ------------------------ //
	any function init(){
		variables.dbengine = getDBEngine();
		return this;		
	}
	
	
	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
     * I delete an entity
	 */
	void function delete( required entity ){
		EntityDelete( arguments.entity );
	}

	/**
     * I return an entity matching an id
	 */
	function get( required string entityname, required numeric id ){
		var Entity = EntityLoadByPK( arguments.entityname, arguments.id );
		if( IsNull( Entity ) ) Entity = new( arguments.entityname );
		return Entity;
	}

	/**
     * I return a new entity
	 */
	function new( required string entityname ){
		return EntityNew( arguments.entityname );
	}

	/**
     * I save an entity
	 */
	function save( required entity ){
		EntitySave( arguments.entity );
		return arguments.entity;
	}
	
	

	// ------------------------ PRIVATE METHODS ------------------------ //
    </cfscript>
    
    <cffunction name="getDBEngine" returntype="string" output="false" access="private">
		<cfset var dbinfo = "">
		<cfdbinfo type="version" name="dbinfo">
		<cfreturn UCase( dbinfo.DATABASE_PRODUCTNAME )>
	</cffunction>
</cfcomponent>