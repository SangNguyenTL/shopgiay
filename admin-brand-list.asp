<!--#include file="header-admin.asp" -->
<%
Dim MM_deletebrand
MM_deletebrand = CStr(Request.ServerVariables("SCRIPT_NAME"))
If (Request.QueryString <> "") Then
  MM_deletebrand = MM_deletebrand & "?" & HTMLEncode(Request.QueryString)
End If

' boolean to abort record edit

' code delelte
    Dim MM_editRedirectUrl
    MM_editRedirectUrl = GetFileName()
' check san pham thuoc thuong hieu do con hay ko
If (CStr(Request("MM_delete")) = "form1" And CStr(Request("MM_recordId")) <> "") then 
	Dim rscheckproductofbrand
	Dim Rscheck_cmd
	Set Rscheck_cmd = Server.CreateObject ("ADODB.Command")
	Rscheck_cmd.ActiveConnection = MM_Connect_STRING
	Rscheck_cmd.CommandText = "SELECT brandName FROM dbo.tb_product WHERE brandName = ?" 
	Rscheck_cmd.Parameters.Append Rscheck_cmd.CreateParameter("param1", 200, 1, 50, Request.Form("MM_recordId")) ' adVarChar
	Rscheck_cmd.Prepared = true
	Set rscheckproductofbrand = Rscheck_cmd.Execute
	If NOT rscheckproductofbrand.EOF or NOT rscheckproductofbrand.BOF then
		Session("DeleteBrand" )= "<p class=""alert alert-danger"" style=""margin-top:20px"">  <i class=""fa fa-time"">&nbsp;&nbsp;</i>Nếu bạn muốn xóa thương hiệu này, hãy xóa sản phẩm của thương hiệu này trước!</p>"

		If (Request.QueryString <> "") Then
		  If (InStr(1, MM_editRedirectUrl, "?", vbTextCompare) = 0) Then
			MM_editRedirectUrl = MM_editRedirectUrl & "?" & Request.QueryString
		  Else
			MM_editRedirectUrl = MM_editRedirectUrl & "&" & Request.QueryString
		  End If
		End If
		Response.Redirect(MM_editRedirectUrl)
	Else		
	' *** Delete Record: construct a sql delete statement and execute it
	Dim MM_huychinhsua
		MM_huychinhsua = false

		  If (Not MM_huychinhsua) Then
			' execute the delete
			Set MM_editCmd = Server.CreateObject ("ADODB.Command")
			MM_editCmd.ActiveConnection = MM_Connect_STRING
			MM_editCmd.CommandText = "DELETE FROM dbo.tb_Brand WHERE brandName = ?"
			MM_editCmd.Parameters.Append MM_editCmd.CreateParameter("param1", 200, 1, 50, Request.Form("MM_recordId")) ' adVarChar
			MM_editCmd.Execute
			MM_editCmd.ActiveConnection.Close
				Session("DeleteBrand" )= "<p class=""alert alert-success"" style=""margin-top:20px""><i class=""fa fa-time"">&nbsp;&nbsp;</i>Xóa thương hiệu thành công</p>"
			' append the query string to the redirect URL
			If (Request.QueryString <> "") Then
			  If (InStr(1, MM_editRedirectUrl, "?", vbTextCompare) = 0) Then
				MM_editRedirectUrl = MM_editRedirectUrl & "?" & Request.QueryString
			  Else
				MM_editRedirectUrl = MM_editRedirectUrl & "&" & Request.QueryString
			  End If
			End If
			Response.Redirect(MM_editRedirectUrl)
		  End If ' end check san pham cua thuong hieu con hay k
	End If
End If
%>
<%
Dim Recordset1
Dim Recordset1_cmd
Dim Recordset1_numRows

Set Recordset1_cmd = Server.CreateObject ("ADODB.Command")
Recordset1_cmd.ActiveConnection = MM_Connect_STRING
Recordset1_cmd.CommandText = "SELECT brandName, logo FROM dbo.tb_Brand" 
Recordset1_cmd.Prepared = true

Set Recordset1 = Recordset1_cmd.Execute
Recordset1_numRows = 0

Dim Repeat1__numRows
Dim Repeat1__index

Repeat1__numRows = 10
Repeat1__index = 0
Recordset1_numRows = Recordset1_numRows + Repeat1__numRows 

Dim MM_paramName 
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


'  *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

Dim Recordset1_total
Dim Recordset1_first
Dim Recordset1_last

' set the record count
Recordset1_total = Recordset1.RecordCount

' set the number of rows displayed on this page
If (Recordset1_numRows < 0) Then
  Recordset1_numRows = Recordset1_total
Elseif (Recordset1_numRows = 0) Then
  Recordset1_numRows = 5
End If

' set the first and last displayed record
Recordset1_first = 1
Recordset1_last  = Recordset1_first + Recordset1_numRows - 1

' if we have the correct record count, check the other stats
If (Recordset1_total <> -1) Then
  If (Recordset1_first > Recordset1_total) Then
    Recordset1_first = Recordset1_total
  End If
  If (Recordset1_last > Recordset1_total) Then
    Recordset1_last = Recordset1_total
  End If
  If (Recordset1_numRows > Recordset1_total) Then
    Recordset1_numRows = Recordset1_total
  End If
End If
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

Set MM_rs    = Recordset1
MM_rsCount   = Recordset1_total
MM_size      = Recordset1_numRows
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
Recordset1_first = MM_offset + 1
Recordset1_last  = MM_offset + MM_size

If (MM_rsCount <> -1) Then
  If (Recordset1_first > MM_rsCount) Then
    Recordset1_first = MM_rsCount
  End If
  If (Recordset1_last > MM_rsCount) Then
    Recordset1_last = MM_rsCount
  End If
End If

' set the boolean used by hide region to check if we are on the last record
MM_atTotal = (MM_rsCount <> -1 And MM_offset + MM_size >= MM_rsCount)
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


  <div class="content container">
    <div class="box table-responsive no-padding">
            <!-- /.box-header -->
	 <div class="box-header">
		<h1>Danh sách thương hiệu</h1>
	 </div>
		  <div class="box-body">
 <%				 if Session.Contents("DeleteBrand") <> "" then
%>
			
				<%=Session.Contents("DeleteBrand")%>
				
<%
				Session.Contents.Remove("DeleteBrand")
					End if
					 
%>
  <table class="table table-hover">
    <tr>
	
      <th><h3 align="center"><strong>Tên thương hiệu</strong></h3></th>
      <th><h3 align="center"><strong align="center">Logo</strong></h3></th>
      <th colspan="3"><h3 align="center"><strong>Tác vụ</strong></h3></th>
    </tr>
    <% While ((Repeat1__numRows <> 0) AND (NOT Recordset1.EOF)) %>
      <tr>
        <td align="center"><a href="brand-ds.asp?brandName=<%= Recordset1.Fields.Item("brandName").Value %>"><%=(Recordset1.Fields.Item("brandName").Value)%></a></td>
        <td class="imageProduct" align="center"><img class="img-thumbnail" src="<%=(Recordset1.Fields.Item("logo").Value)%>"></td>
       <td width="130" align="center">
              <form ACTION="<%=MM_deletebrand%>" name="form1" METHOD="POST">
			  
              <button type="submit" class="btn btn-danger">
					Xóa
			  </button>
              <input type="hidden" name="MM_delete" value="form1">
              <input type="hidden" name="MM_recordId" value="<%= Recordset1.Fields.Item("brandName").Value %>">
              </form>
		</td>	
		<td width="130" align="center">
              <A  HREF="admin-brand.asp?<%= HTMLEncode(MM_keepNone) & MM_joinChar(MM_keepNone) & "brandName=" & Recordset1.Fields.Item("brandName").Value %>" class="btn btn-info">
					Sửa
              </A>
		</td>
        <td width="130" align="center">
             <A HREF="admin-list-product.asp?<%= HTMLEncode(MM_keepNone) & MM_joinChar(MM_keepNone) & "brandName="&  Recordset1.Fields.Item("brandName").Value %>" class="btn btn-primary" >
				DS sản phẩm
              </A>
    	</td>
      </tr>
	 
<% 
  Repeat1__index=Repeat1__index+1
  Repeat1__numRows=Repeat1__numRows-1
  Recordset1.MoveNext()
Wend
%>
  </table>
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
	  </div>
 
</div>
</div>

<!--#include file="footer-admin.asp" -->
<%
Recordset1.Close()
Set Recordset1 = Nothing
%>

