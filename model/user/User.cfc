/**
 * I am the user entity component.
 */
component persistent="true" table="users" cacheuse="transactional" {

	// ------------------------ PROPERTIES ------------------------ //

	property name="userId" column="user_id" fieldtype="id" setter="false" generator="native";

	property name="name" column="user_name" ormtype="string" length="50";
	property name="email" column="user_email" ormtype="string" length="150";
	property name="password" column="user_password" ormtype="string" length="65" setter="false";
	property name="created" column="user_created" ormtype="timestamp";
	property name="updated" column="user_updated" ormtype="timestamp";

	// ------------------------ CONSTANTS ------------------------ //

	variables.PASSWORD_HASH_ITERATION_COUNT = 50;

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
		local.result = {
			isSuccess = false,
			failureMessage = "The email address '#variables.email#' is registered to an existing account."
		};
		if (isPersisted()) {
			local.matches = ORMExecuteQuery("from User where userId <> :userId and email = :email", {userId = variables.userId, email = variables.email});
		} else {
			local.matches = ORMExecuteQuery("from User where email = :email", {email = variables.email});
		}
		if (!ArrayLen(local.matches)) {
			local.result.isSuccess = true;
		}
		return local.result;
	}

	/**
	 * I return true if the user is persisted
	 */
	boolean function isPersisted() {
		return !IsNull(variables.userId);
	}

	/**
	* I override the implicit setter to include hashing of the password
	*/
	string function setPassword(required string password) {
		if (arguments.password != "") {
			variables.password = arguments.password;
			// to help prevent rainbow attacks hash several times
			for (local.i = 0; local.i < variables.PASSWORD_HASH_ITERATION_COUNT; local.i++) {
				variables.password = Hash(variables.password, "SHA-256");
			}
		}
	}

}
