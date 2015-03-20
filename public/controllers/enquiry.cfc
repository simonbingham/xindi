component accessors = true extends = "abstract" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name = "EnquiryService" setter = true getter = false;
	property name = "config" setter = true getter = false;

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function default(required struct rc) {
		if (!StructKeyExists(rc, "Enquiry")) {
			rc.Enquiry = variables.EnquiryService.newEnquiry();
		}
		rc.Validator = variables.EnquiryService.getValidator(Entity = rc.Enquiry);
		if (!StructKeyExists(rc, "result")) {
			rc.result = rc.Validator.newResult();
		}
		rc.MetaData.setMetaTitle("Contact Us");
		rc.MetaData.setMetaDescription("");
		rc.MetaData.setMetaKeywords("");
	}

	void function send(required struct rc) {
		param name = "rc.name" default = "";
		param name = "rc.email" default = "";
		param name = "rc.message" default = "";
		rc.result = variables.EnquiryService.sendEnquiry(properties = rc, config = variables.config.enquiry, emailTemplatePath = "../../public/views/enquiry/email.cfm");
		if (rc.result.getIsSuccess()) {
			variables.fw.redirect("enquiry.thanks");
		} else {
			rc.Enquiry = rc.result.getTheObject();
			variables.fw.redirect("enquiry", "Enquiry,result");
		}
	}

}
