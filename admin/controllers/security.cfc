component accessors = true {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name = "SecurityService" setter = true getter = false;
	property name = "UserService" setter = true getter = false;

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function init(required any fw) {
		variables.fw = arguments.fw;
	}

	void function default(required struct rc) {
		rc.loggedin = variables.SecurityService.hasCurrentUser();
		if (rc.loggedIn) {
			variables.fw.redirect("main");
		} else {
			rc.User = variables.UserService.newUser();
			rc.Validator = variables.UserService.getValidator(Entity = rc.User);
			if (!StructKeyExists(rc, "result")) {
				rc.result = rc.Validator.newResult();
			}
		}
	}

	void function login(required struct rc) {
		param name = "rc.email" default = "";
		param name = "rc.password" default = "";
		rc.result = variables.SecurityService.loginUser(properties = rc);
		if (rc.result.getIsSuccess()) {
			variables.fw.redirect("main", "result");
		} else {
			variables.fw.redirect("security", "result");
		}
	}

	void function logout(required struct rc) {
		rc.result = variables.SecurityService.deleteCurrentUser();
		variables.fw.redirect("security", "result");
	}

	void function password(required struct rc) {
		rc.User = variables.UserService.newUser();
		rc.Validator = variables.UserService.getValidator(Entity = rc.User);
		if (!StructKeyExists(rc, "result")) {
			rc.result = rc.Validator.newResult();
		}
	}

	void function resetpassword(required struct rc) {
		param name = "rc.email" default = "";
		rc.result = variables.SecurityService.resetPassword(properties = rc, name = rc.config.name, config = rc.config.security, emailTemplatePath = "../../admin/views/security/email.cfm");
		variables.fw.redirect("security.password", "result");
	}

}
