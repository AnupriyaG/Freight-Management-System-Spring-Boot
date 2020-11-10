<%-- <%@ taglib uri="http://www.xenotrope.com/taglibs/xenoweb" prefix="xw" %>
<%@ taglib uri="http://telus.njit.edu/taglibs/telus" prefix="telus" %> --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<title>NJDOT FMS | Reports</title>
    <jsp:include page="include/head_common.jsp" />
	<!-- VUETIFY -->

<link href="https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.min.css" rel="stylesheet">
<!-- END VUETIFY -->
	<style>
		.nav-tabs > li {margin-bottom: 0;}
		table.dark-bg {
			background-color: rgba(102, 102, 102, 0.8); margin-top: 30px;
		}
		.theme--light.v-application {
			background-color: rgba(0,0,0,0);
		}
		.v-application.theme--dark, .v-card.theme--dark {
			background-color: rgba(0,0,0,0.6);
		}
		/* td {
			color:white !important;
		} */
		/* .v-application input {
    		background-color: transparent !important; 
			border: 0px;
		} */
		.v-application ol, .v-application ul {
    padding-left: 0px;
}
		.theme--light.v-tabs > .v-tabs-bar {
    background-color: transparent;
}
		.v-tab {
    color: #000000 !important;
		background-color: rgba(102,102,102,0.3)
		}
	.v-tab.v-tab--active {
    color: #ffffff !important;
			font-weight: bold;
		background-color: rgba(25,118,210,0.5);
		}
		.v-application .elevation-1 {
			box-shadow: none!important;
			border: 1px #aaaaaa solid;
			border-radius: 0;
		}
		.v-application--is-ltr .v-data-table th {
			_background-color: rgba(25,118,210,0.8);
			background-color: rgba(102,102,102,0.1);
			vertical-align: middle;
			font-size: .7rem;
		}
		
		.v-application--is-ltr .v-data-table th span {
			font-weight: bold;
			color: #000000;
		}
		.v-card__text {
			margin:0px;
			padding:0px;
		}
		.v-application--is-ltr .v-data-table th span {
			font-size: larger;
			text-transform: uppercase;
		}
		[v-cloak] {
  			display: none;
		}

		.v-application--wrap {
			min-height: 10px !important;
		}
		.light-bg.table > tbody > tr > td {
			color:black !important;
		}
		.multiselect__tags {
			border:1px solid rgb(46, 46, 46) !important;
		}
		.v-data-footer__select {
			display:none;
		}
		button[disabled] {
			opacity:0.3;
			border-color:rgba(102, 102, 102, 0.8) !important;
		}
		button[disabled]>i {
			color:rgba(102, 102, 102, 0.8) !important;
		}
		.btn.btn-outline.yellow-gold {
			background: #ffffff;
		}
		
/*a:link i, a:visited i {
color: red;
}

a:hover i {
color: white;}*/
		
	.theme--light.v-data-table {
		border: 1px #666666 solid;
		border-radius: 0;
}

	</style>
</head>

<body class="page-container-bg-solid page-md">
	<div class="page-wrapper">
		<jsp:include page="include/header.jsp" />
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
								<!-- BEGIN PAGE TITLE -->
								<!--div class="page-title">
                                        <h1>Performance-Based Scoring </h1>
                                    </div-->
								<!-- END PAGE TITLE -->
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
								<!-- BEGIN PAGE BREADCRUMBS -->
								<ul class="page-breadcrumb breadcrumb blk">
									<li>
										<a
											href="${pageContext.servletContext.contextPath}/DisplayAdminMainPage">Home</a>
										<i class="fa fa-circle"></i>
									</li>
									<li>
										<span>Reports</span>
									</li>
								</ul>
								<!-- END PAGE BREADCRUMBS -->
								<!-- BEGIN PAGE CONTENT INNER -->
								<div class="page-content-inner">
									<div class="row">
										<div class="col-lg-offset-1 col-lg-10 _col-lg-12 col-md-12 col-sm-12 col-xs-12">
											<!-- BEGIN PORTLET-->
											<div class="portlet light " id="reportsApp">
												<div class="portlet-title">
													<div class="caption">
														<i class="icon-share font-dark"></i>
														<span class="caption-subject font-dark bold uppercase">Reports</span>
													</div>
													<div class="actions">
														<a class="btn dark btn-circle btn-sm"
															href="${pageContext.servletContext.contextPath}/DisplayAdminMainPage">
															<i class="fa fa-arrow-left"></i> Back
														</a>
														<a class="btn btn-circle btn-icon-only btn-default fullscreen"
															href="javascript:;"> </a>
													</div>
												</div>
												<div class="portlet-body form">
													<ul class="nav nav-tabs">
														<li class="active">
															<a href="#tab_1_1" data-toggle="tab">STIP REPORTS</a>
														</li>
														<!-- <li>
															<a href="#tab_1_2" data-toggle="tab">CUSTOM REPORTS</a>
														</li> -->
														<li>
															<a href="#tab_1_3" data-toggle="tab">CUSTOM PROJECTS</a>
														</li>

													</ul>

													<div class="tab-content">

														<div class="tab-pane fade active in" id="tab_1_1">
															<jsp:include page="reports_stip.jsp" />
														</div>
														<!--End of "tab_1_1" -->
														<div class="tab-pane fade" id="tab_1_2" >
															<jsp:include page="reports_custom.jsp" />
														</div>
														<div class="tab-pane fade" id="tab_1_3">
															<jsp:include page="reports_conceptDevelopmentProjects.jsp" />
														</div>
													</div>
													<!--End of "tab_1_1" -->
												</div>
												<!--End of "tab-content"-->
											</div><!-- End of "portlet-body form"-->
										</div>
										<!-- END PORTLET-->
									</div><!-- end of column -->
								</div><!-- end of row -->
							</div>
							<!-- END PAGE CONTENT INNER -->
						</div>
					</div>
					<!-- END PAGE CONTENT BODY -->
					<!-- END CONTENT BODY -->
				</div>
				<!-- END CONTENT -->
			</div>
			<!-- END CONTAINER -->
		</div>
	</div>
	
	<jsp:include page="include/footer_common.jsp" />
	<jsp:include page="include/quicknav.jsp" />
	</div>
	
	
	
	<!-- BEGIN PAGE LEVEL PLUGINS -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/dropzone/5.5.1/dropzone.js" integrity="sha256-awEOL+kdrMJU/HUksRrTVHc6GA25FvDEIJ4KaEsFfG4=" crossorigin="anonymous"></script>
	
	<!-- END PAGE LEVEL PLUGINS -->
	<!-- BEGIN THEME LAYOUT SCRIPTS -->
	<script type="text/javascript" src="assets/global/plugins/select2/js/select2.full.min.js"></script>

	<!-- END THEME LAYOUT SCRIPTS -->
	<link rel="stylesheet" href="https://unpkg.com/vue-multiselect@2.1.0/dist/vue-multiselect.min.css">
	<!-- Vue - Development build -->
	<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
	<script src="https://unpkg.com/vue-multiselect@2.1.0"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.16.1/axios.min.js"></script>
	<script src="https://unpkg.com/vuetable-2@1.6.0"></script>
	<script src="https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.js"></script>
	<script src="js/reports/reports.js"></script>
	<script src="js/reports/stip.js"></script>
	<script src="js/reports/custom.js"></script>
	<script src="js/reports/cdp.js"></script>
	<script>
		$(document).ready(function () {
			fetch("scoringSystems")
				.then(function (response) {
					this.filterLoading = false;
					return response.json();
				})
				.then(data => {
					stipApp.scoringSystems = data;
					customApp.scoringSystems = data;
					cdpApp.scoringSystems = data;
					stipApp.scoringSystemValue = stipApp.scoringSystems[0];
					customApp.customSelectedScoringSystem = customApp.scoringSystems[0];
					cdpApp.cdpSelectedScoringSystem = cdpApp.scoringSystems[0];
					//this.scoringSystemValue = this.scoringSystems[0];
					//this.customSelectedScoringSystem = this.scoringSystems[0];
				}).catch(error => {
					this.filterError = true;
					this.filterLoading = false;
					console.error(error)
				});
			fetch("getCustomRoutes")
            	.then(response => {
            	    this.filterLoading = false;
            	    return response.json();
            	})
            	.then(data => {
            	    fixedData = [];
            	    data.forEach(val => {
            	        fixedData.push({
            	            title: val[0],
            	            value: val[1]
            	        })
            	    })
            	    cdpApp.routes = fixedData
            	}).catch(error => {
            	    this.filterError = true;
            	    console.error(error)
            	});
			$('#clickmewow').click(function () {
				$('#radio1003').attr('checked', 'checked');
			});
			$("select[name='LoginID']").change(function () {
				filterTable();
			});
		})
		$(".table-scrollable").css("border", "0px");
		$(".dataTables_wrapper").css("background-color", "transparent");
		$(".dataTables_wrapper div").removeClass("row");
	</script>
</body>

</html>