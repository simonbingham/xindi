component accessors="true" {

	/**
	 * I send an email
	 */
	void function send(required string subject, required string to, required string from, required string body, string type="html") {
		var Email = new mail();
		Email.setSubject(arguments.subject);
		Email.setTo(arguments.to);
		Email.setFrom(arguments.from);
		Email.setBody(arguments.body);
		Email.setType(arguments.type);
		Email.send();
	}

}
