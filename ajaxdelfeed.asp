<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="Connections/Connect.asp" -->
<%
dim feedId : feedId = request.form("feedId")
Dim MM_editAction
Dim MM_abortEdit
MM_abortEdit = false
' *** Delete Record: construct a sql delete statement and execute it

If (CStr(Request("MM_delete")) = "delFeed" And CStr(feedId <> "")) Then

  If (Not MM_abortEdit) Then
    ' execute the delete
    Set MM_editCmd = Server.CreateObject ("ADODB.Command")
    MM_editCmd.ActiveConnection = MM_Connect_STRING
    MM_editCmd.CommandText = "DELETE FROM dbo.tb_feedback WHERE feedId = ?"
    MM_editCmd.Parameters.Append MM_editCmd.CreateParameter("param1", 5, 1, -1, feedId) ' adDouble
    MM_editCmd.Execute
    MM_editCmd.ActiveConnection.Close
  End If

End If
%>
