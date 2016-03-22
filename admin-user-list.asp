<!--#include file="header-admin.asp" -->

<%
Dim rsUser
Dim rsUser_cmd
Dim rsUser_numRows

Set rsUser_cmd = Server.CreateObject ("ADODB.Command")
rsUser_cmd.ActiveConnection = MM_Connect_STRING
rsUser_cmd.CommandText = "SELECT userID, fullName, email, phone, Address FROM dbo.tb_user where userID <> 1" 
rsUser_cmd.Prepared = true

Set rsUser = rsUser_cmd.Execute
rsUser_numRows = 0
%>

<!-- tao bang dynamic table -->
<%
Dim Repeat1__numRows
Dim Repeat1__index

Repeat1__numRows = 5
Repeat1__index = 0
rsUser_numRows = rsUser_numRows + Repeat1__numRows
%>
<!-- navi bar -->
<%
'  *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

Dim rsUser_total
Dim rsUser_first
Dim rsUser_last
' -- so dong khi chuyen trang -->
' set the record count
rsUser_total = rsUser.RecordCount

' set the number of rows displayed on this page
If (rsUser_numRows < 0) Then
  rsUser_numRows = rsUser_total
Elseif (rsUser_numRows = 0) Then
  rsUser_numRows = 5
End If

' set the first and last displayed record
rsUser_first = 1
rsUser_last  = rsUser_first + rsUser_numRows - 1

' if we have the correct record count, check the other stats
If (rsUser_total <> -1) Then
  If (rsUser_first > rsUser_total) Then
    rsUser_first = rsUser_total
  End If
  If (rsUser_last > rsUser_total) Then
    rsUser_last = rsUser_total
  End If
  If (rsUser_numRows > rsUser_total) Then
    rsUser_numRows = rsUser_total
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

Set MM_rs    = rsUser
MM_rsCount   = rsUser_total
MM_size      = rsUser_numRows
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
<!-- save -->
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
rsUser_first = MM_offset + 1
rsUser_last  = MM_offset + MM_size

If (MM_rsCount <> -1) Then
  If (rsUser_first > MM_rsCount) Then
    rsUser_first = MM_rsCount
  End If
  If (rsUser_last > MM_rsCount) Then
    rsUser_last = MM_rsCount
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
<!-- Content Wrapper. Contains page content -->
  
	

   <section class="content">

          <div class="box">
            <div class="box-header">
              <h3 class="box-title">Danh sách thành viên</h3>

              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  

                  <div class="input-group-btn">
					
                  </div>
                </div>
              </div>
            </div>
            <!-- /.box-header -->
          
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tbody>
				<tr>
                  <th>Tên thành viên</th>
                  <th>Email</th>
				  <th>Số điện thoại</th>
                  <th>Địa chỉ</th>
                  <th colspan="2" style="text-align:center"	>Lựa chọn</th>
                </tr>
				
                
                  <% While ((Repeat1__numRows <> 0) AND (NOT rsUser.EOF)) %>
				  <tr>
                      <td><%=(rsUser.Fields.Item("fullName").Value)%></td>
                      <td><%=(rsUser.Fields.Item("email").Value)%></td>
                      <td><%=(rsUser.Fields.Item("phone").Value)%></td>
                      <td><%=(rsUser.Fields.Item("Address").Value)%></td>
          		      <td><A HREF="user-info.asp?<%= Server.HTMLEncode(MM_keepNone) & MM_joinChar(MM_keepNone) & "email=" & rsUser.Fields.Item("email").Value %>" class="btn btn-block btn-primary frmlDel">
       		          Xem chi tiết
          		      </A></td>
                      <td>		  				
						 <button type="submit" class="btn btn-block btn-danger frmDel" value="<%=(rsUser.Fields.Item("userID").Value)%>">Xóa</button>
					</td>
					
				  </tr>
                     
                  <%  Repeat1__index=Repeat1__index+1
                      Repeat1__numRows=Repeat1__numRows-1
                      rsUser.MoveNext()
                   	Wend
				  %>
                
              </tbody>
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
            <!-- /.box-body -->
           
          </div>
          <!-- /.box -->
  
   </section>    

<!--#include file="footer-admin.asp" -->
<%
rsUser.Close()
Set rsUser = Nothing
%>
