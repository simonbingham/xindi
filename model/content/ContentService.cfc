component accessors="true" extends="model.abstract.BaseService" {

	// ------------------------ DEPENDENCY INJECTION ------------------------ //

	property name="ContentGateway" getter="false";
	property name="MetaData" getter="false";
	property name="SecurityService" getter="false";
	property name="Validator" getter="false";

	// ------------------------ PUBLIC METHODS ------------------------ //

	/**
	 * I delete a page
	 */		 	
	struct function deletePage( required pageid ){
		transaction{
			var Page = variables.ContentGateway.getPage( Val( arguments.pageid ) );
			var result = variables.Validator.newResult();
			if( Page.isPersisted() ){
				variables.ContentGateway.deletePage( Page );
				result.setSuccessMessage( "The page &quot;#Page.getTitle()#&quot; has been deleted." );
			}else{
				result.setErrorMessage( "The page could not be deleted." );
			}
		}
		return result;
	}

	/**
	 * I return a query of pages and articles that match the search term
	 */	
	query function findContentBySearchTerm( string searchterm="", maxresults=50 ){
		arguments.maxresults = Val( arguments.maxresults );
		return variables.ContentGateway.findContentBySearchTerm( argumentCollection=arguments );
	}
	
	/**
	 * I return a query of child pages
	 */	
	query function getChildren( Page, clearcache=false ){
		return variables.ContentGateway.getChildren( left=arguments.Page.getLeftValue(), right=arguments.Page.getRightValue(), clearcache=arguments.clearcache );
	}	
	
	/**
	 * I return a page matching an id
	 */		
	Page function getPage( required pageid ){
		return variables.ContentGateway.getPage( Val( arguments.pageid ) );
	}
	
	/**
	 * I return a page matching a slug
	 */		
	Page function getPageBySlug( required string slug ){
		return variables.ContentGateway.getPageBySlug( slug=Trim( arguments.slug ) );
	}
	
	/**
	 * I return an array of pages
	 */	
	array function getPages( string searchterm="", sortorder="leftvalue", maxresults=0 ){
		arguments.maxresults = Val( arguments.maxresults );
		return variables.ContentGateway.getPages( argumentCollection=arguments );
	}

	/**
	 * I return a query of pages making up the site hierarchy
	 */	
	query function getNavigation( Page, clearcache=false ){
		if ( StructKeyExists( arguments, "Page" ) ) return variables.ContentGateway.getNavigation( left=arguments.Page.getleftvalue(), right=arguments.Page.getrightvalue(), clearcache=arguments.clearcache );
		else return variables.ContentGateway.getNavigation( clearcache=arguments.clearcache );
	}
	
	/**
	 * I return a query of pages for page's hierarchy
	 */	
	query function getNavigationPath( required pageid ){
		arguments.pageid = Val( arguments.pageid );
		return variables.ContentGateway.getNavigationPath( arguments.pageid );
	}

	/**
	 * I return the root page (i.e. home page)
	 */	
	Page function getRoot(){
		return variables.ContentGateway.getRoot();
	}	
	
	/**
	 * I move a page
	 */		
	struct function movePage( required pageid, required string direction ){
		transaction{
			var result = variables.Validator.newResult();
			var Page = variables.ContentGateway.getPage( Val( arguments.pageid ) );
			result.setErrorMessage( "The page could not be moved." );
			if( Page.isPersisted() && ListFindNoCase( "up,down", Trim( arguments.direction ) ) ){
				if( arguments.direction eq "up" ){
					if( Page.hasPreviousSibling() ){
						variables.ContentGateway.movePage( Page, "up" );
						result.setSuccessMessage( "The page &quot;#Page.getTitle()#&quot; has been moved." );
					}
				}else{
					if( Page.hasNextSibling() ){
						variables.ContentGateway.movePage( Page, "down" );
						result.setSuccessMessage( "The page &quot;#Page.getTitle()#&quot; has been moved." );
					}
				}
			}
			result.setTheObject( Page );
		}
		return result;
	}
	
	/**
	 * I validate and save a page
	 */		
	struct function savePage( required struct properties, required ancestorid, required string context, required string websitetitle ){
		transaction{
			param name="arguments.properties.pageid" default="";
			param name="arguments.properties.metagenerated" default="false";
			arguments.properties.pageid = Val( arguments.properties.pageid );
			var Page = variables.ContentGateway.getPage( arguments.properties.pageid );
			if( arguments.properties.metagenerated ){
				arguments.properties.metatitle = variables.MetaData.generatePageTitle( arguments.websitetitle, arguments.properties.title );
				arguments.properties.metadescription = variables.MetaData.generateMetaDescription( arguments.properties.content );
				arguments.properties.metakeywords = variables.MetaData.generateMetaKeywords( arguments.properties.title );
			}
			var User = variables.SecurityService.getCurrentUser();
			if( !IsNull( User ) ) arguments.properties.updatedby = User.getFullName();
			populate( Page, arguments.properties );
			var result = variables.Validator.validate( theObject=Page, context=arguments.context );
			if( !result.hasErrors() ){
				variables.ContentGateway.savePage( Page, ancestorid );
				result.setSuccessMessage( "The page &quot;#Page.getTitle()#&quot; has been saved." );
			}else{
				result.setErrorMessage( "Your page could not be saved. Please amend the highlighted fields." );
			}
		}
		return result;
	}

	
	// accepts an array of structs
	boolean function saveSortOrder( required array pages ) {
		transaction{
			for ( var page in arguments.pages ){
				var PageEntity = getPage( page.pageid );
				if ( IsNull( PageEntity ) || !PageEntity.isPersisted() ) return false;
				PageEntity.setleftvalue( page.left );
				PageEntity.setrightvalue( page.right );
				variables.ContentGateway.savePage( PageEntity, 0 );
			}
		}
		return true;
	}
		
}