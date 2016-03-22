
<!--#include file="header.asp" -->
<%
Dim Recordset1
Dim Recordset1_cmd
Dim Recordset1_numRows

Set Recordset1_cmd = Server.CreateObject ("ADODB.Command")
Recordset1_cmd.ActiveConnection = MM_Connect_STRING
Recordset1_cmd.CommandText = "SELECT brandName FROM dbo.tb_Brand" 
Recordset1_cmd.Prepared = true

Set Recordset1 = Recordset1_cmd.Execute
Recordset1_numRows = 0

Dim brandNameS
If (Request("brandNameS") <> "") Then 
  brandNameS = HTMLEncode(Request("brandNameS"))
  brandNameS = " and brandName LIke N'%"&brandNameS&"%' "
End If

Dim proNameS
If (Request("proNameS")  <> "") Then 
  proNameS = HTMLEncode(Request.QueryString("proNameS"))
  proNameS = " and proName LIke N'%"&proNameS&"%' "
End If

Dim newArrivalS
If (Request("newArrivalS")  <> "") and IsNumeric(Request("newArrivalS")) Then 
  newArrivalS = HTMLEncode(Request("newArrivalS"))
  newArrivalS = " and newArrival ="&newArrivalS
End If

Dim inventoryS
If (Request("inventoryS")  <> "") and IsNumeric(Request("inventoryS")) Then 
  inventoryS = HTMLEncode(Request("inventoryS"))
  inventoryS = " and inventory ="&inventoryS
End If

Dim priceS
If IsNumeric(Request("price_max")) and IsNumeric(Request("price_min")) and Request("price_max") <> "" and Request("price_min") <> "" Then 
if Request("price_max") > 9999999 or Request("price_min") < 0 then
	Request("price_max") = 5000000
	Request("price_min") = 50000
end if
  priceS = HTMLEncode(Request("inventoryS"))
  priceS = " and (price between "&Request("price_min")&" and "&Request("price_max")&" )"
End If

Dim Recordset2
Dim Recordset2_cmd
Dim Recordset2_numRows
Dim querypro

querypro = brandNameS&proNameS&inventoryS&newArrivalS&priceS

Set Recordset2_cmd = Server.CreateObject ("ADODB.Command")
Recordset2_cmd.ActiveConnection = MM_Connect_STRING
Recordset2_cmd.CommandText = "SELECT * FROM dbo.tb_product WHERE productID > 0"&querypro
Recordset2_cmd.Prepared = true

Set Recordset2 = Recordset2_cmd.Execute
Recordset2_numRows = 0

Dim Repeat2__numRows
Dim Repeat2__index

Repeat2__numRows = 9
Repeat2__index = 0
Recordset2_numRows = Recordset2_numRows + Repeat2__numRows

'  *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

Dim Recordset2_total
Dim Recordset2_first
Dim Recordset2_last

' set the record count
Recordset2_total = Recordset2.RecordCount

' set the number of rows displayed on this page
If (Recordset2_numRows < 0) Then
  Recordset2_numRows = Recordset2_total
Elseif (Recordset2_numRows = 0) Then
  Recordset2_numRows = 1
End If

' set the first and last displayed record
Recordset2_first = 1
Recordset2_last  = Recordset2_first + Recordset2_numRows - 1

' if we have the correct record count, check the other stats
If (Recordset2_total <> -1) Then
  If (Recordset2_first > Recordset2_total) Then
    Recordset2_first = Recordset2_total
  End If
  If (Recordset2_last > Recordset2_total) Then
    Recordset2_last = Recordset2_total
  End If
  If (Recordset2_numRows > Recordset2_total) Then
    Recordset2_numRows = Recordset2_total
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

Set MM_rs    = Recordset2
MM_rsCount   = Recordset2_total
MM_size      = Recordset2_numRows
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
Recordset2_first = MM_offset + 1
Recordset2_last  = MM_offset + MM_size

If (MM_rsCount <> -1) Then
  If (Recordset2_first > MM_rsCount) Then
    Recordset2_first = MM_rsCount
  End If
  If (Recordset2_last > MM_rsCount) Then
    Recordset2_last = MM_rsCount
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
%>

<section>
	<div class="container">
		<div class="row">
			<div class="features_items"><!--features_items-->
				<h2 class="title text-center">Kết quả tìm kiếm</h2>
				<div class="box">
					<div class="box-header">
						<div class="col-sm-12 form-horizontal">
							<div class="form-group">
								<form id="form1" name="form1" method="get" action="" >
									<div class="col-sm-2">
										<select name="brandNames" id="brandName" class="form-control m-b"><option value="">Chọn...</option>
											  <% Dim selectedS
											  While (NOT Recordset1.EOF)
													if Recordset1.Fields.Item("brandName").Value = Request.QueryString("brandNameS") then
													selectedS = "selected"
													else 
													selectedS = ""
													end if
											  %>
												
												<option value="<%=(Recordset1.Fields.Item("brandName").Value)%>" <%=selectedS%>><%=(Recordset1.Fields.Item("brandName").Value)%></option>
											  <% Recordset1.MoveNext()
												Wend
												If (Recordset1.CursorType > 0) Then
												  Recordset1.MoveFirst
												Else
												  Recordset1.Requery
												End If
												Recordset1.Close()
												Set Recordset1 = Nothing
												%>
										</select>
									</div>
									<div class="col-sm-2">
										<select name="inventoryS" id="brandName" class="form-control m-b">
											  <% Dim selected1, selected2
													if Request.QueryString("inventoryS") = "1"then
													selected13 = "selected"
													end if
													if Request.QueryString("inventoryS") = "0"then
													selected23 = "selected"
													end if
											  %>
												<option value="">Chọn...</option>
												<option value="1" <%=selected13%> >Còn hàng</option>
												<option value="0" <%=selected23%> >Hết hàng</option>
										</select>
									</div>
									<div class="col-sm-2">
										<select name="newArrivalS" id="brandName" class="form-control m-b"><option value="">Chọn...</option>
											  <% Dim selected3, selected4
													if "1" = Request.QueryString("newArrivalS")then
													selected3 = "selected"
													end if
													if Request.QueryString("newArrivalS") = "0" then
													selected4 = "selected"
													end if
											  %>
												
												<option value="1" <%=selected3%> >Còn hàng</option>
												<option value="0" <%=selected4%> >Hết hàng</option>
										</select>
									</div>
									<div class="col-sm-2">
										<input type="text" name="proNames" id="proNames" placeholder="Tên sản phẩm" class="form-control" value="<%=Request.QueryString("proNameS")%>">
									</div>
									
									<% dim min_pice, max_price
											  min_pice = Request.QueryString("min_pice")
											  max_pice = Request.QueryString("max_pice")
											  if min_pice <> "" then
											  else
												min_pice = "10000"
											  end if
											  if max_pice <> "" then
											  else
												max_pice = "5000000"
											  end if
									%>
										<div class="text-center col-sm-1"><input name="price_min" type="text" class="form-control" value="<%=min_pice%>" pattern="(\d){5,7}"></div>
										<div class="text-center col-sm-1">Tới</div>
										<div class="text-center col-sm-1"><input name="price_max" type="text" class="form-control" value="<%=max_pice%>" pattern="(\d){5,7}"></div>
									
										<div class="col-sm-1">
											<input type="submit" id="submit" value="Tìm" class="btn btn-block btn-primary" style="border-radius:5px;margin: 0;">
										</div>
								</form>
							</div>
						</div>
					</div>
					<div class="box-body">
					 <% While ((Repeat2__numRows <> 0) AND (NOT Recordset2.EOF)) 
						Response.Write(boxProduct((Recordset2.Fields.Item("productID").Value),(Recordset2.Fields.Item("proName").Value),(Recordset2.Fields.Item("price").Value),(Recordset2.Fields.Item("newArrival").Value),(Recordset2.Fields.Item("image").Value),(Recordset2.Fields.Item("inventory").Value)))
						Repeat2__index=Repeat2__index+1
						Repeat2__numRows=Repeat2__numRows-1
						Recordset2.MoveNext()
						Wend %>
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
				  </div>
						
					</div>
				</div>
			</div><!--features_items-->
		</div>
	</div>
</section>
	
<!--#include file="footer.asp" -->

