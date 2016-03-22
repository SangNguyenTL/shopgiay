<!--#include file="header.asp"-->
    <%
if getItemCount() = 0 then
	Response.Redirect("cart.asp")
end if
dim rsBaskettoCart
dim rsBaskettoCartCmd
dim stringCmdBasket
Dim stringProductId
Dim amountAll : amountAll = 0
Dim increAcart : increAcart = 0
set cart = Session("Cart")
if Session("MM_UserID") <> "" then
	set rsBaskettoCartCmd = Server.CreateObject ("ADODB.Command")
	rsBaskettoCartCmd.ActiveConnection = MM_Connect_STRING
	rsBaskettoCartCmd.CommandText = "SELECT * FROM dbo.tb_basket as bk left join dbo.tb_product as pr on pr.productID = bk.productID where userID ="&Session("MM_UserID")
	rsBaskettoCartCmd.Prepared = true
	Set rsBaskettoCart = rsBaskettoCartCmd.Execute
elseif cart.Count > "0" then
	set rsBaskettoCartCmd = Server.CreateObject ("ADODB.Command")
	rsBaskettoCartCmd.ActiveConnection = MM_Connect_STRING
	colKeys = cart.Keys
	For Each strKey in colKeys
		if(cart.Item(strKey)<>"") then
			if increAcart = 0  then
				stringProductId = strKey
			else
				stringProductId = stringProductId&","&strKey
			end if
		end if
		increAcart = increAcart + 1
	Next
	rsBaskettoCartCmd.CommandText = "SELECT * FROM dbo.tb_product where productID IN ("&stringProductId&") "
	rsBaskettoCartCmd.Prepared = true
	Set rsBaskettoCart = rsBaskettoCartCmd.Execute

end if

Dim quantityrsBaskettoCart

Dim MM_editCheckoutAction
MM_editCheckoutAction = CStr(Request.ServerVariables("SCRIPT_NAME"))
If (Request.QueryString <> "") Then
  MM_editCheckoutAction = MM_editCheckoutAction & "?" & Server.HTMLEncode(Request.QueryString)
End If

' boolean to abort record edit
Dim MM_abortEdit
MM_abortEdit = false

If (CStr(Request("MM_insert")) = "form1") Then
  If (Not MM_abortEdit) Then
    ' execute the insert
    Dim MM_editCheckoutCmd
	Dim emailRecipient : emailRecipient = HTMLEncode(Request.Form("email"))
	Dim nameRecipient : nameRecipient =  HTMLEncode(Request.Form("fullName"))
	Dim addressRecipient : addressRecipient =  HTMLEncode(Request.Form("address"))
	Dim phoneRecipient : phoneRecipient =  HTMLEncode(Request.Form("phone"))
	Dim noitice : noitice =  HTMLEncode(Request.Form("message"))
	Dim detail : detail =  Replace(Request.Form("detail"),"'","&#39;")
	Dim totalPrice : totalPrice =  HTMLEncode(Request.Form("totalPrice"))
	
	If Len(emailRecipient) < 6 or Len(emailRecipient) > 50 then
		Session("statusCheckout") = "Email người nhận phải từ 6 đến 50 ký tự!"
	elseif Len(nameRecipient) > 50 or Len(nameRecipient) < 3 then
		Session("statusCheckout")="Tên người nhận phải từ 3 đến 50 ký tự!"
	elseif Len(phoneRecipient) > 11 Or Len(phoneRecipient) < 8 then 
		Session("statusCheckout")="Số điện thoại phải từ 8 đến 11 chữ số, phải là số"
	elseif Len(addressRecipient) > 200 OR Len(addressRecipient) < 10 then
		Session("statusCheckout")="Địa chỉ phải nằm trong khoảng 10 đến 200 ký tự"
	elseif Len(noitice) > 500 then
		Session("statusCheckout")="Thông tin thêm phải nằm trong khoảng 500 ký tự"
	else
		Set MM_editCheckoutCmd = Server.CreateObject ("ADODB.Command")
		MM_editCheckoutCmd.ActiveConnection = MM_Connect_STRING
		
		MM_editCheckoutCmd.CommandText = "INSERT INTO dbo.tb_order (emailRecipient, nameRecipient, addressRecipient, phoneRecipient, noitice, status, dateOrder, userID, detail, totalPrice) VALUES (N'"&emailRecipient&"', N'"&nameRecipient&"', N'"&addressRecipient&"', '"&phoneRecipient&"', N'"&noitice&"', 0, getdate(), "&Session("MM_UserID")&", N'"&detail&"', "&totalPrice&" ) "
		MM_editCheckoutCmd.Prepared = true
		MM_editCheckoutCmd.Execute
		MM_editCheckoutCmd.ActiveConnection.Close
		clearAllItem()
	   ' append the query string to the redirect URL
		Session("statusCheckout")="Thành công! Xin vui lòng đợi chúng tôi liên hệ để xác nhận đơn hàng!"
	end if
 
  End If
End If
Dim totalPrice_perPro
%>
<section id="cart_items">			
			<%

if Session("statusCheckout") <> "" then
			if Session("statusCheckout") = "Thành công! Xin vui lòng đợi chúng tôi liên hệ để xác nhận đơn hàng!" then %>
			<div class="alert alert-success container">
			 <%=Session("statusCheckout")%>
			</div>
			<%
			else %>
			<div class="alert alert-danger container">
			 <%=Session("statusCheckout")%>
			</div>
			<% 
			end if 
			end if %>
		<div class="container">
			<div class="breadcrumbs">
				<ol class="breadcrumb">
				  <li><a href="<%=linkHome%>">Home</a></li>
				  <li class="active">Xác nhận giỏ hàng</li>
				</ol>
			</div><!--/breadcrums-->

	<%		
			if Session("MM_UserID") <> "" and Session("statusCheckout") <> "Thành công! Xin vui lòng đợi chúng tôi liên hệ để xác nhận đơn hàng!" then %>
			<div class="shopper-informations">
			
				<div class="row">
				
					<div class="col-sm-12 clearfix" >
						<div class="bill-to">
							<p>Điền thông tin người nhận:</p>
							
							<div class="form-one" style="width: 100%;">
							<form ACTION="<%=MM_editCheckoutAction%>" name="form1" METHOD="POST">
									<input name="email" type="text" placeholder="Email*" value="<%=Session("MM_rsEmail")%>" >
									<input type="hidden" name="detail" value='{"cart_detail":[<%
Dim Repeat11__index : Repeat11__index = 0
Do while (not rsBaskettoCart.EOF)
				img = Split(rsBaskettoCart.Fields.Item("image").value,",")
				if Session("MM_UserID") <> "" then
					quantityrsBaskettoCart = rsBaskettoCart.Fields.Item("quantity").value
				elseif not cart is nothing then
					quantityrsBaskettoCart = getQuantity(rsBaskettoCart.Fields.Item("productID").value)
				end if
					totalPrice_perPro = rsBaskettoCart.Fields.Item("price").value * quantityrsBaskettoCart
				if Repeat11__index = 0 then
%>{"img":"<%=img(0)%>","id":"<%=rsBaskettoCart.Fields.Item("productID").value%>","name":"<%=rsBaskettoCart.Fields.Item("proName").value%>","price":"<%=rsBaskettoCart.Fields.Item("price").value%>","quantity":"<%=quantityrsBaskettoCart%>","total":"<%=totalPrice_perPro%>"}<%
else
 %>,{"img":"<%=img(0)%>","id":"<%=rsBaskettoCart.Fields.Item("productID").value%>","name":"<%=rsBaskettoCart.Fields.Item("proName").value%>","price":"<%=rsBaskettoCart.Fields.Item("price").value%>","quantity":"<%=quantityrsBaskettoCart%>","total":"<%=totalPrice_perPro%>"}<%
 end if
				amountAll = amountAll + totalPrice_perPro	
				rsBaskettoCart.MoveNext
				Repeat11__index = Repeat11__index + 1
			Loop
 %>],"amountAll" : "<%=amountAll%>"}' />
									<input name="fullName" type="text" placeholder="Tên đầy đủ" value="<%=Session("MM_Username")%>" required pattern="(.){6,70}" title="Phải từ 6 đến 70 ký tự">
									<input name="address" type="text" placeholder="Địa chỉ" value="<%=Session("MM_Useraddress")%>" required pattern="(.){10,200}">
									<input type="tel" name="phone" placeholder="Điện thoại" value="<%=Session("MM_Userphone")%>" required pattern="(\d){8,11}">
									<input type="hidden" name="totalPrice" value="<%=amountAll%>">
						<div class="order-message">
							<p>Thông tin thêm</p>
							<textarea name="message" placeholder="Những lưu ý thêm mà bạn muốn nhắn với chúng tôi" rows="4"></textarea>
						</div>	
							
<button type="submit" class="btn btn-primary">Xác nhận</button>			
<a class="btn btn-primary" href="cart.asp">Quay lại giỏ hàng</a>
<input type="hidden" name="MM_insert" value="form1">
                            </form>
							</div>
						</div>
					</div>
					
			<div class="payment-options">
					<span>
						<label>Hình thức thanh toán:</label> Thanh toán với người vận chuyển
					</span>
				</div>		
				</div>
			</div>
			<% ENd if
			if Session("MM_UserID") = "" then
			%>
			<div class="step-one">
				<h2 class="heading">Bước 1</h2>
			</div>
<div class="checkout-options">
				<h3>Đăng nhập để có thể gửi đơn hàng</h3>
				<p>Lựa chọn</p>
				<ul class="nav">
					<li>
						<a href="login.asp?vbRedirect=<%=GetFileName()%>"><i class="fa fa-check"></i>Đăng nhập hoặc đăng ký</a>
					</li>
					<li>
						<a href="index.asp?option=clear"><i class="fa fa-times"></i>Hủy bỏ</a>
					</li>
				</ul>
			</div>
			<%
			end if %>
			<div class="review-payment">
				<h2>Xem thử & thanh toán hóa đơn</h2>
			</div>
<%
if getItemCount() > 0 then
%>
			<div class="table-responsive cart_info">
				<table class="table table-condensed">
					<thead>
						<tr class="cart_menu">
							<td class="image">Sản phẩm</td>
							<td class="description"></td>
							<td class="price">Giá</td>
							<td class="quantity">Số lượng</td>
							<td class="total">Tổng</td>
						</tr>
					</thead>
					<tbody>
<%
rsBaskettoCart.MoveFirst
			Do while (not rsBaskettoCart.EOF)
				img = Split(rsBaskettoCart.Fields.Item("image").value,",")
				if Session("MM_UserID") <> "" then
					quantityrsBaskettoCart = rsBaskettoCart.Fields.Item("quantity").value
				elseif not cart is nothing then
					quantityrsBaskettoCart = getQuantity(rsBaskettoCart.Fields.Item("productID").value)
				end if
					totalPrice_perPro = rsBaskettoCart.Fields.Item("price").value * quantityrsBaskettoCart
%>
						<tr>
							<td class="cart_product">
								<a href=""><img src="<%=img(0)%>" alt="" style="width:90px"></a>
							</td>
							<td class="cart_description">
								<h4><a href="product-detail.asp?productID=<%=rsBaskettoCart.Fields.Item("productID").value%>"><%=rsBaskettoCart.Fields.Item("proName").value%></a></h4>
							</td>
							<td class="cart_price">
								<p><%=rsBaskettoCart.Fields.Item("price").value%></p>
							</td>
							<td class="cart_quantity">
								<div class="cart_quantity_button">
									
									<input class="cart_quantity_input" type="text" name="qty_<%=rsBaskettoCart.Fields.Item("productID").value%>" value="<%=quantityrsBaskettoCart%>" autocomplete="off" size="2" disabled>
								</div>
							</td>
							<td class="cart_total">
								<p class="cart_total_price"><%=totalPrice_perPro%></p>
							</td>

						</tr>
<%				
				amountAll = amountAll + totalPrice_perPro	
				rsBaskettoCart.MoveNext
			Loop

 %>
						<tr>
							<td colspan="4">&nbsp;</td>
							<td colspan="2">
								<table class="table table-condensed total-result">
									<tr>
										<td>Tổng giá tiền của giỏ hàng</td>
										<td><%=amountAll%></td>
									</tr>
									<tr class="shipping-cost">
										<td>Phí vận chuyển</td>
										<td>Miễn phí</td>										
									</tr>
									<tr>
										<td>Thành tiền</td>
										<td><span><%=amountAll%></span></td>
									</tr>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
<%
else
%>
<div class="alert alert-warning container" >
Giỏ hàng trống</div>
<%
 end if
Session.Contents.Remove("statusCheckout")
 %>
		</div>
	</section> <!--/#cart_items-->

	

<!--#include file="footer.asp" -->