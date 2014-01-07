component accessors="true" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="MetaData" getter="false";
	property name="Validator" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I return an entity validator
	 */
	function getValidator(required Entity) {
		return variables.Validator.getValidator(theObject=arguments.Entity);
	}

	/**
	 * I populate an entity
	 */
	void function populate(required Entity, required struct memento, boolean trustedSetter=false, string include="", string exclude="") {
		var populate = true;
		for(var key in arguments.memento) {
			populate = true;
			if(Len(arguments.include) && !ListFindNoCase(arguments.include, key)) populate = false;
			if(Len(arguments.exclude) && ListFindNoCase(arguments.exclude, key)) populate = false;
			if(populate && (StructKeyExists(arguments.Entity, "set" & key) || arguments.trustedSetter)) Evaluate("arguments.Entity.set#key#(arguments.memento[key])");
		}
		populateMetaData(arguments.Entity);
	}

	/**
	 * I populate meta data for an entity
	 */
	void function populateMetaData(required Entity) {
		if(StructKeyExists(arguments.Entity, "isMetaGenerated") && arguments.Entity.isMetaGenerated()) {
			if(StructKeyExists(arguments.Entity, "setMetaTitle") && StructKeyExists(arguments.Entity, "getTitle")) arguments.Entity.setMetaTitle(arguments.Entity.getTitle());
			if(StructKeyExists(arguments.Entity, "setMetaDescription") && StructKeyExists(arguments.Entity, "getContent")) arguments.Entity.setMetaDescription(variables.MetaData.generateMetaDescription(arguments.Entity.getContent()));
			if(StructKeyExists(arguments.Entity, "setMetaKeywords") && StructKeyExists(arguments.Entity, "getContent")) arguments.Entity.setMetaKeywords(variables.MetaData.generateMetaKeywords(arguments.Entity.getContent()));
		}
	}

}
