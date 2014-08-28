<cfset request.layout = false />

<!--- no space between the ColdFusion tags and start of xml --->
<cfsavecontent variable="local.xml"><cfoutput><?xml version="1.0" encoding="UTF-8"?>
		<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
			<!--- add pages to sitemap --->
			<cfloop query="rc.navigation">
				<cfif(rc.sesomitindex)>
					<url><loc>#rc.basehref#<cfif rc.config.page.defaultslug neq slug>#slug#</cfif></loc></url>
				<cfelse>
					<url><loc>#rc.basehref#<cfif rc.config.page.defaultslug neq slug>index.cfm/#slug#</cfif></loc></url>
				</cfif>
			</cfloop>

			<!--- add articles to sitemap --->
			<cfif rc.config.news.enabled>
				<cfloop array="#rc.articles#" index="local.Article">
					<cfif(rc.sesomitindex)>
						<url><loc>#rc.basehref#news/article/slug/#local.Article.getSlug()#</loc></url>
					<cfelse>
						<url><loc>#rc.basehref#index.cfm/news/article/slug/#local.Article.getSlug()#</loc></url>
					</cfif>
				</cfloop>
			</cfif>
			
			<!--- add forms to sitemap --->
			<cfif rc.config.forms.enabled> 
				<cfloop array="#rc.forms#" index="local.Form">
					<cfif( rc.sesomitindex )>
						<url><loc>#rc.basehref#forms/form/slug/#local.Form.getSlug()#</loc></url>
					<cfelse>
						<url><loc>#rc.basehref#index.cfm/forms/form/slug/#local.Form.getSlug()#</loc></url>
					</cfif>
				</cfloop>
			</cfif>
		</urlset>
	</cfoutput>
</cfsavecontent>

<cffile action="write" file="#ExpandPath("./")#sitemap.xml" output="#local.xml#">
