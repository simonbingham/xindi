<cfcomponent displayname="Base Gateway" hint="I am the base gateway component" output="false">
	<cfscript>
		// ------------------------ CONSTRUCTOR ------------------------ //

		any function init() {
			variables.dbEngine = getDBEngine();
			return this;
		}

		// ------------------------ PUBLIC METHODS ------------------------ //

		/**
		 * I delete an entity
		 */
		void function delete(required any entity) {
			EntityDelete(arguments.entity);
		}

		/**
		 * I return an entity matching an id
		 */
		function get(required string entityName, required numeric id) {
			local.entity = EntityLoadByPK(arguments.entityName, arguments.id);
			if (IsNull(local.entity)) {
				local.entity = new(arguments.entityName);
			}
			return local.entity;
		}

		/**
		 * I return a new entity
		 */
		function new(required string entityName) {
			return EntityNew(arguments.entityName);
		}

		/**
		 * I save an entity
		 */
		function save(required any entity) {
			EntitySave(arguments.entity);
			return arguments.entity;
		}
	</cfscript>

	<!------------------------ PRIVATE METHODS ------------------------>

	<cffunction name="getDBEngine" returntype="string" output="false" access="private" hint="I return the database engine (e.g. MySQL, MSSQL, etc.)">
		<cfdbinfo type="version" name="local.dbInfo">
		<cfreturn UCase(local.dbInfo.DATABASE_PRODUCTNAME)>
	</cffunction>
</cfcomponent>
