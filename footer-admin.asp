
</div>  <!--footer class="main-footer">
    <div class="pull-right hidden-xs">
      <b>Version</b> 1.0.0
    </div>
    <strong>Copyright &copy; 2014-2015 <a href="http://almsaeedstudio.com">Almsaeed Studio</a>.</strong> All rights
    reserved.
  </footer-->

<!-- ./wrapper -->

<!-- jQuery 2.2.0 -->
<script src="js/jquery.js"></script>

<!-- Bootstrap 3.3.5 -->
<script src="bootstrap/js/bootstrap.min.js"></script>
<!-- Bootstrap WYSIHTML5 -->
<script src="plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>
<!-- Slimscroll -->
<script src="plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- FastClick -->
<script src="plugins/fastclick/fastclick.js"></script>
<!-- AdminLTE App -->
<script src="dist/js/app.min.js"></script>

<script type="text/javascript">
$('.delFeed').on('click',function(){
	var $this = $(this);
	feedId = $this.val();
	$.post('ajaxdelfeed.asp',{
		feedId: feedId,
		MM_deelete: 'delFeed'
	},function(){
		alert('Xóa thành công feedback có ID = '+feedId);
		$this.closest('tr').hide('slow');
	});
});
$(document).on('click','.updateStatus.pending',function(){
	var $this = $(this);
	feedId = $this.val();
	$.post('ajaxstatusfeed.asp',{
		feedId: feedId,
		statusFeed: 1,
		MM_update: 'updateFeed'
	},function(){
		$this.removeClass('pending').addClass('pended');
		$this.html('Đã xử lý');
	});
});
$(document).on('click','.updateStatus.pended',function(){
	var $this = $(this);
	feedId = $this.val();
	$.post('ajaxstatusfeed.asp',{
		feedId: feedId,
		statusFeed: 0,
		MM_update: 'updateFeed'
	},function(){
		$this.removeClass('pended').addClass('pending');
		$this.html('Chưa xử lý');
	});
});
</script>
<% if GetFileName() = "admin-product.asp" then %>
<script type="text/javascript">
$(document).on("submit","form#formUpload",function(e) {

	e.preventDefault();
	
	var formData = new FormData($(this)[0]);
	var $this = $(this).closest('.box-info').find('.statusUpload');
	if ($this.hasClass("alert-danger")||$this.hasClass("alert-success")){
		$this.removeClass("alert-danger");
		$this.removeClass("alert-success");
	}
	if(!$('[name="file1"]')[0].files[0]){
		$this.addClass("alert-danger").text("Bạn chưa chọn ảnh để tải lên server!").fadeIn().delay(3000).fadeOut();
	}else if($('[name="file1"]')[0].files[0].size>2097152){
		$this.addClass("alert-danger").text("Ảnh không được vượt quá 2Mb!").fadeIn().delay(3000).fadeOut();
	}else
	$.ajax({
	  url: 'uploadEnd.asp',
	  data: formData,
	  processData: false,
	  contentType: false,
	  type: 'POST',
	  success: function(result){
		if(result=="not"){
			$this.addClass("alert-danger").text("Không thể tải ảnh này lên máy chủ").fadeIn().delay(3000).fadeOut();
		}else if (result=="dub"){
			$this.addClass("alert-danger").text("Tên ảnh này đã tồn tại").fadeIn().delay(3000).fadeOut();

		}else{
			$this.addClass("alert-success").text("Tải ảnh lên server thành công").fadeIn().delay(3000).fadeOut();
			if($('[name="ProPic"]').val()=="")
			$('[name="ProPic"]').val(result);
			else $('[name="ProPic"]').val($('[name="ProPic"]').val()+","+result);
			$(".imageProduct").html('');
			$.each($('input[name=ProPic]').val().split(","),function(key,index){
				$(".imageProduct").append('<img class="img-thumbnail" src="'+index+'"/>')
			})
		}
	  }
	});
});
$(document).on("change","input[name=ProPic]",function(){
	$(".imageProduct").html('');
	$.each($(this).val().split(","),function(key,index){
		$(".imageProduct").append('<img class="img-thumbnail"  src="'+index+'"/>')
	})
});
$(document).ready(function(){
	$(".imageProduct").html('');
	$.each($('input[name=ProPic]').val().split(","),function(key,index){
		$(".imageProduct").append('<img class="img-thumbnail"  src="'+index+'"/>')
	})
});
</script>
<% end if 
if GetFileName() = "admin-brand.asp" then
%>
<script type="text/javascript">
$(document).on("submit","form#formUpload",function(e) {

	e.preventDefault();
	
	var formData = new FormData($(this)[0]);
	var $this = $(this).closest('.box-info').find('.statusUpload');
	if ($this.hasClass("alert-danger")||$this.hasClass("alert-success")){
		$this.removeClass("alert-danger");
		$this.removeClass("alert-success");
	}
	if(!$('[name="file1"]')[0].files[0]){

		$this.addClass("alert-danger").text("Bạn chưa chọn ảnh để tải lên server!").fadeIn().delay(3000).fadeOut();
	}else if($('[name="file1"]')[0].files[0].size>2097152){
		$this.addClass("alert-danger").text("Ảnh không được vượt quá 2Mb!").fadeIn().delay(3000).fadeOut();
	}else
	$.ajax({
	  url: 'uploadEndBrand.asp',
	  data: formData,
	  processData: false,
	  contentType: false,
	  type: 'POST',
	  success: function(result){
		if(result=="not"){
			$this.addClass("alert-danger").text("Không thể tải ảnh này lên máy chủ").fadeIn().delay(3000).fadeOut();
		}else if (result=="dub"){
			$this.addClass("alert-danger").text("Tên ảnh này đã tồn tại").fadeIn().delay(3000).fadeOut();
		}else{
			$this.addClass("alert-success").text("Tải ảnh lên server thành công").fadeIn().delay(3000).fadeOut();
			$('[name="ProPic"]').val(result);
			$.each($('input[name=ProPic]').val().split(","),function(key,index){
				$(".imageProduct").html('<img class="img-thumbnail" src="'+index+'"/>')
			})
		}
	  }
	});
});
$(document).on("change","input[name=ProPic]",function(){
	$(".imageProduct").html('');
	$(".imageProduct").html('<img class="img-thumbnail"  src="'+$(this).val()+'"/>')
});
$(document).ready(function(){
	$(".imageProduct").html('');
	$(".imageProduct").html('<img class="img-thumbnail"  src="'+$('input[name=ProPic]').val()+'"/>')
});
</script>
<% end IF %>
<script type="text/javascript">
	$('.frmDel').on('click',function(){
		var $this = $(this);
		userID = $this.val();
		$.post('ajaxdeluser.asp',{
			userID : userID,
			MM_delete : 'frmDel'
		},function(){
			alert('Xóa thành công user có ID = '+userID);
			$this.closest('tr').hide('slow');
		});
});
</script>
</body>
</html>