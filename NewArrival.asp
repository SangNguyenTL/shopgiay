<!--#include file="header.asp" -->
<%
Dim rsNewArrival
Dim rsNewArrival_cmd
Dim rsNewArrival_numRows
Dim newArr
	If (Request.QueryString("newArrival") <> "") then
		newArr = Request.QueryString("newArrival")
	End if
Set rsNewArrival_cmd = Server.CreateObject ("ADODB.Command")
rsNewArrival_cmd.ActiveConnection = MM_Connect_STRING
rsNewArrival_cmd.CommandText = "SELECT * FROM dbo.tb_product Where newArrival = '" &newArr&"' " 
rsNewArrival_cmd.Prepared = true

Set rsNewArrival = rsNewArrival_cmd.Execute
rsNewArrival_numRows = 0
%>
<!-- dynamic table -->
<%
Dim Repeat2__numRows
Dim Repeat2__index

Repeat2__numRows = 10
Repeat2__index = 0
rsNewArrival_numRows = rsNewArrival_numRows + Repeat2__numRows
%>
<section>
		<div class="container">
			<div class="row">
					<div class="features_items"><!--features_items-->
					<%
					If newArr="True" then
						newArr = "Sản phẩm mới"
					End if
					%>
						<h2 class="title text-center">Kết quả tìm kiếm <%= newArr %></h2>
						<div class="col-sm-12 form-horizontal">
						<div class="form-group">
		    <% 
							While ((Repeat2__numRows <> 0) AND (NOT rsNewArrival.EOF)) 
			%>
								<div class="col-sm-4">
								<div class="product-image-wrapper">
								<div class="single-products">                          		 									
                                   <div class="productinfo text-center">
          									<img src="<%=(rsNewArrival.Fields.Item("image").Value)%>" height="300" width="150"/>                                               
											<h2><%=(rsNewArrival.Fields.Item("price").Value)%>đ</h2>                                             
											<p><%=(rsNewArrival.Fields.Item("proName").Value)%></p>
											<a href="#" class="btn btn-default add-to-cart"><i class="fa fa-shopping-cart"></i>Thêm vào giỏ hàng</a>
									</div>										
						    	</div>							
						    	</div>
						        </div>
			<% 
							Repeat2__index=Repeat2__index+1
							Repeat2__numRows=Repeat2__numRows-1
							rsNewArrival.MoveNext()
							Wend
						
			%>
    

	
						</div>
						</div>	
					</div><!--features_items-->

            </div>
		</div>
</section>
	
<!--#include file="footer.asp" -->
<%
rsNewArrival.Close()
Set rsNewArrival = Nothing
%>
