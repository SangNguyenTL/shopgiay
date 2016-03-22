<!--#include file="header-admin.asp" -->

<%
Dim MM_addbrand
Dim buttonForm
Dim MM_action
Dim MM_editRedirectUrl

Dim brandName
Dim logo
Dim brandDS
Dim checkBrandName
Dim ckBrandName
Dim statusBrand
if (CStr(Request("MM_action")) <> "") then

	brandName = HTMLEncode(Request("txtBrand"))
	logo = HTMLEncode(Request("ProPic"))
	brandDS = HTMLEncode(Request("txtDes"))
	if CStr(Request("MM_action")) = "add" then
		set checkBrandName = Server.CreateObject("ADODB.Command")
		checkBrandName.ActiveConnection = MM_Connect_STRING
		checkBrandName.CommandText = "Select brandName FROM dbo.tb_Brand WHERE brandName = '"&brandName&"' "
		checkBrandName.Prepared = True
		set ckBrandName = checkBrandName.Execute
		IF (Not ckBrandName.EOF) OR (Not ckBrandName.BOF) then

			statusBrand = "False"
		end if
	elseif CStr(Request("MM_action")) = "edit" then
		statusBrand = "True"
	end if

	if statusBrand = "False" then
		Session("statusBrand") = "Thương hiệu này đã tồn tại xin bạn hãy nhập một thương hiệu khác"
	elseif Len(brandName) < 1 OR Len(brandName) > 50 then
		Session("statusBrand") = "Tên thương hiệu phải nằm trong khoảng 50 ký tự!"
	elseif Len(logo) < 3 OR Len(logo) > 250 then
		Session("statusBrand") = "Ảnh thương hiệu phải nằm trong khoảng từ 3 đến 250 ký tự!"
	elseif Len(brandDS) > 3000 then
		Session("statusBrand") = "Mô tả về thương hiệu phải nằm trong khoảng 3000 ký tự!"
	else
		if (CStr(Request.Querystring("brandName")) = "") then
			MM_editRedirectUrl = "admin-brand-list.asp"
			MM_addbrand = MM_addbrand & "?" & HTMLEncode("action=add")
			If (CStr(Request("MM_action")) = "add") Then
				' execute the insert
				Dim MM_insertBrand

				Set MM_insertBrand = Server.CreateObject ("ADODB.Command")
				MM_insertBrand.ActiveConnection = MM_Connect_STRING
				MM_insertBrand.CommandText = "INSERT INTO dbo.tb_Brand (brandName, logo, brandDS) VALUES (N'"&brandName&"', N'"&logo&"', N'"&brandDS&"')" 
				MM_insertBrand.Prepared = true
				MM_insertBrand.Execute
				MM_insertBrand.ActiveConnection.Close

				' append the query string to the redirect URL
				Response.Redirect(MM_editRedirectUrl)
			End If
		else
			MM_addbrand = MM_addbrand & "?" & HTMLEncode("action=edit")
			If (CStr(Request("MM_action")) = "edit") Then
				Dim MM_editBrand

				Set MM_editBrand = Server.CreateObject ("ADODB.Command")
				MM_editBrand.ActiveConnection = MM_Connect_STRING
				MM_editBrand.CommandText = "UPDATE dbo.tb_Brand SET logo = N'"&logo&"', brandDS = N'"&brandDS&"' WHERE brandName = '"&HTMLEncode(Request.Querystring("brandName"))&"'" 
				MM_editBrand.Execute
				MM_editBrand.ActiveConnection.Close
				Session("statusBrand") = "Cập nhật thành công"
				MM_editRedirectUrl = GetFileName()
				If (Request.QueryString <> "") Then
				  If (InStr(1, MM_editRedirectUrl, "?", vbTextCompare) = 0) Then
					MM_editRedirectUrl = MM_editRedirectUrl & "?" & Request.QueryString
				  Else
					MM_editRedirectUrl = MM_editRedirectUrl & "&" & Request.QueryString
				  End If
				End If
				Response.Redirect(MM_editRedirectUrl)
			end if
		end if
	end if
	ckBrandName.Close()
	set checkBrandName = Nothing
end if
Dim class_dis
if (CStr(Request.Querystring("brandName")) <> "") then
	MM_action = "edit"
	buttonForm = "Cập nhật"
	class_dis = "disabled"
else
	MM_action = "add"
	buttonForm = "Thêm"
end if
Dim rsBrand
Dim rsBrand_cmd
Dim rsBrand_numRows

if Request.QueryString <> "" then
	Set rsBrand_cmd = Server.CreateObject ("ADODB.Command")
	rsBrand_cmd.ActiveConnection = MM_Connect_STRING
	rsBrand_cmd.CommandText = "SELECT * FROM dbo.tb_Brand WHERE brandName = '"&Request.Querystring("brandName")&"' " 
	rsBrand_cmd.Prepared = true

	Set rsBrand = rsBrand_cmd.Execute
	rsBrand_numRows = 0
	IF Not rsBrand.EOF AND Not rsBrand.BOF then
		brandName = rsBrand.Fields.Item("brandName").Value
		logo = rsBrand.Fields.Item("logo").Value
		brandDS = rsBrand.Fields.Item("brandDS").Value
	else
		Response.Redirect("admin-brand-list.asp")
	End if
	rsBrand.Close()
	Set rsBrand = Nothing
end if
%>


  <div class="content">
  	<div class="container">
			<!-- /.box-header -->
		<div class="box box-info">
		
			<div class="box-header with-border">
				<h3 class="box-title">Upload ảnh</h3>
				<div class="statusUpload alert m-t-sm" style="display: none"></div>
			</div>
			<div class="box-body">
				<form name="formUpload" id="formUpload" method="post" enctype="multipart/form-data">
				<div class="form-group">
							<input type="file" class="pull-left" name="file1">
							<input type="submit" class="m-l-sm pull-left" name="submit" value="Upload File">


                </div>
			</div>
			</form>
		</div>
		<div class="box table-responsive no-padding">
			<div class="box-header">
				<h1><%=buttonForm%> thương hiệu </h1>
			  <%
			  If Session("statusBrand") <> "" then
				Response.Write("<p class='alert alert-info page-header'>"&Session.Contents("statusBrand")&"</p>")
				Session.Contents.Remove("statusBrand")
			  End If
			  %>
			</div>

			<div class="box-body">
			<form ACTION="<%=MM_addbrand%>" METHOD="POST" id="form1" role="form" name="form1">
				 <div class="form-group  col-xs-12">
					<label>Tên thương hiệu(*)</label>
						<input name="txtBrand" type="text" <%=class_dis%>  class="form-control" placeholder="Tên thương hiệu từ 6 đến 50 ký tự" pattern=".{1,50}" title="Tên thương hiệu phải nằm trong khoảng 50 ký tự" required value="<%=brandName%>">
				</div>
				<div class="form-group col-xs-12">
					 <label>Logo(*)</label>
					  <input name="ProPic" type="text" class="form-control" value="<%=logo%>" required placeholder="Link ảnh từ 3 đến 250 ký tự" pattern=".{3,250}">
						<div class="imageProduct m-t-sm" style="clear: both;"></div>
				</div>
				<div class="form-group col-xs-12">
					  <label>Mô tả</label>
					  <textarea name="txtDes" class="form-control" rows="3" placeholder="Mô tả nằm trong khoảng 500 ký tự"><%=brandDS%></textarea>
				</div>
			  <button type="submit" class="btn btn-primary"><%=buttonForm%></button>
			  <input type="hidden" name="MM_action" value="<%=MM_action%>">
			</form>
			</div>
		</div>
    </div>
  </div>
 <!--#include file="footer-admin.asp" -->
