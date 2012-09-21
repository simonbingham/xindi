component accessors="true" extends="abstract"{

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="ContentService" setter="true" getter="false";
	property name="NewsService" setter="true" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function default( required struct rc ){
		rc.recentenquiries = variables.EnquiryService.getEnquiries( maxresults=10 );
	}
	
}