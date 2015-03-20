component accessors = true extends = "abstract" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name = "ContentService" setter = true getter = false;

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function default(required struct rc) {
		param name = "rc.searchTerm" default = "";
		rc.Page = variables.ContentService.getRoot(); // required for breadcrumb trail
		if (Len(Trim(rc.searchterm))) {
			rc.pages = variables.ContentService.findContentBySearchTerm(searchTerm = rc.searchTerm);
		}
		rc.MetaData.setMetaTitle("Search Results");
		rc.MetaData.setMetaDescription("");
		rc.MetaData.setMetaKeywords("");
	}

}
