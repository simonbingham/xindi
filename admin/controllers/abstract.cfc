component accessors = true {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name = "EnquiryService" setter = true getter = false;
	property name = "SecurityService" setter = true getter = false;

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function init(required any fw) {
		variables.fw = arguments.fw;
	}

	void function before(required struct rc) {
		rc.isAllowed = variables.SecurityService.isAllowed(action = variables.fw.getFullyQualifiedAction());
		if (!rc.isAllowed) {
			variables.fw.redirect("security");
		} else {
			rc.CurrentUser = variables.SecurityService.getCurrentUser();
			rc.unreadEnquiryCount = variables.EnquiryService.getUnreadCount();
		}
	}

}
