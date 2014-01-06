component accessors="true" {

	// ------------------------ PROPERTIES ------------------------ //

	property name="metatitle";
	property name="metakeywords";
	property name="metadescription";
	property name="metaauthor";

	// ------------------------ CONSTRUCTOR ------------------------ //

	/**
	 * I initialise this component
	 */
	MetaData function init() {
		variables.metatitle = "";
		variables.metakeywords = "";
		variables.metadescription = "";
		variables.metaauthor = "";
		return this;
	}

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I generate a meta description
	 */
	string function generateMetaDescription(string description="") {
		return Left(Trim(replaceMultipleSpacesWithSingleSpace(removeUnrequiredCharacters(stripHTML(arguments.description)))), 200);
	}

	/**
	 * I generate meta keywords
	 */
	string function generateMetaKeywords(string keywords="") {
		return Left(replaceMultipleSpacesWithSingleSpace(removeUnrequiredCharacters(listDeleteDuplicatesNoCase(ListChangeDelims(removeNonKeywords(stripHTML(arguments.keywords)), ",", " .")))), 200);
	}

	/**
	 * I generate a page title
	 */
	string function generatePageTitle(required string websitetitle, required string pagetitle) {
		return Left(stripHTML(arguments.pagetitle) & " | " & stripHTML(arguments.websitetitle), 100);
	}

	/**
	 * I return true if metaauthor does not have zero length
	 */
	boolean function hasMetaAuthor() {
		if(Len(Trim(variables.metaauthor))) return true;
		return false;
	}

	/**
	 * I remove duplicates from a list
	 */
	string function listDeleteDuplicatesNoCase(required string thelist, string delimiter=",") {
		var elements = ListToArray(arguments.thelist, arguments.delimiter);
		elements = CreateObject("java", "java.util.HashSet").init(elements).toArray();
		return ArrayToList(elements);
	}

	/**
	 * I remove non-keywords from a string
	 */
	string function removeNonKeywords(required string thestring) {
		var elements = ListToArray(arguments.thestring, " ");
		var newstring = "";
		for(element in elements) {
			if(!ListFindNoCase("&,a,an,and,are,as,i,if,in,is,it,that,the,this,it,to,of,on,or,us,we", element)) {
				newstring = ListAppend(newstring, element, " ");
			}
		}
		return Trim(Replace(newstring, ".", "", "all"));
	}

	/**
	 * I remove unrequired characters from a string
	 */
	string function removeUnrequiredCharacters(required string thestring) {
		return replaceMultipleSpacesWithSingleSpace(REReplaceNoCase(arguments.thestring, "([#Chr(09)#-#Chr(30)#])", " ", "all"));
	}

	/**
	 * I replace multiple spaces in a string with a single space
	 */
	string function replaceMultipleSpacesWithSingleSpace(required string thestring) {
		return Trim(REReplaceNoCase(arguments.thestring, "\s{2,}", " ", "all"));
	}

	/**
	 * I remove html from a string
	 */
	string function stripHTML(required string thestring) {
		return Trim(replaceMultipleSpacesWithSingleSpace(REReplaceNoCase(arguments.thestring, "<[^>]{1,}>", " ", "all")));
	}

}
