<cfsetting enablecfoutputonly="true">

<cfscript>
	string function urlSafePath(required string path){
		local.result = Replace(arguments.path, "/", ":", "all");
		if(!Len(Trim(local.result))) {
			local.result = "*";
		}
		return local.result;
	}
</cfscript>

<cfoutput>
	<h1>File Manager</h1>

	<p>You are here: <cfif Len(Trim(rc.subDirectory))>#rc.subDirectory#<cfelse>/</cfif></p>

	#view("partials/messages")#

	<hr>

	<form action="#buildURL('filemanager/upload')#" method="post" class="append-bottom" id="upload-form" enctype="multipart/form-data">
		<div class="form-group">
			<label for="file">Select File</label>
			<input type="file" name="file" id="file">
		</div>

		<button type="submit" class="btn btn-primary">Upload</button>

		<input type="hidden" name="subdirectory" id="subdirectory" value="#HtmlEditFormat(rc.subDirectory)#">
	</form>

	<hr>

	<cfif rc.subDirectory neq rc.clientFilesDirectory>
		<p class="clear">
			<cfif Len(Trim(rc.subDirectory))>
				<a href="#buildURL(action = 'filemanager', queryString = 'subdirectory=#urlSafePath(ReReplaceNoCase(rc.subDirectory, '/[^/]*$', ''))#')#"><i class="glyphicon glyphicon-chevron-up"></i> Move Up</a>&nbsp;&nbsp;
			</cfif>
			<a href="#buildURL(action = 'filemanager.createdirectory', queryString = 'subdirectory=#urlSafePath(rc.subDirectory)#')#" onclick="return createFolder(this.href)"><i class="glyphicon glyphicon-plus"></i> Add Directory</a>
		</p>
	</cfif>

	<cfif rc.listing.RecordCount>
		<table class="table table-striped">
			<thead>
				<tr>
					<th>Type</th>
					<th>Name</th>
					<th>Size</th>
					<th class="center">Edit</th>
					<th class="center">Delete</th>
				</tr>
			</thead>

			<tbody>
				<cfloop query="rc.listing">
					<cfif rc.listing.type eq "DIR">
						<cfif rc.listing.name neq "null">
							<tr>
								<td><i class="glyphicon glyphicon-folder-close"></i></td>
								<td><a href="#buildURL(action = 'filemanager', queryString = 'subdirectory=#urlSafePath(rc.subDirectory & '/' & rc.listing.name)#')#">#rc.listing.name#</a></td>
								<td>&ndash;</td>
								<td>&ndash;</td>
								<td>&ndash;</td>
							</tr>
						</cfif>
					<cfelse>
						<cfset local.relativePathToFile = rc.baseHref & rc.clientFilesDirectory & rc.subDirectory & "/" & rc.listing.name>

						<tr>
							<td><i class="glyphicon glyphicon-file"></i></td>
							<td><a href="##" onclick="return sendToEditor('#rc.listing.name#')" <cfif IsImageFile(local.relativePathToFile)>class="image-preview" rel="#local.relativePathToFile#"</cfif>>#rc.listing.name#</a></td>
							<td <cfif rc.listing.size gt 15360>class="error"</cfif>>#NumberFormat(rc.listing.size / 1024)# kb</td>
							<td class="center"><a href="#buildURL(action = 'filemanager.crop', queryString = 'subdirectory=*#urlSafePath(rc.subDirectory)#&image=#rc.listing.name#')#" title="Edit"><i class="glyphicon glyphicon-pencil"></i></a></td>
							<td class="center"><a href="#buildURL(action = 'filemanager.delete', queryString = 'subdirectory=*#urlSafePath(rc.subDirectory)#&delete=#rc.listing.name#')#" title="Delete"><i class="glyphicon glyphicon-trash"></i></a></td>
						</tr>
					</cfif>
				</cfloop>
			</tbody>
		</table>

		<p class="error">Large files are highlighted and will be slow to download.</p>
	<cfelse>
		<hr>

		<p>There are currently no files.</p>
	</cfif>

	<script>
		function sendToEditor(fileUrl){
			window.opener.CKEDITOR.tools.callFunction(#session.CKEditorFuncNum#, "#rc.clientfilesdirectory##rc.subdirectory#/" + fileUrl);
			window.close();
			return false;
		}

		function createFolder(url){
			var newDirectory = prompt("Please enter the folder name", "");
			window.location.href = url + "/newdirectory/" + newDirectory;
			return false;
		}

		jQuery(function($){
			$imagePreview = $('<img id="preview-image" style="position:absolute;top:10px;right:10px;" alt="image preview">').hide().appendTo('body');

			$("a.image-preview").hover(
				function(){
					var $this = $(this);
					var offset = $this.offset();
					$imagePreview
						.attr("src", $this.attr("rel"))
						.css({"top":offset.top+20+"px"})
						.show();
				},
				function(){
					$imagePreview.attr("src","assets/images/icons/ajax-loader.gif").hide();
				}
			);
		});
	</script>
</cfoutput>
