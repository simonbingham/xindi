<cfset request.layout = false>

<cfsetting showdebugoutput="no">

<cfset local.myStruct = {}>
<cfset local.myStruct.title = rc.config.news.rsstitle>
<cfset local.myStruct.link = rc.basehref>
<cfset local.myStruct.description = rc.config.news.rssdescription>
<cfset local.myStruct.pubDate = Now()>
<cfset local.myStruct.version = "rss_2.0">

<cfset local.myStruct.item = []>

<cfset local.currentrow = 1>

<cfloop array="#rc.articles#" index="local.Article">
	<cfset local.myStruct.item[local.currentrow] = {}>
	<cfset local.myStruct.item[local.currentrow].title = local.Article.getTitle()>
	<cfset local.myStruct.item[local.currentrow].link = buildURL(action='news.article', path=rc.basehref & "index.cfm", queryString='slug=#local.Article.getSlug()#')>
	<cfset local.myStruct.item[local.currentrow].description = {}>
	<cfset local.myStruct.item[local.currentrow].description.value = local.Article.getRSSSummary()>
	<cfset local.myStruct.item[local.currentrow].pubDate = DateFormat(local.Article.getPublished())>

	<cfset local.currentrow = local.currentrow + 1>
</cfloop>

<cffeed action="create" name="#local.myStruct#" escapechars="false" xmlVar="local.xml">

<cfcontent type="text/xml" reset="yes"><cfoutput>#local.xml#</cfoutput>
