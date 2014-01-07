component extends="ValidateThis.util.Result" {

	/**
	 * I initialise this component
	 */
	function init(required any Translator, required struct ValidateThisConfig) {
		variables.messagetype = "";
		variables.message = "";
		return super.init(argumentCollection=arguments);
	}

	/**
	 * I return a message
	 */
	string function getMessage() {
		if(Len(super.getSuccessMessage()) != 0) return getSuccessMessage();
		return variables.message;
	}

	/**
	 * I return a message type
	 */
	string function getMessageType() {
		return variables.messagetype;

	}

	/**
	 * I return true if a message exists
	 */
	boolean function hasMessage() {
		return Len(Trim(getMessage())) != 0;
	}

	/**
	 * I set an error message
	 */
	void function setErrorMessage(required string message) {
		super.setIsSuccess(false);
		variables.message = arguments.message;
		variables.messagetype = "error";
	}

	/**
	 * I set an information message
	 */
	void function setInfoMessage(required string message) {
		variables.message = arguments.message;
		variables.messagetype = "info";
	}

	/**
	 * I set a success message
	 */
	void function setSuccessMessage(required string message) {
		super.setIsSuccess(true);
		super.setSuccessMessage(arguments.message);
		variables.messagetype = "success";
	}

	/**
	 * I set a warning message
	 */
	void function setWarningMessage(required string message) {
		variables.message = arguments.message;
		variables.messagetype = "warning";
	}

}
