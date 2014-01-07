component accessors="true" extends="abstract" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="ContentService" setter="true" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function default(required struct rc) {
		rc.navigation = variables.ContentService.getNavigation(clearcache=true);
	}

	void function delete(required struct rc) {
		param name="rc.pageid" default="0";
		rc.result = variables.ContentService.deletePage(rc.pageid);
		if(!rc.config.development && rc.result.getIsSuccess()) {
			var refreshsitemap = new Http(url="#rc.basehref#index.cfm/public:navigation/xml", method="get");
			refreshsitemap.send();
		}
		variables.fw.redirect("pages", "result");
	}

	void function maintain(required struct rc) {
		param name="rc.pageid" default="0";
		param name="rc.context" default="create";
		if(!StructKeyExists(rc, "Page")) rc.Page = variables.ContentService.getPage(rc.pageid);
		if(rc.Page.isPersisted() && !rc.Page.hasRoute(variables.fw.getRoutes())) rc.context = "update";
		rc.Validator = variables.ContentService.getValidator(rc.Page);
		if(!StructKeyExists(rc, "result")) rc.result = rc.Validator.newResult();
	}

	void function save(required struct rc) {
		param name="rc.pageid" default="0";
		param name="rc.ancestorid" default="0";
		param name="rc.title" default="";
		param name="rc.content" default="";
		param name="rc.metagenerated" default="false";
		param name="rc.metatitle" default="";
		param name="rc.metadescription" default="";
		param name="rc.metakeywords" default="";
		param name="rc.context" default="create";
		param name="rc.submit" default="Save & exit";
		rc.result = variables.ContentService.savePage(rc, rc.ancestorid, rc.context, rc.config.name, rc.config.page.defaultslug);
		rc.Page = rc.result.getTheObject();
		if(rc.result.getIsSuccess()) {
			if(!rc.config.development) {
				var refreshsitemap = new Http(url="#rc.basehref#index.cfm/public:navigation/xml", method="get");
				refreshsitemap.send();
			}
			if(rc.submit == "Save & Continue") variables.fw.redirect("pages.maintain", "result,Page,ancestorid", "pageid");
			else variables.fw.redirect("pages", "result");
		}else{
			variables.fw.redirect("pages.maintain", "result,Page,ancestorid", "pageid");
		}
	}

	void function sort(required struct rc) {
		param name="rc.pageid" default="0";
		rc.Page = variables.ContentService.getPage(rc.pageid);
		if (IsNull(rc.Page)) variables.fw.redirect("pages");
		rc.subpages = variables.ContentService.getChildren(page=rc.Page, clearcache=true);
	}

	void function savesort(required struct rc) {
		rc.saved = false;
		if (StructKeyExists(rc, "payload")) {
			var pages = DeserializeJSON(rc.payload);
			rc.saved = variables.ContentService.saveSortOrder(pages);
		}
		// convert result to JavaScript boolean
		rc.saved = rc.saved ? "true" : "false";
	}

}
