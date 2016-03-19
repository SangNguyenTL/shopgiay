
<!--#include file="header.asp" -->



<!-- tao rs -->
<%
if Request.QueryString("productId") = "" then
	Response.Redirect("index.asp") 
end if

Dim rsProductDetail
Dim rsProductDetail_cmd
Dim rsProductDetail_numRows

Set rsProductDetail_cmd = Server.CreateObject ("ADODB.Command")
rsProductDetail_cmd.ActiveConnection = MM_Connect_STRING
rsProductDetail_cmd.CommandText = "SELECT * FROM dbo.tb_product where productId = "&Request.QueryString("productId") 
rsProductDetail_cmd.Prepared = true

Set rsProductDetail = rsProductDetail_cmd.Execute
rsProductDetail_numRows = 0
if not rsProductDetail.BOF then
		Dim proName : proName = rsProductDetail.Fields.Item("proName").Value
		Dim price : price = rsProductDetail.Fields.Item("price").Value
		Dim brandName : brandName = rsProductDetail.Fields.Item("brandName").Value
		Dim inventory : inventory = rsProductDetail.Fields.Item("inventory").Value
		If inventory = "True" then
			inventory = "Còn hàng"
		else
			inventory = "Hết hàng"
		End if
		Dim newArrival : newArrival = rsProductDetail.Fields.Item("newArrival").Value
		If newArrival = "True" then
			newArrival = "Hàng mới"
		else
			newArrival = "Hàng cũ"
		End if
		Dim Describle : Describle = rsProductDetail.Fields.Item("prodescrible").Value
		imgs = Split(rsProductDetail.Fields.Item("image").Value,",")
else
	Response.Redirect("index.asp") 
end if	
%>


<section>
		<div class="container">
			<div class="row">
			<!--#include file="sidebar.asp" -->
<div class="col-sm-9 padding-right">
					<div class="product-details"><!--product-details-->
						<div class="col-sm-5">
							<div class="view-product">
  
								<img src="<%=imgs(0)%>" alt="">
								<% If newArrival = "True" then %>
								<img src="images/home/new.png" alt="">	
								<% end if %>
								<h3>ZOOM</h3>
							</div>
						 <div id="similar-product" class="carousel slide" data-ride="carousel">
								    <div class="carousel-inner">
                                    	
<%
Dim increeImg : increeImg = 0
for each img in imgs
	If increeImg = 0 then
		%><div class="item active"><%
	end if
	if (increeImg mod 3) = 0  and increeImg <> 0 then
		%></div><div class="item">
		<% end if %>		
	<a href=""><img src="<%=img%>" alt="" style="width:85px; height:85px;"></a><%
	If increeImg = UBound(imgs) then
	%></div><%

	end if
	increeImg = increeImg +1
next
%>							
									</div>
								  <a class="left item-control" href="#similar-product" data-slide="prev">
									<i class="fa fa-angle-left"></i>
								  </a>
								   <a class="right item-control" href="#similar-product" data-slide="next">
									 <i class="fa fa-angle-right"></i>
								   </a>
							</div>  

						</div>
						
						<div class="col-sm-7">
							<div class="product-information"><!--/product-information-->
								<h2><%=proName%></h2>
								<div class="col-sm-12">
									<span class="col-12-sm"><span>Đơn giá: <%=price%> VNĐ</span></span>
									<form class="col-12-sm" method="post" action="<%=GetFileName()%>?productId=<%=Request.QueryString("productId")%>">
								
									 <span><!--span class="col-4-sm"><label class="h3">Số lượng:</label></span><span class="col-8-sm"><input name="numCart" type="text" value="1" class="form-control m-t-sm"></span-->
									<input type="hidden" name="ID" value="<%=Request.QueryString("productId")%>" >
									<input type="hidden"  name="option" value="add" >
									<button type="submit" class="btn btn-fefault cart pull-left"></span>
										<i class="fa fa-shopping-cart"></i>
										Thêm vào giỏ
									</button>
									</form>
								</div>
								<p><b>Trạng thái:</b> <%=newArrival%></p>
								<p><b>Tình trạng:</b> <%=inventory%></p>
								<p><b>Thương hiệu:</b> <%=brandName%></p>
								
							</div><!--/product-information-->
						</div>
					</div><!--/product-details-->
					
					<div class="category-tab shop-details-tab"><!--category-tab-->
						<div class="col-sm-12">
							<ul class="nav nav-tabs">
								<li><a href="#details" data-toggle="tab">Chi tiết</a></li>

								<li class="active"><a href="#reviews" data-toggle="tab">Bình luận (5)</a></li>
							</ul>
						</div>
						<div class="tab-content">
							<div class="tab-pane fade" id="details">
								<div class="well">
									<%=Describle%>
								</div>
							</div>
							
						
														
							<div class="tab-pane fade active in" id="reviews">
								<div class="col-sm-12">
									<ul>
										<li><a href=""><i class="fa fa-user"></i>Thành nhân</a></li>
										<li><a href=""><i class="fa fa-clock-o"></i>12:41 PM</a></li>
										<li><a href=""><i class="fa fa-calendar-o"></i>31 DEC 2014</a></li>
									</ul>
									<p>Tuyệt, giày đẹp lắm</p>
									<p><b>Viết nhận định của bạn</b></p>
									
									<form action="#">
										<span>
											<input type="text" placeholder="Your Name">
											<input type="email" placeholder="Email Address">
										</span>
										<textarea name=""></textarea>
										<button type="button" class="btn btn-default pull-right">
											Submit
										</button>
									</form>
								</div>
							</div>
							
						</div>
					</div><!--/category-tab-->
<!-- rs sap thuoc thuong hieu -->
<%
Dim rsSPatTH
Dim rsSPatTH_cmd
Dim rsSPatTH_numRows

Set rsSPatTH_cmd = Server.CreateObject ("ADODB.Command")
rsSPatTH_cmd.ActiveConnection = MM_Connect_STRING
rsSPatTH_cmd.CommandText = "SELECT * FROM dbo.tb_product WHERE brandName = '"&rsProductDetail.Fields.Item("brandName").Value&"' " 
rsSPatTH_cmd.Prepared = true

Set rsSPatTH = rsSPatTH_cmd.Execute
rsSPatTH_numRows = 0
%>

<!-- dynamic table cua  rsSPatTH-->
<%
Dim Repeat1__numRows
Dim Repeat1__index

Repeat1__numRows = 10
Repeat1__index = 0
rsSPatTH_numRows = rsSPatTH_numRows + Repeat1__numRows
%>
					<div class="recommended_items"><!--recommended_items-->
						<h2 class="title text-center">Sản phẩm cùng thương hiệu</h2>
						
						<div id="recommended-item-carousel" class="carousel slide" data-ride="carousel">
							<div class="carousel-inner">
									
								<% 	
										Dim TenSP , Gia , Hinh , i
											i = 0
								While ((Repeat1__numRows <> 0) AND (NOT rsSPatTH.EOF))  
									Hinh = Split(rsSPatTH.Fields.Item("image").Value,",")
									Gia = rsSPatTH.Fields.Item("price").Value
									TenSP = rsSPatTH.Fields.Item("proName").Value
									If i = 0 then
										%><div class="item active"><% end if 

										If i mod 3 = 0  and i <> 0 then
										%></div><div class="item">
										<% end if %>
										<div class="col-sm-4">
											<div class="product-image-wrapper">
												<div class="single-products">
													<div class="productinfo text-center">
														<img src="<%=Hinh(0)%>" alt="">
														<h2> <%=Gia %></h2>
														<p> <%=TenSP%></p>
													<a href="?option=add&ID=<%=rsSPatTH.Fields.Item("productID").value%>" class="btn btn-default add-to-cart"><i class="fa fa-shopping-cart"></i>Thêm vào giỏ hàng</a>
													</div>
												</div>
											</div>
										</div>
										<% 
										
										if rsSPatTH.AbsolutePosition = rsSPatTH.EOF then
										%></div><% end if %>

								<% 
										Repeat1__index=Repeat1__index+1
										Repeat1__numRows=Repeat1__numRows-1
										i = i + 1
										rsSPatTH.MoveNext()
										Wend
										rsSPatTH.Close()
										Set rsSPatTH = Nothing %>

							</div>
							 			
						</div>
													 <a class="left recommended-item-control" href="#recommended-item-carousel" data-slide="prev">
								<i class="fa fa-angle-left"></i>
							  </a>
							  <a class="right recommended-item-control" href="#recommended-item-carousel" data-slide="next">
								<i class="fa fa-angle-right"></i> </a>
					</div><!--/recommended_items-->
					
				</div>
            </div>
		</div>
	</section>
	
<!--#include file="footer.asp" -->
<%
rsProductDetail.Close()
Set rsProductDetail = Nothing
%>
