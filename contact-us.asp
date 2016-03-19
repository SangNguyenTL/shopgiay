<!--#include file="header.asp" -->
	<section>
		<div class="container">
			<div class="row">
            <!-- InstanceBeginEditable name="Content" -->
	 <div id="contact-page" class="container">
    	<div class="bg">
	    	<div class="row">    		
	    		<div class="col-sm-12">    			   			
					<h2 class="title text-center">Liên hệ với <strong>Chúng tôi</strong></h2>    			    				    				
					<div id="gmap" class="contact-map">
					</div>
				</div>			 		
			</div>    	
    		<div class="row">  	
	    		<div class="col-sm-8">
	    			<div class="contact-form">
	    				<h2 class="title text-center">Get In Touch</h2>
	    				<div class="status alert alert-success" style="display: none"></div>
				    	<form id="main-contact-form" class="contact-form row" name="main-contact-form" method="POST">
				            <div class="form-group col-md-6">
				                <input type="text" name="name" class="form-control" required placeholder="Name" required pattern="(.){6,50}" title="Từ 6 đến 50 ký tự">
				            </div>
				            <div class="form-group col-md-6">
				                <input type="email" name="email" class="form-control" required placeholder="Email" required title="Xin điền đầy đủ và đúng quy tắc:
abc@gmail.com">
				            </div>
				            <div class="form-group col-md-12">
				                <input type="text" name="subject" class="form-control" required placeholder="Subject" required pattern="(.){10,50}" title="Từ 10 đến 50 ký tự">
				            </div>
				            <div class="form-group col-md-12">
				                <textarea name="message" id="message" required class="form-control" rows="8" placeholder="Nội dung tin nhắn" pattern="(.){10,500}" title="Từ 50 đến 300 ký tự"></textarea>
				            </div>                        
				            <div class="form-group col-md-12">
				                <input type="submit" name="submit" class="btn btn-primary pull-right" value="Submit">
				            </div>
                            <input type="hidden" name="MM_insert" value="main-contact-form">
                        </form>
	    			</div>
	    		</div>
	    		<div class="col-sm-4">
	    			<div class="contact-info">
	    				<h2 class="title text-center">Contact Info</h2>
	    				<address>
	    					<p><%=siteName%></p>
							<p><%=siteAddress%></p>
							<p>Mobile: <%=sitePhone%></p>
							<p>Email: <%=siteEmail%></p>
	    				</address>
	    				<div class="social-networks">
	    					<h2 class="title text-center">Liên kết mạng xã hội</h2>
							<ul>
								<li>
									<a href="<%=siteFacebook%>"><i class="fa fa-facebook"></i></a>
								</li>
								<li>
									<a href="<%=siteTwitter%>"><i class="fa fa-twitter"></i></a>
								</li>
								<li>
									<a href="<%=siteGoogle%>"><i class="fa fa-google-plus"></i></a>
								</li>
								<li>
									<a href="<%=siteYoutube%>"><i class="fa fa-youtube"></i></a>
								</li>
							</ul>
	    				</div>
	    			</div>
    			</div>    			
	    	</div>  
    	</div>	
    </div><!--/#contact-page-->
			<!-- InstanceEndEditable -->
            </div>
		</div>
	</section>
<!--#include file="footer.asp" -->