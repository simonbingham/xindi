/**
 * I am the notification service component.
 */
component accessors="true" {

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I send an email
	 */
	void function send(required string subject, required string to, required string from, required string body, string type = "html") {
		local.emailService = new mail();
		local.emailService.setSubject(arguments.subject);
		local.emailService.setTo(arguments.to);
		local.emailService.setFrom(arguments.from);
		local.emailService.setBody(arguments.body);
		local.emailService.setType(arguments.type);
		local.emailService.send();
	}

}
