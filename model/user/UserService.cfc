/**
 * I am the user service component.
 */
component accessors="true" extends="model.abstract.BaseService" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="UserGateway" getter="false";
	property name="Validator" getter="false";

	// ------------------------ CONSTANTS ------------------------ //

	variables.PASSWORD_LENGTH = 8;

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I delete a user
	 */
	struct function deleteUser(required numeric userId) {
		transaction{
			local.User = variables.UserGateway.getUser(userId = Val(arguments.userId));
			local.result = variables.Validator.newResult();
			if (local.User.isPersisted()) {
				variables.UserGateway.deleteUser(theUser = local.User);
				local.result.setSuccessMessage("The user &quot;#local.User.getName()#&quot; has been deleted.");
			} else {
				local.result.setErrorMessage("The user could not be deleted.");
			}
		}
		return local.result;
	}

	/**
	 * I return a user matching an id
	 */
	User function getUser(required numeric userId) {
		return variables.UserGateway.getUser(userId = Val(arguments.userId));
	}

	/**
	 * I return a user matching an email address and password
	 */
	User function getUserByCredentials(required User theUser) {
		return variables.UserGateway.getUserByCredentials(theUser = arguments.theUser);
	}

	/**
	 * I return a user matching an email address
	 */
	User function getUserByEmail(required User theUser) {
		return variables.UserGateway.getUserByEmail(theUser = arguments.theUser);
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
		return Left(CreateUUId(), variables.PASSWORD_LENGTH);
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
			local.args = Duplicate(arguments);
			param name = "local.args.properties.userId" default = 0;
			local.User = variables.UserGateway.getUser(userId = Val(local.args.properties.userId));
			populate(Entity = local.User, memento = local.args.properties);
			local.result = variables.Validator.validate(theObject = local.User, context = local.args.context);
			if (!result.hasErrors()) {
				local.result.setSuccessMessage("The user &quot;#local.User.getName()#&quot; has been saved.");
				variables.UserGateway.saveUser(theUser = local.User);
			} else {
				local.result.setErrorMessage("The user could not be saved. Please amend the highlighted fields.");
			}
		}
		return local.result;
	}

}
