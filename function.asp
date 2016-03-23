<%
Dim linkHome : linkHome = "/shopgiay/"
Dim siteName : siteName = "Giày của tui"
Dim siteAddress : siteAddress = "590 CMT8,Ho Chi Minh City, VietNam"
Dim siteEmail : siteEmail = "giaycuatui@gmail.com"
Dim sitePhone : sitePhone = "0164 3456 554"
Function HTMLEncode(sText) 
    Dim regEx 
    Dim matches 
    Dim match 
	
    sText = Replace(sText, Chr(34), "&quot;") 
    sText = Replace(sText, Chr(60)  , "&lt;") 
    sText = Replace(sText, Chr(62)  , "&gt;") 
    sText = Replace(sText, Chr(38), "&amp;") 
    sText = Replace(sText, Chr(39), "&#39;") 
	
    HTMLEncode = sText 
End Function 
public function GetFileName()
    dim files, url, segments

    'get then current url from the server variables
    url = Request.ServerVariables("path_info")

    segments = split(url,"/")

    'read the last segment
    url = segments(ubound(segments))
    GetFileName = url
end function 
Dim MM_editAction
MM_editAction = CStr(Request.ServerVariables("SCRIPT_NAME"))
If (Request.QueryString <> "") Then
  MM_editAction = MM_editAction & "?" & HTMLEncode(Request.QueryString)
End If
MM_LoginAction = Request.ServerVariables("URL")
If Request.QueryString <> "" Then
	MM_LoginAction = MM_LoginAction + "?" + HTMLEncode(Request.QueryString)
end if
' boolean to abort record edit
Dim MM_abortLoginEdit
MM_abortLoginEdit = false
Dim phone
Dim Address 
Dim pass2 
Dim passW
Dim email
Dim fullName
Dim Role
if GetFileName() = "login.asp" then ' nếu là trang đăng nhập sẽ đăng nhập
If (CStr(Request("formRg")) = "ok") Then
  If (Not MM_abortLoginEdit) Then
    ' execute the insert
    Dim MM_regiseterCMD
	fullName = HTMLEncode(Request.Form("txtUser"))
	email = Replace(Request.Form("txtEmail"), Chr(39), "&#39;")
	passW = HTMLEncode(Request.Form("txtPass"))
	pass2 = HTMLEncode(Request.Form("txtPass2"))
	Address = HTMLEncode(Request.Form("txtAddress"))
	phone = HTMLEncode(Request.Form("txtPhone"))
	if email <> "" then
		Dim CheckUsermail
		Dim CheckUsermail_cmd
		Dim CheckUsermail_numRows
		Set CheckUsermail_cmd = Server.CreateObject ("ADODB.Command")
		CheckUsermail_cmd.ActiveConnection = MM_Connect_STRING
		CheckUsermail_cmd.CommandText = "SELECT * FROM dbo.tb_user WHERE email = '"&email&"' "
		CheckUsermail_cmd.Prepared = true

		Set CheckUsermail = CheckUsermail_cmd.Execute
		CheckUsermail_numRows = 0

		If Not CheckUsermail.EOF Or Not CheckUsermail.BOF Then 
			statusEmail = "False"
		else
			statusEmail = "True"
		End IF

		CheckUsermail.Close()
		Set CheckUsermail = Nothing
	end if
	if statusEmail = "False" then
		Session("statusRegister") = "Email đã tồn tại!"		
	elseif Len(email) < 6 or Len(email) > 50 then
		Session("statusRegister") = "Email phải từ 6 đến 50 ký tự!"
	elseif Len(fullName) > 70 or Len(fullName) < 3 then
		Session("statusRegister")="Tên bạn nhập phải từ 3 đến 70 ký tự!"
	elseif Len(passW) < 6 or Len(passW) > 15 then
			Session("statusRegister")="Mật khẩu bạn nhập phải từ 6 đến 15 ký tự!"
	elseif passW <> pass2 then
			Session("statusRegister")="Mật khẩu bạn nhập không khớp nhau!"
	elseif Len(phone) > 11 Or Len(phone) < 8 then 
		Session("statusRegister")="Số điện thoại phải từ 8 đến 11 chữ số, phải là số"
	elseif Len(Address) > 200 OR Len(Address) < 1 then
		Session("statusRegister")="Địa chỉ phải nằm trong khoảng 200 ký tự"
	else
		Session("statusRegister")="Đăng ký thành công"
		Set MM_regiseterCMD = Server.CreateObject ("ADODB.Command")
		MM_regiseterCMD.ActiveConnection = MM_Connect_STRING
		MM_regiseterCMD.CommandText = "INSERT INTO dbo.tb_user (fullName, email, passW, Address, phone,[role]) VALUES (N'"&fullName&"', N'"&email&"', N'"&passW&"', N'"&Address&"', '"&phone&"',0)" 
		MM_regiseterCMD.Prepared = true
		MM_regiseterCMD.Execute
		MM_regiseterCMD.ActiveConnection.Close
	End if
   End If
End If
	' *** Validate request to log in to this site.
	if Request("formLogin") <> "" then 
		MM_valUsername = CStr(Request.Form("txtEmail"))
		If MM_valUsername <> "" Then
		  Dim MM_fldUserAuthorization
		  Dim MM_redirectLoginSuccess
		  Dim MM_redirectLoginFailed
		  Dim MM_loginSQL
		  Dim MM_rsUser
		  Dim MM_rsEmail
		  Dim MM_rsUser_cmd
		  
		  MM_fldUserAuthorization = "role"
		  MM_redirectLoginSuccess = "index.asp"
		  MM_redirectLoginFailed = "login.asp"

		  MM_loginSQL = "SELECT email, passW"

		  If MM_fldUserAuthorization <> "" Then MM_loginSQL = MM_loginSQL & ", fullName, userId,address,phone," & MM_fldUserAuthorization
		  MM_loginSQL = MM_loginSQL & " FROM dbo.tb_user WHERE email = ? AND passW = ?"
		  Set MM_rsUser_cmd = Server.CreateObject ("ADODB.Command")
		  MM_rsUser_cmd.ActiveConnection = MM_Connect_STRING
		  MM_rsUser_cmd.CommandText = MM_loginSQL
		  MM_rsUser_cmd.Parameters.Append MM_rsUser_cmd.CreateParameter("param1", 200, 1, 50, MM_valUsername) ' adVarChar
		  MM_rsUser_cmd.Parameters.Append MM_rsUser_cmd.CreateParameter("param2", 200, 1, 15, Request.Form("txtPass")) ' adVarChar
		  MM_rsUser_cmd.Prepared = true
		  Set MM_rsUser = MM_rsUser_cmd.Execute

		  If Not MM_rsUser.EOF Or Not MM_rsUser.BOF Then 
			' username and password match - this is a valid user
			Session("MM_Username") = MM_rsUser.Fields.Item("fullName").Value
			Session("MM_rsEmail") = MM_rsUser.Fields.Item("email").Value
			Session("MM_UserID") = MM_rsUser.Fields.Item("userId").Value
			Session("MM_Userphone") = MM_rsUser.Fields.Item("phone").Value
			Session("MM_Useraddress") = MM_rsUser.Fields.Item("address").Value
			If (MM_fldUserAuthorization <> "") Then
			  Session("MM_UserAuthorization") = CStr(MM_rsUser.Fields.Item(MM_fldUserAuthorization).Value)
			Else
			  Session("MM_UserAuthorization") = ""
			End If
		   
			if Request.QueryString("vbRedirect") <> "" then 'Dieu huong co muc dich
				 Response.Redirect(redirectContent(Request.QueryString("vbRedirect")))
			else
				Response.Redirect(MM_redirectLoginSuccess)
			end if
			MM_rsUser.Close
		  else
				Session("statusLogin" )= "Đăng nhập thất bại, email hoặc mật khẩu không đúng"
		  End If
		  MM_rsUser.Close
		End if
	end if
end if

Function redirectContent(pageRedirect)
  if (pageRedirect = "") Then pageRedirect = CStr(Request.ServerVariables("URL"))
  If (InStr(1, UC_redirectPage, "?", vbTextCompare) = 0 And Request.QueryString <> "") Then
    MM_newQS = "?"
    For Each Item In Request.QueryString
      If (Item <> "vbRedirect") and (Item <> "MM_Logoutnow") Then
        If (Len(MM_newQS) > 1) Then MM_newQS = MM_newQS & "&"
        MM_newQS = MM_newQS & Item & "=" & Server.URLencode(Request.QueryString(Item))
      End If
    Next
    if (Len(MM_newQS) > 1) Then pageRedirect = pageRedirect & MM_newQS
	redirectContent = pageRedirect
  End If
end function


MM_Logout = CStr(Request.ServerVariables("URL")) & "?MM_Logoutnow=1&vbRedirect="&GetFileName()&"&"&Request.ServerVariables("QUERY_STRING")
If (CStr(Request("MM_Logoutnow")) = "1") Then
  Session.Contents.Remove("MM_Username")
  Session.Contents.Remove("MM_rsEmail")
  Session.Contents.Remove("MM_UserAuthorization")
  Session.Contents.Remove("MM_UserID")
  Session.Contents.Remove("MM_Userphone")
  Session.Contents.Remove("MM_Useraddress")
  MM_logoutRedirectPage = "index.asp"
  ' redirect with URL parameters (remove the "MM_Logoutnow" query param).

	if Request.QueryString("vbRedirect") <> "" then 'Dieu huong co muc dich
		Response.Redirect(redirectContent(Request.QueryString("vbRedirect")))	
	else
		Response.Redirect(MM_logoutRedirectPage)
	end if
End If

Function queryAction(stringQuery)

	Dim queryActionCmd
	Set queryActionCmd = Server.CreateObject ("ADODB.Command")
	queryActionCmd.ActiveConnection = MM_Connect_STRING
	queryActionCmd.CommandText = stringQuery
	queryActionCmd.Prepared = true
	queryActionCmd.Execute
	queryActionCmd.ActiveConnection.Close
End Function

Function getValuequery(nameValue,tb,wheretb)

	Dim getValuequeryCmd
	Dim arrayQuery(10)
	Set getValuequeryCmd = Server.CreateObject ("ADODB.Command")
	getValuequeryCmd.ActiveConnection = MM_Connect_STRING
	getValuequeryCmd.CommandText = "Select "&nameValue&" from "&tb&" "&wheretb
	getValuequeryCmd.Prepared = true
	Dim rsgetValuequery
	Set rsgetValuequery = getValuequeryCmd.Execute
	Dim nameColumnS
	nameColumnS = Replace(nameValue,"Count(*) as ","")
	nameColumnS = Replace(nameColumnS,"'","")
	getNamecolumn = Split(nameColumnS,",")
	dim objectQuery
	set objectQuery = CreateObject("Scripting.Dictionary")
	if not rsgetValuequery.EOF or not rsgetValuequery.BOF then
		For i = LBound(getNamecolumn) To UBound(getNamecolumn)  
			objectQuery.add getNamecolumn(i), rsgetValuequery.Fields.Item(getNamecolumn(i)).value
		Next
		set getValuequery = objectQuery
	else 
		objectQuery.add "Null","True"
		set getValuequery = objectQuery
	end if
	getValuequeryCmd.ActiveConnection.Close
End Function

Dim stringQuery ' khai bao chuoi query sql
Dim quantity
Dim quantityQuery
Dim cart
function addItem(productid) 'ham them 1 san pham vao gio hang
	'Khoi tao cac session
	productID = CStr(productid)

	if productid <> "" and isNumeric(productid) = "True" then 
		if Session("MM_UserID") <> "" then
			set quantityQuery = getValuequery("quantity","dbo.tb_basket","where productID = "&productid&" And userID = "&Session("MM_UserID"))
			if (not quantityQuery.Exists("Null"))  then
				quantity = quantityQuery.Item("quantity")
			end if
		end if
		

		if(Not IsObject(Session("Cart"))) then
			set cart=CreateObject("Scripting.Dictionary")
		else 
			set cart=Session("Cart")
		end if
		'Neu san pham chua co trong gio hang
		if (cart.Exists(productid) <> "True") then
			if getItemCount() < 10 then
				cart.Add productid,"1"
			else
				Session("statusBasket") = "Bạn chỉ được mua tối đa 10 loại sản phẩm"
			end if
		else
			cart.Item(productid)=(CInt(cart.Item(productid))+1)
		end if
		
		if (quantityQuery.Exists("Null")) then
			if getItemCount() < 10 then
				stringQuery = "INSERT INTO dbo.tb_basket values ("&CInt(Session("MM_UserID"))&","&CInt(productid)&", 1)"
				queryAction(stringQuery)
			else
				Session("statusBasket") = "Bạn chỉ được mua tối đa 10 loại sản phẩm"
			end if
		else
				stringQuery = "Update dbo.tb_basket SET quantity = "&quantity+1&" WHERE productID = '"&CInt(productid)&"' And userID = '"&CInt(Session("MM_UserID"))&"' "
				queryAction(stringQuery)
		end if
	end if
		set Session("Cart")=cart
End function
function removeItem(productid) 'ham xoa 1 san pham ra khoi gio hang

	productid = CStr(productid)
	set cart=Session("Cart")
	if cart.Exists(productid) then
	
		cart.Remove(productid)
	end if
	if Session("MM_UserID") <> "" then
		stringQuery = "Delete From dbo.tb_basket WHERE productID="&productId
		queryAction(stringQuery)
	end if
	set Session("Cart")=cart
End function
function clearAllItem() 'xoa het gio hang

	set cart=Session("Cart")
	cart.RemoveAll()
	if Session("MM_UserID") <> "" then
		stringQuery = "Delete From dbo.tb_basket WHERE userID="&Session("MM_UserID")
		queryAction(stringQuery)
	end if
	set Session("Cart")=cart
End Function
function changeItem(productid,num) 'cap nhat so luong 1 san pham

	set cart=Session("Cart")
	'Neu san pham khong co trong gio hang
	productid = CStr(productid)
	
	if(getQuantity(productid)  = 0) then
		removeItem(productid)
	else
		cart.Item(productid)=(CInt(cart.Item(productid))+num)
		if Session("MM_UserID") <> "" then
			set quantityQuery = getValuequery("quantity","dbo.tb_basket","where productID = "&productid&" And userID = "&Session("MM_UserID"))
			if (not quantityQuery.Exists("Null")) then
				quantity = quantityQuery.Item("quantity")
				if quantity > 0 and quantity < 11 then 
					stringQuery = "Update dbo.tb_basket SET quantity = "&CInt(quantity+num)&" WHERE productID = '"&productid&"' And userID = "&Session("MM_UserID")
					queryAction(stringQuery)
				else
					Session("statusBasket") = "Mỗi loại sản phẩm bạn chỉ mua được tối đa 10"
				end if
			end if
		end if
		if(getQuantity(productid)  = 0) then
			removeItem(productid)
		end if
	end if
	set Session("Cart")=cart
End Function
function getQuantity(productid) 'lay so luong cua 1 san pham
	set cart=Session("Cart")
	productId = Cstr(productid)
	getQuantity = (cart.Item(productid))
	if Session("MM_UserID") <> "" then
		set quantityQuery = getValuequery("quantity","dbo.tb_basket","where productID = "&productid&" And userID = '"&Cint(Session("MM_UserID"))&"' ")
		getQuantity = quantityQuery.Item("quantity")
	end if
End Function
function getItemCount() 'dem so san pham trong gio hang

	set cart=Session("Cart")
	getItemCount = cart.Count
	if Session("MM_UserID") <> "" then
		set quantityQuery = getValuequery("Count(*) as 'Count'","dbo.tb_basket","where userID = "&Session("MM_UserID"))
		getItemCount = quantityQuery.Item("Count")
	end if
End Function

function updateShoppingCart() 'cap nhat gio hang
	set cart=Session("Cart")
	Dim updateValue
	colKeys = cart.Keys
	For Each strKey in colKeys
		if strKey <> "" then
			fieldName = "qty_"&strKey
			updateValue= Cstr(Request(fieldName))

			if Mid(updateValue,1,1) = "0" then
				updateValue= Mid(updateValue,2)
			end if
			if Not IsNumeric(updateValue) then
				cart.Remove(strKey)
			end if
			if (updateValue <> "") then
				if(updateValue > 0 and updateValue < 11 ) then
					cart.Item(strKey)=updateValue
					if Session("MM_UserID") <> "" then
						stringQuery = "Update dbo.tb_basket SET quantity = "&updateValue&" WHERE productID = "&strKey&" And userID = "&Session("MM_UserID")
						queryAction(stringQuery)
					end if
				else
					Session("statusBasket") = "Mỗi loại sản phẩm bạn chỉ mua được tối đa 10"
				end if
			end if
			'loai bo cac so 0 dau chuoi
		end if
	Next
End Function

if(NOT IsObject(Session("Cart"))) then
	set Session("Cart") = CreateObject("Scripting.Dictionary")
	set cart = Session("Cart")
else 
	set cart = Session("Cart")
end if
' Truyền ID sản phẩm vào giỏ hàng
if Session("MM_UserID") <> "" then

	colKeys = cart.Keys
	For Each strKey in colKeys
		set quantityQuery = getValuequery("quantity","dbo.tb_basket","where productID = "&strKey&" And userID = "&Session("MM_UserID"))
		if (quantityQuery.Exists("Null")) then
				stringQuery = "INSERT INTO dbo.tb_basket values ("&CInt(Session("MM_UserID"))&","&strKey&","&CInt(cart.Item(strKey))&")"
				queryAction(stringQuery)
		end if
	Next	
end if

'Kiểm tra xem có sản phẩm để thêm vào giỏ hàng
if Request("ID") <> "" then
	set quantityQuery = getValuequery("productID","dbo.tb_product","where productID = "&Request("ID"))
	if (not quantityQuery.Exists("Null")) then
		if Request("option")<> "" then'them 1 sp vao gio hang
			if Request("option")="add" then 
				addItem(Request("ID"))
			elseif Request("option")="remove" then 'xoa 1 sp khoi gio hang
				removeItem(Request("ID"))
			elseif Request("option")="plusQuantity" then 'cap nhat gio hang
				changeItem Request("ID"),CInt("1") 
			elseif Request("option")="subtractQuantity" then
				changeItem Request("ID"),CInt("-1") 
			end if
		end if
	else
		Session("statusBasket") = "Sản phẩm này không tồn tại!"
	end if
end if

if Request("option")="clear" then 'xoa het gio hang
	clearAllItem()
elseif Request("option")="update" then 'cap nhat gio hang
	updateShoppingCart()
end if

if Request("delCommentID") <> "" then
	dim id_comment : id_comment = Request("delCommentID")
	if IsNumeric(id_comment) then
		if Session("MM_UserAuthorization") = "True" then
			stringQuery = "Delete From dbo.tb_comment WHERE parentId="&id_comment&" Delete From dbo.tb_comment WHERE cm_ID = "&id_comment
		else
			stringQuery = "Delete From dbo.tb_comment WHERE parentId="&id_comment&" and userID = "&Session("MM_UserID")&" Delete From dbo.tb_comment WHERE cm_ID = "&id_comment&" and userID = "&Session("MM_UserID")
		end if
		queryAction(stringQuery)
	end if
end if
' Xac nhan don hang
if Request("confirmOrder") <> "" and Request("valueConfirm") <> "" then
	dim id_order : id_order = Request("confirmOrder")
	if IsNumeric(id_order) and IsNumeric(Request("valueConfirm")) then
		if Session("MM_UserAuthorization") = "True" then
			stringQuery = "Update dbo.tb_order set status = "&Request("valueConfirm")&"  WHERE orderId="&id_order
		queryAction(stringQuery)
		end if
	end if
end if
function boxProduct (id,name,price,newArrival,img,inventory)
%>
	<div class="col-sm-4">
		<div class="product-image-wrapper">
			<div class="single-products">
				<div class="productinfo text-center boxc">
					<img class="contentc" src="<%=img%>" alt="">
					<% if newArrival = "True" then %>
					<img src="images/home/new.png" class="new" alt="" style="width: 42px;">                                       <% end if %>   
					<h2><%=price %> VNĐ</h2>
					<p> <a href="product-detail.asp?productID=<%=id%>"><%=name%></a></p>
		<% if inventory = "True" then %>
		<a href="?option=add&ID=<%=id%>" class="btn btn-default add-to-cart"><i class="fa fa-shopping-cart"></i>Thêm vào giỏ hàng</a>
		<% else %>
			<a href="#" class="btn btn-default add-to-cart not"><i class="fa fa-times"></i> Chưa có hàng</a>
		<% end if %>
				</div>
			</div>
		</div>
	</div>
<%
end function
%>
