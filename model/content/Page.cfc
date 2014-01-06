component persistent="true" table="pages" cacheuse="transactional" {

	// ------------------------ PROPERTIES ------------------------ //

	property name="pageid" column="page_id" fieldtype="id" setter="false" generator="native";

	property name="slug" column="page_slug" ormtype="string" length="150";
	property name="leftvalue" column="page_left" ormtype="int";
	property name="rightvalue" column="page_right" ormtype="int";
	property name="ancestorid" column="page_ancestorid" ormtype="int";
	property name="depth" column="page_depth" ormtype="int";
	property name="title" column="page_title" ormtype="string" length="150";
	property name="content" column="page_content" ormtype="text";
	property name="metagenerated" column="page_metagenerated" ormtype="boolean";
	property name="metatitle" column="page_metatitle" ormtype="string" length="200";
	property name="metadescription" column="page_metadescription" ormtype="string" length="200";
	property name="metakeywords" column="page_metakeywords" ormtype="string" length="200";
	property name="created" column="page_created" ormtype="timestamp";
	property name="updated" column="page_updated" ormtype="timestamp";
	property name="updatedby" column="page_updatedby" ormtype="string" length="150";

	// ------------------------ CONSTRUCTOR ------------------------ //

	/**
	 * I initialise this component
	 */
	Page function init() {
		variables.ancestorid = 0;
		variables.metagenerated = true;
		return this;
	}

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I return the page ancestor
	 */
	any function getAncestor() {
		return ORMExecuteQuery("from Page where pageid = :ancestorid", {ancestorid=variables.ancestorid}, true);
	}

	/**
	 * I return a list of descendent page ids
	 */
	string function getDescendentPageIDList() {
		var pageidlist = "";
		for(var looppage in getDescendents()) pageidlist = ListAppend(pageidlist, looppage.getPageID());
		return pageidlist;
	}

	/**
	 * I return the next sibling of the page
	 */
	function getNextSibling() {
		return ORMExecuteQuery("from Page where leftvalue = :leftvalue", {leftvalue=variables.rightvalue + 1}, true);
	}

	/**
	 * I return the page path
	 */
	array function getPath() {
		return ORMExecuteQuery("from Page where leftvalue < :leftvalue and rightvalue > :rightvalue", {leftvalue=variables.leftvalue, rightvalue=variables.rightvalue});
	}

	/**
	 * I return the previous sibling of the page
	 */
	function getPreviousSibling() {
		return ORMExecuteQuery("from Page where rightvalue = :rightvalue", {rightvalue=variables.leftvalue - 1}, true);
	}

	/**
	 * I return true if the page has a child
	 */
	boolean function hasChild() {
		return !IsNull(getFirstChild());
	}

	/**
	 * I return true if the page has a next sibling
	 */
	boolean function hasNextSibling() {
		return !IsNull(getNextSibling());
	}

	/**
	 * I return true if the page has a meta description
	 */
	boolean function hasMetaDescription() {
		return Len(Trim(variables.metadescription));
	}

	/**
	 * I return true if the page has meta keywords
	 */
	boolean function hasMetaKeywords() {
		return Len(Trim(variables.metakeywords));
	}

	/**
	 * I return true if the page has a meta title
	 */
	boolean function hasMetaTitle() {
		return Len(Trim(variables.metatitle));
	}

	/**
	 * I return true if the page id is found in a list of page ids
	 */
	boolean function hasPageIDInPath(required string pageidlist) {
		if(ListFind(arguments.pageidlist, variables.pageid)) return true;
		for(var Page in getPath()) {
			if(ListFind(arguments.pageidlist, Page.getPageID())) return true;
		}
		return false;
	}

	/**
	 * I return true if the page has a previous sibling
	 */
	boolean function hasPreviousSibling() {
		return !IsNull(getPreviousSibling());
	}

	/**
	 * I return true if the page has a FW/1 route
	 */
	boolean function hasRoute(array routes=[]) {
		for(var route in arguments.routes) {
			if(StructKeyExists(route, getSlug())) return true;
		}
		return false;
	}

	/**
	 * I return true if the page is a leaf (i.e. has no children)
	 */
	boolean function isLeaf() {
		return getDescendentCount() == 0;
	}

	/**
	 * I return true if the page meta tags are automatically generated
	 */
	boolean function isMetaGenerated() {
		return variables.metagenerated;
	}

	/**
	 * I return true if the page is persisted
	 */
	boolean function isPersisted() {
		return !IsNull(variables.pageid);
	}

	/**
	 * I return true if the page is the root (i.e. home page)
	 */
	boolean function isRoot() {
		return variables.leftvalue == 1;
	}

	// ------------------------ PRIVATE METHODS ------------------------ //

	/**
	 * I return the count of page descendents
	 */
	private numeric function getDescendentCount() {
		return (variables.rightvalue - variables.leftvalue - 1) / 2;
	}

	/**
	 * I return the page descendents
	 */
	private array function getDescendents() {
		return ORMExecuteQuery("from Page where leftvalue > :leftvalue and rightvalue < :rightvalue", {leftvalue=variables.leftvalue, rightvalue=variables.rightvalue});
	}

	/**
	 * I return the first child of the page
	 */
	private function getFirstChild() {
		return ORMExecuteQuery("from Page where leftvalue = :leftvalue", {leftvalue=variables.leftvalue + 1}, true);
	}

	/**
	 * I return the last child of the page
	 */
	private function getLastChild() {
		return ORMExecuteQuery("from Page where rightvalue = :rightvalue", {rightvalue=variables.rightvalue - 1}, true);
	}

	/**
	 * I return true if the page has content
	 */
	private boolean function hasContent() {
		return Len(Trim(variables.content));
	}

	/**
	 * I return true if the page has descendents
	 */
	private boolean function hasDescendents() {
		return ArrayLen(getDescendents());
	}

	/**
	 * I return true if the page has a parent
	 */
	private boolean function isChild() {
		return variables.ancestorid != 0;
	}

}
