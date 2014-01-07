component accessors="true" extends="abstract" {

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function default(required struct rc) {
		rc.enquiries = variables.EnquiryService.getEnquiries();
		rc.unreadenquirycount = variables.EnquiryService.getUnreadCount();
	}

	void function delete(required struct rc) {
		param name="rc.enquiryid" default="0";
		rc.result = variables.EnquiryService.deleteEnquiry(rc.enquiryid);
		variables.fw.redirect("enquiries", "result");
	}

	void function enquiry(required struct rc) {
		param name="rc.enquiryid" default="0";
		rc.Enquiry = variables.EnquiryService.getEnquiry(rc.enquiryid);
		if(!IsNull(rc.Enquiry)) variables.EnquiryService.markRead(rc.Enquiry.getEnquiryID());
		else variables.fw.redirect("main.notfound");
	}

	void function markread(required struct rc) {
		rc.result = variables.EnquiryService.markRead();
		variables.fw.redirect("enquiries", "result");
	}

}
