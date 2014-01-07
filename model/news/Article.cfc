component persistent="true" table="articles" cacheuse="transactional" {

	// ------------------------ PROPERTIES ------------------------ //

	property name="articleid" column="article_id" fieldtype="id" setter="false" generator="native";

	property name="slug" column="article_slug" ormtype="string" length="150";
	property name="title" column="article_title" ormtype="string" length="150";
	property name="content" column="article_content" ormtype="text";
	property name="metagenerated" column="article_metagenerated" ormtype="boolean";
	property name="metatitle" column="article_metatitle" ormtype="string" length="200";
	property name="metadescription" column="article_metadescription" ormtype="string" length="200";
	property name="metakeywords" column="article_metakeywords" ormtype="string" length="200";
	property name="author" column="article_author" ormtype="string" length="100";
	property name="published" column="article_published" ormtype="timestamp";
	property name="created" column="article_created" ormtype="timestamp";
	property name="updated" column="article_updated" ormtype="timestamp";
	property name="updatedby" column="article_updatedby" ormtype="string" length="150";

	// ------------------------ CONSTRUCTOR ------------------------ //

	/**
	 * I initialise this component
	 */
	Article function init() {
		variables.slug = "";
		variables.content = "";
		variables.metagenerated = true;
		variables.published = "";
		return this;
	}

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I return the summary in xml format
	 */
	string function getRSSSummary() {
		var plaintext = Trim(ReReplace(REReplaceNoCase(Trim(variables.content), "<[^>]{1,}>", " ", "all"), " +", " ", "all"));
		if(Len(plaintext) > 500) return Left(plaintext, 500) & "...";
		return XMLFormat(plaintext);
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
		return DateDiff("ww", variables.published, Now()) < 1;
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
	void function setSlug(string slug) {
		variables.slug = ReReplace(LCase(variables.title), "[^a-z0-9]{1,}", "-", "all");
		while (!isSlugUnique()) variables.slug &= "-";
	}

	// ------------------------ PRIVATE METHODS ------------------------ //

	/**
	 * I return true if the id of the article is unique
	 */
	private boolean function isSlugUnique() {
		var matches = [];
		if(isPersisted()) matches = ORMExecuteQuery("from Article where articleid <> :articleid and slug = :slug", {articleid=variables.articleid, slug=variables.slug});
		else matches = ORMExecuteQuery("from Article where slug=:slug", {slug=variables.slug});
		return !ArrayLen(matches);
	}

}
