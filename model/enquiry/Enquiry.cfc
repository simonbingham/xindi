/**
 * I am the enquiry entity component.
 */
component persistent = true table = "enquiries" cacheuse = "transactional" {

	// ------------------------ PROPERTIES ------------------------ //

	property name = "enquiryId" column = "enquiry_id" fieldtype = "id" setter = false generator = "native";

	property name = "name" column = "enquiry_name" ormtype = "string" length = 50;
	property name = "email" column = "enquiry_email" ormtype = "string" length = 150;
	property name = "message" column = "enquiry_message" ormtype = "text";
	property name = "read" column = "enquiry_read" ormtype = "boolean";
	property name = "created" column = "enquiry_created" ormtype = "timestamp";

	// ------------------------ CONSTRUCTOR ------------------------ //

	/**
	 * I initialise this component
	 */
	Enquiry function init() {
		variables.name = "";
		variables.message = "";
		variables.read = false;
		return this;
	}

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I return the message formatted for display
	 */
	string function getDisplayMessage() {
		return REReplace(HTMLEditFormat(variables.message), "[\r\n]+", "<br /><br />", "ALL");
	}

	/**
	 * I return true if the enquiry is persisted
	 */
	boolean function isPersisted() {
		return !IsNull(variables.enquiryId);
	}

	/**
	 * I return true if the enquiry is read
	 */
	boolean function isRead() {
		return variables.read;
	}

}
