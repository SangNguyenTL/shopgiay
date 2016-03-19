<%@LANGUAGE="VBSCRIPT"%>
<!--#include file="Connections/Connect.asp" -->
<%
Dim CheckUsermail
Dim CheckUsermail_cmd
Dim CheckUsermail_numRows
Dim emailUser
emailUser = ucase(request.querystring("emailUser"))
Set CheckUsermail_cmd = Server.CreateObject ("ADODB.Command")
CheckUsermail_cmd.ActiveConnection = MM_Connect_STRING
CheckUsermail_cmd.CommandText = "SELECT * FROM dbo.tb_user WHERE email = '"&emailUser&"' "
CheckUsermail_cmd.Prepared = true

Set CheckUsermail = CheckUsermail_cmd.Execute
CheckUsermail_numRows = 0

If Not CheckUsermail.EOF Or Not CheckUsermail.BOF Then 
	response.write("exist")
else
	response.write("notExist")
End IF

CheckUsermail.Close()
Set CheckUsermail = Nothing
%>
