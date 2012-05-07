<!---
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
--->

<cfset request.layout = false>

<cfsetting showdebugoutput="no">

<cfset local.myStruct = {}>
<cfset local.myStruct.title = application.config.newssettings.rsstitle> 
<cfset local.myStruct.link = rc.basehref> 
<cfset local.myStruct.description = application.config.newssettings.rssdescription>  
<cfset local.myStruct.pubDate = Now()>  
<cfset local.myStruct.version = "rss_2.0"> 

<cfset local.myStruct.item = []>

<cfset local.currentrow = 1>

<cfloop array="#rc.articles#" index="local.Article">
	<cfset local.myStruct.item[ local.currentrow ] = {}>
	<cfset local.myStruct.item[ local.currentrow ].title = local.Article.getTitle()>
	<cfset local.myStruct.item[ local.currentrow ].link = buildURL( action='news.article', path=rc.basehref & "index.cfm", queryString='uuid=#local.Article.getUUID()#' )>
	<cfset local.myStruct.item[ local.currentrow ].description = {}>
	<cfset local.myStruct.item[ local.currentrow ].description.value = local.Article.getRSSSummary()>
	<cfset local.myStruct.item[ local.currentrow ].pubDate = DateFormat( local.Article.getPublished() )>
	
	<cfset local.currentrow = local.currentrow + 1>
</cfloop>

<cffeed action="create" name="#local.myStruct#" escapechars="false" xmlVar="local.xml"> 

<cfcontent type="text/xml" reset="yes"><cfoutput>#local.xml#</cfoutput>