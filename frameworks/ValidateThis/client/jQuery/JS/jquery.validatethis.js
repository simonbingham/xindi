/*
 * WIP jQuery.validatethis.js plug-in for ValidateThis 0.98.3+
 * Created 2011 Adam Drew
 *
 */

// closure for plugin
(function($){
	
	Object.size = function(obj) {
		var size = 0, key;
		for (key in obj) {
			if (obj.hasOwnProperty(key)) size++;
		}
		return size;
	};

	$.validatethis = {
		version: '0.98.2',
		ruleCache: [], // associatve array for client side rule caching
		Conditions: [],
		
		// Settings
		settings: {}, 
		
		defaults: {
			debug:				false,
			initialized:		false,
			remoteEnabled:		false,
			baseURL: 			'',
			appMapping:			'',
			ajaxProxyURL:		'/remote/validatethisproxy.cfc?method=',
			ignoreClass:		".ignore",
			errorClass:			'ui-state-error'
		},
		
		result: {
			isSuccess:true,
			errors:[]
		},
		
		init : function(options){
			if (!this.settings.initialized){
				this.session = {};
				
				this.log("ValidateThis [plugin]: initializing v" + this.version);
				
				// Log Options For Debugging
				this.log("ValidateThis [options]: " + $.param(options));
				
				var extendedDefaultOptions = $.extend({}, this.defaults, options);
				
				this.settings = extendedDefaultOptions;

				// See: : /validatethis/extras/coldbox/remote/validatethisproxy.cfc
				this.remoteCall("getValidationVersion",{},this.getVersionCallback);
				$.validatethis.remoteCall("getInitializationScript",{format:"json"},
						function(data){
							$.validatethis.evalInitScript(data);
						}
				);
				
				this.setValidatorDefaults();
				this.settings.initialized = true;
				
			} else {
				this.log("ValidateThis [plugin]: initialized ");
			}
		},
		
		setValidatorDefaults: function(){
			$.validator.setDefaults({
				errorClass: $.validatethis.settings.errorClass,
				errorElement: 'span',
				errorPlacement: function(error, element) { error.appendTo( element.parent("div"))}
			});
		},
		
		clearFormRules: function(form){
			form.find(":input").each(function(input){
				$(input).rules("remove");
			});
		},
		
		remoteCall: function(action, arguments, callback){
			this.log("ValidateThis [remote]: " + action + " " + $.param(arguments));
			$.get(this.settings.ajaxProxyURL + action + "&" + $.param(arguments), callback);
		},

		submitHandler: function(form) {
			$.validatethis.log("ValidateThis [form]: submitHandler form " + $(form).attr("name"));
			if ($.validatethis.settings.remoteEnabled){
				$(form).ajaxSubmit({success:$.validatethis.ajaxSubmitSuccessCallback});
			} else {
				form.submit();
			}
		},

		ajaxSubmitSuccessCallback: function(data){
			$.validatethis.log("ValidateThis [remote]: Submit Success - " + $.param(data));
		},

		evaluateCondition: function(element){
			// return true by default
			var result = true;
			
			if ( $(element).data("depends") ){
				var key = $(element).data("depends");
				var formID = $(element).parents().find("form:first").attr("id");
				var clientTest= $.validatethis.Conditions[formID][key];
				result = eval(clientTest);
				this.log("ValidateThis [condition] : Evaluated {" + key + " = " + result + ", " + formID + "}" );
			} 
			return result;
		},

		prepareConditions: function(form,data){
			var formID = form.attr('id');
			
			// Cache form conditions
			for (var key in data) {
			   if (key == "conditions"){
					var obj = data[key];
					for (var condition in obj){
						var clientTest = obj[condition];
						if (!$.validatethis.Conditions[formID]){
							$.validatethis.Conditions[formID] = {};
						}
						$.validatethis.Conditions[formID][condition] = clientTest;
					}
			   }
			}
			
			// Set the element's data "depends" key and the rule.[depends] evluateCondition(element) function 
			for (var key in data) {
			   if (key == "rules"){
					var obj = data[key];
					for (var property in obj){
						var rules = obj[property];
						$(rules).each(function(){
							for (var item in this){
								if (this[item].depends){
									//alert(this[item].depends);
									var key = this[item].depends;
									$(":input[name='" + property + "']",form).data("depends",key);
									this[item].depends = function (element) { return $.validatethis.evaluateCondition(element) };
								}
							}
						});
					}
			   }
			}
			
			return data;
		},
		
		loadRules: function(form,data){
			$.validatethis.log("ValidateThis [loadRules]: " + form.attr('name'));
			
			var validations = this.prepareConditions(form,$.parseJSON(data));
			var cacheItem = {key: form.attr('id'), value: validations};
			this.ruleCache.push(cacheItem);
			
			form.validate({
				debug: false,
				ignore: $.validatethis.settings.ignoreClass,
				submitHandler: $.validatethis.submitHandler,
				rules: validations.rules,
				messages: validations.messages
			});
			
			$.validatethis.log("ValidateThis [status]: ready.");
		},
		
		evalInitScript : function(data){
			var dataEl = $(data);
			eval(dataEl.html());
		},
		
		getVersionCallback: function(data){
			$.validatethis.settings.remoteEnabled = true;
			$.validatethis.log("ValidateThis [remote]: v" + data);
		},

		log: function(message){
			if (this.settings.debug && window.console) {
				if (console.debug){
					console.debug(message);
				} else if (console.log){
					console.log(message);
				}
			}
			else {
				// log to some other mechanism here (alert? ajax? ui?)
				// alert(message);
			};
		}
	};

	// Plugin Methods
	$.fn.validatethis = function(options){	
		// iterate and reformat each matched element
		var opts = $.extend({}, $.validatethis.settings, options);
		return this.each(function(){
			// build element specific options
			var o = $.meta ? $.extend({}, opts, $this.data()) : opts;
				$.validatethis.init(o);	
				// Initialize Validate Plugin
				$(this).find("form").each(function(){
					var $form = $(this);
					$.validatethis.log("ValidateThis [form]: " + $form.attr('name'));
					$.validatethis.remoteCall("getValidationJSON",{"objectType":$form.attr('rel'),"formName":$form.attr('id'),"locale":"","context":$form.attr('id')},
						function(data){
							$.validatethis.loadRules($form,data);
						}
					);
				});
		});
	};

// end of closure
})(jQuery);