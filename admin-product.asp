<!--#include file="header-admin.asp" -->
<%
Dim MM_action
Dim namePro
Dim image
Dim brandName
Dim price
Dim inventory
Dim newArrival
Dim prodescrible
Dim proID
Dim MM_editRedirectUrl
Dim MM_productAction
Dim checkNew2 
Dim checkNew1
Dim checkIve2
Dim checkIve1
Dim buttonForm
MM_editRedirectUrl = GetFileName()
namePro = HTMLEncode(Request.Form("txtNamepro"))
image = HTMLEncode(Request.Form("ProPic"))
brandName = HTMLEncode(Request.Form("txtBrand"))
price = Request.Form("txtPrice")
inventory = CInt(Request.Form("radioInventory"))
newArrival = CInt(Request.Form("optionsNewArrival"))
prodescrible = HTMLEncode(Request.Form("txtDes"))
' Create the FileUploader

If (Request.QueryString("action") = "") or (Request.QueryString("action") = "add") then
	MM_action = "add"
	MM_editRedirectUrl = "admin-list-product.asp"
	buttonForm = "Thêm sản phẩm"
	MM_productAction = CStr(Request.ServerVariables("SCRIPT_NAME"))
	If (Request.QueryString <> "") Then
	  MM_productAction = MM_productAction & "?" & HTMLEncode("action=add")
	End If

	If (CStr(Request("MM_action")) = "add") Then
		If Len(namePro) < 6 or Len(namePro) > 100 then
			Session("statusProduct") = "Tên sản phẩm phải từ 6 đến 100 ký tự!"
		Elseif Len(image) < 1 or Len(image) > 600 then
			Session("statusProduct") = "Bạn phải thêm ảnh, và chuỗi ảnh nằm trong khoảng 600 ký tự!"
		Elseif Len(brandName) = 0 then
			Session("statusProduct") = "Thương hiệu không được bỏ trống"
		Elseif (price < 10000 or price > 9999999) and IsNumeric(price) = "False" then
			Session("statusProduct") = "Giá thành không được để trống, là chữ số và nằm trong khoảng  từ 5 đến 7 chữ số!"
		Elseif Len(prodescrible) > 2000 then
			Session("statusProduct") = "Mô tả sản phẩm chỉ gồm 2000 ký tự!"
		Elseif inventory = "" then
			Session("statusProduct") = "Tình trạng sản phẩm không được để trống!"
		Elseif newArrival = "" then
			Session("statusProduct") = "Trạng thái sản phẩm không được để trống!"
		Else
			' execute the insert
			Dim MM_addproductCmd
			Set MM_addproductCmd = Server.CreateObject ("ADODB.Command")
			MM_addproductCmd.ActiveConnection = MM_Connect_STRING
			MM_addproductCmd.CommandText = "INSERT INTO dbo.tb_product (proName, image, brandName, price, prodescrible, inventory, newArrival, dateEntry) VALUES (N'"&namePro&"', N'"&image&"', N'"&brandName&"', "&price&", N'"&prodescrible&"', '"&inventory&"', '"&newArrival&"','"&Now()&"')" 
			MM_addproductCmd.Prepared = true
			MM_addproductCmd.Execute
			MM_addproductCmd.ActiveConnection.Close
			Session("statusProduct") = "Thêm sản phẩm thành công!"
			Response.Redirect(MM_editRedirectUrl)
		End If
	End If
Elseif Request.QueryString("action") = "edit" then
	MM_action = "edit"
	buttonForm = "Cập nhật sản phẩm"
	MM_productAction = CStr(Request.ServerVariables("SCRIPT_NAME"))
	If (Request.QueryString <> "") Then
	  MM_productAction = MM_productAction & "?" & HTMLEncode("action=edit&productID="&Request.QueryString("productID"))
	End If
	' Dat bien lay ID product
	Dim Recordset1__MMColParam
	Recordset1__MMColParam = "1"
	If (Request.QueryString("productID") <> "") Then 
	  Recordset1__MMColParam = Request.QueryString("productID")
	End If
	' Lay danh ten san pham qua query string productID
	Dim Recordset1
	Dim Recordset1_cmd
	Dim Recordset1_numRows
	proID = Request("productID")
	Set Recordset1_cmd = Server.CreateObject ("ADODB.Command")
	Recordset1_cmd.ActiveConnection = MM_Connect_STRING
	Recordset1_cmd.CommandText = "SELECT * FROM dbo.tb_product WHERE productID = '"&proID&"' " 
	Recordset1_cmd.Prepared = true

	Set Recordset1 = Recordset1_cmd.Execute
	Recordset1_numRows = 0
	' khai bao gia tri cho cac bien cua mat hang
	If (CStr(Request("MM_action")) = "edit") Then
		If Len(namePro) < 6 or Len(namePro) > 100 then
			Session("statusProduct") = "Tên sản phẩm phải từ 6 đến 100 ký tự!"
		Elseif Len(image) < 1 or Len(image) > 600 then
			Session("statusProduct") = "Bạn phải thêm ảnh, và chuỗi ảnh nằm trong khoảng 600 ký tự!"
		Elseif Len(brandName) = 0 then
			Session("statusProduct") = "Thương hiệu không được bỏ trống"
		Elseif (price < 10000 or price > 9999999) and IsNumeric(price) = "False" then
			Session("statusProduct") = "Giá thành không được để trống, là chữ số và nằm trong khoảng  từ 5 đến 7 chữ số!"
		Elseif Len(prodescrible) > 2000 then
			Session("statusProduct") = "Mô tả sản phẩm chỉ gồm 2000 ký tự!"
		Elseif inventory = "" then
			Session("statusProduct") = "Tình trạng sản phẩm không được để trống!"
		Elseif newArrival = "" then
			Session("statusProduct") = "Trạng thái sản phẩm không được để trống!"
		Else
			Dim MM_editCmd

			Set MM_editCmd = Server.CreateObject ("ADODB.Command")
			MM_editCmd.ActiveConnection = MM_Connect_STRING
			MM_editCmd.CommandText = "UPDATE dbo.tb_product SET proName = N'"&namePro&"', image = N'"&image&"', brandName = N'"&brandName&"', price = "&price&", prodescrible = N'"&prodescrible&"', inventory = '"&inventory&"', newArrival = '"&newArrival&"' WHERE productID = '"&proID&"' " 
			MM_editCmd.Prepared = true
			MM_editCmd.Execute
			MM_editCmd.ActiveConnection.Close

			' append the query string to the redirect URL

			If (Request.QueryString <> "") Then
			  If (InStr(1, MM_editRedirectUrl, "?", vbTextCompare) = 0) Then
				MM_editRedirectUrl = MM_editRedirectUrl & "?" & Request.QueryString
			  Else
				MM_editRedirectUrl = MM_editRedirectUrl & "&" & Request.QueryString
			  End If
			End If
			Session("statusProduct") = "Cập nhật sản phẩm thành công!"
			Response.Redirect(MM_editRedirectUrl)
		End If
	End If
	If (Not Recordset1.EOF) OR (Not Recordset1.BOF) then
		namePro = (Recordset1.Fields.Item("proName").Value)
		price = (Recordset1.Fields.Item("price").Value)
		brandName = (Recordset1.Fields.Item("brandName").Value)
		image = (Recordset1.Fields.Item("image").Value)
		prodescrible = (Recordset1.Fields.Item("prodescrible").Value)
		inventory = (Recordset1.Fields.Item("inventory").Value)
		newArrival = (Recordset1.Fields.Item("newArrival").Value)
		proID =  (Recordset1.Fields.Item("productID").Value)
		Recordset1.Close()
		Set Recordset1 = Nothing
	else
		Response.Redirect("admin-list-product.asp")
	end if
End If
'Lay danh sach thuong hieu
Dim Recordset2
Dim Recordset2_cmd
Dim Recordset2_numRows

Set Recordset2_cmd = Server.CreateObject ("ADODB.Command")
Recordset2_cmd.ActiveConnection = MM_Connect_STRING
Recordset2_cmd.CommandText = "SELECT * FROM dbo.tb_Brand" 
Recordset2_cmd.Prepared = true

Set Recordset2 = Recordset2_cmd.Execute
Recordset2_numRows = 0
%>
   <section class="content">
      <!-- /.row -->
      <div class="row">
        <div class="col-xs-12">
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
		<div class="box box-info">
            <div class="box-header with-border">
              <h3 class="box-title"><%=buttonForm%></h3>
			  <%
			  If Session("statusProduct") <> "" then
				Response.Write("<p class='alert alert-info page-header'>"&Session.Contents("statusProduct")&"</p>")
				Session.Contents.Remove("statusProduct")
			  End If
			  %>
            </div>
            <div class="box-body">

             <form ACTION="<%=MM_productAction%>" METHOD="POST" id="form1" role="form" name="form1">
                <!-- text input -->
                <!-- input states -->
                <input type="hidden" name="MM_action" value="<%=MM_action%>">
               <div class="form-group  col-xs-12">
                 <label>Tên sản phẩm(*)</label>
                 <input name="txtNamepro" type="text" required pattern=".{6,100}" class="form-control" placeholder="Nhập tên sản phẩm và phải từ 6 đến 100 ký tự" value="<%=namePro%>">
                </div>
                <div class="form-group col-xs-12">
                  <label>Ảnh(*)</label>
                  <input name="ProPic" type="text" class="form-control" pattern=".{1,600}"  value="<%=image%>" title="Hãy nhập ảnh và nằm trong khoảng 600 ký tự, mỗi link ảnh cách nhau bằng dấu ','">
                    <div class="imageProduct m-t-sm" style="clear: both;"></div>
                </div>
                <div class="form-group col-xs-6">
                  <label>Nhà sản xuất(*)</label>
                  <select name="txtBrand" class="form-control" required title="Hãy chọn nhà sản xuất">
					<option value="">Chọn nhà sản xuất</option>
                          <%	
While (NOT Recordset2.EOF)
	dim selectedBrand
	If Recordset2.Fields.Item("brandName").Value = brandName then
		selectedBrand = "selected"
	else 
		selectedBrand = ""
	End If
%>
                    <option <%=selectedBrand%> value="<%=(Recordset2.Fields.Item("brandName").Value)%>"><%=(Recordset2.Fields.Item("brandName").Value)%></option>
                    <%
  Recordset2.MoveNext()
Wend
If (Recordset2.CursorType > 0) Then
  Recordset2.MoveFirst
Else
  Recordset2.Requery
End If

If inventory = "True" then
	checkIve1 = "checked"
End If
If inventory = "False" then
	checkIve2 = "checked"
End If
If newArrival = "True" then
	checkNew1 = "checked"
End If
If newArrival = "False" then
	checkNew2 = "checked"
End If
%>
                  </select>
                </div>
                <div class="form-group col-xs-3">
                  <label>Giá (VNĐ) (*)</label>
                  <input name="txtPrice" type="text" required class="form-control" placeholder="Hãy nhập giá sản phẩm và phải là số" pattern="[\d]+" value="<%=price%>" title="Hãy nhập giá sản phẩm và phải là số">
                </div>
                <!-- textarea -->
                <div class="form-group col-xs-12">
                  <label>Mô tả</label>
                  <textarea name="txtDes" class="form-control" maxlength="50" rows="3" placeholder="Nhập mô tả" ><%=prodescrible%></textarea>
                </div>
                <div class="form-group col-xs-6">
                  <div class="radio">
                    <label>
                      <input type="radio" name="radioInventory"  value="1" <%=checkIve1%> required>
                      Còn hàng(*)
                    </label>
                  </div>
                  <div class="radio">
                    <label>
                      <input type="radio" name="radioInventory" value="0" <%=checkIve2%> required>
                      Hết hàng(*)
                    </label>
                  </div>
                </div>
                <div class="form-group col-xs-6">
                  <div class="radio">
                    <label>
                      <input type="radio" name="optionsNewArrival"  value="1" <%=checkNew1%> required>
                      Hàng mới(*)
                    </label>
                  </div>
                  <div class="radio">
                    <label>
                      <input type="radio" name="optionsNewArrival" value="0" <%=checkNew2%> required>
                      Hàng cũ(*)
                    </label>
                  </div>
                </div>
                
				<div class="form-group col-xs-12">
                (*)Bắt buộc</br>
                </br>
				<button type="submit" class="btn btn-primary"><%=buttonForm%></button>
				</div>
             </form>
          </div>
        </div>
       </div>
      </div>
     </section>
    <!-- /.content --> 
<!--#include file="footer-admin.asp" -->

