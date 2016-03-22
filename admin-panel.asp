<!--#include file="header-admin.asp" -->
   
    <%
Dim rsCount_total
Dim quantityQuery2
set quantityQuery2 = getValuequery("Count(*) as 'NumPro'","dbo.tb_product","where inventory = 0")
rsCount_total = quantityQuery2.Item("NumPro")
set quantityQuery2 = nothing
%>
<%

Dim	rsCountF
set quantityQuery2 = getValuequery("Count(*) as 'NumFeed'","dbo.tb_feedback","where status = 0")
rsCountF = quantityQuery2.Item("NumFeed")
set quantityQuery2 = nothing

Dim	rsCountO
set quantityQuery2 = getValuequery("Count(*) as 'NumO'","dbo.tb_order","where status = 0")
rsCountO = quantityQuery2.Item("NumO")
set quantityQuery2 = nothing

%>
<!-- Content Header (Page header) -->

    
    <section class="content">
      <div class="row">
        
        <!-- /.col -->
        
        <!-- /.col -->
      </div>
      <!-- /.row -->
      <div class="row">
        <div class="col-xs-12">
            <div class="box-header">
              <h3 class="box-title">Thông báo</h3>

            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tbody><tr>
					<div class="callout callout-warning">
					<h4>Đơn hàng</h4>
					<p>Có <%=rsCountO%> đơn hàng chưa xử lý.
					<a href="admin-order.asp?status=0" class="small-box-footer pull-right">
					 <i class="fa  fa-hand-o-right "></i>
					</a></p>
					</div>
                </tr>
                <tr>
					<div class="callout callout-info">
					<h4>Phản hồi</h4>
					<p>Có <%=rsCountF %> phản hồi mới chưa được trả lời. 
					<a href="admin-feedback.asp?status=False" class="small-box-footer pull-right">
					 <i class="fa  fa-hand-o-right "></i>
					</a></p>
					</div>
                </tr>
                <tr>
					<div class="callout callout-danger">
					<h4>Sản phẩm</h4>
					<p>Có <%=rsCount_total%> sản phẩm đã hết hàng.
					<a href="admin-list-product.asp?inventory=False" class="small-box-footer pull-right">
					 <i class="fa  fa-hand-o-right "></i>
					</a></p>
					</div>
                </tr>
                <tr>
                 
                </tr>
                <tr>
                 
                </tr>
              </tbody></table>
</div>
            <!-- /.box-body -->

          <!-- /.box -->
        </div>
      </div>
    </section>
    <!-- /.content --> 
<!--#include file="footer-admin.asp" -->
