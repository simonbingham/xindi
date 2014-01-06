component accessors="true" extends="model.abstract.BaseService" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="NotificationService" getter="false";
	property name="UserGateway" getter="false";
	property name="UserService" getter="false";
	property name="Validator" getter="false";
	property name="config" getter="false";

	variables.userkey = "userid";

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I delete the current user from the session
	 */
	struct function deleteCurrentUser() {
		var result = variables.Validator.newResult();
		if(hasCurrentUser()) {
			StructDelete(getCurrentStorage(), variables.userkey);
			result.setSuccessMessage("You have been logged out.");
		}else{
			result.setErrorMessage("You are not logged in.");
		}
		return result;
	}

	/**
	 * I return the current storage mechanism
	 */
	function getCurrentStorage() {
		return session;
	}

	function getCurrentUser() {
		if(hasCurrentUser()) {
			var map = getCurrentStorage();
			var userkey = map[variables.userkey];
			return variables.UserGateway.getUser(userkey);
		}
	}

	/**
	 * I return true if the session has a user
	 */
	boolean function hasCurrentUser() {
		return StructKeyExists(getCurrentStorage(), variables.userkey);
	}

	/**
	 * I return true if the user is permitted access to a FW/1 action
	 */
	boolean function isAllowed(required string action, string whitelist) {
		param name="arguments.whitelist" default=variables.config.security.whitelist;
		// user is not logged in
		if(!hasCurrentUser()) {
			// if the requested action is in the whitelist allow access
			for (var unsecured in ListToArray(arguments.whitelist)) {
				if(ReFindNoCase(unsecured, arguments.action)) return true;
			}
		// user is logged in so allow access to requested action
		}else if(hasCurrentUser()) {
			return true;
		}
		// previous conditions not met so deny access to requested action
		return false;
	}

	/**
	 * I verify and login a user
	 */
	struct function loginUser(required struct properties) {
		param name="arguments.properties.email" default="";
		param name="arguments.properties.password" default="";
		var User = variables.UserGateway.newUser();
		populate(User, arguments.properties);
		var result = variables.Validator.validate(theObject=User, context="login");
		User = variables.UserGateway.getUserByCredentials(User);
		if(User.isPersisted()) {
			setCurrentUser(User);
			result.setSuccessMessage("Welcome #User.getName()#. You have been logged in.");
		}else{
			var message = "Sorry, your login details have not been recognised.";
			result.setErrorMessage(message);
			var failure = {propertyName="email", clientFieldname="email", message=message};
			result.addFailure(failure);
		}
		return result;
	}

	/**
	 * I reset the password of a user and send a notification email
	 */
	struct function resetPassword(required struct properties, required string name, required struct config, required string emailtemplatepath) {
		transaction{
			param name="arguments.properties.email" default="";
			var User = variables.UserGateway.newUser();
			populate(User, arguments.properties);
			var result = variables.Validator.validate(theObject=User, context="password");
			User = variables.UserGateway.getUserByEmail(User);
			if(User.isPersisted()) {
				var password = variables.UserService.newPassword();
				User.setPassword(password);
				savecontent variable="emailtemplate" {include arguments.emailtemplatepath;}
				variables.NotificationService.send(arguments.config.resetpasswordemailsubject, User.getEmail(), arguments.config.resetpasswordemailfrom, emailtemplate);
				result.setSuccessMessage("A new password has been sent to #User.getEmail()#.");
			}else{
				var message = "Sorry, your email address has not been recognised.";
				result.setErrorMessage(message);
				var failure = {propertyName="email", clientFieldname="email", message=message};
				result.addFailure(failure);
			}
		}
		return result;
	}

	/**
	 * I add a user to the session
	 */
	void function setCurrentUser(required any User) {
		getCurrentStorage()[variables.userkey] = arguments.User.getUserID();
	}

}
