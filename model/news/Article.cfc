/**
 * I am the article entity component.
 */
component persistent = true table = "articles" cacheuse = "transactional" {

	// ------------------------ PROPERTIES ------------------------ //

	property name = "articleId" column = "article_id" fieldtype = "id" setter = false generator = "native";

	property name = "slug" column = "article_slug" ormtype = "string" length = 150;
	property name = "title" column = "article_title" ormtype = "string" length = 150;
	property name = "content" column = "article_content" ormtype = "text";
	property name = "metaGenerated" column = "article_metagenerated" ormtype = "boolean";
	property name = "metaTitle" column = "article_metatitle" ormtype = "string" length = 200;
	property name = "metaDescription" column = "article_metadescription" ormtype = "string" length = 200;
	property name = "metaKeywords" column = "article_metakeywords" ormtype = "string" length = 200;
	property name = "author" column = "article_author" ormtype = "string" length = 100;
	property name = "published" column = "article_published" ormtype = "timestamp";
	property name = "created" column = "article_created" ormtype = "timestamp";
	property name = "updated" column = "article_updated" ormtype = "timestamp";
	property name = "updatedBy" column = "article_updatedby" ormtype = "string" length = 150;

	// ------------------------ CONSTANTS ------------------------ //

	variables.NEW_ARTICLE_THRESHOLD_IN_WEEKS = 1;
	variables.RSS_SUMMARY_LENGTH = 500;

	// ------------------------ CONSTRUCTOR ------------------------ //

	/**
	 * I initialise this component
	 */
	Article function init() {
		variables.slug = "";
		variables.content = "";
		variables.metaGenerated = true;
		variables.published = "";
		return this;
	}

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I return the summary in xml format
	 */
	string function getRSSSummary() {
		local.plainText = Trim(ReReplace(REReplaceNoCase(Trim(variables.content), "<[^>]{1,}>", " ", "all"), " +", " ", "all"));
		if (Len(local.plainText) > variables.RSS_SUMMARY_LENGTH) {
			return Left(local.plainText, variables.RSS_SUMMARY_LENGTH) & "...";
		}
		return XMLFormat(local.plainText);
	}

	/**
	 * I return true if the article has an author
	 */
	boolean function hasAuthor() {
		return Len(Trim(variables.author));
	}

	/**
	 * I return true if the article has a meta description
	 */
	boolean function hasMetaDescription() {
		return Len(Trim(variables.metadescription));
	}

	/**
	 * I return true if the article has meta keywords
	 */
	boolean function hasMetaKeywords() {
		return Len(Trim(variables.metakeywords));
	}

	/**
	 * I return true if the article has a meta title
	 */
	boolean function hasMetaTitle() {
		return Len(Trim(variables.metatitle));
	}

	/**
	 * I return true if the article meta tags are generated automatically
	 */
	boolean function isMetaGenerated() {
		return variables.metagenerated;
	}

	/**
	 * I return true if the article is new
	 */
	boolean function isNew() {
		return DateDiff("ww", variables.published, Now()) < variables.NEW_ARTICLE_THRESHOLD_IN_WEEKS;
	}

	/**
	 * I return true if the article is persisted
	 */
	boolean function isPersisted() {
		return !IsNull(variables.articleid);
	}

	/**
	 * I return true if the article is published
	 */
	boolean function isPublished() {
		return variables.published < Now();
	}

	/**
	* I am called before inserting the article into the database
	*/
	void function preInsert() {
		setSlug();
	}

	/**
	 * I generate a unique id for the article
	 */
	void function setSlug() {
		variables.slug = ReReplace(LCase(variables.title), "[^a-z0-9]{1,}", "-", "all");
		while (!isSlugUnique()) {
			variables.slug &= "-";
		}
	}

	// ------------------------ PRIVATE METHODS ------------------------ //

	/**
	 * I return true if the id of the article is unique
	 */
	private boolean function isSlugUnique() {
		if (isPersisted()) {
			local.matches = ORMExecuteQuery("from Article where articleId <> :articleId and slug = :slug", {articleId = variables.articleId, slug = variables.slug});
		} else {
			local.matches = ORMExecuteQuery("from Article where slug = :slug", {slug = variables.slug});
		}
		return !ArrayLen(local.matches);
	}

}
