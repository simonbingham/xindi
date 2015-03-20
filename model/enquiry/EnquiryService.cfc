/**
 * I am the enquiry service component.
 */
component accessors = true extends = "model.abstract.BaseService" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name = "EnquiryGateway" getter = false;
	property name = "NotificationService" getter = false;
	property name = "Validator" getter = false;

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I delete an enquiry
	 */
	struct function deleteEnquiry(required numeric enquiryId) {
		transaction{
			local.Enquiry = variables.EnquiryGateway.getEnquiry(enquiryId = Val(arguments.enquiryId));
			local.result = variables.Validator.newResult();
			if (local.Enquiry.isPersisted()) {
				variables.EnquiryGateway.deleteEnquiry(theEnquiry = local.Enquiry);
				local.result.setSuccessMessage("The enquiry from &quot;#local.Enquiry.getName()#&quot; has been deleted.");
			} else {
				local.result.setErrorMessage("The enquiry could not be deleted.");
			}
		}
		return local.result;
	}

	/**
	 * I return an array of enquiries
	 */
	array function getEnquiries(numeric maxResults = 0) {
		return variables.EnquiryGateway.getEnquiries(maxResults = Val(arguments.maxResults));
	}

	/**
	 * I return an enquiry matching an id
	 */
	Enquiry function getEnquiry(required numeric enquiryId) {
		return variables.EnquiryGateway.getEnquiry(enquiryId = Val(arguments.enquiryId));
	}

	/**
	 * I return a count of unread enquiries
	 */
	numeric function getUnreadCount() {
		return variables.EnquiryGateway.getUnreadCount();
	}

	/**
	 * I mark an enquiry, or enquiries, as read
	 */
	struct function markRead(numeric enquiryId = 0) {
		transaction{
			local.result = variables.Validator.newResult();
			if (Val(arguments.enquiryId)) {
				local.Enquiry = variables.EnquiryGateway.getEnquiry(enquiryId = Val(arguments.enquiryId));
				if (!IsNull(local.Enquiry)) {
					variables.EnquiryGateway.markRead(theEnquiry = local.Enquiry);
					local.result.setSuccessMessage("The message has been marked as read.");
				} else {
					local.result.setErrorMessage("The message could not be marked as read.");
				}
			} else {
				variables.EnquiryGateway.markRead();
				local.result.setSuccessMessage("All messages have been marked as read.");
			}
		}
		return local.result;
	}

	/**
	 * I return a new enquiry
	 */
	Enquiry function newEnquiry() {
		return variables.EnquiryGateway.newEnquiry();
	}

	/**
	 * I validate and send an enquiry
	 */
	struct function sendEnquiry(required struct properties, required struct config, required string emailTemplatePath) {
		transaction{
			local.Enquiry = variables.EnquiryGateway.newEnquiry();
			populate(Entity = local.Enquiry, memento = arguments.properties);
			local.result = variables.Validator.validate(theObject = local.Enquiry);
			if (!local.result.hasErrors()) {
				savecontent variable="local.emailTemplate" {include arguments.emailTemplatePath;}
				variables.NotificationService.send(subject = arguments.config.subject, to = arguments.config.emailTo, from = local.Enquiry.getEmail(), body = local.emailTemplate);
				variables.EnquiryGateway.saveEnquiry(theEnquiry = local.Enquiry);
				local.result.setSuccessMessage("Your enquiry has been sent.");
			} else {
				local.result.setErrorMessage("Your enquiry could not be sent. Please amend the highlighted fields.");
			}
		}
		return local.result;
	}

}
