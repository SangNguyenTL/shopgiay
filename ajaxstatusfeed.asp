<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="Connections/Connect.asp" -->
<%
dim feedId : feedId = request.form("feedId")
Dim MM_editAction
Dim MM_abortEdit
Dim feedstatus : feedstatus = request.form("statusFeed")
MM_abortEdit = false

If (CStr(Request("MM_update")) = "updateFeed" And CStr(feedId <> "")) Then

  If (Not MM_abortEdit) Then
    ' execute the delete
    Set MM_editCmd = Server.CreateObject ("ADODB.Command")
    MM_editCmd.ActiveConnection = MM_Connect_STRING
    MM_editCmd.CommandText = "UPDATE dbo.tb_feedback SET status = '"&feedstatus&"' WHERE feedId = '"&feedId&"' "
    MM_editCmd.Execute
    MM_editCmd.ActiveConnection.Close
	response.write(feedstatus&"a")
  End If

End If
%>
