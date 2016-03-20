<!--#include file="header.asp"-->
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
if getItemCount() <> "0" then
%>
<div class="content">
<form method="post" action="?option=update" >
	<section id="cart_items">
		<div class="container">
			<div class="breadcrumbs">
				<ol class="breadcrumb">
				  <li><a href="#">Home</a></li>
				  <li class="active">Giỏ hàng</li>
				</ol>
			</div>
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
									<a class="cart_quantity_up" href="?option=plusQuantity&ID=<%=rsBaskettoCart.Fields.Item("productID").value%>"> + </a>
									<input class="cart_quantity_input" type="text" name="qty_<%=rsBaskettoCart.Fields.Item("productID").value%>" value="<%=quantityrsBaskettoCart%>" autocomplete="off" size="2">
									<a class="cart_quantity_down" href="?option=subtractQuantity&ID=<%=rsBaskettoCart.Fields.Item("productID").value%>"> - </a>
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
					</tbody>
				</table>
			</div>
		</div>
	</section> <!--/#cart_items-->

	<section id="do_action">
		<div class="container">
			<div class="row">
				<div class="col-sm-6">
			<div class="heading">
				<h3>Bạn đã chọn xong sản phẩm của mình?</h3>
				<p>Nếu có thay đổi giỏ hàng hãy click cập nhật!<br/> Xác nhận đơn hàng click <b>tiếp tục</b>!</p>
			</div>
				</div>
				<div class="col-sm-6">
					<div class="total_area">
						<ul>
							<li>Tổng giá tiền của giỏ hàng <span><%=amountAll%></span></li>
							<li>Phí vận chuyển <span>Miễn phí</span></li>
							<li>Thành tiền <span><%=amountAll%></span></li>
						</ul>
							<button class="btn btn-default update" name="update" type="submit">Cập nhật</button>
							<a class="btn btn-default check_out del-all" href="?option=clear">Xóa hết</a>
							<a class="btn btn-default check_out" href="checkout.asp">Tiếp tục</a>
					</div>
				</div>
			</div>
		</div>
	</section><!--/#do_action-->
</form><div>
<%
else
%><div class="count">
<div class="alert alert-warning container" >
Giỏ hàng trống</div>
	</div>
<%
 end if %>
<!--#include file="footer.asp"-->