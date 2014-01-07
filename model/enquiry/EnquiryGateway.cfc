component accessors="true" extends="model.abstract.BaseGateway" {

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I delete an enquiry
	 */
	void function deleteEnquiry(required Enquiry theEnquiry) {
		delete(arguments.theEnquiry);
	}

	/**
	 * I return an array of enquiries
	 */
	array function getEnquiries(numeric maxresults=0) {
		var ormoptions = {};
		if(arguments.maxresults) ormoptions.maxresults = arguments.maxresults;
		return EntityLoad("Enquiry", {}, "read, created DESC", ormoptions);
	}

	/**
	 * I return an enquiry matching an id
	 */
	Enquiry function getEnquiry(required numeric enquiryid) {
		return get("Enquiry", arguments.enquiryid);
	}

	/**
	 * I return a count of unread enquiries
	 */
	numeric function getUnreadCount() {
		return ORMExecuteQuery("select count(*) from Enquiry where read = false", [], true);
	}

	/**
	 * I mark an enquiry, or enquiries, as read
	 */
	void function markRead(theEnquiry="") {
		if(IsObject(arguments.theEnquiry)) {
			arguments.theEnquiry.setRead(true);
			save(arguments.theEnquiry);
		}else{
			ORMExecuteQuery("update Enquiry set read=true");
		}
	}

	/**
	 * I return a new enquiry
	 */
	Enquiry function newEnquiry() {
		return new("Enquiry");
	}

	/**
	 * I save an enquiry
	 */
	Enquiry function saveEnquiry(required Enquiry theEnquiry) {
		return save(arguments.theEnquiry);
	}

}
