component accessors="true" extends="model.abstract.BaseService" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="UserGateway" getter="false";
	property name="Validator" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I delete a user
	 */
	struct function deleteUser(required userid) {
		transaction{
			var User = variables.UserGateway.getUser(Val(arguments.userid));
			var result = variables.Validator.newResult();
			if(User.isPersisted()) {
				variables.UserGateway.deleteUser(User);
				result.setSuccessMessage("The user &quot;#User.getName()#&quot; has been deleted.");
			}else{
				result.setErrorMessage("The user could not be deleted.");
			}
		}
		return result;
	}

	/**
	 * I return a user matching an id
	 */
	User function getUser(required userid) {
		return variables.UserGateway.getUser(Val(arguments.userid));
	}

	/**
	 * I return a user matching an email address and password
	 */
	User function getUserByCredentials(required User theUser) {
		return variables.UserGateway.getUserByCredentials(theUser);
	}

	/**
	 * I return a user matching an email address
	 */
	User function getUserByEmail(required User theUser) {
		return variables.UserGateway.getUserByEmail(theUser);
	}

	/**
	 * I return an array of users
	 */
	array function getUsers() {
		return variables.UserGateway.getUsers();
	}

	/**
	 * I return a new password
	 */
	string function newPassword() {
		return Left(CreateUUID(), 8);
	}

	/**
	 * I return a new user
	 */
	User function newUser() {
		return variables.UserGateway.newUser();
	}

	/**
	 * I validate and save a user
	 */
	struct function saveUser(required struct properties, required string context) {
		transaction{
			param name="arguments.properties.userid" default="0";
			var User = variables.UserGateway.getUser(Val(arguments.properties.userid));
			populate(User, arguments.properties);
			var result = variables.Validator.validate(theObject=User, context=arguments.context);
			if(!result.hasErrors()) {
				result.setSuccessMessage("The user &quot;#User.getName()#&quot; has been saved.");
				variables.UserGateway.saveUser(User);
			}else{
				result.setErrorMessage("The user could not be saved. Please amend the highlighted fields.");
			}
		}
		return result;
	}

}
