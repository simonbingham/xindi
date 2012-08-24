<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfset ValidateThis = createObject("component","ValidateThis.ValidateThis").init()>
<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>QUnit Test Suite</title>
	<link rel="stylesheet" href="qunit/qunit.css" type="text/css" media="screen">
	<script type="text/javascript" src="qunit/qunit.js"></script>
	<!-- Your project file goes here -->
	#ValidateThis.getInitializationScript()#
	<script type="text/javascript">
	jQuery(function($) {
		/* --------------- HELPER METHODS --------------- */
		function methodTest( methodName ) {
			var v = $("##form").validate();
			var method = $.validator.methods[methodName];
			var element = $("##firstname")[0];
			return function(value, param) {
				element.value = value;
				return method.call( v, value, element, param );
			};
		}
		
		function testedvalue( pass, v ) {
			var result = pass ? '':'NOT '; 
			return result + v.toString() + ' [' + typeof v + ']';
		}

		/* --------------- START TESTS --------------- */
		test("boolean", function() {
			var method = methodTest("boolean");
			var shouldPass = ['',1,0,'1','0',true,false,'true','false',10,'10','yes','no','Yes','No','YES','NO'];
			var shouldFail = ['abc123',{},[]];
			
			//should pass
			jQuery.each(shouldPass,function(index,value){
				ok( method( value ), testedvalue(true,value) );
			});
			
			//should fail
			jQuery.each(shouldFail,function(index,value){
				ok( !method( value ), testedvalue(false,value) );
			});
			
		});
		
		test("DoesNotContainOtherProperties", function() {
			var v = jQuery("##form").validate();
			var method = $.validator.methods["doesnotcontainotherproperties"], 
				param = ['firstname','lastname'],
				e = $("##password")[0];
				
			var shouldPass = ['','123abc','xyz','','123','abc'];
			var shouldFail = ['abc123','xx-abc123','xx-abc123-xx','abc123-xx'];

			//should fail
			$('##lastname, ##firstname').val('abc123');
			jQuery.each(shouldFail,function(index,value){
				ok( !method.call( v, value, e, param ), testedvalue(false,value) );
			});

			//should fail
			$('##lastname').val('');
			jQuery.each(shouldFail,function(index,value){
				ok( !method.call( v, value, e, param ), testedvalue(false,value) );
			});
			
			//should pass
			jQuery.each(shouldPass,function(index,value){
				ok( method.call( v, value, e, param ), testedvalue(false,value) );
			});			
		});
		
		test("equalTo", function() {
			var v = jQuery("##form").validate();
			var method = $.validator.methods.equalTo,
				e = $('##firstname, ##lastname');
			
			var shouldPass = ['','abc123'];
			var shouldFail = ['zzzzz'];

			
			jQuery.each(shouldPass,function(index,value){
				$('##lastname, ##firstname').val(value);
				ok( method.call( v, value, e[0], "##firstname"), testedvalue(true,value) );
			});
			jQuery.each(shouldFail,function(index,value){
				ok( !method.call( v, value, e[1], "##lastname"), testedvalue(false,value) );
			});

		});
		
		test("false", function() {
			var method = methodTest("false");
			var shouldPass = ['','false','0',false,0];
			var shouldFail = ['true','1',true,1,'vt rocks'];
			
			jQuery.each(shouldPass,function(index,value){
				ok( method(value), testedvalue(true,value));
			});
			jQuery.each(shouldFail,function(index,value){
				ok( !method(value), testedvalue(false,value));
			});
		});
		
		test("true", function() {
			var method = methodTest("true");
			var shouldPass = ['','true','1',true,1];
			var shouldFail = ['false','0',false,0,'vt rocks'];
			
			jQuery.each(shouldPass,function(index,value){
				ok( method(value), testedvalue(true,value));
			});
			jQuery.each(shouldFail,function(index,value){
				ok( !method(value), testedvalue(false,value));
			});
		});
		
		
		
		test("minpatternsmatch", function() {
			var v = jQuery("##form").validate();
			var method = $.validator.methods["minpatternsmatch"]; 
			var param = {
				minMatches:3,
				pattern_lowerCaseLetter:"[a-z]",
				pattern_upperCaseLetter:"[A-Z]",
				pattern_digits:"[0-9]"
			};
			
			var e = $("##firstname")[0];
			
			var shouldPass = ['',"abc123XYZ","a1A","!A}1¬a+"];
			var shouldFail = ["ABC123XYZ","abc123xyz","abcXYZ","!A}1~A+"];
			
			jQuery.each(shouldPass,function(index,value){
				ok( method.call( v, value, e, param ), testedvalue(true,value) );
			});
			jQuery.each(shouldFail,function(index,value){
				ok( !method.call( v, value, e, param ), testedvalue(false,value) );
			});
			
			
			param = {
				minMatches:2,
				pattern_lowerCaseLetter:"[a-z]",
				pattern_upperCaseLetter:"[A-Z]",
				pattern_digits:"[0-9]"
			};
			shouldPass = ['',"abc123XYZ","a1A","!A}1¬a+","ABC123XYZ","abc123xyz","abcXYZ","!A}1~A+","aA","a1"];
			shouldFail = ["a","1","aa","AA","10"];
			
			jQuery.each(shouldPass,function(index,value){
				ok( method.call( v, value, e, param ), testedvalue(true,value) );
			});
			jQuery.each(shouldFail,function(index,value){
				ok( !method.call( v, value, e, param ), testedvalue(false,value) );
			});
			
		});
		
		test("nohtml", function() {
			var method = methodTest("nohtml");
			var shouldPass = ['',"a","a few words","10 < 1","1 > 10","what if there's only a closing tag />","</","/>"];
			var shouldFail = ["<p>","<p />","<p/>","<tag with='attributes'>test</tag>",'<tag with="attributes">',"some words with an <a>embedded","some words with an <a>embedded</a>","<notARealTag>","<notARealTag />","<p>Tag at the beginning","Tag at the end<p>"];
			
			jQuery.each(shouldPass,function(index,value){
				ok( method(value), testedvalue(true,value));
			});
			jQuery.each(shouldFail,function(index,value){
				ok( !method(value), testedvalue(false,value));
			});
		});
		
		test("regex", function() {
			var v = jQuery("##form").validate();
			var method = $.validator.methods["regex"]; 
			var param = "^(Dr|Prof|Mr|Mrs|Ms|Miss)(\.)?$";
			var e = $("##firstname")[0];
			
			var shouldPass = ['',"Dr","Prof","Mr","Mrs","Ms","Miss","Dr.","Prof.","Mr.","Mrs.","Ms.","Miss."];
			var shouldFail = [" Miss","dr","prof","mr","mrs","ms","miss","dr.","prof.","mr.","mrs.","ms.","miss."];
			
			jQuery.each(shouldPass,function(index,value){
				ok( method.call( v, value, e, param ), testedvalue(true,value) );
			});
			jQuery.each(shouldFail,function(index,value){
				ok( !method.call( v, value, e, param ), testedvalue(false,value) );
			});
		});
		
		test("notregex", function() {
			var v = jQuery("##form").validate();
			var method = $.validator.methods["notregex"]; 
			var param = "[,\.\*]+";
			var e = $("##firstname")[0];
			
			var shouldFail = ["abc,123","abc.123","abc*123"];
			var shouldPass = ["","abc123","abc-123","+-\/"];
			
			jQuery.each(shouldPass,function(index,value){
				ok( method.call( v, value, e, param ), testedvalue(true,value) );
			});
			jQuery.each(shouldFail,function(index,value){
				ok( !method.call( v, value, e, param ), testedvalue(false,value) );
			});
		});
				

		module("inlist");
		
		test("no delimiter,('milk,cookies,ice cream')", function() {
			var v = jQuery("##form").validate();
			var method = $.validator.methods["inlist"], 
				param = {list:"milk,cookies,ice cream"},
				e = $("##firstname")[0];
			var shouldPass = ['',"milk","cookies","ice cream"];
			var shouldFail = ["beer","burgers","cheese","chips","ice","cream"];
			
			jQuery.each(shouldPass,function(index,value){
				ok( method.call( v, value, e, param ), testedvalue(true,value) );
			});
			jQuery.each(shouldFail,function(index,value){
				ok( !method.call( v, value, e, param ), testedvalue(false,value) );
			});
		});
		
		test("',' delimiter,('milk,cookies,ice cream')", function(){
			// test again with delimiter
			var v = jQuery("##form").validate();
			var method = $.validator.methods["inlist"], param = {
				list: "milk,cookies,ice cream",
				delim: ','
			}, e = $("##firstname")[0];
			var shouldPass = ['',"milk", "cookies", "ice cream"];
			var shouldFail = ["beer", "burgers", "cheese", "chips", "ice", "cream"];
			
			jQuery.each(shouldPass, function(index, value){
				ok(method.call(v, value, e, param), testedvalue(true, value));
			});
			jQuery.each(shouldFail, function(index, value){
				ok(!method.call(v, value, e, param), testedvalue(false, value));
			});
		});
			
		test("'^' delimiter,('milk^cookies^ice cream')", function() {
			
			// test again with different delimiter
			var v = jQuery("##form").validate();
			var method = $.validator.methods["inlist"];
			
			var e = $("##firstname")[0];
			var shouldPass = ['',"milk", "cookies", "ice cream"];
			var shouldFail = ["beer", "burgers", "cheese", "chips", "ice", "cream"];
			
			var param = {list:"milk^cookies^ice cream",delim:'^'};
			
			jQuery.each(shouldPass,function(index,value){
				ok( method.call( v, value, e, param ), testedvalue(true,value) );
			});
			jQuery.each(shouldFail,function(index,value){
				ok( !method.call( v, value, e, param ), testedvalue(false,value) );
			});
		});
		
		
		module("notinlist");
		
		test("no delimiter,('milk,cookies,ice cream')", function() {
			var v = jQuery("##form").validate();
			var method = $.validator.methods["notinlist"], 
				param = {list:"milk,cookies,ice cream"},
				e = $("##firstname")[0];
			var shouldPass = ['',"beer","burgers","cheese","chips","cream","ice"];
			var shouldFail = ["milk","cookies","ice cream"];
				
			jQuery.each(shouldPass,function(index,value){
				ok( method.call( v, value, e, param ), testedvalue(true,value) );
			});
			jQuery.each(shouldFail,function(index,value){
				ok( !method.call( v, value, e, param ), testedvalue(false,value) );
			});
		});
		
		test("',' delimiter,('milk,cookies,ice cream')", function() {		
			// test again with delimiter
			var v = jQuery("##form").validate();
			var method = $.validator.methods["notinlist"], 
				param = {list:"milk,cookies,ice cream",delim:','},
				e = $("##firstname")[0];
				
			var shouldPass = ['',"beer","burgers","cheese","chips","cream","ice"];
			var shouldFail = ["milk","cookies","ice cream"];
			
			jQuery.each(shouldPass,function(index,value){
				ok( method.call( v, value, e, param ), testedvalue(true,value) );
			});
			jQuery.each(shouldFail,function(index,value){
				ok( !method.call( v, value, e, param ), testedvalue(false,value) );
			});
		});
		
		test("'^' delimiter,('milk^cookies^ice cream')", function() {	
			// test again with different delimiter
			var v = jQuery("##form").validate();
			var method = $.validator.methods["notinlist"], 
				param = {list:"milk^cookies^ice cream",delim:'^'},
				e = $("##firstname")[0];
				
			var shouldPass = ['',"beer","burgers","cheese","chips","cream","ice"];
			var shouldFail = ["milk","cookies","ice cream"];
			
			jQuery.each(shouldPass,function(index,value){
				ok( method.call( v, value, e, param ), testedvalue(true,value) );
			});
			jQuery.each(shouldFail,function(index,value){
				ok( !method.call( v, value, e, param ), testedvalue(false,value) );
			});
		});
		
		module("date validators");
		
		test("futuredate", function() {
			var v = jQuery("##form").validate();
			var method = $.validator.methods["futuredate"], 
				param = {},
				e = $("##firstname")[0];
			
			var today = new Date();
			var tomorrow = today.setDate(today.getDate()+1);
			var yesterday = today.setDate(today.getDate()-1);
			
			//should pass
			jQuery.each(['',new Date(2100,1,1),tomorrow],function(index,value){
				ok( method.call( v, value, e, param ), testedvalue(true,value) );
			});
			
			//should fail
			jQuery.each([new Date(2000,1,1),today,yesterday,'abc123'],function(index,value){
				ok( !method.call( v, value, e, param ), testedvalue(false,value) );
			});

			var v = jQuery("##form").validate();
			var method = $.validator.methods["futuredate"], 
				param = {after:tomorrow},
				e = $("##firstname")[0];
				
			//should pass
			jQuery.each('',[new Date(2100,1,1)],function(index,value){
				ok( method.call( v, value, e, param ), testedvalue(true,value) );
			});
			//should fail
			jQuery.each([new Date(2000,1,1),today,yesterday,tomorrow],function(index,value){
				ok( !method.call( v, value, e, param ), testedvalue(false,value) );
			});
		});
		
			
<cfset today = CreateDate(Year(Now()), Month(Now()), Day(Now()))>
<cfset tomorrow = DateAdd('d', 1, today)>
<cfset yesterday = DateAdd('d', -1, today)>
<cfset dayaftertomorrow = DateAdd('d', 2, today)>
		
		test("pastdate (no param)", function() {
			var v = jQuery("##form").validate();
			var method = $.validator.methods["pastdate"], 
				param = {},
				e = $("##firstname")[0];
		
			// NOTE: "31/12/1968" is an invalid date
			var shouldPass = ['','#DateFormat(yesterday, "yyyy/mm/dd")#',"12/29/1968","1/1/1969","1968/12/29","12/31/1968","December 31, 1968","12/31/68","1968/12/31"];
			var shouldFail = [new Date(2100,1,1),'#DateFormat(tomorrow, "yyyy/mm/dd")#','#DateFormat(today, "yyyy/mm/dd")#'];
			
			//should pass
			jQuery.each(shouldPass,function(index,value){
				ok( method.call( v, value, e, param ), testedvalue(true,value) );
			});
			
			//should fail
			jQuery.each(shouldFail,function(index,value){
				ok( !method.call( v, value, e, param ), testedvalue(false,value) );
			});
		});
			
		test("pastdate (after:'#DateFormat(tomorrow,'yyyy/mm/dd')#')", function() {
			var v = jQuery("##form").validate();
			var method = $.validator.methods["pastdate"], 
				param = {},
				e = $("##firstname")[0];


			var v = jQuery("##form").validate();
			var method = $.validator.methods["futuredate"], 
				param = {after:'#DateFormat(tomorrow, "yyyy/mm/dd")#'},
				e = $("##firstname")[0];
				
			//should pass
			jQuery.each(['','#DateFormat(dayaftertomorrow,'yyyy/mm/dd')#',new Date(2100,1,1)],function(index,value){
				ok( method.call( v, value, e, param ), testedvalue(true,value) );
			});
			//should fail
			jQuery.each([new Date(2000,1,1),'#DateFormat(today, "yyyy/mm/dd")#','#DateFormat(yesterday, "yyyy/mm/dd")#','#DateFormat(tomorrow, "yyyy/mm/dd")#'],function(index,value){
				ok( !method.call( v, value, e, param ), testedvalue(false,value) );
			});
		});
		
		module("daterange");
		test("from:'12/29/1968', until:'1/1/1969'", function() {
			var v = jQuery("##form").validate();
			var method = $.validator.methods["daterange"], 
				param = {from:'12/29/1968', until:'1/1/1969'},
				e = $("##firstname")[0];

			// should all pass
			jQuery.each(['',"12/29/1968","1/1/1969","1968/12/29","12/31/1968","December 31, 1968","12/31/68","1968/12/31"],function(index,value){
				ok( method.call( v, value, e, param ), testedvalue(true,value) );
			});
			// should all fail
			jQuery.each(["12/28/1969","1/2/1969","01/02/1969","12/31/1969","2010-12-31","abc",-1],function(index,value){
				ok( !method.call( v, value, e, param ), testedvalue(false,value) );
			});
			
		});
	});
	</script>
</head>
<body>
	<h1 id="qunit-header">QUnit Test Suite</h1>
	<h2 id="qunit-banner"></h2>
	<div id="qunit-testrunner-toolbar"></div>
	<h2 id="qunit-userAgent"></h2>
	<ol id="qunit-tests"></ol>
	
	<form style="display:none;">
		<input type="text" id="firstname" name="firstname">
		<input type="text" id="lastname" name="lastname">
		<input type="text" id="password" name="password">
	</form>
</body>
</html>
</cfoutput>