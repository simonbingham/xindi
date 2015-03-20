/**
 * I am the content service component.
 */
component accessors = true extends = "model.abstract.BaseService" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name = "ContentGateway" getter = false;
	property name = "MetaData" getter = false;
	property name = "SecurityService" getter = false;
	property name = "Validator" getter = false;

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I delete a page
	 */
	struct function deletePage(required numeric pageId) {
		transaction{
			local.Page = variables.ContentGateway.getPage(pageId = Val(arguments.pageId));
			local.result = variables.Validator.newResult();
			if (local.Page.isPersisted()) {
				variables.ContentGateway.deletePage(thePage = local.Page);
				local.result.setSuccessMessage("The page &quot;#local.Page.getTitle()#&quot; has been deleted.");
			} else {
				local.result.setErrorMessage("The page could not be deleted.");
			}
		}
		return local.result;
	}

	/**
	 * I return a query of pages and articles that match the search term
	 */
	query function findContentBySearchTerm(string searchTerm = "", numeric maxResults = 50) {
		local.args = Duplicate(arguments);
		local.args.maxresults = Val(local.args.maxResults);
		return variables.ContentGateway.findContentBySearchTerm(argumentCollection = local.args);
	}

	/**
	 * I return a query of child pages
	 */
	query function getChildren(required any Page, boolean clearCache = false) {
		return variables.ContentGateway.getChildren(left = arguments.Page.getLeftValue(), right = arguments.Page.getRightValue(), clearCache = arguments.clearCache);
	}

	/**
	 * I return a page matching an id
	 */
	Page function getPage(required numeric pageId) {
		return variables.ContentGateway.getPage(pageId = Val(arguments.pageId));
	}

	/**
	 * I return a page matching a slug
	 */
	Page function getPageBySlug(required string slug) {
		return variables.ContentGateway.getPageBySlug(slug = Trim(arguments.slug));
	}

	/**
	 * I return an array of pages
	 */
	array function getPages(string searchTerm = "", string sortOrder = "leftValue", numeric maxResults = 0) {
		local.args = Duplicate(arguments);
		local.args.maxResults = Val(local.args.maxResults);
		return variables.ContentGateway.getPages(argumentCollection = local.args);
	}

	/**
	 * I return a query of pages making up the site hierarchy
	 */
	query function getNavigation(any Page, numeric depth, boolean clearCache = false) {
		local.params = {
			clearcache = arguments.clearCache
		};
		if (StructKeyExists(arguments, "Page")) {
			local.params.left = arguments.Page.getLeftValue();
			local.params.right = arguments.Page.getRightValue();
		}
		if (StructKeyExists(arguments, "depth")) {
			local.params.depth = arguments.depth;
		}
		return variables.ContentGateway.getNavigation(argumentCollection = local.params);
	}

	/**
	 * I return a query of pages for page's hierarchy
	 */
	query function getNavigationPath(required numeric pageId) {
		local.args = Duplicate(arguments);
		local.args.pageId = Val(local.args.pageId);
		return variables.ContentGateway.getNavigationPath(pageId = local.args.pageId);
	}

	/**
	 * I return the root page (i.e. home page)
	 */
	Page function getRoot() {
		return variables.ContentGateway.getRoot();
	}

	/**
	 * I validate and save a page
	 */
	struct function savePage(required struct properties, required numeric ancestorId, required string context, required string websiteTitle, required string defaultSlug) {
		transaction{
			local.args = Duplicate(arguments);
			param name = "local.args.properties.pageId" default = "";
			param name = "local.args.properties.metaGenerated" default = false;
			local.args.properties.pageId = Val(local.args.properties.pageId);
			local.Page = variables.ContentGateway.getPage(pageId = local.args.properties.pageId);
			if (local.args.properties.metaGenerated) {
				local.args.properties.metaTitle = variables.MetaData.generatePageTitle(websiteTitle = local.args.websiteTitle, pageTitle = local.args.properties.title);
				local.args.properties.metaDescription = variables.MetaData.generateMetaDescription(content = local.args.properties.content);
				local.args.properties.metaKeywords = variables.MetaData.generateMetaKeywords(content = local.args.properties.title);
			}
			local.User = variables.SecurityService.getCurrentUser();
			if (!IsNull(local.User)) {
				local.args.properties.updatedBy = local.User.getName();
			}
			populate(Entity = local.Page, memento = local.args.properties);
			local.result = variables.Validator.validate(theObject = local.Page, context = local.args.context);
			if (!local.result.hasErrors()) {
				variables.ContentGateway.savePage(thePage = local.Page, ancestorId = local.args.ancestorId, defaultSlug = local.args.defaultSlug);
				local.result.setSuccessMessage("The page &quot;#local.Page.getTitle()#&quot; has been saved.");
			} else {
				local.result.setErrorMessage("Your page could not be saved. Please amend the highlighted fields.");
			}
		}
		return local.result;
	}

	// accepts an array of structs
	// TODO: doesn't currently update left and right values of sub pages - need to fix
	boolean function saveSortOrder(required array pages) {
		local.newLeft = -1;
		local.width = -1;
		local.newRight = -1;
		local.affectedPages = -1;
		local.sorted = [];
		for (local.page in arguments.pages) {
			local.PageEntity = getPage(pageId = local.page.pageId);
			if (IsNull(local.PageEntity) || !local.PageEntity.isPersisted()) {
				return false;
			}
			local.width = local.PageEntity.getRightValue() - local.PageEntity.getLeftValue();
			local.newLeft = local.newLeft == -1 ? local.page.left : local.newRight++;
			local.newRight = local.newLeft + local.width;
			local.shift = local.newLeft - local.PageEntity.getLeftValue();
			local.affectedPages = local.PageEntity.getPageId();
			if (local.shift != 0) {
				local.descendants = variables.ContentGateway.getNavigation(left = local.PageEntity.getLeftValue(), right = local.PageEntity.getRightValue());
				if (local.descendants.recordCount) {
					local.affectedPages &= "," & ValueList(local.descendants.pageid);
				}
			}
			// storing extra info to help debug
			ArrayAppend(local.sorted, {
				shift = local.shift,
				affectedPages = local.affectedPages,
				newLeft = local.newLeft,
				newRight = local.newRight,
				width = local.width,
				title = local.PageEntity.getTitle()
			});
		}
		// now it's all figured out, save it
		transaction{
			for (local.node in local.sorted) {
				if (local.node.shift != 0) {
					variables.ContentGateway.shiftPages(affectedPages = local.node.affectedPages, shift = local.node.shift);
				}
			}
		}
		// as we've used SQL instead of ORM to adjust clear ORM cache
		ORMEvictEntity("Page");
		return true;
	}

}
