<cfset request.layout = false>

<cfsetting showdebugoutput="no">

<cfset local.myStruct = {}>
<cfset local.myStruct.title = rc.config.news.rssTitle>
<cfset local.myStruct.link = rc.basehref>
<cfset local.myStruct.description = rc.config.news.rssDescription>
<cfset local.myStruct.pubDate = Now()>
<cfset local.myStruct.version = "rss_2.0">

<cfset local.myStruct.item = []>

<cfset local.currentRow = 1>

<cfloop array="#rc.articles#" index="local.Article">
	<cfset local.myStruct.item[local.currentRow] = {}>
	<cfset local.myStruct.item[local.currentRow].title = local.Article.getTitle()>
	<cfset local.myStruct.item[local.currentRow].link = buildURL(action = 'news.article', path = rc.baseHref & "index.cfm", queryString = 'slug=#local.Article.getSlug()#')>
	<cfset local.myStruct.item[local.currentRow].description = {}>
	<cfset local.myStruct.item[local.currentRow].description.value = local.Article.getRSSSummary()>
	<cfset local.myStruct.item[local.currentRow].pubDate = DateFormat(local.Article.getPublished())>

	<cfset local.currentRow++>
</cfloop>

<cffeed action="create" name="#local.myStruct#" escapechars="false" xmlVar="local.xml">

<cfcontent type="text/xml" reset="yes"><cfoutput>#local.xml#</cfoutput>
