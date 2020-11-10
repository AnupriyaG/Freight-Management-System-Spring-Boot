<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="req" value="${pageContext.request}" />
<c:set var="url">${req.requestURL}</c:set>
<c:set var="uri" value="${req.requestURI}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>NJDOT FMS | Page Not Found</title>
		<jsp:include page="/WEB-INF/jsp/include/head_common.jsp" />
		<!-- BEGIN PAGE LEVEL PLUGINS -->
		<link href="assets/global/plugins/datatables/datatables.min.css" rel="stylesheet" type="text/css" />
		<link href="assets/global/plugins/datatables/plugins/bootstrap/datatables.bootstrap.css" rel="stylesheet" type="text/css" />
		<!-- END PAGE LEVEL PLUGINS -->
	</head>
	<body class="page-container-bg-solid page-md">
		<div class="page-wrapper">
			<div class="page-wrapper-row">
				<div class="page-wrapper-top">
					<jsp:include page="/WEB-INF/jsp/include/header.jsp"/>
				</div>
			</div>
			<div class="page-wrapper-row full-height">
				<div class="page-wrapper-middle">
					<!-- BEGIN CONTAINER -->
					<div class="page-container">
						<!-- BEGIN CONTENT -->
						<div class="page-content-wrapper">
							<!-- BEGIN CONTENT BODY -->
							<!-- BEGIN PAGE HEAD-->
							<div class="page-head">
								<div class="container-fluid">
									
									<!-- BEGIN PAGE TOOLBAR -->
									<div class="page-toolbar">
										<!-- BEGIN THEME PANEL -->
										<!-- END THEME PANEL -->
									</div>
									<!-- END PAGE TOOLBAR -->
								</div>
							</div>
							<!-- END PAGE HEAD-->
							<!-- BEGIN PAGE CONTENT BODY -->
							<div class="page-content">
								<div class="container-fluid">
                            		<!-- BEGIN PAGE CONTENT INNER -->
                                    <div class="page-content-inner">
										<div class="row">
											<div class="col-lg-offset-1 col-lg-10 col-md-12 col-sm-12 col-xs-12">
												<!-- BEGIN PORTLET-->
					 							<div class="portlet light ">
													<div class="portlet-title">
														<div class="caption">
															<i class="icon-share font-dark"></i>
                                                            <span class="caption-subject font-dark bold uppercase">404 - Page Not Found</span>
                                                        </div>
                                                        <div class="actions">
                                                           <a class="btn btn-circle btn-icon-only btn-default fullscreen" href="javascript:;"> </a>
                                                        </div>
                                                    </div>
                                                    <div class="portlet-body">
                                                    	<div class="row">
                                                    		<div class="col-md-12">
                                                    			The server generated a 404 Error, This means that the page you requested could not be found
                                                    			
                                                    		</div>
                                                    		<div class="col-md-12" style="background: rgba(255,255,255,0.8);">
                                                    			<p>If you would like to report this error, please provide the following information:</p>
                                                    			<ul>
                                                    				<li><b>Date and Time:</b> <%= new java.util.Date() %></li>
                                                    				<li><b>Requested URL:</b> ${pageContext.request.scheme}://${header.host}${pageContext.errorData.requestURI}</li>
                                                    				<li><b>Session ID:</b> <%=request.getSession().getId() %> </li>
                                                    				
                                                    			</ul>
                                                    			
                                                    			
                                                    			
                                                     		</div>
                                                    	</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
							</div>				
						</div>
					</div>
				</div>
			</div>
			<jsp:include page="/WEB-INF/jsp/include/footer_common.jsp" />
		</div>
		<!-- BEGIN PAGE LEVEL PLUGINS -->
		<script src="${pageContext.servletContext.contextPath}/assets/global/scripts/datatable.js" type="text/javascript"></script>
		<script src="${pageContext.servletContext.contextPath}/assets/global/plugins/datatables/datatables.min.js" type="text/javascript"></script>
		<script src="${pageContext.servletContext.contextPath}/assets/global/plugins/datatables/plugins/bootstrap/datatables.bootstrap.js" type="text/javascript"></script>
		<!-- END PAGE LEVEL PLUGINS -->
	</body>
</html>