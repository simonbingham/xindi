component accessors = true extends = "abstract" {

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function default(required struct rc) {
		rc.enquiries = variables.EnquiryService.getEnquiries();
		rc.unreadEnquiryCount = variables.EnquiryService.getUnreadCount();
	}

	void function delete(required struct rc) {
		param name = "rc.enquiryId" default = 0;
		rc.result = variables.EnquiryService.deleteEnquiry(enquiryId = Val(rc.enquiryId));
		variables.fw.redirect("enquiries", "result");
	}

	void function enquiry(required struct rc) {
		param name = "rc.enquiryId" default = 0;
		rc.Enquiry = variables.EnquiryService.getEnquiry(enquiryId = Val(rc.enquiryId));
		if (!IsNull(rc.Enquiry)) {
			variables.EnquiryService.markRead(enquiryId = rc.Enquiry.getEnquiryId());
		} else {
			variables.fw.redirect("main.notfound");
		}
	}

	void function markRead(required struct rc) {
		rc.result = variables.EnquiryService.markRead();
		variables.fw.redirect("enquiries", "result");
	}

}
