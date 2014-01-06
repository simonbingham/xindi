<cfsetting enablecfoutputonly="true">

<cfscript>
	string function urlSafePath(required string path){
		var result = Replace(arguments.path, "/", ":", "all");
		if(!Len(Trim(result))) result = "*";
		return result;
	}
</cfscript>

<cfoutput>
	<h1>File Manager</h1>

	<p>You are here: <cfif Len(Trim(rc.subdirectory))>#rc.subdirectory#<cfelse>/</cfif></p>

	#view("helpers/messages")#

	<form action="#buildURL('filemanager/upload')#" method="post" class="form-horizontal" id="upload-form" enctype="multipart/form-data">
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

		<input type="hidden" name="subdirectory" id="subdirectory" value="#HtmlEditFormat(rc.subdirectory)#">
	</form>

	<cfif rc.subdirectory neq rc.clientfilesdirectory>
		<p class="clear">
			<cfif Len(Trim(rc.subdirectory))><a href="#buildURL(action='filemanager', querystring='subdirectory=#urlSafePath(ReReplaceNoCase(rc.subdirectory, '/[^/]*$', ''))#')#"><i class="icon-chevron-up"></i> Move Up</a>&nbsp;&nbsp;</cfif>
			<a href="#buildURL(action='filemanager.createdirectory', querystring='subdirectory=#urlSafePath(rc.subdirectory)#')#" onclick="return createFolder(this.href)"><i class="icon-plus"></i> Add Directory</a>
		</p>
	</cfif>

	<cfif rc.listing.RecordCount>
		<table class="table table-striped table-bordered table-condensed">
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
								<td><i class="icon-folder-close"></i></td>
								<td><a href="#buildURL(action='filemanager', querystring='subdirectory=#urlSafePath(rc.subdirectory & '/' & rc.listing.name)#')#">#rc.listing.name#</a></td>
								<td>&ndash;</td>
								<td>&ndash;</td>
							</tr>
						</cfif>
					<cfelse>
						<cfset local.relativepathtofile = rc.basehref & rc.clientfilesdirectory & rc.subdirectory & "/" & rc.listing.name>

						<tr>
							<td><i class="icon-file"></i></td>
							<td><a href="##" onclick="return sendToEditor('#rc.listing.name#')" <cfif IsImageFile(local.relativepathtofile)>class="image-preview" rel="#local.relativepathtofile#"</cfif>>#rc.listing.name#</a></td>
							<td <cfif rc.listing.size gt 15360>class="error"</cfif>>#NumberFormat(rc.listing.size / 1024)# kb</td>
							<td class="center"><a href="#buildURL(action='filemanager.crop', querystring='subdirectory=*#urlSafePath(rc.subdirectory)#&image=#rc.listing.name#')#" title="Edit"><i class="icon-pencil"></i></a></td>
							<td class="center"><a href="#buildURL(action='filemanager.delete', querystring='subdirectory=*#urlSafePath(rc.subdirectory)#&delete=#rc.listing.name#')#" title="Delete"><i class="icon-trash"></i></a></td>
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
	function sendToEditor(fileUrl){
		window.opener.CKEDITOR.tools.callFunction(#session.CKEditorFuncNum#, "#rc.clientfilesdirectory##rc.subdirectory#/" + fileUrl);
		window.close();
		return false;
	}

	function createFolder(url){
		var newdirectory = prompt("Please enter the folder name", "");
		window.location.href = url + "/newdirectory/" + newdirectory;
		return false;
	}

	jQuery(function($){
		$imagePreview = $('<img id="preview-image" style="position:absolute;top:10px;right:10px;" alt="image preview" />').hide().appendTo('body');

		$('a.image-preview').hover(
			function(){
				var $this = $(this);
				var offset = $this.offset();
				$imagePreview
					.attr('src', $this.attr('rel'))
					.css({'top':offset.top+20+'px'})
					.show();
			},
			function(){
				$imagePreview.attr('src','assets/images/icons/ajax-loader.gif').hide();
			}
		);

	});
	</script>
</cfoutput>
