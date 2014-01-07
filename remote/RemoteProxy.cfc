component {

	remote any function logClientSideError(message, url, linenumber) {
		if (StructKeyExists(application, "exceptiontracker")) {
			// Hoth expects a struct with the following keys
			var exception = {
				detail = "[#arguments.url# (#arguments.linenumber#)] #arguments.message#",
				type = "clientside",
				tagContext = "[#arguments.url# (#arguments.linenumber#)]",
				// stack is used to identify unique errors so include lots of info!
				StackTrace = SerializeJSON(arguments),
				Message = arguments.message
			};
			application.exceptiontracker.track(exception);
			return true;
		}
		return false;
	}

}
