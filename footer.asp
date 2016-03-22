
<%
Dim rsm
Dim rsm_cmd
Dim rsm_numRows

Set rsm_cmd = Server.CreateObject ("ADODB.Command")
rsm_cmd.ActiveConnection = MM_Connect_STRING
rsm_cmd.CommandText = "SELECT * FROM dbo.tb_Brand order by newID()" 
rsm_cmd.Prepared = true

Set rsm = rsm_cmd.Execute

%>
<%
Dim rsThuonghieu
Dim rsThuonghieu_cmd
Dim rsThuonghieu_numRows

Set rsThuonghieu_cmd = Server.CreateObject ("ADODB.Command")
rsThuonghieu_cmd.ActiveConnection = MM_Connect_STRING
rsThuonghieu_cmd.CommandText = "SELECT * FROM dbo.tb_Brand" 
rsThuonghieu_cmd.Prepared = true

Set rsThuonghieu = rsThuonghieu_cmd.Execute
rsThuonghieu_numRows = 0
%>
<%
Dim rpm_numRows 
Dim rpm_index

rpm_numRows  = 4
rpm_index = 0
rsm_numRows = rsm_numRows + rpm_numRows 
%>
<%
Dim MM_paramten 
%>
<%
' *** Go To Record and Move To Record: create strings for maintaining URL and Form parameters

Dim MM_keepNonee
Dim MM_keepURLl
Dim MM_keepFormm
Dim MM_keepBothh

Dim MM_removeListt
Dim MM_itemm
Dim MM_nextItemm

' create the list of parameters which should not be maintained
MM_removeListt = "&index="
If (MM_paramten <> "") Then
  MM_removeListt = MM_removeListt & "&" & MM_paramten & "="
End If

MM_keepURLl=""
MM_keepFormm=""
MM_keepBothh=""
MM_keepNonee=""

' add the URL parameters to the MM_keepURLl string
For Each MM_itemm In Request.QueryString
  MM_nextItemm = "&" & MM_itemm & "="
  If (InStr(1,MM_removeListt,MM_nextItemm,1) = 0) Then
    MM_keepURLl = MM_keepURLl & MM_nextItemm & Server.URLencode(Request.QueryString(MM_itemm))
  End If
Next

' add the Form variables to the MM_keepFormm string
For Each MM_itemm In Request.Form
  MM_nextItemm = "&" & MM_itemm & "="
  If (InStr(1,MM_removeListt,MM_nextItemm,1) = 0) Then
    MM_keepFormm = MM_keepFormm & MM_nextItemm & Server.URLencode(Request.Form(MM_itemm))
  End If
Next

' create the Form + URL string and remove the intial '&' from each of the strings
MM_keepBothh = MM_keepURLl & MM_keepFormm
If (MM_keepBothh <> "") Then 
  MM_keepBothh = Right(MM_keepBothh, Len(MM_keepBothh) - 1)
End If
If (MM_keepURLl <> "")  Then
  MM_keepURLl  = Right(MM_keepURLl, Len(MM_keepURLl) - 1)
End If
If (MM_keepFormm <> "") Then
  MM_keepFormm = Right(MM_keepFormm, Len(MM_keepFormm) - 1)
End If

' a utility function used for adding additional parameters to these strings
Function MM_joinChar(firstItem)
  If (firstItem <> "") Then
    MM_joinChar = "&"
  Else
    MM_joinChar = ""
  End If
End Function
%>
	<footer id="footer"><!--Footer-->
		<div class="footer-top">
				
				<div class="container">
				<div class="row">
					<div class="col-sm-2">
						<div class="companyinfo">
							<h2><span>G</span>iày <span>C</span>ua <span>T</span>ui</h2>
							<p>Cám ơn bạn đã ghé thăm chúng tôi</p>
						</div>
					</div>
					<div class="col-sm-7">
						<% While ((rpm_numRows  <> 0) AND (NOT rsm.EOF))%>
						<div class="col-sm-3">
							<div class="video-gallery text-center">
								<a href="brand-ds.asp?<%= Server.HTMLEncode(MM_keepNonee) & MM_joinChar(MM_keepNonee) & "brandName=" & rsm.Fields.Item("brandName").Value %>">
									<div class="iframe-img">
										<img src="<%=(rsm.Fields.Item("logo").Value)%>" alt="" />
									</div>
									<div class="overlay-icon">
										<i class="fa fa-play-circle-o"></i>
									</div>
								</a>
								<p><%=(rsm.Fields.Item("brandName").Value)%></p>
							
							</div>
						</div>

                                    
                                    <% 
  rpm_index=rpm_index+1
  rpm_numRows =rpm_numRows -1
  rsm.MoveNext()
Wend
%>
			</div>
					<div class="col-sm-3">
						<div class="address">
							<img src="images/home/map.png" alt="" />
							<p><%=siteAddress%></p>
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

</script>

<% end if %>
<script src="js/jquery.scrollUp.min.js"></script>
<script src="js/price-range.js"></script>
<script src="js/jquery.elevateZoom-3.0.8.min.js"></script>
<script src="js/main.js"></script>

<script type="text/javascript">

	var changeHl = ".cart_quantity_down,.cart_quantity_up,.add-to-cart,.del-comment,.rep-comment".split(",");
				$.each(changeHl,function(key,item){
					$(item).each(function(){
						var url = $(this).attr("href");
						$(this).attr("data-href",url);
						$(this).attr("href",'#');
					})
				});

				$(document).on('click','.add-to-cart',function(){
					var url = $(this).attr("data-href",url);
					$.get($(this).attr("data-href"),{},function(result){
						$(".header-bottom .container").append('<div id="statusBasket"></div>');
						var success =  $($.parseHTML(result)).find(".count.badge").text();
						$("#statusBasket").html('<div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">  <div class="modal-dialog modal-sm">    <div class="modal-content well">Bạn đã thêm một sản phẩm vào giỏ hàng</div>  </div></div>');
						if($($.parseHTML(result)).find("#statusBasket").text()!=""){
							$("#statusBasket").html('<div class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">  <div class="modal-dialog modal-sm">    <div class="modal-content well">'+$($.parseHTML(result)).find("#statusBasket").text()+'</div>  </div></div>');
						}
						$('.bs-example-modal-sm').modal('toggle');
						$(".count.badge").removeClass("hidden").text(success)
					});
					return false
				});
<% IF GetFileName() = "cart.asp" then %>
				$(document).on('click','.cart_quantity_up,.cart_quantity_down',function(){
					var url = $(this).attr("data-href",url);
					var $this = $(this);
					$.get($(this).attr("data-href"),{},function(result){
						var id = "[name="+$this.closest('.cart_quantity_button').find("input").attr("name")+"]";
						result = $($.parseHTML(result));
						var qty = result.find(id).val();
						console.log(qty);
						if(qty == 0 || qty == "0" || qty == undefined){
							$this.closest('tr').remove();
						}else{
							$this.closest('.cart_quantity_button').find("input").val(qty);
							$this.closest('tr').find(".cart_total_price").text(result.find(id).closest('tr').find(".cart_total_price").text());
						}
						$(".total_area span:first,.total_area li:nth-child(3) span").text(result.find(".total_area span:first").text());
					});
					return false
				});
<% end if %>
<% if  GetFileName() = "product-detail.asp" then %>
				$(document).on('click','.del-comment,.rep-comment',function(){
					var url = $(this).attr("data-href",url);
					var $this = $(this);
					$.get($(this).attr("data-href"),{},function(result){
						result = $($.parseHTML(result));
						$("#content-comments").html(result.find("#content-comments").html());
					});
					
					return false
				});
<% end if %>
				$(document).on('click','a[href=#]',function(){
					return false
				});
	$('[data-toggle="modal"]').on('click',function(){
		var $this = $(this);
		var detail = JSON.parse($this.closest('td').find('span.hidden').text());
		var html="";
		$.each(detail.cart_detail,function(key,item){
			html +='<tr>';
			html +='	<td><img src="'+item.img+'" alt="" style="width:90px"></td>';
			html +='	<td><a href="product-detail.asp?productID='+item.id+'">'+item.name+'</td>';
			html +='	<td>';
			html +='		<p>'+item.price+'</p>';
			html +='	</td>';
			html +='	<td>'+item.quantity+'</td>';
			html +='	<td>'+item.total+'</td>';
			html +='</tr>';
		});
		$this.closest('td').find(".content-detail").html(html);
	});

$(document).ready(function () {
$("#zoom_01").elevateZoom({ zoomType: "lens", containLensZoom: true, gallery:'gallery_01f', cursor: 'pointer', galleryActiveClass: "active"}); 

$("#zoom_01").bind("click", function(e) {  
  var ez =   $('#zoom_01').data('elevateZoom');
  ez.closeAll(); //NEW: This function force hides the lens, tint and window	
	$.fancybox(ez.getGalleryList());     
    
  return false;
}); 

}); 
</script>

</body>
<!-- InstanceEnd --></html>
