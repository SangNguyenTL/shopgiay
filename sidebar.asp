<%

' tao record set  lay brandname
Dim rsBrand
Dim rsBrand_cmd
Dim rsBrand_numRows

Set rsBrand_cmd = Server.CreateObject ("ADODB.Command")
rsBrand_cmd.ActiveConnection = MM_Connect_STRING
rsBrand_cmd.CommandText = "SELECT * FROM dbo.tb_Brand" 
rsBrand_cmd.Prepared = true

Set rsBrand = rsBrand_cmd.Execute
rsBrand_numRows = 0
 

<!-- tao bang dynamic table liet ke thuong hieu vao sidebar -->

Dim Repeat2__numRows
Dim Repeat2__index

Repeat2__numRows = -1
Repeat2__index = 0
rsBrand_numRows = rsBrand_numRows + Repeat2__numRows

 %>

        		<div class="col-sm-3">
					<div class="left-sidebar">	
						<h2>Thương hiệu</h2>
						
						<div class="panel-group category-products" id="accordian"><!--category-productsr-->
                               <% While ((Repeat2__numRows <> 0) AND (NOT rsBrand.EOF)) 
							   'tao recordset  để  đếm số sản phẩm thuộc 1 thương hiệu
								Dim rsCountProduct
								Dim rsCountProduct_cmd
								Dim rsCountProduct_numRows
								Dim Count_total

								Set rsCountProduct_cmd = Server.CreateObject ("ADODB.Command")
								rsCountProduct_cmd.ActiveConnection = MM_Connect_STRING
								rsCountProduct_cmd.CommandText = "SELECT Count(*) AS CountPro FROM dbo.tb_product WHERE brandName = '"&(rsBrand.Fields.Item("brandName").Value)&"' " 
								rsCountProduct_cmd.Prepared = true

								Set rsCountProduct = rsCountProduct_cmd.Execute
								rsCountProduct_numRows = 0
								Count_total = rsCountProduct.Fields.Item("CountPro").Value
								rsCountProduct.Close()
								set rsCountProduct = Nothing
%>
							<div class="panel panel-default">
								<div class="panel-heading">
									<h4 class="panel-title">
										<a class="collapsed" href="brand-ds.asp?brandName=<%=(rsBrand.Fields.Item("brandName").Value)%>">
											<span class="pull-right"><%=Count_total%></span><%=(rsBrand.Fields.Item("brandName").Value)%>
										</a>
									</h4>
								</div>
							</div>					
								
					<%  Repeat2__index=Repeat2__index+1
                      Repeat2__numRows=Repeat2__numRows-1
                      rsBrand.MoveNext()
                   	Wend
				  %>						
						</div><!--/category-products-->					
						<div class="brands_products"><!--brands_products-->
							<h2>Khác</h2>
							
								
							
							<div class="panel-heading">
									<h4 class="panel-title"><a href="search.asp?newArrivalS=1">Sản phẩm mới</a></h4>
								</div>
						</div><!--/brands_products-->
			
					</div>
				</div>
                <%
rsBrand.Close()
Set rsBrand = Nothing
%>
