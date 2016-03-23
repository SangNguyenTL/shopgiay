// Google Map Customization
var form = $('.contact-form');
form.submit(function () {'use strict',

	$this = $(this);
	$this.find('[name="submit"]').before('<i class="fa fa-spinner"> Đang xử lý</i>');
	var $name = $('[name="name"]'),
	$email = $('[name="email"]'),
	$subject = $('[name="subject"]'),
	$message = $('[name="message"]');
	$this.find('[name="submit"]').attr('disabled','');
	if($name.val().length < 6 || $name.val().length > 50){
		$name.focus();
		$this.prev().text("Tên người gửi phải từ 6 đến 50 ký tự").fadeIn().delay(3000).fadeOut();
		$this.find('[name="submit"]').removeAttr('disabled');
		$this.find('.fa-spinner').remove();
		return false;
	}else if(!$email.val().match(/[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$/)){
		$email.focus();
		$this.prev().text("Email không đúng định dạng").fadeIn().delay(3000).fadeOut();
		$this.find('[name="submit"]').removeAttr('disabled');
		$this.find('.fa-spinner').remove();
		return false;
	}else if($subject.val().length<10 || $subject.val().length>50){
		$subject.focus();
		$this.prev().text("Tiêu đề phải từ 10 đến 50 ký tự").fadeIn().delay(3000).fadeOut();
		$this.find('[name="submit"]').removeAttr('disabled');
		$this.find('.fa-spinner').remove();
		return false;
	}
	else if($message.val().length<10 || $message.val().length>500){
		$message.focus();
		$this.prev().text("Nội dung phải từ 50 đến 500 ký tự").fadeIn().delay(3000).fadeOut();
		$this.find('[name="submit"]').removeAttr('disabled');
		$this.find('.fa-spinner').remove();
		return false;
	}else{
		$.get("sendcontact.asp", $(".contact-form").serialize(),function(result){
			result = JSON.parse(result);
			if(result[0].type == 'success'){
				$this.prev().text(result[0].message).fadeIn().delay(3000).fadeOut();
			}
			if(result[0].type == 'notFill'){
				$this.prev().text(result[0].message).fadeIn().delay(3000).fadeOut();
			}
			//$this.find('[name="submit"]').removeAttr('disabled');
		});
		$this.find('[name="submit"]').removeAttr('disabled');
		$this.find('.fa-spinner').remove();
		return false;
	}
});
(function(){

	var map;

	map = new GMaps({
		el: '#gmap',
		lat: 10.7869367,
		lng: 106.6662187,
		scrollwheel:false,
		zoom: 14,
		zoomControl : false,
		panControl : false,
		streetViewControl : false,
		mapTypeControl: false,
		overviewMapControl: false,
		clickable: false
	});

	var image = 'images/map-icon.png';
	map.addMarker({
		lat: 10.7869367,
		lng: 106.6662187,
		// icon: image,
		animation: google.maps.Animation.DROP,
		verticalAlign: 'bottom',
		horizontalAlign: 'center',
		backgroundColor: '#ffffff',
	});

	var styles = [ 

	{
		"featureType": "road",
		"stylers": [
		{ "color": "" }
		]
	},{
		"featureType": "water",
		"stylers": [
		{ "color": "#A2DAF2" }
		]
	},{
		"featureType": "landscape",
		"stylers": [
		{ "color": "#ABCE83" }
		]
	},{
		"elementType": "labels.text.fill",
		"stylers": [
		{ "color": "#000000" }
		]
	},{
		"featureType": "poi",
		"stylers": [
		{ "color": "#2ECC71" }
		]
	},{
		"elementType": "labels.text",
		"stylers": [
		{ "saturation": 1 },
		{ "weight": 0.1 },
		{ "color": "#111111" }
		]
	}

	];

	map.addStyle({
		styledMapName:"Styled Map",
		styles: styles,
		mapTypeId: "map_style"  
	});

	map.setStyle("map_style");
}());