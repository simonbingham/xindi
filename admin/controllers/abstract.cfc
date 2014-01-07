component accessors="true" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="EnquiryService" setter="true" getter="false";
	property name="SecurityService" setter="true" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function init(required any fw) {
		variables.fw = arguments.fw;
	}

	void function before(required struct rc) {
		rc.isallowed = variables.SecurityService.isAllowed(variables.fw.getFullyQualifiedAction());
		if(!rc.isallowed) {
			variables.fw.redirect("security");
		}else{
			rc.CurrentUser = variables.SecurityService.getCurrentUser();
			rc.unreadenquirycount = variables.EnquiryService.getUnreadCount();
		}
	}

}
