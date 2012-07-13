{"validateThis" : {
	"conditions" : [
		{"name":"MustLikeSomething",
			"serverTest":"getLikeCheese() EQ 0 AND getLikeChocolate() EQ 0",
			"clientTest":"$(&quot;[name='LikeCheese']&quot;).getValue() == 0 &amp;&amp; $(&quot;[name='LikeChocolate']&quot;).getValue() == 0;"
		}
	],

	"contexts" : [
		{"name":"Register","formName":"frmRegister"},
		{"name":"Profile","formName":"frmProfile"}
	],

	"objectProperties" : [
		{"name":"UserName","desc":"Email Address",
			"rules": [
				{"type":"required","contexts":"*"},
				{"type":"email","contexts":"*","failureMessage":"Hey, buddy, you call that an Email Address?"}
			]
		},
		{"name":"Nickname",
			"rules" : [
				{"type":"custom","failureMessage":"That Nickname is already taken. Please try another",
					"params":[
						{"name":"methodName","value":"CheckDupNickname"},
						{"name":"remoteURL","value":"CheckDupNickname.cfm"}
					]
				}
			]
		},
		{"name":"UserPass","desc":"Password",
			"rules" : [
				{"type":"required","contexts":"*"},
				{"type":"rangelength","contexts":"*",
					"params" : [
						{"name":"minlength","value":"5"},
						{"name":"maxlength","value":"10"}
					]
				}
			]
		},
		{"name":"VerifyPassword","desc":"Verify Password",
			"rules" : [
				{"type":"required","contexts":"*"},
				{"type":"equalTo","contexts":"*",
					"params" : [
						{"name":"ComparePropertyName","value":"UserPass"}
					]
				}
			]
		},
		{"name":"UserGroup","desc":"User Group","clientFieldName":"UserGroupID",
			"rules" : [
				{"type":"required","contexts":"*"}
			]
		},
		{"name":"Salutation",
			"rules" : [
				{"type":"required","contexts":"Profile"},
				{"type":"regex","contexts":"*","failureMessage":"Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.",
					"params" : [
						{"name":"Regex","value":"^(Dr|Prof|Mr|Mrs|Ms|Miss)(\\.)?$"}
					]
				}
			]
		},
		{"name":"FirstName","desc":"First Name",
			"rules" : [
				{"type":"required","contexts":"Profile"}
			]
		},
		{"name":"LastName","desc":"Last Name",
			"rules" : [
				{"type":"required","contexts":"Profile"},
				{"type":"required","contexts":"Register",
					"params" : [
						{"name":"DependentPropertyName","value":"FirstName"}
					]
				}
			]
		},
		{"name":"LikeOther","desc":"What do you like?",
			"rules" : [
				{"type":"required","contexts":"*","condition":"MustLikeSomething","failureMessage":"If you don't like cheese and you don't like chocolate, you must like something!"}
			]
		},
		{"name":"HowMuch","desc":"How much money would you like?",
			"rules" : [
				{"type":"numeric", "contexts":"*"}
			]
		},
		{"name":"CommunicationMethod","desc":"Communication Method",
			"rules" : [
				{"type":"required","contexts":"*","failureMessage":"if you are allowing communication, you must choose a method",
					"params" : [
						{"name":"DependentPropertyName","value":"AllowCommunication"},
						{"name":"DependentPropertyValue","value":"1"}
					]
				}
			]
		}
	]
}
}