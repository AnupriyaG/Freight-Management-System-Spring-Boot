<!DOCTYPE html>
<html>

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no">
	<meta name="description" content="ArcGIS JS v4, Calcite Maps and Bootstrap Example">

	<title>NJDOT FMS | GIS</title>

	<!-- Calcite Maps Bootstrap -->
	<link rel="stylesheet" href="https://esri.github.io/calcite-maps/dist/css/calcite-maps-bootstrap.min-v0.10.css">

	<!-- Calcite Maps -->
	<link rel="stylesheet" href="https://esri.github.io/calcite-maps/dist/css/calcite-maps-arcgis-4.x.min-v0.10.css">

	<!-- ArcGIS JS 4 -->
	<!-- <link rel="stylesheet" href="https://js.arcgis.com/4.10/esri/css/main.css"> -->
	<link
      rel="stylesheet"
      href="https://js.arcgis.com/4.10/esri/themes/light/main.css"
    />
	<script src="https://code.jquery.com/jquery-3.3.1.js"
		integrity="sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60=" crossorigin="anonymous"></script>
	<!-- Vue - Development build -->
	<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
	<script src="https://unpkg.com/vue-multiselect@2.1.0"></script>
	<link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.9.0/css/all.min.css'/>
	    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />

	<style>
		html,
		body {
			margin: 0;
			padding: 0;
			height: 100%;
			width: 100%;
		}
		.panel-body {
			background-color: rgb(46, 46, 46) !important;
		}
		.graphicRow {
			cursor:pointer;
			/* background-color: rgb(73, 73, 73); */
			margin:2px;
			border:1px solid rgb(114, 114, 114);
		}
		.graphicRow:hover {
			background-color: rgb(204, 204, 204);
		}
		.esri-view-user-storage {
			display:none;
		}
		/* #SelectDiv .col-md-12, #SelectDiv .col-md-10, #SelectDiv .col-md-2{
			padding-left: 0px;
			padding-right: 0px;
		} */
		.panel-body {
			background-color: white !important;
		}
		
		.btn {
	padding: 0;
    width: 35px;
	height:35px;
    line-height: 35px;
			font-size: 16px;
		}
		.btn-default i {
		display: inline-block;
width: inherit;
text-align: center;	
		}
		
		.btn.btn-default.btn-pdf {
			background: transparent;
			color: #ff1b0e;
		}
		
		.btn.btn-default.btn-pdf:hover {
			color: #ffffff;
			background: #ff1b0e;
		}
		#panelSelect .panel-body {
			width:450px;
			max-height:600px;
		}
		#panelFilter .panel-body {
			width:450px;
			height:500px;
		}
		.multiselect__tags {
			border:1px solid rgb(46, 46, 46) !important;
		}
		.multiselect__option--selected.multiselect__option--highlight {
			background-color: black !important;
		}
	</style>

</head>

<body class="calcite-maps calcite-nav-top">
	<!-- Navbar -->

	<nav class="navbar calcite-navbar navbar-fixed-top calcite-text-light calcite-bg-dark">
		<!-- Menu -->
		<div class="dropdown calcite-dropdown calcite-text-dark calcite-bg-light" role="presentation">
			<a class="dropdown-toggle" role="menubutton" aria-haspopup="true" aria-expanded="false" tabindex="0">
				<div class="calcite-dropdown-toggle">
					<span class="sr-only">Toggle dropdown menu</span>
					<span></span>
					<span></span>
					<span></span>
					<span></span>
				</div>
			</a>
			<ul class="dropdown-menu" role="menu">
				<li><a role="menuitem" tabindex="0" data-target="#panelLayers" aria-haspopup="true"><span
							class="glyphicon glyphicon-list-alt"></span> Layers</a></li>
				<li><a role="menuitem" tabindex="0" data-target="#panelBasemap" aria-haspopup="true"><span
							class="glyphicon glyphicon-list-alt"></span> Basemap</a></li>
				<li><a role="menuitem" tabindex="0" data-target="#panelFilter" aria-haspopup="true"><span
							class="glyphicon glyphicon-list-alt"></span> Filter</a></li>
				<li><a role="menuitem" tabindex="0" href="#" data-target="#panelLegend" aria-haspopup="true"><span
							class="glyphicon glyphicon-list-alt"></span> Legend</a></li>
				<li><a role="menuitem" tabindex="0" href="#" id="calciteToggleNavbar" aria-haspopup="true"><span
							class="glyphicon glyphicon-fullscreen"></span> Full Map</a></li>
			</ul>
		</div>
		<!-- Title -->
		<div class="calcite-title calcite-overflow-hidden">
			<a href="${pageContext.servletContext.contextPath}/">
				<img 
					src="${pageContext.servletContext.contextPath}/assets/layouts/layout3/img/titleTELUS.png" 
					alt="logo" 
					class="logo-default"
					style="max-height: 95%; max-height:55px;">
			</a>
		</div>
		<!-- Nav -->
		<ul class="nav navbar-nav calcite-nav">
			<li class="active">
				<a role="button" tabindex="0" href="#panelLayers" data-target="#panelLayers" aria-haspopup="true" title="Layers"><i class="fas fa-layer-group"></i></a>
			</li>
			<li>
				<a role="button" tabindex="0" href="#panelBasemap" data-target="#panelBasemap" aria-haspopup="true" title="Basemap"><i class="fas fa-map"></i></a>
			</li>
			<li>
				<a role="button" tabindex="0" href="#panelFilter" data-target="#panelFilter" aria-haspopup="true" title="Filters"><i class="fas fa-filter"></i></a>
			</li>
			<li>
				<a role="button" tabindex="0" href="#panelSelect" data-target="#panelSelect" aria-haspopup="true" title="Select"><i class="fas fa-mouse-pointer"></i></a>
			</li>
			<li>
				<a role="button" tabindex="0" href="#panelLegend" data-target="#panelLegend" aria-haspopup="true" title="Legend"><i class="fas fa-list-ul"></i></a>
			</li>
			<li>
				<div class="calcite-navbar-search calcite-search-expander">
					<div id="searchWidgetDiv"></div>
				</div>
			</li>
		</ul>
	</nav>

	<!--/.calcite-navbar -->

	<!-- Map  -->

	<div class="calcite-map calcite-map-absolute">
		<div id="mapViewDiv">
				<div
				id="select-by-polygon"
				class="esri-widget esri-widget--button esri-widget esri-interactive"
				title="Select features by polygon"
			  >
				<span class="esri-icon-checkbox-unchecked"></span>
			  </div>
		</div>
	</div>

	<!-- /.calcite-map -->

	<!-- Panels -->

	<div class="calcite-panels calcite-panels-right calcite-text-light calcite-bg-dark panel-group" id="panelsApp">

		<!-- Panel - Layers -->

		<div id="panelLayers" class="panel collapse in">
			<div id="headingLayers" class="panel-heading" role="tab">
				<div class="panel-title">
					<a class="panel-toggle" role="button" data-toggle="collapse" href="#collapseLayers"
						aria-expanded="true" aria-controls="collapseLayers"><i class="fas fa-layer-group"></i><span class="panel-label">Layers</span></a>
					<a class="panel-close" role="button" data-toggle="collapse" tabindex="0" href="#panelLayers"><span
							class="esri-icon esri-icon-close" aria-hidden="true"></span></a>
				</div>
			</div>
			<div id="collapseLayers" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingLayers">
				<div class="panel-body">
					<div id="layerListDiv"></div>
				</div>
			</div>
		</div>

		<!-- Panel - Legend -->

		<div id="panelLegend" class="panel collapse">
			<div id="headingLegend" class="panel-heading" role="tab">
				<div class="panel-title">
					<a class="panel-toggle" role="button" data-toggle="collapse" href="#collapseLegend"
						aria-expanded="false" aria-controls="collapseLegend"><i class="fas fa-list-ul"></i><span class="panel-label">Legend</span></a>
					<a class="panel-close" role="button" data-toggle="collapse" tabindex="0" href="#panelLegend"><span
							class="esri-icon esri-icon-close" aria-hidden="true"></span></a>
				</div>
			</div>
			<div id="collapseLegend" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingLegend">
				<div class="panel-body">
					<div id="legendDiv"></div>
				</div>
			</div>
		</div>

		<!-- Panel - Filter -->

		<div id="panelFilter" class="panel collapse">
			<div id="headingFilter" class="panel-heading" role="tab">
				<div class="panel-title">
					<a class="panel-toggle" role="button" data-toggle="collapse" href="#collapseFilter"
						aria-expanded="false" aria-controls="collapseFilter"><i class="fas fa-filter"></i><span class="panel-label">Filter</span></a>
					<a class="panel-close" role="button" data-toggle="collapse" tabindex="0" href="#panelFilter"><span
							class="esri-icon esri-icon-close" aria-hidden="true"></span></a>
				</div>
			</div>
			<div id="collapseFilter" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingFilter">
				<div class="panel-body">
					<div id="filterDiv">
						<div class="form-horizontal calcite-form-padding">
							<div class="form-group">
								<label class="col-xs-3 control-label">Criteria</label>
								<div class="col-xs-9">
									<vue-multiselect
										v-model="selectedFilter"
										:options="filterOptions"
										:searchable="true" label="name"
										track-by="name"
										:close-on-select="true"
										:show-labels="false"
										:allow-empty="false"
										placeholder="Criteria">
									</vue-multiselect>
								</div>
							</div>
							<div class="form-group" v-if="selectedFilter.values">
								<label class="col-xs-3 control-label">{{selectedFilter.name}}</label>
								<div class="col-xs-9">
									<vue-multiselect
										v-model="filterValue"
										:options="selectedFilter.values"
										:searchable="true"
										:close-on-select="true"
										:show-labels="false"
										:allow-empty="true"
										
									>
									</vue-multiselect>
								</div>
							</div>
							
							<div class="form-group"
								v-if="selectedFilter.values && filterValue!='' && selectedFilter.type=='CASCADE'">
								<label for="criteriaSelect"
									class="col-xs-3 control-label">{{selectedFilter.cascadeName}}</label>
								<div class="col-xs-9">
									<vue-multiselect
										v-model="cascadeValue"
										:options="selectedFilter.cascadeValues"
										:searchable="true"
										:close-on-select="true"
										:show-labels="false"
										:allow-empty="true"
									>
									
								</div>
							</div>
							<div v-if="filterResultsLoading">
								LOADING RESULTS
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- Panel - Select -->

		<div id="panelSelect" class="panel collapse">
			<div id="headingSelect" class="panel-heading" role="tab">
				<div class="panel-title">
					<a class="panel-toggle" role="button" data-toggle="collapse" href="#collapseSelect" aria-expanded="false"
						aria-controls="collapseSelect"><i class="fas fa-mouse-pointer"></i><span class="panel-label">Select</span></a>
					<a class="panel-close" role="button" data-toggle="collapse" tabindex="0" href="#panelSelect"><span
							class="esri-icon esri-icon-close" aria-hidden="true"></span></a>
				</div>
			</div>
			<div id="collapseSelect" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingSelect">
				<div class="panel-body">
					<div id="SelectDiv">
						<div class="row" style="color:black; text-align: center; margin-bottom: 25px;">
							<!--a href="#" class="btn btn-default" onclick="select('point')" title="Point"><i class="fas fa-mouse-pointer"></i></a>
							<a href="#" class="btn btn-default" onclick="select('polyline')" title="Polyline"><i class="fas fa-slash"></i></a-->
							<a href="#" class="btn btn-default" onclick="select('polygon')" title="Polygon"><i class="fas fa-draw-polygon"></i></a>
							<a href="#" class="btn btn-default" onclick="select('rectangle')" title="Rectangle"><i class="far fa-square"></i></a>
							<a href="#" class="btn btn-default" onclick="select('circle')" title="Circle"><i class="far fa-circle"></i></a>
							<span v-if="Object.keys(segmentSearchResults).length>0" style="color:white; float: right; padding-top:8px;">
							<buttom class="_btn btn-sm btn-primary" v-on:click="clearSegmentSelection" style="width:60px; margin-right:15px; cursor: pointer; padding-top:10px; padding-bottom:10px;">Clear</buttom>
						</span>
						</div>
						<div v-if="Object.keys(segmentSearchResults).length==0">
							Please use the above tools to select an area of the map containing road segments and/or STIP Projects. 
							<!-- To select Multiple areas on the map, click the "Search Multiple button below"
							<div class="btn btn-default" v-on:click="selectMultiple">Multiple search</div> -->
						</div>
						<div class="card" v-if="Object.keys(segmentSearchResults).length>0">
							<div class="card-body">
								<div style="padding-left:8px; padding-right:5px; border: 1px #666666 solid;">
									<h5><b>Report Settings</b></h5>
									<vue-multiselect style="padding-left:10px; width:95%; height:20px; margin-bottom:5px;"
										v-model="selectedScoringSystem"
										:options="scoringSystems"
										:searchable="true" label="systemName"
										track-by="systemID"
										:close-on-select="true"
										:show-labels="false"
										:allow-empty="false"
										placeholder="Scoring System">
									</vue-multiselect>
									<input class="_form-control" v-model="reportDescription" placeholder="Enter description" style="padding-left: 5px; width: 95%;margin-bottom: 8px; margin-left: 10px; height: 32px;border-width: 0 0 1px 0; border-color: #666666;">
								</div>
								<div>&nbsp;</div>
								<div style="padding-left:8px; padding-right:5px; border: 1px #666666 solid;">
								<h5><b>Combined segment report</b></h5>
								<p>Use the button below to create one report for all selected segments.</p>
								<p>HINT: Use the Ctrl key to add/remove segments to this report</p>
								
								
								<center class="btn-sm btn-primary" style="width:200px; margin-bottom: 10px; margin-left:auto; margin-right:auto; cursor: pointer;" v-on:click="generateCombinedReport"><i class="fa fa-file-pdf-o" style="margin-right:5px;"></i>Create Combined Report</center>
								
								</div>
								<h5 class="card-title" style="font-weight: bold; margin-left: 5px;">{{Object.keys(segmentSearchResults).length}} Routes</h5>
								<div class="graphicRow row" v-for="(data,sri) in segmentSearchResults">
									<table>
										<tr>
											<td width="38" valign="top">
												<div class="btn btn-default btn-pdf" style="border-width: 0;"
													v-on:click="generateCustomReport(sri, data[2], data[3])"><i class="fa fa-file-pdf-o"></i></div>
											</td>
											<td>
												{{data[0]}} - {{data[1]}}
												<br>{{data[2].toFixed(2)}} - {{data[3].toFixed(2)}}
											</td>
										</tr>
									</table>
								</div>
							</div>
						</div>
						<div class="card"  v-if="graphicsSearchResults.length>0">
							<div class="card-body">
								<h5 class="card-title" style="font-weight: bold; margin-left: 5px;">{{graphicsSearchResults.length}} STIP Projects</h5>
								<div class="graphicRow row" v-for="row in graphicsSearchResults" v-on:click="graphicResultClicked(row)">
									<table><tr><td width="38" valign="top">
										<div class="btn btn-default btn-pdf" style="border-width: 0;" v-on:click="generateSTIPReport(row.DBNUM)"><i class="fa fa-file-pdf-o" ></i></div>
									</div>
									</td>
									<td>
											{{row.DBNUM}} - {{row.PROJECT_NAME}}
										<br>
											{{row.COUNTY}}
										</td>
										</tr>
									</table>
									
								</div>
							</div>
						</div>
						
						
						
					</div>
				</div>
			</div>
		</div>
		
		<!-- Panel - Basemap -->
		
		<div id="panelBasemap" class="panel collapse">
			<div id="headingBasemap" class="panel-heading" role="tab">
				<div class="panel-title">
					<a class="panel-toggle" role="button" data-toggle="collapse" href="#collapseBasemap" aria-expanded="false"
						aria-controls="collapseBasemap"><i class="fas fa-map"></i><span class="panel-label">Base map</span></a>
					<a class="panel-close" role="button" data-toggle="collapse" tabindex="0" href="#panelBasemap"><span
							class="esri-icon esri-icon-close" aria-hidden="true"></span></a>
				</div>
			</div>
			<div id="collapseBasemap" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingBasemap">
				<div class="panel-body">
					<div id="basemapDiv">
		
					</div>
				</div>
			</div>
		</div>


	</div>

	<!-- /.calcite-panels -->

	<script type="text/javascript">
		var dojoConfig = {
			packages: [{
				name: "bootstrap",
				location: "https://esri.github.io/calcite-maps/dist/vendor/dojo-bootstrap"
			},
			{
				name: "calcite-maps",
				location: "https://esri.github.io/calcite-maps/dist/js/dojo"
			}]
		};
	</script>

	<!-- ArcGIS JS 4 -->
	<script src="https://js.arcgis.com/4.14/"></script>
	<script src="${pageContext.servletContext.contextPath}/js/gis.js"></script>


	<link rel="stylesheet" href="https://unpkg.com/vue-multiselect@2.1.0/dist/vue-multiselect.min.css">
	<!-- Vue code -->
	<script>

		// register globally
		Vue.component('vue-multiselect', window.VueMultiselect.default)
		var vueApp;
		$(function () {
			

			$("nav li a[role='button']").click(function() {
				$("nav li").removeClass("active");
				$(".calcite-panels .panel").removeClass("in");
				target = $(this).attr("data-target");
				$(target).addClass("in");
				$(target + " div[role='tabpanel']").addClass("in");
				$(this).parent().addClass("active");
			})
			
			vueApp = new Vue({
				el: "#panelsApp",
				data() {
					return {
						reportDescription: "",
						filterEnabled: false, //Are filters enabled
						filterLoading: false,
						filterResultsLoading: false,
						filterError: false,
						filterIndex: -1,		//the index of the selected filter option
						filterValue: "",	//The index of the selected filter value
						cascadeValue: "",
						filterCascadeIndex: -1,	//The index of the selected cascade sub item
						filterOptions: [			//the index of available filters
							{
								name: "None",
								type:"NONE"
							},
							{
								name: "DBNUM",
								colName: "DBNUM",
								type: "LIST",
								listURL: "../filterValues?filterName=DBNUM",
								values: []
							},
							{
								name: "Project Name",
								colName: "PROJECT_NAME",
								type: "LIST",
								listURL: "../filterValues?filterName=ProjectName",
								values: []
							},
							{
								name: "Route",
								colName: "ROUTE",
								type: "LIST",
								listURL: "../filterValues?filterName=Route",
								values: []
							},
							{
								name: "County",
								colName: "COUNTY",
								type: "LIST",
								listURL: "../filterValues?filterName=County",
								values: []
							},
							{
								name: "Municipality",
								colName: "MUNC1",
								type: "LIST",
								listURL: "../filterValues?filterName=Municipality",
								values: []
							},
							{
								name: "MPO",
								colName: "MPO",
								type: "LIST",
								listURL: "../filterValues?filterName=MPO",
								values: []
							},
							{
								name: "CIS Program Category",
								colName: "CIS_PROGRAM_CATEGORY",
								type: "CASCADE",
								listURL: "../filterValues?filterName=CISCategory",
								values: [],
								cascadeName: "CIS Subcategory",
								cascadeColName: "CIS_SUBCATEGORY",
								cascadeURL: "../filterValues?filterName=CISSubCategory&cascadeFilter=",
								cascadeValues: []
							}
						],
						selectedFilter:null,
						graphicsSearchResults:[],
						segmentSearchResults:[],
						combinedSegmentSearchResults:[],
						selectedScoringSystem:"",
						scoringSystems:[]
					};
				},
				created: function() {
					this.selectedFilter = this.filterOptions[0];
					fetch("../scoringSystems")
						.then(function (response) {
							this.filterLoading = false;
							return response.json();
						})
						.then(data => {
							this.scoringSystems = data;
							this.selectedScoringSystem = this.scoringSystems[0]
						}).catch(error => {
							
							console.error(error)
						});
				},
				watch: {
					filterEnabled: function (value) {
						focusSTIPFilterLayer(value);
						console.log("Filter: " + value);
						if (!value) performQuery("1", "1");
					},
					selectedFilter: function(val) {
						this.filterValue="";
						console.log("Filter:" + this.selectedFilter.name);
						if (this.selectedFilter.type!="NONE") {
							this.filterEnabled = true;
							if (this.selectedFilter.listURL) {
								this.filterLoading = true;
								fetch(this.selectedFilter.listURL)
									.then(function (response) {
										this.filterLoading = false;
										return response.json();
									})
									.then(data => {
										this.selectedFilter.values = data
									}).catch(error => {
										this.filterError = true;
										this.filterLoading = false;
										console.error(error)
									});
							}
						} else {
							this.filterEnabled = false;
						}
					},
					filterIndex: function (value) {
						console.log("Filter Index:" + value);
						if (value >= 0) {
							this.filterEnabled = true;
							if (this.filterOptions[value].listURL) {
								this.filterLoading = true;
								fetch(this.filterOptions[value].listURL)
									.then(function (response) {
										this.filterLoading = false;
										return response.json();
									})
									.then(data => {
										this.filterOptions[value].values = data
									}).catch(error => {
										this.filterError = true;
										this.filterLoading = false;
										console.error(error)
									});
							}
						} else {
							this.filterEnabled = false;
						}
					},
					filterValue: function (value) {
						console.log("Filter Value:" + value);
						if (value < 0) this.filterEnabled = false;
						else this.filterEnabled = true;

						if (this.filterEnabled) {
							console.log("Filter enabled, performing tasks");
							if (this.selectedFilter.type == "CASCADE") {
								fetch(this.selectedFilter.cascadeURL + value)
									.then(function (response) {
										this.filterLoading = false;
										return response.json();
									})
									.then(data => {
										this.selectedFilter.cascadeValues = data
									}).catch(error => {
										this.filterError = true;
										this.filterLoading = false;
										console.error(error)
									});
							}
							vueApp.filterResultsLoading = true;
							performQuery(this.selectedFilter.colName, this.filterValue);
						}
					}
				},
				methods: {
					graphicResultClicked: function(row) {
						selectFeatureFromGraphicSearch(row.OID);
					},
					generateSTIPReport: function(dbnum) {
						if (!this.selectedScoringSystem.systemID) {alert("Please select a scoring system to generate this report.");return;}
						rptfile = "Web_Telus_ScoringReport_chartsonly_FMS";
						var customsql = "DBNUM='" + dbnum + "'&systemID='"+this.selectedScoringSystem.systemID+"'";
            			var url = "../LoadProjectReport?" + customsql + "&rptfile=" + rptfile;
            			myPopup = window.open(url, 'popupWindow', 'width=700,height=500,resizable=yes,menubar=no,status=yes,location=no,toolbar=no,scrollbars=no');
            			if (!myPopup.opener)
                			myPopup.opener = self;
					},
					generateCustomReport: function(sri, start_mp, end_mp) {
						if (!this.selectedScoringSystem.systemID) {alert("Please select a scoring system to generate this report.");return;}
						url = "../DownloadCustomReport?route=" + sri +
							"&from=" + start_mp +
							"&to=" + end_mp +
							"&scoresystem=" + this.selectedScoringSystem.systemID +
							"&projdesc= ";
						myPopup = window.open(url, 'popupWindow', 'width=700,height=500,resizable=yes,menubar=no,status=yes,location=no,toolbar=no,scrollbars=no');
            			if (!myPopup.opener)
                			myPopup.opener = self;
					},
					generateCombinedReport: function() {
						if (!this.selectedScoringSystem.systemID) {alert("Please select a scoring system to generate this report.");return;}
						console.log(this.segmentSearchResults);
						sris = Object.keys(this.segmentSearchResults).join(",");
						startMPs = Object.keys(this.segmentSearchResults).map(item => this.segmentSearchResults[item][2].toFixed(2));
						endMPs = Object.keys(this.segmentSearchResults).map(item => this.segmentSearchResults[item][3].toFixed(2));
						url = "../CombinedReport?sri=" + sris + "&start=" + startMPs + "&end=" + endMPs + "&systemID=" + this.selectedScoringSystem.systemID + "&projDesc=" + this.reportDescription;
						console.log(url);
						myPopup = window.open(url, 'popupWindow', 'width=700,height=500,resizable=yes,menubar=no,status=yes,location=no,toolbar=no,scrollbars=no');
            			if (!myPopup.opener)
                			myPopup.opener = self;
					},
					clearSegmentSelection: function() {
						this.segmentSearchResults={};
						this.graphicsSearchResults=[];
						arcgisUnhighlightAllFeatures('SEGMENT_HL')
					}
				}
			});
		})
	</script>
</body>

</html>