<cfset request.layout = false />

<cfsavecontent variable="local.xml">
	<!--- no space between opening cfoutput tag and start of xml --->
	<cfoutput><?xml version="1.0" encoding="UTF-8"?>
		<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
			<!--- add pages to sitemap --->
			<cfloop array="#rc.pages#" index="local.Page">
				<cfif( rc.sesomitindex )>
					<url><loc>#rc.basehref##local.Page.getSlug()#</loc></url>
				<cfelse>
					<url><loc>#rc.basehref#index.cfm/#local.Page.getSlug()#</loc></url>
				</cfif>
			</cfloop>
			
			<!--- add articles to sitemap --->
			<cfif rc.config.news.enabled> 
				<cfloop array="#rc.articles#" index="local.Article">
					<cfif( rc.sesomitindex )>
						<url><loc>#rc.basehref#news/article/slug/#local.Article.getSlug()#</loc></url>
					<cfelse>
						<url><loc>#rc.basehref#index.cfm/news/article/slug/#local.Article.getSlug()#</loc></url>
					</cfif>
				</cfloop>
			</cfif>
		</urlset>
	</cfoutput>
</cfsavecontent>

<cffile action="write" file="#ExpandPath( "./" )#sitemap.xml" output="#local.xml#">