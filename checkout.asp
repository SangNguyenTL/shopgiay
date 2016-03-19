<!--#include file="header.asp"-->

	<section id="cart_items">
		<div class="container">
			<div class="breadcrumbs">
				<ol class="breadcrumb">
				  <li><a href="<%=linkHome%>">Home</a></li>
				  <li class="active">Xác nhận giỏ hàng</li>
				</ol>
			</div><!--/breadcrums-->
			<% if Session("MM_UserID") <> "" then %>
			<div class="shopper-informations">
			
				<div class="row">
				
					<div class="col-sm-4 clearfix" >
						<div class="bill-to">
							<p>Điền thông tin người nhận:</p>
							
							<div class="form-one" style="width: 100%;">
							<form>
									<input name="email" type="text" placeholder="Email*" value="<%=Session("MM_rsEmail")%>" >
									<input name="fullName" type="text" placeholder="Tên đầy đủ" value="<%=Session("MM_Username")%>">
									<input name="address" type="text" placeholder="Địa chỉ" value="<%=Session("MM_Useraddress")%>">
									<input type="text" name="phone" placeholder="Điện thoại" value="<%=Session("MM_Userphone")%>">
							
							</form>
							</div>
						</div>
					</div>
					<div class="col-sm-8">
						<div class="order-message">
							<p>Thông tin thêm</p>
							<textarea name="message"  placeholder="Notes about your order, Special Notes for Delivery" rows="16"></textarea>
							<label><input type="checkbox"> Gửi đến nơi như trong hóa đơn</label>
						</div>	
					</div>
					
			<div class="payment-options">
					<span>
						<label>Hình thức thanh toán:</label> Thanh toán với người vận chuyển
					</span>
				</div>	
<a class="btn btn-primary" href="">Xác nhận</a>			
<a class="btn btn-primary" href="cart.asp">Quay lại giỏ hàng</a>			
				</div>
			</div>
			<% else
			%>
			<div class="step-one">
				<h2 class="heading">Bước 1</h2>
			</div>
<div class="checkout-options">
				<h3>Đăng nhập để có thể gửi đơn hàng</h3>
				<p>Lựa chọn</p>
				<ul class="nav">
					<li>
						<a href="login.asp"><i class="fa fa-check"></i>Đăng nhập hoặc đăng ký</a>
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
if cart.count > 0 then
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
							<td></td>
						</tr>
					</thead>
					<tbody>
<%

			Do while (not rsBaskettoCart.EOF)
				img = Split(rsBaskettoCart.Fields.Item("image").value,",")
				if Session("MM_UserID") <> "" then
					quantityrsBaskettoCart = rsBaskettoCart.Fields.Item("quantity").value
				elseif not cart is nothing then
					quantityrsBaskettoCart = getQuantity(rsBaskettoCart.Fields.Item("productID").value)
				end if
					Dim totalPrice_perPro : totalPrice_perPro = rsBaskettoCart.Fields.Item("price").value * quantityrsBaskettoCart
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
							<td class="cart_delete">
								<a class="cart_quantity_delete" href="?option=remove&ID=<%=rsBaskettoCart.Fields.Item("productID").value%>"><i class="fa fa-times"></i></a>
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
 end if %>
		</div>
	</section> <!--/#cart_items-->

	

<!--#include file="footer.asp" -->