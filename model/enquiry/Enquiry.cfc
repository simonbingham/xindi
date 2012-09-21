component persistent="true" table="enquiries" cacheuse="transactional"{
	
	// ------------------------ PROPERTIES ------------------------ //
	
	property name="enquiryid" column="enquiry_id" fieldtype="id" setter="false" generator="native";
	
	property name="firstname" column="enquiry_firstname" ormtype="string" length="50";
	property name="lastname" column="enquiry_lastname" ormtype="string" length="50";
	property name="email" column="enquiry_email" ormtype="string" length="150";
	property name="message" column="enquiry_message" ormtype="text";
	property name="read" column="enquiry_read" ormtype="boolean";
	property name="created" column="enquiry_created" ormtype="timestamp";

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I initialise this component
	 */	
	Enquiry function init(){
		variables.firstname = "";
		variables.lastname = "";
		variables.read = false;
		return this;
	}
	
	/**
	 * I return the message formatted for display
	 */	
	string function getDisplayMessage(){
		return REReplace( HTMLEditFormat( variables.message ), "[\r\n]+", "<br /><br />", "ALL" );
	}	

	/**
	 * I return the full name
	 */		
	string function getFullName(){
		return variables.firstname & " " & variables.lastname;
	}

	/**
	 * I return true if the enquiry is persisted
	 */	
	boolean function isPersisted(){
		return !IsNull( variables.enquiryid );
	}
	
	/**
	 * I return true if the enquiry is read
	 */		
	boolean function isRead(){
		return variables.read;
	}
	
}