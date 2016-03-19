<%@LANGUAGE="VBSCRIPT"%>
<!--#include file="Connections/Connect.asp" -->
<%
Dim brandName : brandName = Request("brandName")
	Dim MM_abortEdit ,MM_editajaxbrand
	Dim Repeat__numRows
	Dim Repeat__index
	Dim MM_editajaxbrand__numRows
		
	 MM_abortEdit = false
If (CStr(brandName <> "")) Then

  If (Not MM_abortEdit) Then
    ' execute the delete
    Set MM_editajaxbrandCmd = Server.CreateObject ("ADODB.Command")
    MM_editajaxbrandCmd.ActiveConnection = MM_Connect_STRING
    MM_editajaxbrandCmd.CommandText = "Select * FROM dbo.tb_product WHERE brandName = '"&brandName&"'"
   ' MM_editajaxbrandCmd.Parameters.Append MM_editajaxbrandCmd.CreateParameter("param1", 5, 1, -1, productname) ' adDouble
     set MM_editajaxbrand = MM_editajaxbrandCmd.Execute
	 
	    
		Repeat__numRows = 4
		Repeat__index = 0
		 MM_editajaxbrand__numRows = 0
		 
While ((Repeat__numRows <> 0) AND NOT (MM_editajaxbrand.EOF))  
									Hinh = Split(MM_editajaxbrand.Fields.Item("image").Value,",")
									Gia = MM_editajaxbrand.Fields.Item("price").Value
									TenSP = MM_editajaxbrand.Fields.Item("proName").Value
									id = MM_editajaxbrand.Fields.Item("productID").Value
									inventory = MM_editajaxbrand.Fields.Item("inventory").Value
%>
										<div class="col-sm-3">
											<div class="product-image-wrapper">
												<div class="single-products">
													<div class="productinfo text-center boxc">
														<img class="contentc" src="<%=Hinh(0)%>" alt="">
														<% if newArrival = "True" then %>
														<img src="images/home/new.png" class="new" alt="" style="width: 42px;">                                       <% end if %>   
														<h2> <%=Gia %> VNĐ</h2>
														<p> <%=TenSP%></p>
											<% if inventory = "True" then %>
											<a href="?option=add&ID=<%=id%>" class="btn btn-default add-to-cart"><i class="fa fa-shopping-cart"></i>Thêm vào giỏ hàng</a>
											<% else %>
												<a href="#" class="btn btn-default add-to-cart"><i class="fa fa-times"></i>Chưa có hàng</a>
											<% end if %>
													</div>
												</div>
											</div>
										</div>

								<% 
										Repeat__index=Repeat__index+1
										Repeat__numRows=Repeat__numRows-1
										i = i + 1
										MM_editajaxbrand.MoveNext()
										Wend
										MM_editajaxbrand.Close()
										Set MM_editajaxbrand = Nothing 
  End If
End If
%>
