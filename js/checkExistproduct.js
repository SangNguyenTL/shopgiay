var urlCheckproduct = 'checkExistproduct.asp';
// Ajax check user
$(document).on('blur','#form1 input[name="txtNamepro"]', function(e){
	$('.check-status').remove();
	$('#form1 input[name="txtNamepro"]').after('<i class="fa-spinner fa check-status text-info"> Đang xử lý...</i>');
	$('#form1 button').attr('disabled','');
	if($('#form1 input[name="txtNamepro"]').val()&&($('#form1 input[name="txtNamepro"]').val().length>=6&&$('#form1 input[name="txtNamepro"]').val().length<=70)){
		$.get(urlCheckproduct,{proName:$('#form1 input[name="txtNamepro"]').val()
		},function(result){
			$('.check-status').remove();
			if(result=='exist'){
				$('#form1 input[name="txtNamepro"]').after('<i class="fa-times fa check-status text-danger"> Sản phẩm đã tồn tại</i>');
				$('#form1 input[name="txtNamepro"]').val('');
			} 
			else if(result=='notExist')
				$('#form1 input[name="txtNamepro"]').after('<i class="fa-check fa check-status text-success"> Bạn có thể sử dụng tên này</i>');
				$('#form1 button').removeAttr('disabled');
			
		})
	}else{
		$('.check-status').remove();
		$('#form1 input[name="txtNamepro"]').after('<i class="fa-times fa check-status text-danger"> Tên phải từ 6 đến 30 kí tự</i>');
		$('#form1 input[name="txtNamepro"]').val('');
	}
});