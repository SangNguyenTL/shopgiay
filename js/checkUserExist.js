var urlCheckuser = 'checkExistuser.asp';
// Ajax check user
$(document).on('blur','#form2 input[name="txtEmail"]', function(e){
	$('.check-status').remove();
	$('#form2 input[name="txtEmail"]').after('<i class="fa-spinner fa check-status text-info"> Đang xử lý...</i>');
	$('#form2 button').attr('disabled','');
	if($('#form2 input[name="txtEmail"]').val().match(/[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$/)&&($('#form2 input[name="txtEmail"]').val().length>=6&&$('#form2 input[name="txtEmail"]').val().length<=50)){
		$.get(urlCheckuser,{emailUser:$('#form2 input[name="txtEmail"]').val()
		},function(result){
			$('.check-status').remove();
			if(result=='exist'){
				$('#form2 input[name="txtEmail"]').after('<i class="fa-times fa check-status text-danger"> Email đã tồn tại</i>');
				$('#form2 input[name="txtEmail"]').val('');
			} 
			else if(result=='notExist')
				$('#form2 input[name="txtEmail"]').after('<i class="fa-check fa check-status text-success"> Bạn có thể sử dụng email này</i>');
				$('#form2 button').removeAttr('disabled');
			
		})
	}else{
		$('.check-status').remove();
		$('#form2 input[name="txtEmail"]').after('<i class="fa-times fa check-status text-danger"> Bạn phải nhập đúng định dạng email và từ 6 đến 50 ký tự</i>');
		$('#form2 input[name="txtEmail"]').val('');
	}
});