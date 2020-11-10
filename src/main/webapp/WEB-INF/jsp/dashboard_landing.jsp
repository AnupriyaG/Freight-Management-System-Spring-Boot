<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>

	<title>NJDOT FMS | Dashboard</title>
	<jsp:include page="include/head_common.jsp" />
	
	<script src="assets/global/plugins/jquery.min.js" type="text/javascript"></script>
	
	<script type="text/javascript" src="js/html2pdf.bundle.js"></script>
	<script type="text/javascript" src="assets/global/plugins/select2/js/select2.full.min.js"></script>
	<link rel="stylesheet" type="text/css" href="assets/global/plugins/select2/css/select2-bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="assets/global/plugins/select2/css/select2.min.css" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.5/jspdf.debug.js"></script>
	<script src="https://code.highcharts.com/highcharts.js"></script>
	<script src="https://code.highcharts.com/modules/exporting.js"> </script>
	<script src="https://code.highcharts.com/modules/offline-exporting.js"> </script>
	<!-- development version, includes
		helpful console warnings -->
	<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
	<script src="https://unpkg.com/vue-multiselect@2.1.0"></script>

	<script type="text/javascript"
        src="https://cdn.jsdelivr.net/npm/vue-highcharts/dist/vue-highcharts.min.js"></script>
        <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/highcharts/7.2.0/css/highcharts.css'/> 
	<style>
		.portlet-body {
			background-color: rgba(255, 255, 255, 0.8);
		}

		h3,
		h4 {
			font-weight: bolder;
		}

		h4 {
			font-size: 22px;
		}

		

		


		.select2-container--bootstrap .select2-selection--single {
			line-height: 1.2;
		}

		.select2-container .select2-selection--single .select2-selection__rendered {
			display: block;
			padding-left: 0px;
			padding-right: 0px;
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
		}

		.select2-choices {
			height: 100px;
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
										<a href="DisplayAdminMainPage">Home</a>
										<i class="fa fa-circle"></i>
									</li>
									<li>
										<span>Dashboard</span>
									</li>
								</ul>
								<!-- END PAGE BREADCRUMBS -->
								<!-- BEGIN PAGE CONTENT INNER -->
								<div class="page-content-inner">
									<div class="row">
										<div class="col-lg-offset-1 col-lg-10 col-md-12 col-sm-12 col-xs-12">
											<div class="portlet light ">
												<div class="portlet-title">
													<div class="caption">
														<i class="fa fa-tachometer font-dark"
															style="margin-top: -1px;"></i>
														<span
															class="caption-subject font-dark bold uppercase">Performance
															Indicators (2014 - 2016)</span>
													</div>
													<div class="actions">
														<a class="btn dark btn-circle btn-sm"
															href="DisplayAdminMainPage">
															<i class="fa fa-arrow-left"></i> Back
														</a>
														<a class="btn btn-circle btn-icon-only btn-default fullscreen"
															href="javascript:;" data-original-title="" title=""> </a>
													</div>
												</div>
												<div class="portlet-body" id="dashboardApp">
													<div class="row">
														<div class="col-md-12"
															style="text-align: right; padding-right:30px;">
															<a v-on:click="exportCharts"
																class="btn yellow-gold mt-ladda-btn ladda-button btn-outline"
																style="font-size: 1.1em;text-transform: initial"><i
																	class="fa fa-file-pdf-o" style="color:red;"></i>
																Download PDF</a>
															<
													</div>
													<div class="row">
														<div class="col-sm-5">
															<div class="col-md-12 text-center">
																<h4>New Jersey Interstate System</h4>
															</div>
															<div class="col-md-12" v-if="tttriChartLoaded">
																<highcharts ref="tttriChart" :options="tttriChartData"
																	style="height: 250px">
																</highcharts>
															</div>
															<div class="col-md-12" v-else style="height:350px">
																LOADING
															</div>
															<div class="col-md-12">&nbsp;</div>
															
															<div class="col-md-12" v-if="percTotalCrashesChartLoaded">
																<highcharts ref="percTotalCrashesChart"
																	:options="percTotalCrashesChartData"
																	style="height: 250px">
																</highcharts>
															</div>
															<div class="col-md-12" v-else style="height:350px">
																LOADING
															</div>
														</div>
														<div class="col-sm-7">
															
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
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
		</div>
		<div class="page-wrapper-row">
			<div class="page-wrapper-bottom">
				<!-- BEGIN FOOTER -->

				<!-- BEGIN INNER FOOTER -->
				<div class="page-footer">
					<div class="container-fluid"> 2017 &copy;
						<!--Metronic Theme By
                            <a target="_blank" href="http://keenthemes.com">Keenthemes</a> &nbsp;|&nbsp;
                            <a href="http://themeforest.net/item/metronic-responsive-admin-dashboard-template/4021469?ref=keenthemes" title="Purchase Metronic just for 27$ and get lifetime updates for free" target="_blank">Purchase Metronic!</a-->
					</div>
				</div>
				<div class="scroll-to-top">
					<i class="icon-arrow-up"></i>
				</div>
				<!-- END INNER FOOTER -->
				<!-- END FOOTER -->
			</div>
		</div>
		<!-- BEGIN QUICK NAV -->
		<nav class="quick-nav">
			<a class="quick-nav-trigger" href="#0">
				<span aria-hidden="true"></span>
			</a>
			<jsp:include page="include/quicknav.jsp" />
			<span aria-hidden="true" class="quick-nav-bg"></span>
		</nav>
		<div class="quick-nav-overlay"></div>
		<!-- END QUICK NAV -->

	</div>
	<!-- BEGIN QUICK NAV -->
	<nav class="quick-nav">
		<a class="quick-nav-trigger" href="#0">
			<span aria-hidden="true"></span>
		</a>
		<jsp:include page="include/quicknav.jsp" />
		<span aria-hidden="true" class="quick-nav-bg"></span>
	</nav>
	<div class="quick-nav-overlay"></div>
	<!-- END QUICK NAV -->
	<!--============================================================-->
	<!--[if lt IE 9]>
<script src="assets/global/plugins/respond.min.js"></script>
<script src="assets/global/plugins/excanvas.min.js"></script> 
<script src="assets/global/plugins/ie8.fix.min.js"></script> 
<![endif]-->
	<!-- BEGIN CORE PLUGINS -->
	<script src="assets/global/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
	<script src="assets/global/plugins/js.cookie.min.js" type="text/javascript"></script>
	<script src="assets/global/plugins/jquery-slimscroll/jquery.slimscroll.min.js" type="text/javascript"></script>
	<script src="assets/global/plugins/jquery.blockui.min.js" type="text/javascript"></script>
	<script src="assets/global/plugins/bootstrap-switch/js/bootstrap-switch.min.js" type="text/javascript"></script>
	<!-- END CORE PLUGINS -->
	<!-- BEGIN THEME GLOBAL SCRIPTS -->
	<script src="assets/global/scripts/app.min.js" type="text/javascript"></script>
	<!-- END THEME GLOBAL SCRIPTS -->
	<!-- BEGIN THEME LAYOUT SCRIPTS -->
	<script src="assets/layouts/layout3/scripts/layout.min.js" type="text/javascript"></script>
	<script src="assets/layouts/layout3/scripts/demo.min.js" type="text/javascript"></script>
	<script src="assets/layouts/global/scripts/quick-sidebar.min.js" type="text/javascript"></script>
	<script src="assets/layouts/global/scripts/quick-nav.min.js" type="text/javascript"></script>
	<!-- Start jQuery Library -->



	<!-- Call OneMenu -->
	<script type="text/javascript">
		$(window).load(function () {
			$("#pdfbtn").click(function () {
				dashboardApp.exportCharts()
			});
			$("#excelbtn").click(function () {
				intersection = $("#intersections").val();
				yearSelect = $(".btn-primary").length;
				yearVal = $(".btn-primary").html();
				if ($("#directionDropdown").size() == 0) return;
				direction = $("#directionDropdown").val();
				window.location = "dashboardExcelReport?road=" + encodeURIComponent(intersection) + "&direction=" + direction + "&year=" + yearVal;
			});
		});
	</script>
	<link rel="stylesheet" href="https://unpkg.com/vue-multiselect@2.1.0/dist/vue-multiselect.min.css">

	<script>
		// register globally
		Vue.component('vue-multiselect', window.VueMultiselect.default)
		/**
 		* Create a global getSVG method that takes an array of charts as an argument. The SVG is returned as an argument in the callback.
		 */
		Highcharts.getSVG = function (charts, options, callback) {
			var svgArr = [],
				top = 0,
				width = 0,
				line = false,
				addSVG = function (svgres, i) {
					// Grab width/height from exported chart
					var svgWidth = +svgres.match(
						/^<svg[^>]*width\s*=\s*\"?(\d+)\"?[^>]*>/
					)[1],
						svgHeight = +svgres.match(
							/^<svg[^>]*height\s*=\s*\"?(\d+)\"?[^>]*>/
						)[1],
						// Offset the position of this chart in the final SVG
						svg;
					//console.log("Chart Height: " + svgHeight);
					midWidth = 600;
					height1 = 250;
					height2 = 500;
					height3 = 350;
					curTop = 0;
					curLeft = 0;
					switch (i) {
						case 0: curTop = 0; curLeft = 0;
							break;
						case 1: curTop = height1; curLeft = 0;
							break;
						case 2: curTop = height2; curLeft = 0;
							break;
						case 3: curTop = 0; curLeft = midWidth;
							break;
						case 4: curTop = height3; curLeft = midWidth;
							break;
						case 5: curTop = height3; curLeft = midWidth + 300;
							break;

					}
					svg = svgres.replace('<svg', '<g transform="translate(' + curLeft + ', ' + curTop + ')"');
					/* if (line) {
						line = false;
						svg = svgres.replace('<svg', '<g transform="translate(' + width + ', ' + top + ')"');
						width += svgWidth;
						console.log("width: " + width);
						top += svgHeight;
					} else {
						line = true;
						width = 0;
						svg = svgres.replace('<svg', '<g transform="translate(' + width + ', ' + top + ')"');
						width += svgWidth;
					} */

					svg = svg.replace('</svg>', '</g>');
					svgArr.push(svg);
				},
				exportChart = function (i) {
					if (i === charts.length) {
						return callback('<svg height="800" width="1200" version="1.1" xmlns="http://www.w3.org/2000/svg">' + svgArr.join('') + '</svg>');
					}
					if (i==4||i==5) {
						options.sourceWidth=300;
					}
					charts[i].chart.getSVGForLocalExport(options, {}, function () {
						console.log("Failed to get SVG");
					}, function (svg) {
						addSVG(svg, i);
						return exportChart(i + 1); // Export next only when this SVG is received
					});
				};
			exportChart(0);
		};
		/* Highcharts.getSVG = function (charts, options, callback) {
			var svgArr = [];
				var top = 0,
				width = 0,
				addSVG = function (svgres, chart) {
					title = chart.title.textStr;

					// Grab width/height from exported chart
					var svgWidth = +svgres.match(
						/^<svg[^>]*width\s*=\s*\"?(\d+)\"?[^>]*>/
					)[1],
					svgHeight = +svgres.match(
						/^<svg[^>]*height\s*=\s*\"?(\d+)\"?[^>]*>/
					)[1],
					// Offset the position of this chart in the final SVG
					svg = svgres.replace('<svg', '<g transform="translate(0,' + top + ') scale(0.5, 0.5)" ');
					svg = svg.replace('</svg>', '</g>');
					top += svgHeight/2;
					width = Math.max(width, svgWidth);
					svgArr.push(svg);
				},
				exportChart = function (i) {
					if (i === charts.length) {
						return callback('<svg height="' + top + '" width="' + width +
							'" version="1.1" xmlns="http://www.w3.org/2000/svg">' + svgArr.join('') + '</svg>');
					}
					//debugger;
					//svg = charts[i].chart.getSVG();
					//addSVG(svg);

					charts[i].chart.getSVGForLocalExport(options, {}, function () {
						console.log("Failed to get SVG");
					}, function (svg) {
						addSVG(svg, charts[i].chart);
						return exportChart(i + 1); // Export next only when this SVG is received
					});
				};
			exportChart(0);
		}; */
		/**
		* Create a global exportCharts method that takes an array of charts as an argument,
		* and exporting options as the second argument
		*/
		Highcharts.exportCharts = function (charts, options) {
			options = Highcharts.merge(Highcharts.getOptions().exporting, options);

			// Get SVG asynchronously and then download the resulting SVG
			Highcharts.getSVG(charts, options, function (svg) {
				Highcharts.downloadSVGLocal(svg, options, function () {
					console.log("Failed to export on client side");
				});
			});
		};
		var dashboardApp = new Vue({
			el: "#dashboardApp",
			data: {
				tttriChartLoaded: false,
				tttriChartData: {
                    chart: {
                        exporting:false,
                        styledMode: true,
                        type:"column",
                        options3d: {
                            anabled:true,
                            alpha:0,
                            beta:0,
                            depth:50,
                            viewDistance:25
                        }
                    },
                    title: {text:"Truck Travel Time Reliability Index"},
                    plotOptions:{series:{dataLabels:{enabled:true}}},
                    series: [
                        {
                            name:"TTTRI",
                            data:[]
                        }
                    ],
                    xAxis: {
                        categories:["2014","2015", "2016"]
                    },
                    yAxis:{
                        title: {
                            text: "TTTRI"
                        }
                    }
                },
				percTotalCrashesChartLoaded: false,
				percTotalCrashesChartData: {
                    chart:{
                        exporting:false,
                        styledMode:true,
                        type:"column"
                    },
                    title:{text:"TTTRI"},
                    plotOptions:{series:{dataLabels:{enabled:true}}},
                    series:[
                        {
                            name:"Large Truck",
                            data:[]
                        },{
                            name:"Other Truck",
                            data:[]
                        }
                    ],
                    xAxis: {
                        categories:["2014","2015", "2016"]
                    },

                },
				
			},
			created: function () {
				fetch("dashboard/tttri")
					.then(function (response) {
						return response.json();
					})
					.then(data => {
						this.tttriChartLoaded = true;
						Vue.set(this.tttriChartData.series[0], "data", data);
					})
				fetch("dashboard/perc_crashes")
					.then(function (response) {
						return response.json();
					})
					.then(data => {
						this.percTotalCrashesChartLoaded = true
						data.forEach(item => {
                            this.percTotalCrashesChartData.series[0].data.push(item[0]);
                            this.percTotalCrashesChartData.series[1].data.push(item[1]);
                            
                        })
					})

			},
			methods: {
				exportCharts: function () {
					chart2 = this.$refs.percTotalCrashesChart;
					chart3 = this.$refs.tttriChart;
					

					Highcharts.exportCharts([chart3, chart2], {
						type: 'application/pdf'
					});

				},
				
			},

		})
	</script>
</body>

</html>