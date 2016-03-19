<!--#include file="header-admin.asp" -->
   
    <%
Dim rsProduct
Dim rsProduct_cmd
Dim rsProduct_numRows
Dim rsCount_total


Set rsProduct_cmd = Server.CreateObject ("ADODB.Command")
rsProduct_cmd.ActiveConnection = MM_Connect_STRING
rsProduct_cmd.CommandText = "SELECT Count(*) as 'NumPro' FROM dbo.tb_product " 
rsProduct_cmd.Prepared = true

Set rsProduct = rsProduct_cmd.Execute
rsProduct_numRows = 10

rsCount_total = rsProduct.Fields.Item("NumPro").Value
%>
<%
Dim rsCountFeedback
Dim rsCountFeedback_cmd
Dim rsCountFeedback_numRows
Dim	rsCountF

Set rsCountFeedback_cmd = Server.CreateObject ("ADODB.Command")
rsCountFeedback_cmd.ActiveConnection = MM_Connect_STRING
rsCountFeedback_cmd.CommandText = "SELECT Count(*) as 'NumFeed' FROM dbo.tb_feedback" 
rsCountFeedback_cmd.Prepared = true

Set rsCountFeedback = rsCountFeedback_cmd.Execute
rsCountFeedback_numRows = 10
rsCountF=rsCountFeedback.Fields.Item("NumFeed").Value
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

              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
               
                  <div class="input-group-btn">
                 
                  </div>
                </div>
              </div>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover">
                <tbody><tr>
					<div class="callout callout-warning">
					<h4>Đơn hàng</h4>
					<p>Có ?? đơn hàng chưa xử lý.
					<a href="" class="small-box-footer pull-right">
					 <i class="fa  fa-hand-o-right "></i>
					</a></p>
					</div>
                </tr>
                <tr>
					<div class="callout callout-info">
					<h4>Phản hồi</h4>
					<p>Có <%= rsCountF %> feedback mới chưa được trả lời. 
					<a href="admin-feedback.asp?status=False" class="small-box-footer pull-right">
					 <i class="fa  fa-hand-o-right "></i>
					</a></p>
					</div>
                </tr>
                <tr>
					<div class="callout callout-danger">
					<h4>Sản phẩm</h4>
					<p>Có <%= rsCount_total%> sản phẩm đã hết hàng.
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
<%
rsProduct.Close()
Set rsProduct = Nothing
%>
