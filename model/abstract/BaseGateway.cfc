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
    </cfscript>
    
    <!------------------------ PRIVATE METHODS ------------------------>
    
    <cffunction name="getDBEngine" returntype="string" output="false" access="private">
		<cfset var dbinfo = "">
		<cfdbinfo type="version" name="dbinfo">
		<cfreturn UCase( dbinfo.DATABASE_PRODUCTNAME )>
	</cffunction>
</cfcomponent>