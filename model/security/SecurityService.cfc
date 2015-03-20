/**
 * I am the security service component.
 */
component accessors = true extends = "model.abstract.BaseService" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name = "NotificationService" getter = false;
	property name = "UserGateway" getter = false;
	property name = "UserService" getter = false;
	property name = "Validator" getter = false;
	property name = "config" getter = false;

	// ------------------------ CONSTANTS ------------------------ //

	variables.USER_KEY = "userid";

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I delete the current user from the session
	 */
	struct function deleteCurrentUser() {
		local.result = variables.Validator.newResult();
		if (hasCurrentUser()) {
			StructDelete(getCurrentStorage(), variables.USER_KEY);
			local.result.setSuccessMessage("You have been logged out.");
		} else {
			local.result.setErrorMessage("You are not logged in.");
		}
		return local.result;
	}

	/**
	 * I return the current storage mechanism
	 */
	function getCurrentStorage() {
		return session;
	}

	function getCurrentUser() {
		if (hasCurrentUser()) {
			local.map = getCurrentStorage();
			local.userKey = local.map[variables.USER_KEY];
			return variables.UserGateway.getUser(userId = local.userKey);
		}
	}

	/**
	 * I return true if the session has a user
	 */
	boolean function hasCurrentUser() {
		return StructKeyExists(getCurrentStorage(), variables.USER_KEY);
	}

	/**
	 * I return true if the user is permitted access to a FW/1 action
	 */
	boolean function isAllowed(required string action, string whiteList) {
		local.args = Duplicate(arguments);
		param name = "local.args.whiteList" default = variables.config.security.whiteList;
		// user is not logged in
		if (!hasCurrentUser()) {
			// if the requested action is in the whitelist allow access
			for (local.unsecured in ListToArray(local.args.whiteList)) {
				if (ReFindNoCase(local.unsecured, local.args.action)) {
					return true;
				}
			}
		// user is logged in so allow access to requested action
		} else if (hasCurrentUser()) {
			return true;
		}
		// previous conditions not met so deny access to requested action
		return false;
	}

	/**
	 * I verify and login a user
	 */
	struct function loginUser(required struct properties) {
		local.args = Duplicate(arguments);
		param name = "local.args.properties.email" default = "";
		param name = "local.args.properties.password" default = "";
		local.User = variables.UserGateway.newUser();
		populate(Entity = local.User, memento = local.args.properties);
		local.result = variables.Validator.validate(theObject = local.User, context = "login");
		local.User = variables.UserGateway.getUserByCredentials(theUser = local.User);
		if (local.User.isPersisted()) {
			setCurrentUser(local.User);
			local.result.setSuccessMessage("Welcome #local.User.getName()#. You have been logged in.");
		} else {
			local.message = "Sorry, your login details have not been recognised.";
			local.result.setErrorMessage(local.message);
			local.failure = {
				propertyName = "email",
				clientFieldname = "email",
				message = local.message
			};
			local.result.addFailure(local.failure);
		}
		return local.result;
	}

	/**
	 * I reset the password of a user and send a notification email
	 */
	struct function resetPassword(required struct properties, required string name, required struct config, required string emailTemplatePath) {
		transaction {
			param name = "arguments.properties.email" default = "";
			local.User = variables.UserGateway.newUser();
			populate(Entity = local.User, memento = arguments.properties);
			local.result = variables.Validator.validate(theObject = local.User, context = "password");
			local.User = variables.UserGateway.getUserByEmail(theUser = local.User);
			if (local.User.isPersisted()) {
				local.password = variables.UserService.newPassword();
				local.User.setPassword(local.password);
				savecontent variable = "local.emailTemplatePath" {include arguments.emailTemplatePath;}
				variables.NotificationService.send(subject = arguments.config.resetPasswordEmailSubject, to = local.User.getEmail(), from = arguments.config.resetPasswordEmailFrom, body = local.emailTemplatePath);
				local.result.setSuccessMessage("A new password has been sent to #local.User.getEmail()#.");
			} else {
				local.message = "Sorry, your email address has not been recognised.";
				local.result.setErrorMessage(local.message);
				local.failure = {
					propertyName = "email",
					clientFieldname = "email",
					message = local.message
				};
				result.addFailure(local.failure);
			}
		}
		return local.result;
	}

	/**
	 * I add a user to the session
	 */
	void function setCurrentUser(required any User) {
		getCurrentStorage()[variables.USER_KEY] = arguments.User.getUserId();
	}

}
