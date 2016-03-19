<%@LANGUAGE="VBSCRIPT"%>
<!--#include file="Connections/Connect.asp" -->
<%
Dim productname : productname = Request("productname")
	Dim MM_huychinhsua ,MM_findProduct
	Dim Repeat6__numRows
	Dim Repeat6__index
	Dim MM_findProduct__numRows
		
	 MM_huychinhsua = false
If (CStr(brandName <> "")) Then

  If (Not MM_huychinhsua) Then
    ' execute the delete
    Set MM_findProductCmd = Server.CreateObject ("ADODB.Command")
    MM_findProductCmd.ActiveConnection = MM_Connect_STRING
    MM_findProductCmd.CommandText = "Select * FROM dbo.tb_product WHERE productname = '"&productname&"'"
   ' MM_findProductCmd.Parameters.Append MM_findProductCmd.CreateParameter("param1", 5, 1, -1, productname) ' adDouble
     set MM_findProduct = MM_findProductCmd.Execute
	 
	    
		Repeat6__numRows = 4
		Repeat6__index = 0
		MM_findProduct__numRows = 0
			While ((Repeat6__numRows <> 0) AND NOT (MM_findProduct.EOF))  
					Hinh = Split(MM_findProduct.Fields.Item("image").Value,",")
					Gia = MM_findProduct.Fields.Item("price").Value
					TenSP = MM_findProduct.Fields.Item("proName").Value
%>
						<div class="col-sm-4">
							<div class="product-image-wrapper">
                            
								<div class="single-products">                               		 
									<div class="productinfo text-center">
          									<img src="<%= Hinh%>" alt="" />                                                
											<h2><%= Gia%></h2>                                             
											<p><%= TenSP%></p>
											<a href="#" class="btn btn-default add-to-cart"><i class="fa fa-shopping-cart"></i>Thêm vào giỏ hàng</a>
									</div>										
								</div>
							</div>
						</div>
<% 
										Repeat6__index=Repeat6__index+1
										Repeat6__numRows=Repeat6__numRows-1
										MM_findProduct.MoveNext()
										Wend
										MM_findProduct.Close()
										Set MM_findProduct = Nothing 
  End If
End If
%>