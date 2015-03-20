component {

	remote any function logClientSideError(required string message, required string url, required numeric lineNumber) {
		if (StructKeyExists(application, "exceptionTracker")) {
			// Hoth expects a struct with the following keys
			local.exception = {
				detail = "[#arguments.url# (#arguments.lineNumber#)] #arguments.message#",
				type = "clientside",
				tagContext = "[#arguments.url# (#arguments.lineNumber#)]",
				// stack is used to identify unique errors so include lots of info!
				stackTrace = SerializeJSON(arguments),
				message = arguments.message
			};
			application.exceptionTracker.track(local.exception);
			return true;
		}
		return false;
	}

}
