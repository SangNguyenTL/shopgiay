<!--#include file="header-admin.asp" -->
<%
Dim comment
Dim comment_cmd
Dim comment_numRows

Set comment_cmd = Server.CreateObject ("ADODB.Command")
comment_cmd.ActiveConnection = MM_Connect_STRING
comment_cmd.CommandText = "SELECT * FROM dbo.tb_comment as cm Left Join dbo.tb_user as us on us.userID = cm.userID left join dbo.tb_product as pr on pr.productId = cm.proID " 
comment_cmd.Prepared = true

Set comment = comment_cmd.Execute
comment_numRows = 10
%>
<%
'  *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

Dim comment_total
Dim comment_first
Dim comment_last

' set the record count
comment_total = comment.RecordCount

' set the number of rows displayed on this page
If (comment_numRows < 0) Then
  comment_numRows = comment_total
Elseif (comment_numRows = 0) Then
  comment_numRows = 1
End If

' set the first and last displayed record
comment_first = 1
comment_last  = comment_first + comment_numRows - 1

' if we have the correct record count, check the other stats
If (comment_total <> -1) Then
  If (comment_first > comment_total) Then
    comment_first = comment_total
  End If
  If (comment_last > comment_total) Then
    comment_last = comment_total
  End If
  If (comment_numRows > comment_total) Then
    comment_numRows = comment_total
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

Set MM_rs    = comment
MM_rsCount   = comment_total
MM_size      = comment_numRows
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
comment_first = MM_offset + 1
comment_last  = MM_offset + MM_size

If (MM_rsCount <> -1) Then
  If (comment_first > MM_rsCount) Then
    comment_first = MM_rsCount
  End If
  If (comment_last > MM_rsCount) Then
    comment_last = MM_rsCount
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
<section class="content-header">
  <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
              <h1 class="box-title">Danh sách bình luận</h1>

              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  

                  <div class="input-group-btn">
                   
                  </div>
                </div>
              </div>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
			<p class="alert alert-warning" style="
    margin: 10px;
"> (*) Bình luận này có phần trả lời, khi xóa sẽ mất phần trả lời </p>
    <%
Dim Repeat1__numRows
Dim Repeat1__index

Repeat1__numRows = 10
Repeat1__index = 0
comment_numRows = comment_numRows + Repeat1__numRows
%>
				<table class="table table-hover">
					<thead>
                      <tr>
                        <th width="260">Loại</th>
                        <th width="260">Tên người gửi</th>
                        <th width="260">Email</th>
                        <th width="260">Thời gian</th>                     
                        <th width="260">Tác vụ</th>
                      </tr>
					</thead>
                    <tbody>    
<% 

While ((Repeat1__numRows <> 0) AND (NOT comment.EOF))

%>                  
					  <tr>
						<td><%if (comment.Fields.Item("parentId").Value <> "") then %>
							Hỏi
						<%else%>
							Trả lời
						<%end if %></td>
                      	<td><a href="user-info.asp?email=<%=comment.Fields.Item("email").Value%>"><%=(comment.Fields.Item("fullName").Value)%><%if (comment.Fields.Item("parentId").Value <> ""	) then%>
						<%else%>
						(*)
						<%end if %></a></td>
						<td><%=(comment.Fields.Item("email").Value)%></td>
                        <td><span><%=(comment.Fields.Item("datePost").Value)%></span></td>
						<td>

                        	<div class="btn-group">
                            	<a href="#" data-toggle="modal" data-target="#cm_ID-<%=(comment.Fields.Item("cm_ID").Value)%>" class="btn btn-primary" style="width: 80px;">Xem</a>	
                            	<a href="?delCommentID=<%=(comment.Fields.Item("cm_ID").Value)%>" class="btn btn-danger" style="width: 80px;">Xóa</a>	
                             </div>
                        <input type="hidden" name="delCommentID" value="<%=(comment.Fields.Item("cm_ID").Value)%>">
                        </form>
                       </td>
                       </tr>
                       <div class="modal fade" id="cm_ID-<%=(comment.Fields.Item("cm_ID").Value)%>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
                              <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                  <div class="modal-header">
									Tại <a href="product-detail.asp?productID=<%=comment.Fields.Item("proID").Value%>#<%=comment.Fields.Item("cm_ID").Value%>"><%=comment.Fields.Item("proName").Value%></a>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                  </div>
                                  <div class="modal-body">
                                    <%=(comment.Fields.Item("cmContent").Value)%>
                                  </div>
                                  <div class="modal-footer">
                                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                    </div>
                                    </div>
                                    </div>
                                    </div>
<% 
  Repeat1__index=Repeat1__index+1
  Repeat1__numRows=Repeat1__numRows-1
  comment.MoveNext()
Wend
comment.Close()
Set comment = Nothing
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
            </div>
            <!-- /.box-body -->
          </div>
          <!-- /.box -->
        </div>
</div>
      <!-- /.row -->
</section>
<!--#include file="footer-admin.asp" -->

