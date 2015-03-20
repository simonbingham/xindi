/**
 * I am the base service component.
 */
component accessors = true {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name = "MetaData" getter = false;
	property name = "Validator" getter = false;

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I return an entity validator
	 */
	function getValidator(required any Entity) {
		return variables.Validator.getValidator(theObject = arguments.Entity);
	}

	/**
	 * I populate an entity
	 */
	void function populate(required any Entity, required struct memento, boolean trustedSetter = false, string include = "", string exclude = "") {
		for (local.key in arguments.memento) {
			local.populate = true;
			if (Len(Trim(arguments.include)) && !ListFindNoCase(arguments.include, local.key)) {
				local.populate = false;
			}
			if (Len(Trim(arguments.exclude)) && ListFindNoCase(arguments.exclude, local.key)) {
				local.populate = false;
			}
			if (local.populate && (StructKeyExists(arguments.Entity, "set" & local.key) || arguments.trustedSetter)) {
				Evaluate("arguments.Entity.set#local.key#(arguments.memento[local.key])");
			}
		}
		populateMetaData(Entity = arguments.Entity);
	}

	/**
	 * I populate meta data for an entity
	 */
	void function populateMetaData(required any Entity) {
		if (StructKeyExists(arguments.Entity, "isMetaGenerated") && arguments.Entity.isMetaGenerated()) {
			if (StructKeyExists(arguments.Entity, "setMetaTitle") && StructKeyExists(arguments.Entity, "getTitle")) {
				local.metaTitle = arguments.Entity.getTitle();
				arguments.Entity.setMetaTitle(local.metaTitle);
			}
			if (StructKeyExists(arguments.Entity, "setMetaDescription") && StructKeyExists(arguments.Entity, "getContent")) {
				local.metaDescription = variables.MetaData.generateMetaDescription(content = arguments.Entity.getContent());
				arguments.Entity.setMetaDescription(local.metaDescription);
			}
			if (StructKeyExists(arguments.Entity, "setMetaKeywords") && StructKeyExists(arguments.Entity, "getContent")) {
				local.metaKeywords = variables.MetaData.generateMetaKeywords(content = arguments.Entity.getContent());
				arguments.Entity.setMetaKeywords(local.metaKeywords);
			}
		}
	}

}
