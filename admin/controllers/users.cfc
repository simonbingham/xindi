component accessors="true" extends="abstract" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="UserService" setter="true" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //

	void function default(required struct rc) {
		rc.users = variables.UserService.getUsers();
	}

	void function delete(required struct rc) {
		param name="rc.userid" default="0";
		rc.result = variables.UserService.deleteUser(rc.userid);
		variables.fw.redirect("users", "result");
	}

	void function maintain(required struct rc) {
		param name="rc.userid" default="0";
		param name="rc.context" default="create";
		if(!StructKeyExists(rc, "User")) rc.User = variables.UserService.getUser(rc.userid);
		if(rc.User.isPersisted()) rc.context = "update";
		rc.Validator = variables.UserService.getValidator(rc.User);
		if(!StructKeyExists(rc, "result")) rc.result = rc.Validator.newResult();
	}

	void function save(required struct rc) {
		param name="rc.userid" default="0";
		param name="rc.name" default="";
		param name="rc.email" default="";
		param name="rc.password" default="";
		param name="rc.context" default="create";
		param name="rc.submit" default="Save & exit";
		rc.result = variables.UserService.saveUser(rc, rc.context);
		rc.User = rc.result.getTheObject();
		if(rc.result.getIsSuccess()) {
			if(rc.submit == "Save & Continue") variables.fw.redirect("users.maintain", "result,User", "userid");
			else variables.fw.redirect("users", "result");
		}else{
			variables.fw.redirect("users.maintain", "result,User", "userid");
		}
	}

}
