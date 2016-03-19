
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
							<h2><span>G</span>iày <span>C</span>ủa <span>T</span>ui</h2>
							<p>Thanks you for visiting us websites.</p>
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
