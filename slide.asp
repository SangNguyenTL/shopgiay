<%
Dim rsHangNgauNhien
Dim rsHangNgauNhien_cmd
Dim rsHangNgauNhien_numRows

Set rsHangNgauNhien_cmd = Server.CreateObject ("ADODB.Command")
rsHangNgauNhien_cmd.ActiveConnection = MM_Connect_STRING
rsHangNgauNhien_cmd.CommandText = "SELECT * FROM dbo.tb_product order by newid()" 
rsHangNgauNhien_cmd.Prepared = true

Set rsHangNgauNhien = rsHangNgauNhien_cmd.Execute
rsHangNgauNhien_numRows = 6
%>
<section id="slider">
		<div class="container">
			<div class="row">
				<div class="col-sm-12">
					<div id="slider-carousel" class="carousel slide" data-ride="carousel">
						<ol class="carousel-indicators">
							<li data-target="#slider-carousel" data-slide-to="0" class="active"></li>
							<li data-target="#slider-carousel" data-slide-to="1"></li>
							<li data-target="#slider-carousel" data-slide-to="2"></li>
						</ol>
						
						<div class="carousel-inner">
									
								<% 	
											i = 0
								While ((Repeat1__numRows <> 0) AND (NOT rsHangNgauNhien.EOF))  
									imgs = Split(rsHangNgauNhien.Fields.Item("image").Value,",")
									price = rsHangNgauNhien.Fields.Item("price").Value
									nameProduct = rsHangNgauNhien.Fields.Item("proName").Value
									brandName = rsHangNgauNhien.Fields.Item("brandName").Value
									inventory = rsHangNgauNhien.Fields.Item("inventory").Value
									id = rsHangNgauNhien.Fields.Item("productID").Value
									If i = 0 then
										%><div class="item active"><%
										else 
										%><div class="item">
										<% end if %>
												<div class="col-sm-6">
													<h1><a href="product-detail.asp?productID=<%=id%>"><%=nameProduct%></a></h1>
													<h2><a href="brand-ds.asp?brandName=<%=brandName%>"><%=brandName%></a>
													</h2>
													<p><%=rsHangNgauNhien.Fields.Item("prodescrible").Value%></p>
											<% if inventory = "True" then %>
											<a href="?option=add&ID=<%=id%>" class="btn btn-default add-to-cart"><i class="fa fa-shopping-cart"></i>Thêm vào giỏ hàng</a>
											<% else %>
												<a href="#" class="btn btn-default add-to-cart"><i class="fa fa-times"></i>Chưa có hàng</a>
											<% end if %>
												</div>
												<div class="col-sm-6">
													<img src="<%=imgs(0)%>" class="girl img-responsive" alt="" />
												</div>
											</div>

								<% 
										i = i + 1
										rsHangNgauNhien.MoveNext()
										Wend
										rsHangNgauNhien.Close()
										Set rsHangNgauNhien = Nothing %>
							
						</div>
						
						<a href="#slider-carousel" class="left control-carousel hidden-xs" data-slide="prev">
							<i class="fa fa-angle-left"></i>
						</a>
						<a href="#slider-carousel" class="right control-carousel hidden-xs" data-slide="next">
							<i class="fa fa-angle-right"></i>
						</a>
					</div>
					
				</div>
			</div>
		</div>
	</section>