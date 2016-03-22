<!--#include file="header.asp" -->
<%
if (Session("MM_Username") <> "") then
	Response.Redirect("index.asp")
end if
%>	
	
	<section>
		<div class="container">
			<div class="row">
            <div id="form">
				<div class="col-sm-4 col-sm-offset-1">
					<div class="login-form"><!--login form-->
						<h2>Đăng nhập</h2>
<%				 if Session.Contents("statusLogin") <> "" then
%>
				<p class="alert alert-danger" style="margin-top:20px">  
				<i class="fa fa-time"></i>&nbsp;&nbsp;<%=Session.Contents("statusLogin")%>
				</p>
<%
				  Session.Contents.Remove("statusLogin")
				end if

%>	
						<form action="<%=MM_LoginAction%>" id="form1" name="form1" method="POST">
							<input name="txtEmail" type="text" placeholder="Địa chỉ email" required pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$" title="Xin điền đầy đủ và đúng quy tắc:
abc@gmail.com">
							<input type="hidden" name="formLogin" value="ok"/>
							<input name="txtPass" type="password" placeholder="Mật khẩu" required pattern="(.){6,15}">
							<button type="submit" class="btn btn-default">Đăng nhập</button>
						</form>
					</div><!--/login form-->
				</div>
				<div class="col-sm-1">
					<h2 class="or">Hoặc</h2>
				</div>
				<div class="col-sm-4">
					<div class="signup-form"><!--sign up form-->
						<h2>Đăng ký!</h2>
<%				 if Session.Contents("statusRegister") = "Đăng ký thành công" then
%>
				<p class="alert alert-success" style="margin-top:20px">  
				<i class="fa fa-check"></i>&nbsp;&nbsp;<%=Session.Contents("statusRegister")%> bạn có thể đăng nhập!
				</p>
				
<%					Session.Contents.Remove("statusRegister")
				elseif (Session.Contents("statusRegister") <> "") then
%>
				<p class="alert alert-danger" style="margin-top:20px">  
				<i class="fa fa-time"></i>&nbsp;&nbsp;<%=Session.Contents("statusRegister")%>
				</p>
<%
					Session.Contents.Remove("statusRegister")
				end if

%>	
						<form action="<%=MM_editAction%>" id="form2" name="form2" method="POST">
							<input name="txtUser" type="text" placeholder="Tên đầy đủ" required pattern="(.){6,70}" title="Phải từ 6 đến 70 ký tự">
							<input name="txtEmail" type="email" placeholder="Địa chỉ email" required pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$" title="Xin điền đầy đủ và đúng quy tắc:
abc@gmail.com">
							<input name="txtPass" type="password" placeholder="Mật khẩu" required pattern="(.){6,15}" title="Phải từ 6 đến 15 ký tự">
							<input name="txtPass2" type="password" placeholder="Nhập lại mật khẩu" required pattern="(.){6,15}" title="Phải từ 6 đến 15 ký tự">
							<input name="txtAddress" type="text" placeholder="Địa chỉ" required pattern="(.){20,100}" title="Phải từ 30 đến 200 ký tự">
							<input name="txtPhone" type="tel" placeholder="Số điện thoại" required pattern="(\d){8,11}" title="Phải từ 8 đến 11 số">
							<button type="submit" class="btn btn-default">Đăng ký</button>
                            <input type="hidden" name="formRg" value="ok">
                        </form>
					</div><!--/sign up form-->
				</div>	
                </div>
            </div>
		</div>
	</section>	
<!--#include file="footer.asp" -->

