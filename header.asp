<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="Connections/Connect.asp" -->
<!--#include file="function.asp" -->
<%
Session.Contents.Remove("vbRedirect")
Session("vbRedirect") = GetFileName()
Dim the_title
Dim title
Dim classActive
Dim classActive1
Dim classActive2
Dim classActive3
Dim classActive4
Dim classActive5
Dim classActive6
If (GetFileName() = "") OR (GetFileName = "index.asp") then
	title = "Trang chủ"
	classActive = "active"
elseif(GetFileName() = "search.asp") then
	title = "Tìm kiếm"
	classActive1 = "active"
elseif(GetFileName() = "login.asp") then
	title = "Đăng nhập | Đăng ký"
	classActive2 = "active"
elseif(GetFileName() = "contact-us.asp") then
	title = "Liên hệ | Phản hồi"
	classActive3 = "active"
elseif(GetFileName() = "checkout.asp") then
	title = "Xác nhận đơn hàng"
	classActive4 = "active"
elseif(GetFileName() = "cart.asp") then
	title = "Giỏ hàng"
	classActive5 = "active"
elseif(GetFileName() = "user-info.asp") then
	title = "Thông tin cá nhân"
	classActive6 = "active"
End if
the_title = title &" | Giày của tui"
' *** Logout the current user.
%>
<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <title><%=the_title%></title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/font-awesome.min.css" rel="stylesheet">
    <link href="css/prettyPhoto.css" rel="stylesheet">
    <link href="css/price-range.css" rel="stylesheet">
    <link href="css/animate.css" rel="stylesheet">
	<link href="css/main.css" rel="stylesheet">
	<link href="css/responsive.css" rel="stylesheet">
    <!--[if lt IE 9]>
    <script src="js/html5shiv.js"></script>
    <script src="js/respond.min.js"></script>
    <![endif]-->       
    <link rel="shortcut icon" href="images/ico/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="images/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="images/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="images/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="images/ico/apple-touch-icon-57-precomposed.png">

</head><!--/head-->

<body>
	<header id="header"><!--header-->
		<div class="header_top"><!--header_top-->
			<div class="container">
				<div class="row">
					<div class="col-sm-6">
						<div class="contactinfo">
							<ul class="nav nav-pills">
								<li><i class="fa fa-phone"></i> <%=sitePhone%></li>
								<li><a href="mailto:siteEmail"><i class="fa fa-envelope"></i> <%=siteEmail%></a></li>
							</ul>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="social-icons pull-right">
							<ul class="nav navbar-nav">
								<li><a href="#"><i class="fa fa-facebook"></i></a></li>
								<li><a href="#"><i class="fa fa-twitter"></i></a></li>
								<li><a href="#"><i class="fa fa-linkedin"></i></a></li>
								<li><a href="#"><i class="fa fa-dribbble"></i></a></li>
								<li><a href="#"><i class="fa fa-google-plus"></i></a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div><!--/header_top-->
		
		<div class="header-middle"><!--header-middle-->
			<div class="container">
				<div class="row">
					<div class="col-sm-4">
						<div class="logo pull-left">
							<a href="/"><img src="images/home/logo.png" alt="" /></a>
						</div>
					</div>
					<div class="col-sm-8">
						<div class="shop-menu pull-right">
							<ul class="nav navbar-nav">
							<% dim show_cart
							if getItemCount() <> "0" then 
								show_cart = ""
								else 
								show_cart = "hidden"
							 end if%>
								<li><a href="cart.asp" class="<%=classActive5%>"><i class="fa fa-shopping-cart"></i> Giỏ hàng <span class="badge badge-sm up alert-danger count <%=show_cart%>"><%=getItemCount()%>
								</span></a></li>
<%
	if	Session("MM_UserAuthorization") <> "" and Session("MM_UserAuthorization") = "True" then
			Response.Write("<li><a href=""admin-panel.asp""><i class=""fa fa-gear""></i> Quản lý</a></li>")
	end if
%>
<%
if (Session("MM_Username") <> "") then
%>

<li class="dropdown"><a href='user-info.asp'><i class='fa fa-user'></i> <%=Session.Contents("MM_Username")%></a></li>
<li><a href="<%= MM_Logout %>"><i class='fa fa-sign-out'></i> Đăng xuất</a></li>
<% 
else
Response.Write("<li><a href='login.asp' class='"&classActive2&"'><i class='fa fa-lock'></i> Đăng nhập / Đăng ký</a></li>")
End if
%>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div><!--/header-middle-->
	
		<div class="header-bottom"><!--header-bottom-->
			<div class="container">
				<div class="row panel">
					<div class="col-sm-9">
						<div class="navbar-header">
							<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
								<span class="sr-only">Toggle navigation</span>
								<span class="icon-bar"></span>
								<span class="icon-bar"></span>
								<span class="icon-bar"></span>
							</button>
						</div>
						<div class="mainmenu pull-left">
							<ul class="nav navbar-nav collapse navbar-collapse">
								<li><a href="<%=linkHome%>" class="<%=classActive%>">Trang Chủ</a></li>
                                <li><a href="search.asp" class="<%=classActive1%>">Tìm kiếm</a></li>
								<li><a href="contact-us.asp" class="<%=classActive3%>">Liên hệ / Phản hồi</a></li>
							</ul>
						</div>
					</div>
					<div class="col-sm-3">
						<div class="search_box pull-right">
							<input type="text" placeholder="Search"/>
						</div>
					</div>
				</div>
				<%
				if Session("statusBasket") <> "" then
				%>
					<div class="alert alert-danger"><%=Session("statusBasket")%></div>
				<%
					Session.Contents.Remove("statusBasket")
				end if
				%>
			</div>
		</div><!--/header-bottom-->
	</header><!--/header-->