<div class="container-fluid">
		<div class="container" style="margin-bottom:25px;">
		<form method="#">
				<div class="form-main-fo2">
					<div class="form-alignments-fo2">
						<h3 class="form-fo2-title">Register with us</h3>
						<div class="row form-fo2-contents">
							<div class="row"><%@include file="sociallogin.jsp"%> 
								<div class="col-xs-12 col-sm-6 form-group">
									<div class="row fo2-alg">
										<div class="col-xs-12 col-sm-3 form-group">
											<label class="control-label forms-title-color-fo form-filedfirst-fo2-label form-label-name-fo2">Email Id<span class="asterisk-sign-clr">*</span></label>
										</div>
										<div class="col-xs-12 col-sm-8 paddingZero form-filedfirst-fo2">
            								<input  type="text" id="emailID" name="emailID" value="${requestScope.email}" style="text-align:left;"/>
										</div>
									</div>
								<div class="row fo2-alg">
										<div class="col-xs-12 col-sm-3 form-group">
											<label class="control-label forms-title-color-fo form-filedfirst-fo2-label form-label-name-fo2">First Name<span class="asterisk-sign-clr">*</span></label>
										</div>
										<div class="col-xs-12 col-sm-8 paddingZero form-filedfirst-fo2">
            							<input  type="text" id="firstName" name="firstName" value="${requestScope.firstName}" style="text-align:left;"/>
										</div>
									</div>
									<div class="row fo2-alg">
										<div class="col-xs-12 col-sm-3 form-group">
											<label class="control-label forms-title-color-fo form-filedfirst-fo2-label form-label-name-fo2">Last Name<span class="asterisk-sign-clr">*</span></label>
										</div>
										<div class="col-xs-12 col-sm-8 paddingZero form-filedfirst-fo2">

									<input type="text" id="lastName"  id="lastName" type="text"  name="lastName" value="${requestScope.lastName}" value=" " style="text-align:left;"/>
										</div>
									</div>

								</div>								
								<div class="col-xs-12 col-sm-6 form-group paddingFo1Right">
									<div class="row fo2-alg">
										<div class="col-xs-12 col-sm-4 form-group">
										   <label class="control-label forms-title-color-fo form-filedfirst-fo2-label col-md-offset-1 fo2PwdMargn">Password<span class="asterisk-sign-clr">*</span></label>
										</div>
										<div class="col-xs-12 col-sm-8 paddingZero">
											<input  type="password" id="password" name="password" value="" style="text-align:left;"/><br/>
										</div>
									</div>
									<div class="row fo2-alg">
										<div class="col-xs-12 col-sm-4 form-group">
											<label class="control-label forms-title-color-fo form-filedfirst-fo2-label col-md-offset-1 form-label-name-fo2">Country</label>
										</div>
										<div class="col-xs-12 col-sm-8 paddingZero">
											<input  name="country" type="text" value="${requestScope.country}" style="text-align:left;" />
										</div>
									</div>
									<div class="row fo2-alg">
										<div class="col-xs-12 col-sm-4 form-group">
											<label class="control-label forms-title-color-fo form-filedfirst-fo2-label col-md-offset-1">Address</label>
										  
										</div>
										<div class="col-xs-12 col-sm-8 paddingZero">
											<input  name="address" type="text" value="${requestScope.address}" style="text-align:left;" />
										</div>
									</div>									
								</div>

						<div class="row fo2-buttons">
									<div class="col-xs-12 col-md-12  form-group col-md-offset-1 col-sm-offset-1 paddingZero">
										<div class="col-md-4 col-sm-3 col-xs-6 paddingZero">
											<div class="form-group form-fo2-next">
										<input type="button" class="btnnew" value="Sign up"  name="submit" id="submit" style="color: #e1e1e1 !important;background-color: #000000; border: 0; height: 45px; width:150px;margin-left: 58px;">
											</div>
										</div>

									</div>

								</div>

</form>
</div>
</div>
</div>
</div>
</div>
</div>
</div>

