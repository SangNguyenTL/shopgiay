<!--#include file="header.asp" -->
<%
Dim rsProductnew
Dim rsProductnew_cmd
Dim rsProductnew_numRows

Set rsProductnew_cmd = Server.CreateObject ("ADODB.Command")
rsProductnew_cmd.ActiveConnection = MM_Connect_STRING
rsProductnew_cmd.CommandText = "SELECT * FROM dbo.tb_product ORDER BY dateEntry DESC" 
rsProductnew_cmd.Prepared = true

Set rsProductnew = rsProductnew_cmd.Execute
rsProductnew_numRows = 0

%>
<%
Dim Repeat1__numRows
Dim Repeat1__index

Repeat1__numRows = 6
Repeat1__index = 0
rsProductnew_numRows = rsProductnew_numRows + Repeat1__numRows
'  *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

Dim rsProductnew_total
Dim rsProductnew_first
Dim rsProductnew_last

' set the record count
rsProductnew_total = rsProductnew.RecordCount

' set the number of rows displayed on this page
If (rsProductnew_numRows < 0) Then
  rsProductnew_numRows = rsProductnew_total
Elseif (rsProductnew_numRows = 0) Then
  rsProductnew_numRows = 1
End If

' set the first and last displayed record
rsProductnew_first = 1
rsProductnew_last  = rsProductnew_first + rsProductnew_numRows - 1

' if we have the correct record count, check the other stats
If (rsProductnew_total <> -1) Then
  If (rsProductnew_first > rsProductnew_total) Then
    rsProductnew_first = rsProductnew_total
  End If
  If (rsProductnew_last > rsProductnew_total) Then
    rsProductnew_last = rsProductnew_total
  End If
  If (rsProductnew_numRows > rsProductnew_total) Then
    rsProductnew_numRows = rsProductnew_total
  End If
End If
%>
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

Set MM_rs    = rsProductnew
MM_rsCount   = rsProductnew_total
MM_size      = rsProductnew_numRows
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
rsProductnew_first = MM_offset + 1
rsProductnew_last  = MM_offset + MM_size

If (MM_rsCount <> -1) Then
  If (rsProductnew_first > MM_rsCount) Then
    rsProductnew_first = MM_rsCount
  End If
  If (rsProductnew_last > MM_rsCount) Then
    rsProductnew_last = MM_rsCount
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
  MM_keepMove = Server.HTMLEncode(MM_keepMove) & "&"
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
%>
<!-- slide -->
<!--#include file="slide.asp" -->
<!-- /slide -->




<section>
		<div class="container">
			<div class="row">
<!--#include file="sidebar.asp" -->
				
				<div class="col-sm-9 padding-right">
				  <div class="features_items"><!--features_items-->
						<h2 class="title text-center">Hàng mới nhập</h2>
  <% While ((Repeat1__numRows <> 0) AND (NOT rsProductnew.EOF))
  Dim imagePr : imagePr = rsProductnew.Fields.Item("image").value
  Dim proName : proName = rsProductnew.Fields.Item("proName").value
  Dim price : price = rsProductnew.Fields.Item("price").value
  Dim newArrival : newArrival = rsProductnew.Fields.Item("newArrival").value
  Dim inventory : inventory = rsProductnew.Fields.Item("inventory").value
  id = rsProductnew.Fields.Item("productID").value
   %>
	<%=boxProduct(id,proName,price,newArrival,Split(imagePr,",")(0),inventory)%>
                            <% 
  Repeat1__index=Repeat1__index+1
  Repeat1__numRows=Repeat1__numRows-1
  rsProductnew.MoveNext()
Wend
rsProductnew.Close()
Set rsProductnew = Nothing
%>
        <div class="col-sm-12">
        <div class="dataTables_paginate paging_simple_numbers">
        <ul class="pagination">
        <% If MM_offset <> 0 Then %><li class="paginate_button"><a href="<%=MM_moveFirst%>">Đầu tiên</a></li><% End If %>
        <% If MM_offset <> 0 Then %><li class="paginate_button"><a href="<%=MM_movePrev%>">Trước</a></li><% End If %>
        <% If Not MM_atTotal Then %><li class="paginate_button "><a href="<%=MM_moveNext%>">Kế</a></li><% End If %>
		<% If Not MM_atTotal Then %><li class="paginate_button"><a href="<%=MM_moveLast%>">Cuối</a></li><% End If %>
        </ul>
        </div>
        </div>
                  </div><!--features_items-->
<!-- rs liet ke thuong hieu -->
<%
Dim rsHangCaoCap
Dim rsHangCaoCap_cmd
Dim rsHangCaoCap_numRows

Set rsHangCaoCap_cmd = Server.CreateObject ("ADODB.Command")
rsHangCaoCap_cmd.ActiveConnection = MM_Connect_STRING
rsHangCaoCap_cmd.CommandText = "SELECT * FROM dbo.tb_product WHERE price >= 2000000" 
rsHangCaoCap_cmd.Prepared = true

Set rsHangCaoCap = rsHangCaoCap_cmd.Execute
rsHangCaoCap_numRows = 12
%>
<!-- dynamic table cua rsHangCaoCap -->
					
					<div class="recommended_items"><!--new arrival for woman-->
						<h2 class="title text-center">Hàng mới cao cấp</h2>
						
						<div id="recommended-item-carousel" class="carousel slide" data-ride="carousel"  data-interval="false">
							<div class="carousel-inner">
							
									
								<% 	
										Dim TenSP , Gia ,  i
											i = 0
								While (NOT rsHangCaoCap.EOF)  
									Hinh = Split(rsHangCaoCap.Fields.Item("image").Value,",")
									Gia = rsHangCaoCap.Fields.Item("price").Value
									TenSP = rsHangCaoCap.Fields.Item("proName").Value
									newArrival = rsHangCaoCap.Fields.Item("newArrival").Value
									inventory =  rsHangCaoCap.Fields.Item("inventory").Value
									id = rsHangCaoCap.Fields.Item("productID").Value
									If i = 0 then
										%><div class="item active"><% end if 

										If i mod 6 = 0  and i <> 0 then
										%></div><div class="item">
										<% end if %>
										<%=boxProduct(id,TenSP,Gia,newArrival,Hinh(0),inventory)%>
										<%
										if rsHangCaoCap.AbsolutePosition = rsHangCaoCap.EOF then
										%></div><% end if %>

								<% 
										i = i + 1
										rsHangCaoCap.MoveNext()
										Wend
										rsHangCaoCap.Close()
										Set rsHangCaoCap = Nothing %>
								
							</div>
								
						</div>
						 <a class="left recommended-item-control" href="#recommended-item-carousel" data-slide="prev">
								<i class="fa fa-angle-left"></i>
							  </a>
							  <a class="right recommended-item-control" href="#recommended-item-carousel" data-slide="next">
								<i class="fa fa-angle-right"></i>
							  </a>		
					</div><!--/recommended_items-->
					
<%
Dim rsDSTH
Dim rsDSTH_cmd
Dim rsDSTH_numRows

Set rsDSTH_cmd = Server.CreateObject ("ADODB.Command")
rsDSTH_cmd.ActiveConnection = MM_Connect_STRING
rsDSTH_cmd.CommandText = "SELECT * FROM dbo.tb_Brand order by newid()" 
rsDSTH_cmd.Prepared = true

Set rsDSTH = rsDSTH_cmd.Execute
rsDSTH_numRows = 5
%>
<!-- dynamic table cua rsSPtheoTH -->
<%
Dim Repeat5__numRows
Dim Repeat5__index

Repeat5__numRows = 10
Repeat5__index = 0
rsDSTH_numRows = rsDSTH_numRows + Repeat5__numRows
%>
										<div class="category-tab"><!--Thương hiệu-->
						<div class="col-sm-12">
						<ul class="nav nav-tabs" id="checkbrand" >
						<%While ((Repeat5__numRows <> 0) AND (NOT rsDSTH.EOF))  %>
							
								<li class=""  ><a href="#" data-toggle="tab" ><%=(rsDSTH.Fields.Item("brandName").Value) %></a></li>
							
						
						<% 
										Repeat5__index=Repeat5__index+1
										Repeat5__numRows=Repeat5__numRows-1
										i = i + 1
										rsDSTH.MoveNext()
										Wend
										rsDSTH.Close()
										Set rsDSTH = Nothing 
						%>
						
					
							</ul>
						</div>
						<div class="tab-content">
							<div class="tab-pane active"  >
							 
							
							
							</div>
						</div>
					</div><!--/Thương hiệu-->
		
                </div>
			</div>
  </div>
		</div>
</section>
<!-- footer-->
<!--#include file="footer.asp" -->

<!-- /footer-->