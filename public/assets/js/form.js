
//set the browser setting for the local and session storage amplify type to use
var localStorageType = 'localStorage';

$(document).ready(function() {
    if (testStorage()) {
        //load in old data
        setTimeout(function() {
		    loadData();
		}, 2000);

        setTimeout(function() {
		    //store every 10 seconds
       		window.setInterval(saveData, 10 * 1000);
		}, 5000);

       
        //clear on submit
         $("#customForm").submit(function() {
         	clearData();
         });

    }
    
});

function testStorage () {
	try {
		amplify.store('test-key','test-value');
		if (amplify.store('test-key') == 'test-value'){
			//alert('default storage');
			return true;
		}
	} catch (e) {
			amplify.store.memory('test-key','test-value');
			if (amplify.store.memory('test-key') == 'test-value'){
				localStorageType = 'memory';
				//alert('in-memory storage');
				return true;
			}
		} 
	return false;
}

function loadData() {
	$('input, select, textarea', '#customForm').each(
	    function() {
	        var id = $(this).attr('id');
	        var inputtype = $(this).attr('type');
	        var newVal = retrieveObject(id);
	        if (newVal.length) {
	        	if (typeof inputtype !== "undefined" && (inputtype === 'radio' || inputtype === 'checkbox') ) {
	        		$(this).attr("checked", "checked");
	        	} else {
	        		$(this).val( newVal );
	        	}
	        	
	        }
	        
	    }
	);
}

function saveData() {
	$('input[type=text], input[type=checkbox]:checked, input[type=radio]:checked, select, textarea', '#customForm').each(
	    function() {
	        var id = $(this).attr('id');
	        var val = $(this).val();
	        storeObject(id, val);
	    }
	); 
	$('input[type=checkbox]:not(:checked), input[type=radio]:not(:checked)', '#customForm').each(
	    function() {
	        var id = $(this).attr('id');
	        removeObject(id);
	    }
	); 
}

function clearData() {
	$('input[type=text], input[type=checkbox]:checked, input[type=radio]:checked, select, textarea', '#customForm').each(
	    function() {
	        var id = $(this).attr('id');
	        removeObject(id);
	    }
	);
}

//global function for storing the data in local storage
function storeObject(key,obj) {
	if ( typeof obj !== 'undefined' && obj !== null ) {
		var storeObj = {data:obj, timestamp: new Date().getTime()};
		amplify.store[localStorageType](key, storeObj);
	}
}

//global function to retrieve data stored in local storage
function retrieveObject(key) {
	// set this date when the database information has changed and we need to force an update of the client-stored data
	var expireDate = new Date("November 5, 2013");
	var obj = amplify.store[localStorageType](key);
	if (typeof obj === 'undefined' || obj === null) {
		return '';
	} else if ( obj.length === 0 ){
		return '';
	} else {
		//check the date to see if we need to expire the data
		var storeDate = obj.timestamp;
		if (typeof storeDate !== 'undefined' && storeDate !== null && storeDate >= expireDate) {
			return obj.data;
		} else return '';
	}
}

function removeObject(key) {
	amplify.store[localStorageType](key, null);
}
