/*
	Xindi - http://www.getxindi.com/
	
	Copyright (c) 2012, Simon Bingham
	
	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, 
	modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
	is furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

component {

	remote any function logClientSideError( message, url, linenumber ) {
		if ( StructKeyExists( application, "exceptiontracker" ) ) {
			// Hoth expects a struct with the following keys
			var exception = {
				detail = "[#arguments.url# (#arguments.linenumber#)] #arguments.message#",
				type = "clientside",
				tagContext = "[#arguments.url# (#arguments.linenumber#)]",
				// stack is used to identify unique errors so include lots of info!
				StackTrace = SerializeJSON( arguments ),
				Message = arguments.message
			};
			application.exceptiontracker.track( exception );
			return true;
		}
		return false;
	}
	
}