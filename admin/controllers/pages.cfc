component accessors = true extends = "abstract" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name = "ContentService" setter = true getter = false;

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function default(required struct rc) {
		rc.navigation = variables.ContentService.getNavigation(clearCache = true);
	}

	void function delete(required struct rc) {
		param name = "rc.pageId" default = 0;
		rc.result = variables.ContentService.deletePage(pageId = Val(rc.pageId));
		if (!rc.config.development && rc.result.getIsSuccess()) {
			local.refreshSitemap = new http(url = "#rc.basehref#index.cfm/public:navigation/xml", method = "get");
			local.refreshSitemap.send();
		}
		variables.fw.redirect("pages", "result");
	}

	void function maintain(required struct rc) {
		param name = "rc.pageId" default = 0;
		param name = "rc.context" default = "create";
		if (!StructKeyExists(rc, "Page")) {
			rc.Page = variables.ContentService.getPage(pageId = Val(rc.pageId));
		}
		if (rc.Page.isPersisted() && !rc.Page.hasRoute(routes = variables.fw.getRoutes())) {
			rc.context = "update";
		}
		rc.Validator = variables.ContentService.getValidator(Entity = rc.Page);
		if (!StructKeyExists(rc, "result")) {
			rc.result = rc.Validator.newResult();
		}
		rc.pageTitle = rc.Page.isPersisted() ? "Edit Article" : "Add Article";
	}

	void function save(required struct rc) {
		param name = "rc.pageId" default = 0;
		param name = "rc.ancestorId" default = 0;
		param name = "rc.title" default = "";
		param name = "rc.content" default = "";
		param name = "rc.metaGenerated" default = false;
		param name = "rc.metaTitle" default = "";
		param name = "rc.metaDescription" default = "";
		param name = "rc.metaKeywords" default = "";
		param name = "rc.context" default = "create";
		param name = "rc.submit" default = "Save & exit";
		rc.result = variables.ContentService.savePage(properties = rc, ancestorId = Val(rc.ancestorId), context = rc.context, websiteTitle = rc.config.name, defaultSlug = rc.config.page.defaultSlug);
		rc.Page = rc.result.getTheObject();
		if (rc.result.getIsSuccess()) {
			if (!rc.config.development) {
				local.refreshSitemap = new http(url = "#rc.basehref#index.cfm/public:navigation/xml", method = "get");
				local.refreshSitemap.send();
			}
			if (rc.submit == "Save & Continue") {
				variables.fw.redirect("pages.maintain", "result,Page,ancestorId", "pageId");
			} else {
				variables.fw.redirect("pages", "result");
			}
		} else {
			variables.fw.redirect("pages.maintain", "result,Page,ancestorId", "pageId");
		}
	}

	void function sort(required struct rc) {
		param name = "rc.pageId" default = 0;
		rc.Page = variables.ContentService.getPage(pageId = Val(rc.pageId));
		if (IsNull(rc.Page)) {
			variables.fw.redirect("pages");
		}
		rc.subPages = variables.ContentService.getChildren(page = rc.Page, clearCache = true);
	}

	void function saveSort(required struct rc) {
		rc.saved = false;
		if (StructKeyExists(rc, "payload")) {
			local.pages = DeserializeJSON(rc.payload);
			rc.saved = variables.ContentService.saveSortOrder(pages = local.pages);
		}
		// convert result to JavaScript boolean
		rc.saved = rc.saved ? "true" : "false";
	}

}
