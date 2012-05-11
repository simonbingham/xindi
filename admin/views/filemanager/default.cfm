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

<cfsetting enablecfoutputonly="true">

<cfscript>
	string function urlSafePath( required string path )
	{
		var result = Replace( arguments.path, "/", ":", "all" );
		if( !Len( Trim( result ) ) ) result = "*";
		return result;
	}
</cfscript>	

<cfoutput>
	<!DOCTYPE html>
	
	<html lang="en">
		<head>
			<meta charset="utf-8">
			<meta name="author" content="Simon Bingham (http://www.simonbingham.me.uk/)">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			
			<base href="#rc.basehref##request.subsystem#/">

			<title>Xindi</title>

			<link href="assets/css/bootstrap.min.css" rel="stylesheet">
			<link href="assets/css/bootstrap-responsive.min.css" rel="stylesheet">
			<link href="assets/css/core.css?r=#rc.config.revision#" rel="stylesheet">

			<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
			<script src="assets/js/bootstrap.min.js"></script>
			<script src="assets/ckeditor/ckeditor.js"></script>
			<script src="assets/js/core.js?r=#rc.config.revision#"></script>
			
			<link rel="shortcut icon" href="assets/ico/favicon.ico">
			<link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/ico/apple-touch-icon-114-precomposed.png">
			<link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/ico/apple-touch-icon-72-precomposed.png">
			<link rel="apple-touch-icon-precomposed" href="assets/ico/apple-touch-icon-57-precomposed.png">
		</head>
		
		<body>	
			<div id="container" class="container">
				<div class="row">
					<div id="content" class="span12">		
						<p>You are here: <cfif Len( Trim( rc.subdirectory ) )>#rc.subdirectory#<cfelse>/</cfif></p>
					
						#view( "helpers/messages" )#
						
						<form action="#buildURL( 'filemanager/upload' )#" method="post" class="form-horizontal" id="upload-form" enctype="multipart/form-data">
						    <fieldset>
						        <legend>Upload File</legend>
								
								<div class="control-group">
									<label class="control-label" for="file">Select File</label>
									<div class="controls"><input class="input-xlarge" type="file" name="file" id="file"></div>
								</div>
								
								<div class="form-actions">
									<input type="submit" name="upload" id="upload" value="Upload" class="btn btn-primary">
								</div>
							</fieldset>
							
							<input type="hidden" name="subdirectory" id="subdirectory" value="#HtmlEditFormat( rc.subdirectory )#">
						</form>	
						
						<cfif rc.subdirectory neq rc.clientfilesdirectory>
							<p class="clear">
								<cfif Len( Trim( rc.subdirectory ) )><a href="#buildURL( action='filemanager', querystring='subdirectory=#urlSafePath( ReReplaceNoCase( rc.subdirectory, '/[^/]*$', '' ) )#' )#"><i class="icon-chevron-up"></i> Move Up</a>&nbsp;&nbsp;</cfif> 
								<a href="#buildURL( action='filemanager.createdirectory', querystring='subdirectory=#urlSafePath( rc.subdirectory )#' )#" onclick="return createFolder( this.href )"><i class="icon-plus"></i> Add Directory</a> 
							</p>
						</cfif>
						
						<cfif rc.listing.RecordCount>
							<table class="table table-striped table-bordered table-condensed">
								<thead>
									<tr>
										<th>Type</th>
										<th>Name</th>
										<th>Size</th>
										<th class="center">Actions</th>
									</tr>
								</thead>
								
								<tbody>
									<cfloop query="rc.listing">
										<cfif rc.listing.type eq "DIR">
											<cfif rc.listing.name neq "null">
												<tr>
													<td><i class="icon-folder-close"></i></td>
													<td><a href="#buildURL( action='filemanager', querystring='subdirectory=#urlSafePath( rc.subdirectory & '/' & rc.listing.name )#' )#">#rc.listing.name#</a></td>
													<td>&ndash;</td>
													<td>&ndash;</td>
												</tr>
											</cfif>
										<cfelse>
											<cfset local.relativepathtofile = rc.basehref & rc.clientfilesdirectory & rc.subdirectory & "/" & rc.listing.name>
											
											<tr>
												<td><i class="icon-file"></i></td>
												<td><a href="##" onclick="return sendToEditor( '#rc.listing.name#' )" <cfif IsImageFile( local.relativepathtofile )>class="image-preview" rel="#local.relativepathtofile#"</cfif>>#rc.listing.name#</a></td>
												<td <cfif rc.listing.size gt 15360>class="error"</cfif>>#NumberFormat( rc.listing.size / 1024 )# kb</td>
												<td><a href="#buildURL( action='filemanager.delete', querystring='subdirectory=*#urlSafePath( rc.subdirectory )#&delete=#rc.listing.name#' )#" title="Delete"><i class="icon-remove"></i></a></td>
											</tr>
										</cfif>
									</cfloop>
								</tbody>
							</table>
							
							<p class="error">Large files are highlighted and will be slow to download.</p>
						<cfelse>
							<hr />
							
							<p>There are currently no files.</p>
						</cfif>

						<script>
						function sendToEditor( fileUrl ){
							window.opener.CKEDITOR.tools.callFunction( #session.CKEditorFuncNum#, "#rc.clientfilesdirectory##rc.subdirectory#/" + fileUrl );
							window.close();
							return false;
						}
						
						function createFolder( url ){
							var newdirectory = prompt( "Please enter the folder name", "" );
							window.location.href = url + "/newdirectory/" + newdirectory;
							return false;
						}

						// method to display image preview on mouse over in file manager
						this.imagePreview = function(){	
							xOffset = 10;
							yOffset = 30;
							$( "a.image-preview" ).hover( function( e ){
								this.t = this.title;
								this.title = "";	
								var c = ( this.t != "" ) ? "<br/>" + this.t : "";
								$( "body" ).append( "<p id='image-preview'><img src='"+ this.rel +"' alt='url preview' />"+ c +"</p>" );								 
								$( "##image-preview" )
									.css( "top",( e.pageY - xOffset ) + "px" )
									.css( "left", (e.pageX + yOffset) + "px" )
									.css( "width", "300px" )
									.fadeIn( "fast" );
							},
							function(){
								this.title = this.t;	
								$( "##image-preview" ).remove();
							});	
							$( "a.image-preview" ).mousemove( function( e ){
								$( "##image-preview" )
									.css( "top", ( e.pageY - xOffset ) + "px" )
									.css( "left", ( e.pageX + yOffset ) + "px" )
									.css( "width", "300px" );
							});
						};
						
						$( function() {
							imagePreview();
						});
						</script>
					</div>
				</div>
			</div>
		</body>		
	</html>	
</cfoutput>