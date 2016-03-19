<!-- #include file="header.asp" -->
<%
Dim rsUser__MMColParam
rsUser__MMColParam = Replace(Session.Contents("MM_rsEmail"),"'","&#39;")
If (Request.QueryString("email") <> "") Then 
  rsUser__MMColParam = Replace(Request.QueryString("email"),"'","&#39;")
End If

if (Session("MM_rsEmail") = "" and Request.QueryString = "") or Session("MM_UserID") = "1" then
	Response.Redirect("index.asp")
end if


Dim MM_editUser
Dim MM_editUserAction
Dim plusQuery
MM_editUserAction = CStr(Request.ServerVariables("SCRIPT_NAME"))
If (Request.QueryString <> "") Then
  MM_editUserAction = MM_editUserAction & "?" & HTMLEncode("email="&Request.QueryString("email"))
End If

fullName = HTMLEncode(Request.Form("txtName"))
passW = HTMLEncode(Request.Form("txtPass"))
phone = Request.Form("txtphone")
Address = HTMLEncode(Request.Form("txtaddress"))
Role = Request.Form("txtRole")
pass2 = HTMLEncode(Request.Form("txtpass2"))
If (CStr(Request("MM_update")) = "frm1") Then
  If (Not MM_abortEdit) Then
    ' execute the update
		if Len(fullName) > 70 or Len(fullName) < 3 then
			Session("Updatestatus")="Tên bạn nhập phải từ 3 đến 70 ký tự!"
		elseif Len(passW) <> 0 then
			if Len(passW) < 6 or Len(passW) > 15 then
				Session("Updatestatus")="Mật khẩu bạn nhập phải từ 6 đến 15 ký tự!"
			elseif passW <> pass2 then
				Session("Updatestatus")="Mật khẩu bạn nhập không khớp nhau!"
			end if
		elseif ((IsNumeric(phone) = False) OR Len(phone) > 11 Or Len(phone) < 8) then 
			Session("Updatestatus")="Số điện thoại phải từ 8 đến 11 chữ số, phải là số"
		elseif Len(Address) > 200 OR Len(Address) < 1 then
			Session("Updatestatus")="Địa chỉ phải nằm trong khoảng 200 ký tự"
		elseif Role > 1 or Role < 0 then
	
			Session("Updatestatus")="Quyền phải là 1(Admin) hoặc 0(thành viên)"
		else	
			if Len(passW) <> 0 then
				passW = "passW = '"&passW&"',"
			else
				passW = ""
			end if
			if (Session("MM_UserAuthorization")) = "True" then
				plusQuery = ", [role]= "&Role
			end if
			Set MM_editUser = Server.CreateObject ("ADODB.Command")
			MM_editUser.ActiveConnection = MM_Connect_STRING
			MM_editUser.CommandText = "UPDATE dbo.tb_user SET "&passW&" fullName = N'"&fullName&"', phone = '"&phone&"', Address = N'"&Address&"'"&plusQuery&" WHERE email = '"& rsUser__MMColParam &"' " 
			'MM_editUser.Parameters.Append MM_editUser.CreateParameter("param1", 5, 1, -1, CInt(Request.Form("MM_recordId"))) ' adDouble
			
			MM_editUser.Prepared = true
			MM_editUser.Execute
			MM_editUser.ActiveConnection.Close
			Session("Updatestatus") = "Cập nhật thành công!"
			' append the query string to the redirect URL
			Dim MM_editRedirectUrl
			MM_editRedirectUrl = "user-info.asp"
			If (Request.QueryString <> "") Then
			  If (InStr(1, MM_editRedirectUrl, "?", vbTextCompare) = 0) Then
				MM_editRedirectUrl = MM_editRedirectUrl & "?" & Request.QueryString
			  Else
				MM_editRedirectUrl = MM_editRedirectUrl & "&" & Request.QueryString
			  End If
			End If
			Response.Redirect(MM_editRedirectUrl)
		end if

  
  End If
End If

Dim rsUser
Dim rsUser_cmd
Dim rsUser_numRows

Set rsUser_cmd = Server.CreateObject ("ADODB.Command")
rsUser_cmd.ActiveConnection = MM_Connect_STRING
rsUser_cmd.CommandText = "SELECT * FROM dbo.tb_user WHERE email = '"&rsUser__MMColParam&"'" 
rsUser_cmd.Prepared = true

Set rsUser = rsUser_cmd.Execute
rsUser_numRows = 0
if (rsUser.EOF or rsUser.BOF) then
	Response.Redirect("index.asp")
end if
Dim checkRole1
Dim checkRole2
if rsUser.Fields.Item("role") = "False" then
	txtRole = "Thành viên"
	checkRole1 = "selected"
end if
if rsUser.Fields.Item("role") = "True" then
	txtRole = "Quản trị"
	checkRole2 = "selected"
end if

%>

		<section>
			
		<div class="container">						
			<div class="row"> 
             		<h2 style="color:#428BCA; text-align:center" >Thông tin cá nhân</h2>

    
<%
if Session.Contents("Updatestatus") <> "" then
	if Session.Contents("Updatestatus") = "Cập nhật thành công!" then
%>
	<p class="alert alert-success" style="margin-top:20px">  
		<i class="fa fa-check-circle">&nbsp;&nbsp;<%=Session.Contents("Updatestatus")%></i>
	</p>
<%
	  Session.Contents.Remove("Updatestatus")
	else
%>
	<p class="alert alert-danger" style="margin-top:20px">  
		<i class="fa fa-time">&nbsp;&nbsp;<%=Session.Contents("Updatestatus")%></i>
	</p>
<%
	  Session.Contents.Remove("Updatestatus")
	end if
end if
%>	
              <form ACTION="<% if Session("MM_UserAuthorization") = "True" or rsUser.Fields.Item("userId").value = Session("MM_UserId") then %>
			  <%=MM_editUserAction%>
			  <%end if%>" METHOD="POST" name="frm1" id="frm1" class="form-horizontal" role="form" >
            	<div class="col-md-6">
                                  <div class="form-group">
                                    <label class="control-label col-sm-4" for="email">Email:</label>
                                    <div class="col-sm-6">
                                      <input type="email" value="<%=(rsUser.Fields.Item("email").Value)%>" class="form-control" id="email" disabled>
                                    </div>
                                  </div>
                                  <div class="form-group">
                                    <label class="control-label col-sm-4" for="pwd" >Mật khẩu:</label>
                                    <div class="col-sm-6"> 
                                      <input name="txtpass" type="password" pattern=".{6,15}" title="Password phải từ 6 đến 15 kí tự"class="form-control" >
                                    </div>
                                  </div>
                                 <div class="form-group">
                                    <label class="control-label col-sm-4" for="pwd">Xác nhận mật khẩu:</label>
                                    <div class="col-sm-6"> 
                                      <input name="txtpass2" type="password" class="form-control" >
                                    </div>
                			  </div>      
					
                </div>
                <div class="col-md-6">
                	
                                  <div class="form-group">
                                    <label class="control-label col-sm-4" for="email">Họ Tên:</label>
                                    <div class="col-sm-6">
                                      <input name="txtName" type="text" required patern="[abc]{6,50}" title="Họ Tên phải có ít nhất 6 kí tự " class="form-control" value="<%=(rsUser.Fields.Item("fullName").Value)%>" >
                                    </div>
                                  </div>
                                  <div class="form-group">
                                    <label class="control-label col-sm-4" for="pwd">Số điện thoại:</label>
                                    <div class="col-sm-6"> 
                                      <input name="txtphone" type="text" class="form-control" required pattern="[\d]{8,11}" title="SĐT phải là số (8->11 số)" value="<%=(rsUser.Fields.Item("phone").Value)%>" >
                                    </div>
                                  </div>
                                   <div class="form-group">
                                    <label class="control-label col-sm-4" for="pwd">Địa chỉ:</label>
                                    <div class="col-sm-6"> 
                                      <input name="txtaddress" type="text" class="form-control" required pattern=".{20,50}" title="Địa chỉ phải từ 20 đến 50 kí tự" value="<%=(rsUser.Fields.Item("Address").Value)%>">
                                    </div>
                                  </div>
                                   <div class="form-group">
                                    <label class="control-label col-sm-4" for="txtRole">Quyền:</label>
									<% if Session("MM_UserAuthorization") = "True" then %>
                                    <div class="col-sm-6"> 
                                      <select class="form-control" name="txtRole">
										<option value="0" <%=checkRole1%>>Thành viên</option>
										<option value="1" <%=checkRole2%>>Quản trị</option>
									  </select>
                                    </div>
									<% 
									else
										Response.Write("<div class=""col-sm-6""><div class=""form-control"">"&txtRole&"</div></div>")
									end if %>
                                  </div>
								  <% if Session("MM_UserAuthorization") = "True" or rsUser.Fields.Item("userId").value = Session("MM_UserId") then %>
                                  <div class="form-group"> 
                                    <div class="col-sm-offset-8 col-sm-10">
                                      <button type="submit" class="btn btn-success btn-lg">Lưu</button>
								  <% if Session("MM_UserAuthorization") = "True" then %>
										<a href="admin-user-list.asp" class="btn btn-danger btn-lg">Quay lại</a>
								  <% end if %>
                                    </div>
                                  </div>
								  <% end if %>

                </div>
                <input type="hidden" name="MM_update" value="frm1" />
                <input type="hidden" name="MM_recordId" value="<%= rsUser.Fields.Item("userID").Value %>" />
              </form>
		</div>
        
	</section>
<!-- #include file="footer.asp" -->
<%
rsUser.Close()
Set rsUser = Nothing
%>
