<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="Connections/Connect.asp" -->
<%
' *** Delete Record: construct a sql delete statement and execute it
	Dim userID : userID = request.form("userID")
	Dim MM_editAction
	Dim MM_abortEdit 
	 MM_abortEdit = false
If (CStr(Request("MM_delete")) = "frmDel" And CStr(userID <> "")) Then

  If (Not MM_abortEdit) Then
    ' execute the delete
    Set MM_editCmd = Server.CreateObject ("ADODB.Command")
    MM_editCmd.ActiveConnection = MM_Connect_STRING
    MM_editCmd.CommandText = "DELETE FROM dbo.tb_basket WHERE userID = ? DELETE FROM dbo.tb_comment WHERE userID = ? DELETE FROM dbo.tb_user WHERE userID = ?"
    MM_editCmd.Parameters.Append MM_editCmd.CreateParameter("param1", 5, 1, -1, userID) ' adDouble
    MM_editCmd.Parameters.Append MM_editCmd.CreateParameter("param2", 5, 1, -1, userID) ' adDouble
    MM_editCmd.Parameters.Append MM_editCmd.CreateParameter("param3", 5, 1, -1, userID) ' adDouble
    
    MM_editCmd.Execute
    MM_editCmd.ActiveConnection.Close
  End If
End If
%>
