
<!--#include file="header.asp" -->



<!-- tao rs -->
<%
if Request.QueryString("productId") = "" then
	Response.Redirect("index.asp") 
end if

Dim MM_addComment
MM_addComment = CStr(Request.ServerVariables("SCRIPT_NAME"))
If (Request.QueryString <> "") Then
  MM_addComment = MM_addComment & "?" & Server.HTMLEncode(Request.QueryString)
End If

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
		Dim id : id = rsProductDetail.Fields.Item("productID").Value
' boolean to abort record edit
Dim MM_abortEdit
MM_abortEdit = false

' IIf implementation
Function MM_IIf(condition, ifTrue, ifFalse)
  If condition = "" Then
    MM_IIf = ifFalse
  Else
    MM_IIf = ifTrue
  End If
End Function

If (CStr(Request("MM_insert")) = "form1") Then
  If (Not MM_abortEdit) Then
    ' execute the insert
    Dim MM_editCmd

    Set MM_editCmd = Server.CreateObject ("ADODB.Command")
    MM_editCmd.ActiveConnection = MM_Connect_STRING
    MM_editCmd.CommandText = "INSERT INTO dbo.tb_comment (proID, userID, cmContent, datePost) VALUES ('"&id&"','"&Session("MM_UserID")&"', N'"&Request.Form("message")&"', getDate())" 
    MM_editCmd.Prepared = true
    MM_editCmd.Execute
    MM_editCmd.ActiveConnection.Close

    ' append the query string to the redirect URL
    Dim MM_editRedirectUrl
    MM_editRedirectUrl = "product-detail.asp"
    If (Request.QueryString <> "") Then
      If (InStr(1, MM_editRedirectUrl, "?", vbTextCompare) = 0) Then
        MM_editRedirectUrl = MM_editRedirectUrl & "?" & Request.QueryString
      Else
        MM_editRedirectUrl = MM_editRedirectUrl & "&" & Request.QueryString
      End If
    End If
    Response.Redirect(MM_editRedirectUrl)
  End If
End If

Dim rsComment
Dim rsComment_cmd
Dim rsComment_numRows

Set rsComment_cmd = Server.CreateObject ("ADODB.Command")
rsComment_cmd.ActiveConnection = MM_Connect_STRING
rsComment_cmd.CommandText = "SELECT * FROM dbo.tb_comment as cm LEFT JOIN dbo.tb_user as userv On cm.userId = userv.userId left join dbo.tb_product as pr on pr.productId = cm.proID where pr.productID="&Request.QueryString("productID")  
rsComment_cmd.Prepared = true

Set rsComment = rsComment_cmd.Execute
rsComment_numRows = 10

Dim RepeatComment__numRows
Dim RepeatComment__index

RepeatComment__numRows = 10
RepeatComment__index = 0
rsComment_numRows = rsComment_numRows + RepeatComment__numRows

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
									<div class="col-12-sm">
										<% if inventory = "True" then %>
										<a href="?option=add&ID=<%=id%>" class="btn btn-default add-to-cart"><i class="fa fa-shopping-cart"></i>Thêm vào giỏ hàng</a>
										<% else %>
											<a href="#" class="btn btn-default add-to-cart"><i class="fa fa-times"></i>Chưa có hàng</a>
										<% end if %>
									</div>
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
                              <% While ((RepeatComment__numRows <> 0) AND (NOT rsComment.EOF)) %>
									<ul>
										<li><a href=""><i class="fa fa-user"></i><%=rsComment.Fields.Item("fullName").value%></a></li>
										<li><a href=""><i class="fa fa-calendar-o"></i> <%=rsComment.Fields.Item("datePost").value%></a></li>
									</ul>
									<p><%=rsComment.Fields.Item("cmContent").value%></p>

                                 <%
								   RepeatComment__index=RepeatComment__index+1
									  RepeatComment__numRows=RepeatComment__numRows-1
									  rsComment.MoveNext()
									Wend
								    %>
								<% if Session("MM_username") <> "" then %>
								<form name="form1" id="checkform" class="checkform row"   METHOD="POST" action="<%=MM_addComment%>">
								    <% if Request.QueryString("parentID") <> "" then %>
									<input type="hidden" name="parentID" value="<%=Request.QueryString("parentID")%>" />
									<% end if %>
								 	<textarea  name="message" id="message"  pattern="(.){10,70}" placeholder="Nội dung tin nhắn"></textarea>
								  <input type="submit" name="submit" class="btn btn-primary pull-right" value="Gửi"></button>
                                  <input type="hidden" name="MM_insert" value="form1">
                                </form>
                                <% else %>
                                <p class="alert alter-warning">Bạn phải <a href="login.asp">đăng nhập</a> mới được bình luận!</p>
                                <% end if %>
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
rsSPatTH_numRows = 6
%>

<!-- dynamic table cua  rsSPatTH-->

					<div class="recommended_items"><!--recommended_items-->
						<h2 class="title text-center">Sản phẩm cùng thương hiệu</h2>
						
						<div id="recommended-item-carousel" class="carousel slide" data-ride="carousel">
							<div class="carousel-inner">
							
									
								<% 	
										Dim TenSP , Gia ,  i
											i = 0
								While (NOT rsSPatTH.EOF)  
									Hinh = Split(rsSPatTH.Fields.Item("image").Value,",")
									Gia = rsSPatTH.Fields.Item("price").Value
									TenSP = rsSPatTH.Fields.Item("proName").Value
									newArrival = rsSPatTH.Fields.Item("newArrival").Value
									inventory =  rsSPatTH.Fields.Item("inventory").Value
									id = rsSPatTH.Fields.Item("productID").Value
									If i = 0 then
										%><div class="item active"><% end if 

										If i mod 3 = 0  and i <> 0 then
										%></div><div class="item">
										<% end if %>
										<%=boxProduct(id,TenSP,Gia,newArrival,Hinh(0),inventory)%>
										<%
										if rsSPatTH.AbsolutePosition = rsSPatTH.EOF then
										%></div><% end if %>

								<% 
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
