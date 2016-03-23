<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="Connections/Connect.asp" -->
<!--#include file="function.asp" -->
<%

    Dim MM_editfeedbackCmd
	Dim datetimeNguoigui
	Dim nameNguoigui
	Dim emailNguoigui
	Dim subjectNguoigui
	Dim contentNguoigui
	datetimeNguoigui = Now()
	nameNguoigui = HTMLEncode(request.querystring("name"))
	emailNguoigui = HTMLEncode(request.querystring("email"))
	subjectNguoigui = HTMLEncode(request.querystring("subject"))
	contentNguoigui = HTMLEncode(request.querystring("message"))
	if (nameNguoigui = "" OR emailNguoigui = "" OR subjectNguoigui = "" OR contentNguoigui = "" ) then
		response.write("[{""type"":""notFill"",""message"":""Form chưa được điền đủ thông tin""}]")
	elseif Len(nameNguoigui) < 6 OR Len(nameNguoigui) > 50 then
		response.write("[{""type"":""notFill"",""message"":""Tên bạn phải từ 6 đến 50 ký tự""}]")	
	elseif Len(emailNguoigui) > 70 then
		response.write("[{""type"":""notFill"",""message"":""Email bạn phải nằm trong khoảng 70 ký tự""}]")	
	elseif Len(subjectNguoigui) > 50 or Len(subjectNguoigui) < 10 then
		response.write("[{""type"":""notFill"",""message"":""Tiêu đề phải từ 10 đến 50 ký tự""}]")	
	elseif Len(contentNguoigui) > 500 or Len(contentNguoigui) < 30 then
		response.write("[{""type"":""notFill"",""message"":""Nội dung của bạn phải từ 30 đến 500 ký tự""}]")	
	else
    Set MM_editfeedbackCmd = Server.CreateObject ("ADODB.Command")
    MM_editfeedbackCmd.ActiveConnection = MM_Connect_STRING
    MM_editfeedbackCmd.CommandText = "INSERT INTO dbo.tb_feedback (fullName, email, subject, content, datePost) VALUES (N'"&nameNguoigui&"', N'"&emailNguoigui&"', N'"&subjectNguoigui&"', N'"&contentNguoigui&"', '"& datetimeNguoigui &"')" 
    MM_editfeedbackCmd.Prepared = true
	MM_editfeedbackCmd.Execute
    MM_editfeedbackCmd.ActiveConnection.Close

    ' append the query string to the redirect URL
	response.write("[{""type"":""success"",""message"":""Cám ơn bạn đã quan tâm tới chúng tôi. Chúng tôi sẽ cố gắng sớm nhất hồi đáp lại cho bạn.""}]")
	End if
%>