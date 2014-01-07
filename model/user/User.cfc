component persistent="true" table="users" cacheuse="transactional" {

	// ------------------------ PROPERTIES ------------------------ //

	property name="userid" column="user_id" fieldtype="id" setter="false" generator="native";

	property name="name" column="user_name" ormtype="string" length="50";
	property name="email" column="user_email" ormtype="string" length="150";
	property name="password" column="user_password" ormtype="string" length="65" setter="false";
	property name="created" column="user_created" ormtype="timestamp";
	property name="updated" column="user_updated" ormtype="timestamp";

	// ------------------------ CONSTRUCTOR ------------------------ //

	/**
	 * I initialise this component
	 */
	User function init() {
		return this;
	}

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I return true if the email address is unique
	 */
	struct function isEmailUnique() {
		var matches = [];
		var result = {issuccess=false, failuremessage="The email address '#variables.email#' is registered to an existing account."};
		if(isPersisted()) matches = ORMExecuteQuery("from User where userid <> :userid and email = :email", {userid=variables.userid, email=variables.email});
		else matches = ORMExecuteQuery("from User where email=:email", {email=variables.email});
		if(!ArrayLen(matches)) result.issuccess = true;
		return result;
	}

	/**
	 * I return true if the user is persisted
	 */
	boolean function isPersisted() {
		return !IsNull(variables.userid);
	}

	/**
	* I override the implicit setter to include hashing of the password
	*/
	string function setPassword(required password) {
		if(arguments.password != "") {
			variables.password = arguments.password;
			// to help prevent rainbow attacks hash several times
			for (var i=0; i<50; i++) variables.password = Hash(variables.password, "SHA-256");
		}
	}

}
