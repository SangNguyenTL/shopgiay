
<!--#include file="header.asp" -->



<!-- tao rs -->
<%
if Request.QueryString("productID") = "" or not IsNumeric(Request.QueryString("productID")) then
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
		Session("proName") = proName
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


If (CStr(Request("MM_insert")) = "comment") Then
  If (Not MM_abortEdit) Then
    ' execute the insert
    Dim MM_editCmd
	Dim plusquery
	Dim message : message = HTMLEncode(Request.Form("message"))
	if Len(message) > 300 then
		Session("statusComment") = "Bình luận của bạn không được quá 300 ký tự!"
	else
		if Request.QueryString("parentID") <> "" then
			queryComment = "INSERT INTO dbo.tb_comment (proID, userID, cmContent, parentID,datePost) VALUES ('"&id&"','"&Session("MM_UserID")&"', N'"&message&"', "&Request.QueryString("parentID")&",getDate())"
		else 	
			queryComment = "INSERT INTO dbo.tb_comment (proID, userID, cmContent, datePost) VALUES ('"&id&"','"&Session("MM_UserID")&"', N'"&message&"', getDate())"
		end if
		Set MM_editCmd = Server.CreateObject ("ADODB.Command")
		MM_editCmd.ActiveConnection = MM_Connect_STRING
		MM_editCmd.CommandText = queryComment 
		MM_editCmd.Prepared = true
		MM_editCmd.Execute
		MM_editCmd.ActiveConnection.Close
		
	end if
    ' append the query string to the redirect URL
	if Request.QueryString("vbRedirect") <> "" then 'Dieu huong co muc dich
		Response.Redirect(redirectContent(Request.QueryString("vbRedirect")))	
	else
		Response.Redirect("product-detail.asp?productID="&Request.QueryString("productID"))
	end if
  End If
End If

Dim rsComment
Dim rsComment_cmd
Dim rsComment_numRows

Set rsComment_cmd = Server.CreateObject ("ADODB.Command")
rsComment_cmd.ActiveConnection = MM_Connect_STRING
rsComment_cmd.CommandText = "SELECT * FROM dbo.tb_comment as cm LEFT JOIN dbo.tb_user as userv On cm.userId = userv.userId left join dbo.tb_product as pr on pr.productId = cm.proID where pr.productID="&Request.QueryString("productID")&" and cm.parentID is Null order by cm.datePost DESC"
rsComment_cmd.Prepared = true

Set rsComment = rsComment_cmd.Execute
rsComment_numRows = 0


else
	Response.Redirect("index.asp") 
end if	
%>
<%
Dim Repeat1__numRows
Dim Repeat1__index

Repeat1__numRows = 10
Repeat1__index = 0
rsComment_numRows = rsComment_numRows + Repeat1__numRows
%>
<%
'  *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

Dim rsComment_total
Dim rsComment_first
Dim rsComment_last

' set the record count
rsComment_total = rsComment.RecordCount

' set the number of rows displayed on this page
If (rsComment_numRows < 0) Then
  rsComment_numRows = rsComment_total
Elseif (rsComment_numRows = 0) Then
  rsComment_numRows = 1
End If

' set the first and last displayed record
rsComment_first = 1
rsComment_last  = rsComment_first + rsComment_numRows - 1

' if we have the correct record count, check the other stats
If (rsComment_total <> -1) Then
  If (rsComment_first > rsComment_total) Then
    rsComment_first = rsComment_total
  End If
  If (rsComment_last > rsComment_total) Then
    rsComment_last = rsComment_total
  End If
  If (rsComment_numRows > rsComment_total) Then
    rsComment_numRows = rsComment_total
  End If
End If
%>
<!-- xoa-->
<%
Dim MM_paramName 
%>
<%
' *** Move To Record and Go To Record: declare variables

Dim MM_rs
Dim MM_rsCount
Dim MM_size
Dim MM_uniqueCol
Dim MM_offset
Dim MM_atTotal
Dim MM_paramIsDefined

Dim MM_param
Dim MM_index

Set MM_rs    = rsComment
MM_rsCount   = rsComment_total
MM_size      = rsComment_numRows
MM_uniqueCol = ""
MM_paramName = ""
MM_offset = 0
MM_atTotal = false
MM_paramIsDefined = false
If (MM_paramName <> "") Then
  MM_paramIsDefined = (Request.QueryString(MM_paramName) <> "")
End If
%>
<%
' *** Move To Record: handle 'index' or 'offset' parameter

if (Not MM_paramIsDefined And MM_rsCount <> 0) then

  ' use index parameter if defined, otherwise use offset parameter
  MM_param = Request.QueryString("index")
  If (MM_param = "") Then
    MM_param = Request.QueryString("offset")
  End If
  If (MM_param <> "") Then
    MM_offset = Int(MM_param)
  End If

  ' if we have a record count, check if we are past the end of the recordset
  If (MM_rsCount <> -1) Then
    If (MM_offset >= MM_rsCount Or MM_offset = -1) Then  ' past end or move last
      If ((MM_rsCount Mod MM_size) > 0) Then         ' last page not a full repeat region
        MM_offset = MM_rsCount - (MM_rsCount Mod MM_size)
      Else
        MM_offset = MM_rsCount - MM_size
      End If
    End If
  End If

  ' move the cursor to the selected record
  MM_index = 0
  While ((Not MM_rs.EOF) And (MM_index < MM_offset Or MM_offset = -1))
    MM_rs.MoveNext
    MM_index = MM_index + 1
  Wend
  If (MM_rs.EOF) Then 
    MM_offset = MM_index  ' set MM_offset to the last possible record
  End If

End If
%>
<%
' *** Move To Record: if we dont know the record count, check the display range

If (MM_rsCount = -1) Then

  ' walk to the end of the display range for this page
  MM_index = MM_offset
  While (Not MM_rs.EOF And (MM_size < 0 Or MM_index < MM_offset + MM_size))
    MM_rs.MoveNext
    MM_index = MM_index + 1
  Wend

  ' if we walked off the end of the recordset, set MM_rsCount and MM_size
  If (MM_rs.EOF) Then
    MM_rsCount = MM_index
    If (MM_size < 0 Or MM_size > MM_rsCount) Then
      MM_size = MM_rsCount
    End If
  End If

  ' if we walked off the end, set the offset based on page size
  If (MM_rs.EOF And Not MM_paramIsDefined) Then
    If (MM_offset > MM_rsCount - MM_size Or MM_offset = -1) Then
      If ((MM_rsCount Mod MM_size) > 0) Then
        MM_offset = MM_rsCount - (MM_rsCount Mod MM_size)
      Else
        MM_offset = MM_rsCount - MM_size
      End If
    End If
  End If

  ' reset the cursor to the beginning
  If (MM_rs.CursorType > 0) Then
    MM_rs.MoveFirst
  Else
    MM_rs.Requery
  End If

  ' move the cursor to the selected record
  MM_index = 0
  While (Not MM_rs.EOF And MM_index < MM_offset)
    MM_rs.MoveNext
    MM_index = MM_index + 1
  Wend
End If
%>
<%
' *** Move To Record: update recordset stats

' set the first and last displayed record
rsComment_first = MM_offset + 1
rsComment_last  = MM_offset + MM_size

If (MM_rsCount <> -1) Then
  If (rsComment_first > MM_rsCount) Then
    rsComment_first = MM_rsCount
  End If
  If (rsComment_last > MM_rsCount) Then
    rsComment_last = MM_rsCount
  End If
End If

' set the boolean used by hide region to check if we are on the last record
MM_atTotal = (MM_rsCount <> -1 And MM_offset + MM_size >= MM_rsCount)
%>
<%
' *** Go To Record and Move To Record: create strings for maintaining URL and Form parameters

Dim MM_keepNone
Dim MM_keepURL
Dim MM_keepForm
Dim MM_keepBoth

Dim MM_removeList
Dim MM_item
Dim MM_nextItem

' create the list of parameters which should not be maintained
MM_removeList = "&index="
If (MM_paramName <> "") Then
  MM_removeList = MM_removeList & "&" & MM_paramName & "="
End If

MM_keepURL=""
MM_keepForm=""
MM_keepBoth=""
MM_keepNone=""

' add the URL parameters to the MM_keepURL string
For Each MM_item In Request.QueryString
  MM_nextItem = "&" & MM_item & "="
  If (InStr(1,MM_removeList,MM_nextItem,1) = 0) Then
    MM_keepURL = MM_keepURL & MM_nextItem & Server.URLencode(Request.QueryString(MM_item))
  End If
Next

' add the Form variables to the MM_keepForm string
For Each MM_item In Request.Form
  MM_nextItem = "&" & MM_item & "="
  If (InStr(1,MM_removeList,MM_nextItem,1) = 0) Then
    MM_keepForm = MM_keepForm & MM_nextItem & Server.URLencode(Request.Form(MM_item))
  End If
Next

' create the Form + URL string and remove the intial '&' from each of the strings
MM_keepBoth = MM_keepURL & MM_keepForm
If (MM_keepBoth <> "") Then 
  MM_keepBoth = Right(MM_keepBoth, Len(MM_keepBoth) - 1)
End If
If (MM_keepURL <> "")  Then
  MM_keepURL  = Right(MM_keepURL, Len(MM_keepURL) - 1)
End If
If (MM_keepForm <> "") Then
  MM_keepForm = Right(MM_keepForm, Len(MM_keepForm) - 1)
End If

' a utility function used for adding additional parameters to these strings
Function MM_joinChar(firstItem)
  If (firstItem <> "") Then
    MM_joinChar = "&"
  Else
    MM_joinChar = ""
  End If
End Function
%>
<%
' *** Move To Record: set the strings for the first, last, next, and previous links

Dim MM_keepMove
Dim MM_moveParam
Dim MM_moveFirst
Dim MM_moveLast
Dim MM_moveNext
Dim MM_movePrev

Dim MM_urlStr
Dim MM_paramList
Dim MM_paramIndex
Dim MM_nextParam

MM_keepMove = MM_keepBoth
MM_moveParam = "index"

' if the page has a repeated region, remove 'offset' from the maintained parameters
If (MM_size > 1) Then
  MM_moveParam = "offset"
  If (MM_keepMove <> "") Then
    MM_paramList = Split(MM_keepMove, "&")
    MM_keepMove = ""
    For MM_paramIndex = 0 To UBound(MM_paramList)
      MM_nextParam = Left(MM_paramList(MM_paramIndex), InStr(MM_paramList(MM_paramIndex),"=") - 1)
      If (StrComp(MM_nextParam,MM_moveParam,1) <> 0) Then
        MM_keepMove = MM_keepMove & "&" & MM_paramList(MM_paramIndex)
      End If
    Next
    If (MM_keepMove <> "") Then
      MM_keepMove = Right(MM_keepMove, Len(MM_keepMove) - 1)
    End If
  End If
End If

' set the strings for the move to links
If (MM_keepMove <> "") Then 
  MM_keepMove = HTMLEncode(MM_keepMove) & "&"
End If

MM_urlStr = Request.ServerVariables("URL") & "?" & MM_keepMove & MM_moveParam & "="

MM_moveFirst = MM_urlStr & "0"
MM_moveLast  = MM_urlStr & "-1"
MM_moveNext  = MM_urlStr & CStr(MM_offset + MM_size)
If (MM_offset - MM_size < 0) Then
  MM_movePrev = MM_urlStr & "0"
Else
  MM_movePrev = MM_urlStr & CStr(MM_offset - MM_size)
End If
dim rsCommentCountQuantity
dim rsCommentCount
set rsCommentCountQuantity = getValuequery("Count(*) as 'Count'","dbo.tb_comment","where proID = "&Request.QueryString("productID"))
rsCommentCount = rsCommentCountQuantity.Item("Count")
%>

<section>
		<div class="container">
			<div class="row">
			<!--#include file="sidebar.asp" -->
<div class="col-sm-9 padding-right">
					<div class="product-details"><!--product-details-->
						<div class="col-sm-5">
							<div class="view-product">
								<img  id="zoom_01" src="<%=imgs(0)%>" data-zoom-image="<%=imgs(0)%>" alt="">
								<% If newArrival = "True" then %>
								<img src="images/home/new.png" alt="">	
								<% end if %>
								
							</div>
						 <div id="similar-product" class="carousel slide" data-ride="carousel">
								    <div class="carousel-inner" id="gallery_01f">
                                    	
<%
Dim increeImg : increeImg = 0

		dim activeimage 
for each img in imgs
	If increeImg = 0 then
		activeimage = "active"
		%><div class="item active"><%
	else 
		activeimage = ""
	end if
	if (increeImg mod 3) = 0  and increeImg <> 0 then
		%></div><div class="item">
		<% end if %>		
		 
<a href="#" class="elevatezoom-gallery <%=activeimage%>" data-image="<%=img%>" 
data-zoom-image="<%=img%>"> <img  src="<%=img%>"  style="width:85px; height:85px;"/> </a><%
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
							<div class="page-header">
								<h2><%=proName%></h2></div>
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

								<li class="active"><a href="#reviews" data-toggle="tab">Bình luận (<%=rsCommentCount%>)</a></li>
							</ul>
						</div>
						<div class="tab-content">
							<div class="tab-pane fade" id="details">
								<div class="well">
									<%=Describle%>
								</div>
							</div>
							
						
														
							<div class="tab-pane fade active in" id="reviews">
								<div id="content-comments">
				<%
				if Session("statusComment") <> "" then
				%>
					<div class="alert alert-danger"><%=Session("statusComment")%></div>
				<%
					Session.Contents.Remove("statusComment")
				end if
				%>
                              <% 
							  While ((Repeat1__numRows <> 0) AND (NOT rsComment.EOF)) %>
									<div class="col-sm-12" id="<%=rsComment.Fields.Item("cm_ID").value%>"><ul>
										<li><a href="user-info.asp?email=<%=rsComment.Fields.Item("email").value%>"><i class="fa fa-user"></i><%=rsComment.Fields.Item("fullName").value%></a></li>
										<li><a href=""><i class="fa fa-calendar-o"></i> <%=rsComment.Fields.Item("datePost").value%></a></li>
										<% if Session("MM_UserID") <> "" then %>
											<li><a class="rep-comment" href="?productId=<%=id%>&parentID=<%=rsComment.Fields.Item("cm_ID").value%>"><i class="fa fa-comments"></i> Trả lời</a></li>
										<% end if %>
										<% if Cint(Session("MM_UserID")) = Cint(rsComment.Fields.Item("userID").value) or Session("MM_UserAuthorization") = "True" then%>
											<li><a class="del-comment"  href="?delCommentID=<%=rsComment.Fields.Item("cm_ID").value%>"><i class="fa fa-times"></i> Xóa</a></li>
										<% end if %>
									</ul>
									<blockquote><%=rsComment.Fields.Item("cmContent").value%></blockquote></div>
									
                                 <% dim child_Comment
								dim rschildComment
								dim rschildComment_numRows
									set child_Comment = Server.CreateObject ("ADODB.Command")
									child_Comment.ActiveConnection = MM_Connect_STRING
									child_Comment.CommandText = "SELECT TOP 5 * FROM dbo.tb_comment as cm LEFT JOIN dbo.tb_user as userv On cm.userId = userv.userId left join dbo.tb_product as pr on pr.productId = cm.proID where pr.productID="&Request.QueryString("productID")&" and cm.parentID ="&rsComment.Fields.Item("cm_ID").value&"  order by cm.datePost DESC"
									child_Comment.Prepared = true

									Set rschildComment = child_Comment.Execute
									rschildComment_numRows = 0
									While (NOT rschildComment.EOF) %>
									<div class="col-sm-11 pull-right" id="<%=rschildComment.Fields.Item("cm_ID").value%>"><ul>
										<li><a href="user-info.asp?email=<%=rschildComment.Fields.Item("email").value%>"><i class="fa fa-user"></i><%=rschildComment.Fields.Item("fullName").value%></a></li>
										<li><a class="rep-comment" href=""><i class="fa fa-calendar-o"></i> <%=rschildComment.Fields.Item("datePost").value%></a></li>
										<% if Session("MM_UserID") = rschildComment.Fields.Item("cm_ID").value or Session("MM_UserAuthorization") = "True" then%>
											<li><a class="del-comment" href="?productID=<%=Request.QueryString("productID")%>&delCommentID=<%=rschildComment.Fields.Item("cm_ID").value%>"><i class="fa fa-times"></i> Xóa</a></li>
										<% end if %>
									</ul>
									<blockquote><%=rschildComment.Fields.Item("cmContent").value%></blockquote></div>
									
                                 <%
										rschildComment.MoveNext()
									Wend
									rschildComment.Close()
									Set rschildComment = Nothing
								   RepeatComment__index=RepeatComment__index+1
									  Repeat1__numRows=Repeat1__numRows-1
									  rsComment.MoveNext()
									Wend
									rsComment.Close()
									Set rsComment = Nothing
								    %>
								<% if Session("MM_username") <> "" then %>
								<form name="form1" id="checkform" class="checkform row" METHOD="POST" action="<%=MM_addComment%>">
								 	<textarea  name="message" id="message"  pattern="(.){10,70}" placeholder="<%if Request.QueryString("parentID") = "" then %>Nội dung tin nhắn<%
									else 
									Response.Write("Trả lời cho comment có ID ="&Request.QueryString("parentID"))
									end if %>"></textarea>
								  <input type="submit" name="submit" class="btn btn-primary pull-right" value="Gửi"></button>
                                  <input type="hidden" name="MM_insert" value="comment">
                                </form>
                                <% else %>
									<div class="col-sm-12">
									<p class="alert alter-warning">Bạn phải <a href="login.asp?vbRedirect=<%=GetFileName()&"&"&Request.ServerVariables("QUERY_STRING")%>">đăng nhập</a> mới được bình luận!</p>
									<% end if %>
								  </div>
							  </div>
							  </div>
        <div class="col-sm-7">
        <div class="dataTables_paginate paging_simple_numbers">
        <ul class="pagination">
        <% If MM_offset <> 0 Then %><li class="paginate_button"><a href="<%=MM_moveFirst%>">Đầu tiên</a></li><% End If %>
        <% If MM_offset <> 0 Then %><li class="paginate_button"><a href="<%=MM_movePrev%>">Trước</a></li><% End If %>
        <% If Not MM_atTotal Then %><li class="paginate_button "><a href="<%=MM_moveNext%>">Kế</a></li><% End If %>
		<% If Not MM_atTotal Then %><li class="paginate_button"><a href="<%=MM_moveLast%>">Cuối</a></li><% End If %>
        </ul>
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
