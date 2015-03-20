/**
 * I am the user gateway component.
 */
component accessors="true" extends="model.abstract.BaseGateway" {

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I delete a user
	 */
	void function deleteUser(required User theUser) {
		delete(arguments.theUser);
	}

	/**
	 * I return a user matching an id
	 */
	User function getUser(required numeric userId) {
		return get(entityName = "User", id = arguments.userId);
	}

	/**
	 * I return a user matching a email address and password
	 */
	User function getUserByCredentials(required User theUser) {
		local.User = ORMExecuteQuery("from User where email = :email and password = :password", {email = arguments.theUser.getEmail(), password = arguments.theUser.getPassword()}, true);
		if (IsNull(local.User)) {
			local.User = new("User");
		}
		return local.User;
	}

	/**
	 * I return a user matching an email address
	 */
	User function getUserByEmail(required User theUser) {
		local.User = ORMExecuteQuery("from User where email = :email", {email = arguments.theUser.getEmail()}, true);
		if (IsNull(User)) {
			local.User = new("User");
		}
		return local.User;
	}

	/**
	 * I return an array of users
	 */
	array function getUsers() {
		return EntityLoad("User", {}, "name");
	}

	/**
	 * I return a new user
	 */
	User function newUser() {
		return new("User");
	}

	/**
	 * I save a user
	 */
	User function saveUser(required User theUser) {
		return save(arguments.theUser);
	}

}
