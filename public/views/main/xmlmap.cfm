<!---
   Copyright 2012, Simon Bingham

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->

<cfset request.layout = false>

<cfset local.pages = getBeanFactory().getBean( "PageService" ).getPages()>

<!--- xml validation will fail if indentation is incorrect --->
<cfsavecontent variable="local.sitemap"><cfoutput><?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd"><cfloop array="#local.pages#" index="local.Page"><url><loc>#buildURL( action=local.Page.getSlug(), path=rc.basehref & "index.cfm" )#</loc></url></cfloop></urlset></cfoutput></cfsavecontent>

<cffile action="write" file="#ExpandPath( './' )#sitemap.xml" output="#local.sitemap#">