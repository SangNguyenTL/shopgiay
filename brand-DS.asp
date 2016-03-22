<!--#include file="header.asp" -->
<%
Dim rs1__MMColParam
rs1__MMColParam = "1"
If (Request.QueryString("brandName") <> "") Then 
  rs1__MMColParam = Request.QueryString("brandName")
End If

Dim rs1
Dim rs1_cmd
Dim rs1_numRows

Set rs1_cmd = Server.CreateObject ("ADODB.Command")
rs1_cmd.ActiveConnection = MM_Connect_STRING
rs1_cmd.CommandText = "SELECT * FROM dbo.tb_Brand WHERE brandName = ?" 
rs1_cmd.Prepared = true
rs1_cmd.Parameters.Append rs1_cmd.CreateParameter("param1", 200, 1, 50, rs1__MMColParam) ' adVarChar

Set rs1 = rs1_cmd.Execute
rs1_numRows = 1
rsm_numRows = 4

if rs1.EOF or Request.QueryString("brandName") = "" then 
	Response.Redirect("index.asp")
else 



%>
    <%
Dim rsSP
Dim rsSP_cmd
Dim rsSP_numRows

Set rsSP_cmd = Server.CreateObject ("ADODB.Command")
rsSP_cmd.ActiveConnection = MM_Connect_STRING
rsSP_cmd.CommandText = "SELECT * FROM dbo.tb_product WHERE brandName = ?" 
rsSP_cmd.Prepared = true
rsSP_cmd.Parameters.Append rsSP_cmd.CreateParameter("param1", 200, 1, 50, rs1__MMColParam) ' adVarChar

Set rsSP = rsSP_cmd.Execute
rsSP_numRows = 9
	if not rsSP.EOF then
		brandName = rsSP.Fields.Item("brandName").Value
	end if
end if
%>

<section id="slider">
  <div class="container">
    <div class="row">
      <div class="col-sm-12">
	  <% imgsBrand = Split(rs1.Fields.Item("logo").value,",")
	  if uBound(imgsBrand) > 0 then	  %>
        <div id="slider-carousel" class="carousel slide" data-ride="carousel">
          <ol class="carousel-indicators">
            <li data-target="#slider-carousel" data-slide-to="0" class="active"></li>
            <li data-target="#slider-carousel" data-slide-to="1"></li>
          </ol>
          <div class="carousel-inner">
		  <% for each img in imgsBrand
			if img = uBound(imgsBrand) then %>
            <div class="item active">
			<%else%>
			<div class="item">
			<% end if %>
              <img src="<%img%>" class="girl img-responsive" alt="" />
			</div>
		<% next %>
          <a href="#slider-carousel" class="left control-carousel hidden-xs" data-slide="prev"> <i class="fa fa-angle-left"></i> </a> <a href="#slider-carousel" class="right control-carousel hidden-xs" data-slide="next"> <i class="fa fa-angle-right"></i> </a>
		</div>
		<% end if %>
      </div>
    </div>
  </div>
</section>
<section>
  <div class="container">
    <div class="row">
<div class="box">
<div class="page-header text-center"><img src="<%=(rs1.Fields.Item("logo").Value)%>" height="200" width="250"/></div>
  <div class="box-body well"><%=(rs1.Fields.Item("brandDS").Value)%>
      </div>
</div>

  <% if not rsSP.EOF then %> 
    <div class="recommended_items"><!--new arrival for woman-->
						<h2 class="title text-center">Một số sản phẩm thuộc thương hiệu <%=brandName%></h2>
						<P>
						</BR>
						
						<div id="recommended-item-carousel2" class="carousel slide" data-ride="carousel"  data-interval="false">
							<div class="carousel-inner">
                             
								
                                  <% 
								  i =0
								 While ((NOT rsSP.EOF))
									idProduct = rsSP.Fields.Item("productId").value
									nameProduc=rsSP.Fields.Item("proName").value
									priceProduc=rsSP.Fields.Item("price").value
									newArrivalProduc=rsSP.Fields.Item("newArrival").value
									imgsProduc=Split(rsSP.Fields.Item("image").value,",")
									inventoryProduc=rsSP.Fields.Item("inventory").value

									if i = 0 then  %>
                                  <div class="item active">	
                                  <% elseif i mod 3 = 0 then %>
								  </div><div class="item">
								  <% end if	 %>
									<%=boxProduct(idProduct,nameProduc,priceProduc,newArrivalProduc,imgsProduc(0),inventoryProduc) %>
<%									
									if rsSP.AbsolutePosition = rsSP.EOF then %>
                                    </div>
								<% end if
								 i=i+1
								  Repeathai__index=Repeathai__index+1
								  Repeathai__numRows=Repeathai__numRows-1
								  rsSP.MoveNext()
								Wend
								rsSP.Close()
								Set rsSP = Nothing
%>
                                                    

												
							</div>
							
				
						</div>							  <a class="left recommended-item-control" href="#recommended-item-carousel2" data-slide="prev">
								<i class="fa fa-angle-left"></i>
							  </a>
							  <a class="right recommended-item-control" href="#recommended-item-carousel2" data-slide="next">
								<i class="fa fa-angle-right"></i>
							  </a>
	  </div><!--/recommended_items-->	<% end if %>
   <div class="col-sm-12 text-center "> <a class="m-b-sm btn btn-primary" href="search.asp?brandNameS=<%=rs1.Fields.Item("brandName").value%>">Tìm thêm sản phẩm của thương hiệu này</a>
	</div></div>

  </div>
  
</section>
<%
rs1.Close()
Set rs1 = Nothing
%>
<!--#include file="footer.asp" -->

