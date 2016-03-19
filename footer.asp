	<footer id="footer"><!--Footer-->
		<div class="footer-top">
				
				<div class="container">
				<div class="row">
					<div class="col-sm-2">
						<div class="companyinfo">
							<h2><span>G</span>iày <span>C</span>ủa <span>T</span>ui</h2>
							<p>Thanks you for visiting us websites.</p>
						</div>
					</div>
					<div class="col-sm-7">
						<div class="col-sm-3">
							<div class="video-gallery text-center">
								<a href="#">
									<div class="iframe-img">
										<img src="images/home/van.jpg" alt="" />
									</div>
									<div class="overlay-icon">
										<i class="fa fa-play-circle-o"></i>
									</div>
								</a>
								<p>VAN</p>
							</div>
						</div>
						
						<div class="col-sm-3">
							<div class="video-gallery text-center">
								<a href="#">
									<div class="iframe-img">
										<img src="images/home/JOR.jpg" alt="" />
									</div>
									<div class="overlay-icon">
										<i class="fa fa-play-circle-o"></i>
									</div>
								</a>
								<p>JORDAN</p>
								
							</div>
						</div>
						
						<div class="col-sm-3">
							<div class="video-gallery text-center">
								<a href="#">
									<div class="iframe-img">
										<img src="images/home/ADI.jpg" alt="" />
									</div>
									<div class="overlay-icon">
										<i class="fa fa-play-circle-o"></i>
									</div>
								</a>
								<p>ADIDAS</p>
							
							</div>
						</div>
						
						<div class="col-sm-3">
							<div class="video-gallery text-center">
								<a href="#">
									<div class="iframe-img">
										<img src="images/home/NIKE.png" alt="" />
									</div>
									<div class="overlay-icon">
										<i class="fa fa-play-circle-o"></i>
									</div>
								</a>
								<p>NIKE</p>
							</div>
						</div>
					</div>
					<div class="col-sm-3">
						<div class="address">
							<img src="images/home/map.png" alt="" />
							<p>590 CMT8,Ho Chi Minh City, VietNam</p>
						</div>
					</div>
				</div>
			</div>			
		</div>
		
	
		
		<div class="footer-bottom">
			<div class="container">
				<div class="row">
					<p class="pull-left">Copyright © 2016 Giày của tui Inc. All rights reserved.</p>
				</div>
			</div>
		</div>
		
	</footer><!--/Footer-->
	

  
<script src="js/jquery.js"></script>
<script src="js/bootstrap.min.js"></script>
<% IF GetFileName() = "contact-us.asp" then %>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyClnSzPG1-TNBZKlS4el2c9ja3y91BHXXs"></script>
<script type="text/javascript" src="js/gmaps.js"></script>
<script src="js/contact.js"></script>
<% end if %>
<% IF GetFileName() = "login.asp" then %>
<script type="text/javascript" src="js/checkUserExist.js"></script>
<% end if %>
<% IF GetFileName() = "dangnhap.asp" then %>
<script type="text/javascript" src="js/checkUserExist.js"></script>
<% end if %>
<% IF GetFileName() = "index.asp" then %>
<script type="text/javascript">	
				$('.nav.nav-tabs#checkbrand a').click(function() {
				var vall = $(this).text(); // lay gia tri  cua tab vua click
				
					$.post('ajaxloadproduct.asp',{
						brandName : vall // gan gia tri vua lay vao brandname rồi chuyen qa trang ajax
					},function(result){
						$("#checkbrand").closest(".category-tab").find(".tab-pane").html(result)
					$('#checkbrand .add-to-cart').each(function(){
						var url = $(this).attr("href");
						$(this).attr("data-href",url);
						$(this).attr("href",'#');
					});
					});
						
				});
				$(document).ready(function(){

					 $("#checkbrand li:first").addClass("active");
					$.post('ajaxloadproduct.asp',{
						brandName : $("#checkbrand li:first a").text(),
					},function(result){
						$("#checkbrand").closest(".category-tab").find(".tab-pane").html(result);
					$('#checkbrand li:first .add-to-cart').each(function(){
						var url = $(this).attr("href");
						$(this).attr("data-href",url);
						$(this).attr("href",'#');
					});
					});
				})
				$(document).on('click','a[href=#]',function(){
					return false
				});
				$(document).on('click','.add-to-cart',function(){
					var url = $(this).attr("data-href",url);
					$.get($(this).attr("data-href"),{},function(result){
						var success =  $($.parseHTML(result)).find(".count.badge").text();
						console.log(success);
						$(".count.badge").removeClass("hidden").text(success)
					});
					return false
				});
</script>
<!--script type="text/javascript">	
				$('.search_box #find').blur(function() {
					var value = $(this).text();
					$.post('ajaxindexfind.asp',{
						productname : value
					},function(){
						$("")
					});
				});
</script-->
<% end if %>
<script type="text/javascript">
					$('.add-to-cart').each(function(){
						var url = $(this).attr("href");
						$(this).attr("data-href",url);
						$(this).attr("href",'#');
					});
				
</script>
<script src="js/jquery.scrollUp.min.js"></script>
<script src="js/price-range.js"></script>
<script src="js/jquery.prettyPhoto.js"></script>
<script src="js/main.js"></script>
</body>
<!-- InstanceEnd --></html>
