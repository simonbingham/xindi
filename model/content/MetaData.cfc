/**
 * I am the meta data component.
 */
component accessors = true {

	// ------------------------ PROPERTIES ------------------------ //

	property name = "metaTitle";
	property name = "metaKeywords";
	property name = "metaDescription";
	property name = "metaAuthor";

	// ------------------------ CONSTANTS ------------------------ //

	variables.META_DESCRIPTION_LENGTH = 200;
	variables.META_KEYWORDS_LENGTH = 200;
	variables.NON_KEYWORDS = "&,a,an,and,are,as,i,if,in,is,it,that,the,this,it,to,of,on,or,us,we";
	variables.PAGE_TITLE_LENGTH = 100;

	// ------------------------ CONSTRUCTOR ------------------------ //

	/**
	 * I initialise this component
	 */
	MetaData function init() {
		variables.metaTitle = "";
		variables.metaKeywords = "";
		variables.metaDescription = "";
		variables.metaAuthor = "";
		return this;
	}

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I generate a meta description
	 */
	string function generateMetaDescription(required string content) {
		return Left(Trim(replaceMultipleSpacesWithSingleSpace(removeUnrequiredCharacters(stripHTML(arguments.content)))), variables.META_DESCRIPTION_LENGTH);
	}

	/**
	 * I generate meta keywords
	 */
	string function generateMetaKeywords(required string content) {
		return ListSort(Lcase(Left(replaceMultipleSpacesWithSingleSpace(removeUnrequiredCharacters(listDeleteDuplicatesNoCase(ListChangeDelims(removeNonKeywords(stripHTML(arguments.content)), ",", " .")))), variables.META_KEYWORDS_LENGTH)), "text");
	}

	/**
	 * I generate a page title
	 */
	string function generatePageTitle(required string websiteTitle, required string pageTitle) {
		return Left(stripHTML(arguments.pageTitle) & " | " & stripHTML(arguments.websiteTitle), variables.PAGE_TITLE_LENGTH);
	}

	/**
	 * I return true if metaAuthor does not have zero length
	 */
	boolean function hasMetaAuthor() {
		if (Len(Trim(variables.metaAuthor))) {
			return true;
		}
		return false;
	}

	/**
	 * I remove duplicates from a list
	 */
	private string function listDeleteDuplicatesNoCase(required string theList, string delimiter = ",") {
		local.elements = ListToArray(arguments.theList, arguments.delimiter);
		local.elements = CreateObject("java", "java.util.HashSet").init(local.elements).toArray();
		return ArrayToList(local.elements);
	}

	/**
	 * I remove non-keywords from a string
	 */
	private string function removeNonKeywords(required string theString) {
		local.elements = ListToArray(arguments.theString, " ");
		local.newString = "";
		for (element in local.elements) {
			if (!ListFindNoCase(variables.NON_KEYWORDS, element)) {
				local.newString = ListAppend(local.newString, element, " ");
			}
		}
		return Trim(Replace(local.newString, ".", "", "all"));
	}

	/**
	 * I remove unrequired characters from a string
	 */
	private string function removeUnrequiredCharacters(required string theString) {
		return replaceMultipleSpacesWithSingleSpace(REReplaceNoCase(arguments.theString, "([#Chr(09)#-#Chr(30)#])", " ", "all"));
	}

	/**
	 * I replace multiple spaces in a string with a single space
	 */
	private string function replaceMultipleSpacesWithSingleSpace(required string theString) {
		return Trim(REReplaceNoCase(arguments.theString, "\s{2,}", " ", "all"));
	}

	/**
	 * I remove html from a string
	 */
	private string function stripHTML(required string theString) {
		return Trim(replaceMultipleSpacesWithSingleSpace(REReplaceNoCase(arguments.theString, "<[^>]{1,}>", " ", "all")));
	}

}
