<%@ Language=VBScript %>
<%Option Explicit%>
<!-- #include file="upLoadFunctions.asp" -->
<%
' Create the FileUploader
Dim Uploader, File, FileSys, FilePath
Set Uploader = New FileUploader

' This starts the upload process
Uploader.Upload()

' Check if any files were uploaded

If Uploader.Files.Count = 0 Then
    Response.Write "not"
Else
    ' Loop through the uploaded files
    For Each File In Uploader.Files.Items
        
        ' Set upload Path and Filename to check if that file already exists
        FilePath = "C:\Inetpub\wwwroot\shopgiay\images\logo\"&File.FileName
        Set FileSys = CreateObject("Scripting.FileSystemObject")

        ' If intended uploaded file already exists in the specified directory do alert and redirect previous page
        If FileSys.FileExists(FilePath) then 
            Response.Write("dub")
        else
            ' Else Save the file
            File.SaveToDisk "C:\\Inetpub\\wwwroot\\shopgiay\\images\\logo"
			Response.Write("images/logo/"&File.FileName)
        end if
    Next
    ' Confirm file saved and redirect to previous page if more files to be uploaded
End If

%>
