<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="Connections/Connect.asp" -->
<!--#include file="function.asp" -->
<%

if Session("MM_UserAuthorization") <> "True" then
	Session("statusLogin" ) = "Bạn phải đăng nhập để có thể tiếp tục hành vi này!"
	Response.Redirect("login.asp?vbRedirect=admin-panel.asp")
end if

Dim namePage
Dim pageChild
Dim activeUserlist
Dim activeBrandlist
Dim activeProductlist
Dim activeProductlistChild
Dim activeFeedback
if GetFileName() = "admin-user-list.asp" then
	namePage = "Quản lý thành viên"
	pageChild = "<li><a href=""admin-user-list.asp""><i class=""fa fa-edit""></i> Quản lý thành viên</a></li>"
	activeUserlist = "active"
	
elseif GetFileName() = "admin-brand-list.asp" or GetFileName() = "admin-brand.asp" then
	namePage = "Quản lý thương hiệu"
	pageChild = "<li><a href=""admin-brand-list.asp""><i class=""fa fa-edit""></i> Quản lý thương hiệu</a></li>"
	activeBrandlist = "active"
	
elseif GetFileName() = "admin-list-product.asp" or GetFileName() = "admin-product.asp" then
	namePage = "Quản lý Sản phẩm"
	pageChild = "<li><a href=""admin-list-product.asp""><i class=""fa fa-edit""></i> Quản lý sản phẩm</a></li>"
	activeProductlist = "active"	
	if GetFileName() = "admin-product.asp" then
		namePage = "Thêm sản phẩm"
		if Request.Querystring <> "" then
			namePage = "Cập nhật sản phẩm"
		end if
	end if
	if GetFileName() = "admin-list-product.asp" then
		activeProductlistChild = "active"
	end if
elseif GetFileName() = "admin-feedback.asp"then
	namePage = "Quản lý Phản hồi"
	pageChild = "<li><a href=""admin-brand-list.asp""><i class=""fa fa-edit""></i> Quản lý phản hồi</a></li>"
	activeFeedback = "active"
elseif GetFileName() = "admin-panel.asp"then
	namePage = "Trang Quản trị"
elseif GetFileName() = "admin-comment.asp" then
	namePage = "Quản lý bình luận"
	pageChild = "<li><a href=""admin-comment.asp""><i class=""fa fa-edit""></i> Quản lý bình luận</a></li>"
elseif GetFileName() = "admin-order.asp" then
	namePage = "Quản lý Giỏ hàng"
	activeOrderlist = "active"
	pageChild = "<li><a href=""admin-order.asp.asp""><i class=""fa fa-edit""></i> Quản lý đơn hàng</a></li>"
end if
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title><%=namePage%></title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <!-- Bootstrap 3.3.5 -->
  <link rel="stylesheet" type="text/css" href="bootstrap/css/bootstrap.min.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="css/font-awesome.min.css">
  <!-- Ionicons -->
  <link rel="stylesheet" href="css/simple-line-icons.css">
  <!-- Theme style -->
  <link rel="stylesheet" type="text/css" href="dist/css/AdminLTE.min.css">
  <!-- AdminLTE Skins. Choose a skin from the css/skins
       folder instead of downloading all of them to reduce the load. -->
  <link rel="stylesheet" type="text/css" href="dist/css/skins/_all-skins.min.css">
  <!-- bootstrap wysihtml5 - text editor -->
  <link rel="stylesheet" href="plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css">


  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->

</head>


<body class="hold-transition skin-purple sidebar-mini">
<div class="wrapper">

  <header class="main-header">
    <!-- Logo -->
    <a href="<%=linkHome%>" class="logo">
      <!-- mini logo for sidebar mini 50x50 pixels -->
      <span class="logo-mini"><b>Shop Giày</b></span>
      <!-- logo for regular state and mobile devices -->
      <span class="logo-lg"><b><img src="images/home/logo.png" alt=""></b></span>
    </a>
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top" role="navigation">
      <!-- Sidebar toggle button-->
      <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
        <span class="sr-only">Toggle navigation</span>
      </a>

     <div class="navbar-custom-menu">
        <ul class="nav navbar-nav"> 
          <li class="user user-menu">
            <a href="user-info.asp">
              <span class="hidden-xs"><%
					if Session("MM_Username") <> "" then
				%>
                  <%=Session.Contents("MM_Username")%> 
				  <% end if %>
			</span>
            </a>
          </li>   
          <li class="user user-menu">
			<a href="<%=MM_Logout%>"><span class="hidden-xs">Đăng xuất</span></a>
          </li>       
        </ul>
      </div>
    </nav>
  </header>
  <!-- Left side column. contains the logo and sidebar -->
  <aside class="main-sidebar">
    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">
      <!-- Sidebar user panel -->
      
      <!-- sidebar menu: : style can be found in sidebar.less -->
      <ul class="sidebar-menu">
        <li class="header">Thanh điều hướng chính</li>
        <li class="<%=activeProductlist%> treeview">
          <a href="#">
            <i class="fa fa-dropbox"></i> <span>Quản lý sản phẩm</span> <i class="fa fa-angle-left pull-right"></i>
          </a>
          <ul class="treeview-menu">
            <li><a href="admin-product.asp"><i class="fa fa-plus"></i> Thêm sản phẩm</a></li>
            <li class="<%=activeProductlistChild%> treeview"><a href="admin-list-product.asp"><i class="fa fa-list"></i> Danh sách <i class="fa fa-angle-left pull-right"></i>
			</a>
				<ul class="<%=activeProductlistChild%> treeview-menu">
					<li><a href="admin-list-product.asp">Tất cả</a></li>
					<li><a href="admin-list-product.asp?inventory=True">Còn hàng</a></li>
					<li><a href="admin-list-product.asp?inventory=False">Hết hàng</a></li>
					<li><a href="admin-list-product.asp?newArrival=True">Hàng mới</a></li>
					<li><a href="admin-list-product.asp?newArrival=False">Hàng cũ</a></li>
				</ul>
			</li>
          </ul>
        </li><!-- /li san pham -->
          <li class="<%=activeBrandlist%> treeview"> <!-- tab thuong hieu -->
          <a href="#">
            <i class="fa fa-laptop"></i>
            <span>Quản lý thương hiệu</span>
            <i class="fa fa-angle-left pull-right"></i>
          </a>
          <ul class="treeview-menu">
            <li><a href="admin-brand.asp"><i class="fa fa-plus"></i> Thêm thương hiệu</a></li>
            <li><a href="admin-brand-list.asp"><i class="fa fa-list"></i> Danh sách thương hiệu</a></li>
          </ul>
        </li><!-- /li dong thuong hieu -->
		
         <li class="<%=activeUserlist%>"><!-- thong tin thanh vien -->
          <a href="admin-user-list.asp">
            <i class="fa fa-user"></i> <span>Quản lý thành viên</span>         
          </a>        
        </li><!-- /li thong tin thanh vien-->
		
         <li class="<%=activeOrderlist%> treeview"><!-- thong tin gio hang -->
          <a href="#">
            <i class="fa fa-shopping-cart"></i> <span>Quản lý đơn hàng</span>
			<i class="fa fa-angle-left pull-right"></i>
          </a>
		    <ul class="treeview-menu">
            <li><a href="admin-order.asp"><i class="fa fa-book"></i> Tất cả</a></li>
            <li><a href="admin-order.asp?status=1"><i class="fa fa-check"></i> Đã xử lý</a></li>
            <li><a href="admin-order.asp?status=0"><i class="fa fa-spinner"></i> Chưa xử lý</a></li>
          </ul>
           </li><!-- /li thong tin gio hang -->
           <li class="<%=activeFeedback%> treeview"><!--Feedback -->
          <a href="admin-feedback.asp">
            <i class="fa  fa-envelope"></i> <span>Quản lý phản hồi</span>
			<i class="fa fa-angle-left pull-right"></i>
          </a>
          <ul class="treeview-menu">
            <li><a href="admin-feedback.asp"><i class="fa fa-book"></i> Tất cả</a></li>
            <li><a href="admin-feedback.asp?status=True"><i class="fa fa-check"></i> Đã xử lý</a></li>
            <li><a href="admin-feedback.asp?status=False"><i class="fa fa-spinner"></i> Chưa xử lý</a></li>
          </ul>
        </li><!-- /li feedback -->
		 <li><!--Comment -->
          <a href="admin-comment.asp">
            <i class="fa  fa-comment"></i> <span>Quản lý bình luận</span>
          </a>
        </li>
		 <li class="treeview"><!-- Home -->
          <a href="admin-panel.asp">
            <i class="fa fa-home"></i> <span>Trang quản trị</span>         
          </a>
         
        </li>
      </ul>
    </section>
    <!-- /.sidebar -->
  </aside>
  <div class="content-wrapper" style="min-height: 323px;">

     <section class="content-header">
      <h1>
       <%=NamePage%>
      </h1>
      <ol class="breadcrumb">
        <li><a href="<%=linkHomeAD%>"><i class="fa fa-home"></i> Trang quản trị</a></li>
		<%=pageChild%>
      </ol>
    </section>