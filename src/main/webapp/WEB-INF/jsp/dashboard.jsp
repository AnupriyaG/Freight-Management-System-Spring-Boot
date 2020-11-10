<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>

        <title>NJDOT FMS | Dashboard</title>
        <jsp:include page="include/head_common.jsp" />
        <!-- VUETIFY -->
        <link href="https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.min.css" rel="stylesheet">
        <!-- END VUETIFY -->
        <link rel="stylesheet" type="text/css" href="assets/global/plugins/select2/css/select2-bootstrap.min.css" />
        <link rel="stylesheet" type="text/css" href="assets/global/plugins/select2/css/select2.min.css" />
<!--         <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/highcharts/7.2.0/css/highcharts.css' />
 -->        <link rel="stylesheet" href="https://js.arcgis.com/4.13/esri/themes/light/main.css" />
	    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/dropzone/5.5.1/dropzone.css" integrity="sha256-0Z6mOrdLEtgqvj7tidYQnCYWG3G2GAIpatAWKhDx+VM=" crossorigin="anonymous" />
        <style>
            #mapViewDiv {
                padding: 0;
                margin: 0;
                height: 100vh;
                width: 100%;
            }
            .page-content {
                padding: 0px 0 0px; 
            }
			.btn.btn-outline.yellow-gold {
				background: #ffffff;
			}
            .help-icon {
                position: absolute;
                right: 24px;
                top: 8px;
                color:#17a2b8!important;
                cursor:pointer;
                font-size: 14pt;
            }
            .chart-help-overlay {
                position: absolute;
                /* left: 100px; */
                right: 20px;
                top: 38px;
                background-color: rgba(255,255,255,0.85);
                /* bottom: 70px; */
                border: 1px solid black;
                border-radius: 5px;
                padding: 5px;
            }
            .chart-row {
                width:100%; 
                position: relative;
                padding:1px;
                margin-bottom:5px;
            }
        </style>
        <!-- <script src="https://code.highcharts.com/modules/no-data-to-display.js"></script> -->
    </head>
    <body class="page-container-bg-solid page-md">
        <script type="text/x-template" id="intersection-autocomplete">
            <v-autocomplete
                v-model="autocompleteModel" 
                :items="items"
                :label="label"
                attach
            >
            </v-autocomplete>
        </script>
        <script type="text/x-template" id="direction-autocomplete">
            <v-autocomplete
                v-model="autocompleteModel" 
                :items="items"
                :label="label"
                attach
            >
                <template v-slot:item="{ item }">
                    {{item[0]}}
                </template>
                <template v-slot:selection="{ item }">
                    {{item[0]}}
                </template>
            </v-autocomplete>
        </script>
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
                                <div>
                                    <!-- BEGIN PAGE BREADCRUMBS -->
                                    <!--<ul class="page-breadcrumb breadcrumb blk">
                                        <li>
                                            <a href="DisplayAdminMainPage">Home</a>
                                            <i class="fa fa-circle"></i>
                                        </li>
                                        <li>
                                            <span>Dashboard</span>
                                        </li>
                                    </ul>-->
                                    <!-- END PAGE BREADCRUMBS -->
                                    <!-- BEGIN PAGE CONTENT INNER -->
                                    <div class="page-content-inner" id="dashboardApp">
                                        <div class="row" style="margin-right:0px;margin-left: 0px;">
                                            <div class="col-lg-offset-1 col-lg-10 col-md-12 col-sm-12 col-xs-12">
                                                <div class="portlet light ">
                                                    <div class="portlet-title">
                                                        <div class="_caption" style="padding: 10px 0; font-size: 16px;">
                                                            <i class="fas fa-tachometer-alt font-dark" style="margin-top: -1px;"></i>
                                                            <span class="caption-subject font-dark bold uppercase">Performance
															Indicators (2014 - 2018)</span>
                                                        </div>
                                                        <div class="actions">
                                                            <a v-on:click="exportCharts" class="btn yellow-gold mt-ladda-btn ladda-button btn-outline"
                                                                style="font-size: 1.1em;text-transform: initial;">
                                                                <i class="fa fa-file-pdf-o" style="color:red;"></i>
                                                                Download PDF
                                                            </a>
                                                            <a v-on:click="exportExcel" class="btn yellow-gold mt-ladda-btn ladda-button btn-outline"
                                                                style="font-size:1.1em;text-transform: initial; margin-right:20px;">
                                                                <i class="fa fa-file-excel-o" style="color:green;"></i>
                                                                Download Excel
                                                            </a>
                                                            <button class="btn dark btn-circle btn-sm" style="margin-right:10px;" v-on:click="gotoPrevStage">
                                                                <i class="fa fa-arrow-left"></i> Back
                                                            </button>
                                                            <a class="btn btn-circle btn-icon-only btn-default fullscreen" href="javascript:;" data-original-title="" title=""> </a>
                                                        </div>
                                                    </div>
                                                    <div class="portlet-body">
                                                        <v-app>
                                                            <!-- <v-navigation-drawer v-model="helpDrawer" absolute temporary>
                                                                <button class="btn btn-default" v-on:click="helpDrawer=false">CLOSE</button>
                                                                <template v-if="helpMode=='WELCOME'">
                                                                    <h4>Welcome</h4>
                                                                    <p>This is help text that can be displayed when the application loads</p>
                                                                </template>
                                                                <template v-if="helpMode=='STATE_TTTRI'">
                                                                    <h4>Welcome</h4>
                                                                    <p>This is help text that is displayed for the state TTTRI chart</p>
                                                                </template>
                                                                <template v-if="helpMode=='STATE_PERCTOTALCRASHES'">
                                                                    <h4>Welcome</h4>
                                                                    <p>This is help text that is displayed for the state percent total crashes chart</p>
                                                                </template>
                                                                <template v-if="helpMode=='STATE_MILESUNCON'">
                                                                    <h4>Welcome</h4>
                                                                    <p>This is help text that is displayed for the state miles uncongested chart</p>
                                                                </template>
                                                                <template v-if="helpMode=='ROUTE_TTTRI'">
                                                                    <h4>Welcome</h4>
                                                                    <p>This is help text that is displayed for the route TTTRI chart</p>
                                                                </template>
                                                                <template v-if="helpMode=='ROUTE_PERCTOTALCRASHES'">
                                                                    <h4>Welcome</h4>
                                                                    <p>This is help text that is displayed for the route percent total crashes chart</p>
                                                                </template>
                                                                <template v-if="helpMode=='ROUTE_MILESUNCON'">
                                                                    <h4>Welcome</h4>
                                                                    <p>This is help text that is displayed for the route miles uncongested chart</p>
                                                                </template>
                                                                <template v-if="helpMode=='ROUTEDETAIL_TTTR'">
                                                                    <h4>Welcome</h4>
                                                                    <p>This is help text that is displayed for the route detail TTTR chart</p>
                                                                </template>
                                                                <template v-if="helpMode=='ROUTEDETAIL_CRASHES'">
                                                                    <h4>Welcome</h4>
                                                                    <p>This is help text that is displayed for the route detail crashes chart</p>
                                                                </template>
                                                                <template v-if="helpMode=='ROUTEDETAIL_VOLUME'">
                                                                    <h4>Welcome</h4>
                                                                    <p>This is help text that is displayed for the route detail volume chart</p>
                                                                </template>
                                                                <template v-if="helpMode=='YEARDETAIL_TTTR'">
                                                                    <h4>Welcome</h4>
                                                                    <p>This is help text that is displayed for the year detail TTTR chart</p>
                                                                </template>
                                                                <template v-if="helpMode=='YEARDETAIL_CRASHES'">
                                                                    <h4>Welcome</h4>
                                                                    <p>This is help text that is displayed for the year detail crashes chart</p>
                                                                </template>
                                                                <template v-if="helpMode=='YEARDETAIL_VOLUME'">
                                                                    <h4>Welcome</h4>
                                                                    <p>This is help text that is displayed for the year detail volume chart</p>
                                                                </template>
                                                                
                                                            </v-navigation-drawer> -->
                                                            <v-row>
                                                                <v-col md="5" cols="12">
                                                                    <!--ArcGIS Container -->
                                                                    <div id="mapViewDiv"></div>
                                                                </v-col>
                                                                <v-col md="7" cols="12">
                                                                    <v-col sm="12" style="height:100vh;overflow:auto;padding-top:0px;" v-if="mode=='STATE_SUMMARY'">
                                                                        <v-row style="height:30vh" class="chart-row">
                                                                            <v-card style="width:100%">
                                                                                <highcharts ref="stateTTTRI" :options="stateTTTRIOptions" style="width:100%;height:100%"></highcharts>
                                                                                <i class="fas fa-info-circle help-icon" v-on:mouseover="helpMode='STATE_TTTRI'" v-on:mouseout="helpMode=''"></i>
                                                                                <div class="chart-help-overlay" v-if="helpMode=='STATE_TTTRI'">
                                                                                    The ratio of the longer truck travel time (95th percentile) to a "normal" truck travel time (50th percentile).
                                                                                </div>
                                                                            </v-card>
                                                                        </v-row>
                                                                        <v-row style="height:30vh;" class="chart-row">
                                                                            <v-card style="width:100%">
                                                                                <highcharts ref="statePercTotalCrashes" :options="statePercTotalCrashesOptions" style="width:100%;height:100%"></highcharts>
                                                                                <i class="fas fa-info-circle help-icon" v-on:mouseover="helpMode='STATE_PERCTOTALCRASHES'" v-on:mouseout="helpMode=''"></i>
                                                                                <div class="chart-help-overlay" v-if="helpMode=='STATE_PERCTOTALCRASHES'">
                                                                                    Percent of all crashes that involve trucks.
                                                                                </div>
                                                                            </v-card>
                                                                        </v-row>
                                                                        <v-row style="height:30vh;" class="chart-row">
                                                                            <v-card style="width:100%">
                                                                                <highcharts ref="stateMilesUncon" :options="stateMilesUnconOptions" style="width:100%;height:100%"></highcharts>
                                                                                <i class="fas fa-info-circle help-icon" v-on:mouseover="helpMode='STATE_MILESUNCON'" v-on:mouseout="helpMode=''"></i>
                                                                                <div class="chart-help-overlay" v-if="helpMode=='STATE_MILESUNCON'">
                                                                                    Percent of the Interstate System mileage providing for reliable truck travel times.
                                                                                </div>
                                                                            </v-card>
                                                                        </v-row>
                                                                    </v-col>
                                                                    <v-col sm="12" style="height:100vh;overflow:auto;padding-top:0px;" v-if="mode=='ROUTE_SUMMARY'">
                                                                        <v-row>
                                                                            <v-col md="6" style="padding-top: 0px;">
                                                                                <intersection-autocomplete :model.sync="selectedIntersection" 
                                                                                    :items="intersections" label="Roadway">
                                                                                </intersection-autocomplete>
                                                                            </v-col>
                                                                            <v-col md="6" style="padding-top: 0px;">
                                                                                <direction-autocomplete :model.sync="selectedDirection" 
                                                                                    :items="directions" label="Directions">
                                                                                </direction-autocomplete>                                                                                 
                                                                            </v-col>
                                                                            
                                                                        </v-row>
                                                                        <!-- <v-row><button class="btn btn-default" v-on:click="mode='STATE_SUMMARY'">Return to state summary</button></v-row> -->
                                                                        <v-row style="height:25vh;" class="chart-row">
                                                                            <v-card style="width:100%">
                                                                                <highcharts ref="routeTTTRI" :options="routeTTTRIOptions" style="width:100%;height:100%;"></highcharts>
                                                                                <i class="fas fa-info-circle help-icon" v-on:mouseover="helpMode='ROUTE_TTTRI'" v-on:mouseout="helpMode=''"></i>
                                                                                <div class="chart-help-overlay" v-if="helpMode=='ROUTE_TTTRI'">
                                                                                    The ratio of the longer truck travel time (95th percentile) to a "normal" truck travel time (50th percentile).
                                                                                </div>
                                                                            </v-card>
                                                                        </v-row>
                                                                        <v-row style="height:25vh;" class="chart-row">
                                                                            <v-card style="width:100%">
                                                                                <highcharts ref="routePercTotalCrashes" :options="routePercTotalCrashesOptions" style="width:100%;height:100%;"></highcharts>
                                                                                <i class="fas fa-info-circle help-icon" v-on:mouseover="helpMode='ROUTE_PERCTOTALCRASHES'" v-on:mouseout="helpMode=''"></i>
                                                                                <div class="chart-help-overlay" v-if="helpMode=='ROUTE_PERCTOTALCRASHES'">
                                                                                    Percent of all crashes that involve trucks.
                                                                                </div>
                                                                            </v-card>
                                                                        </v-row>
                                                                        <v-row style="height:25vh;" class="chart-row">
                                                                            <v-card  style="width:100%">
                                                                                <highcharts ref="routeMilesUncon" :options="routeMilesUnconOptions" style="width:100%;height:100%;"></highcharts>
                                                                                <i class="fas fa-info-circle help-icon" v-on:mouseover="helpMode='ROUTE_MILESUNCON'" v-on:mouseout="helpMode=''"></i>
                                                                                <div class="chart-help-overlay" v-if="helpMode=='ROUTE_MILESUNCON'">
                                                                                    Percent of the Interstate System mileage providing for reliable truck travel times.
                                                                                </div>
                                                                            </v-card>
                                                                        </v-row>
                                                                    </v-col>
                                                                    <v-col sm="12" style="height:100vh;overflow:auto;padding-top:0px;" v-if="mode=='ROUTE_DETAIL'">
                                                                        <v-row>
                                                                            <v-col style="padding-top: 0px;">
                                                                                <intersection-autocomplete :model.sync="selectedIntersection" 
                                                                                    :items="intersections" label="Roadway">
                                                                                </intersection-autocomplete>
                                                                            </v-col>
                                                                            <v-col style="padding-top: 0px;">
                                                                                <direction-autocomplete :model.sync="selectedDirection" 
                                                                                    :items="directions" label="Directions">
                                                                                </direction-autocomplete>
                                                                            </v-col>
                                                                        </v-row>
                                                                        <!-- <v-row><button class="btn btn-default" v-on:click="mode='ROUTE_SUMMARY'">Return to route summary</button></v-row> -->
                                                                        <!-- TODO: Add code to handle loading state -->
                                                                        <v-row style="height:25vh;" class="chart-row">
                                                                            <v-card style="width:100%">
                                                                                <highcharts ref="routeTttriByMilepost" :options="routeTttriByMilepostOptions" style="height:100%;width:100%"></highcharts>
                                                                                <i class="fas fa-info-circle help-icon" v-on:mouseover="helpMode='ROUTEDETAIL_TTTRi'" v-on:mouseout="helpMode=''"></i>
                                                                                <div class="chart-help-overlay" v-if="helpMode=='ROUTEDETAIL_TTTRi'">
                                                                                    The ratio of the longer truck travel time (95th percentile) to a "normal" truck travel time (50th percentile).
                                                                                </div>
                                                                            </v-card>
                                                                        </v-row>
                                                                        
                                                                        <v-row style="height:25vh;" class="chart-row">
                                                                            <v-card style="width:100%">
                                                                                <highcharts ref="routeCrashesByMilepost" :options="routeCrashesByMilepostOptions" style="height:100%;width:100%"></highcharts>
                                                                                <i class="fas fa-info-circle help-icon" v-on:mouseover="helpMode='ROUTEDETAIL_CRASHES'" v-on:mouseout="helpMode=''"></i>
                                                                                <div class="chart-help-overlay" v-if="helpMode=='ROUTEDETAIL_CRASHES'">
                                                                                    Percent of all crashes that involve trucks.
                                                                                </div>
                                                                            </v-card>
                                                                        </v-row>
                                                                        
                                                                        <v-row style="height:25vh;" class="chart-row">
                                                                            <v-card style="width:100%">
                                                                                <highcharts ref="routeVolumeByMilepost" :options="routeVolumeByMilepostOptions" style="height:100%;width:100%"></highcharts>
                                                                            </v-card>
                                                                        </v-row>
                                                                        
                                                                        <v-row>
                                                                            <v-col class="px-4">
                                                                              <v-range-slider 
                                                                                v-model="range" 
                                                                                :max="max" 
                                                                                :min="min" 
                                                                                hide-details 
                                                                                class="align-center"
                                                                                step="0.1"
                                                                                thumb-label="always"
                                                                            >
                                                                                <template v-slot:prepend>
                                                                                  {{ min }}
                                                                                </template>
                                                                                <template v-slot:append>
                                                                                  {{ max }}
                                                                                </template>
                                                                              </v-range-slider>
                                                                            </v-col>
                                                                          </v-row>
                                                                          <v-row>
                                                                              <v-col sm="6" style="padding-top:0px;margin-top:-20px;">Start MP</v-col>
                                                                              <v-col sm="6" style="text-align:right;padding-top:0px;margin-top:-20px;">End MP</v-col>
                                                                          </v-row>
                                                                        <!--<v-row style="position:relative;height:100px;">
                                                                            <highcharts ref="navigator" :options="milepostFilterChartOptions" style="width:90%"></highcharts>                                                                        
                                                                        </v-row>-->
                                                                    </v-col>
                                                                    <v-col sm="12" style="height:100vh;overflow:auto;padding-top:0px;" v-if="mode=='YEAR_DETAIL'">
                                                                        
                                                                        <v-row>
                                                                            <v-col style="padding-top: 0px;">
                                                                                <intersection-autocomplete :model.sync="selectedIntersection" 
                                                                                    :items="intersections" label="Roadway">
                                                                                </intersection-autocomplete>
                                                                            </v-col>
                                                                            <v-col style="padding-top: 0px;">
                                                                                <direction-autocomplete :model.sync="selectedDirection" 
                                                                                    :items="directions" label="Directions">
                                                                                </direction-autocomplete>
                                                                            </v-col>
                                                                            <v-col style="padding-top: 0px;">
                                                                                <v-autocomplete
                                                                                    v-model="selectedYear"
                                                                                    :items="['2014','2015','2016','2017','2018']"
                                                                                    label="Year"
                                                                                    attach
                                                                                ></v-autocomplete>
                                                                            </v-col>
                                                                        </v-row>
                                                                        <!-- <v-row>
                                                                            <button class="btn btn-default" v-on:click="mode='ROUTE_DETAIL'">Return to route details</button>
                                                                        </v-row> -->
                                                                        <v-row style="height:25vh;" class="chart-row">
                                                                            <v-card style="width:100%">
                                                                                <highcharts ref="routeTttriCategoriesByMilepost" :options="routeTttriCategoriesByMilepostOptions" style="width:100%;height:100%;"></highcharts>
                                                                                <i class="fas fa-info-circle help-icon" v-on:mouseover="helpMode='YEARDETAIL_TTTRI'" v-on:mouseout="helpMode=''"></i>
                                                                                <div class="chart-help-overlay" v-if="helpMode=='YEARDETAIL_TTTRI'">
                                                                                    The ratio of the longer truck travel time (95th percentile) to a "normal" truck travel time (50th percentile).
                                                                                </div>
                                                                            </v-card>

                                                                        </v-row>
                                                                        <v-row style="height:25vh;" class="chart-row">
                                                                            <v-card style="width:100%">
                                                                                <highcharts ref="routeCrashesCategoriesByMilepost" :options="routeCrashesCategoriesByMilepostOptions" style="height:100%;width:100%"></highcharts>
                                                                                <i class="fas fa-info-circle help-icon" v-on:mouseover="helpMode='YEARDETAIL_CRASHES'" v-on:mouseout="helpMode=''"></i>
                                                                                <div class="chart-help-overlay" v-if="helpMode=='YEARDETAIL_CRASHES'">
                                                                                    Used to identify low volume, high crash risk locations that do not necessarily experience a high total number of crashes.
                                                                                </div>
                                                                            </v-card>

                                                                        </v-row>
                                                                        <v-row style="height:25vh;" class="chart-row">
                                                                            <v-card style="width:100%">
                                                                                <highcharts ref="routeSeverityByMilepost" :options="routeSeverityByMilepostOptions" style="width:100%;height:100%"></highcharts>                                                                        
                                                                                <i class="fas fa-info-circle help-icon" v-on:mouseover="helpMode='YEARDETAIL_SEVERITY'" v-on:mouseout="helpMode=''"></i>
                                                                                <div class="chart-help-overlay" v-if="helpMode=='YEARDETAIL_SEVERITY'">
                                                                                    Severity Rate distinguishes crash locations based on their severity (fatal, property damage only, incapaitated).
                                                                                </div>
                                                                            </v-card>

                                                                        </v-row>
                                                                        <v-row>
                                                                            <v-col class="px-4">
                                                                              <v-range-slider 
                                                                                v-model="range" 
                                                                                :max="max" 
                                                                                :min="min" 
                                                                                hide-details 
                                                                                class="align-center"
                                                                                step="0.1"
                                                                                thumb-label="always"
                                                                            >
                                                                                <template v-slot:prepend>
                                                                                  {{ min }}
                                                                                </template>
                                                                                <template v-slot:append>
                                                                                  {{ max }}
                                                                                </template>
                                                                              </v-range-slider>
                                                                            </v-col>
                                                                        </v-row>
                                                                        <v-row>
                                                                            <v-col sm="6" style="padding-top:0px;margin-top:-20px;">Start MP</v-col>
                                                                            <v-col sm="6" style="text-align:right;padding-top:0px;margin-top:-20px;">End MP</v-col>
                                                                        </v-row>
                                                                    </v-col>
                                                                </v-col>
                                                            </v-row>
                                                        </v-app>
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
            
        </div>
        <jsp:include page="include/footer_common.jsp" />
        <!--============================================================-->
        <jsp:include page="include/quicknav.jsp" />
        <script src="https://unpkg.com/vue-multiselect@2.1.0"></script>
        <script type="text/javascript" src="js/html2pdf.bundle.js"></script>
        <!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.5/jspdf.debug.js"></script> -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/highcharts/8.0.4/lib/jspdf.src.min.js" integrity="sha256-NDvp98diZvxKKSzWpDU4N9xUl/0TNu1xNJMhYNIR0fo=" crossorigin="anonymous"></script> 
        <!-- <script src="https://code.highcharts.com/stock/highstock.js"></script> -->
        <script src="https://code.highcharts.com/highcharts.js"></script>
        <script src="https://code.highcharts.com/modules/no-data-to-display.js"></script>

        <script src="https://code.highcharts.com/modules/exporting.js"></script>
        <script src="https://code.highcharts.com/modules/offline-exporting.js"></script>
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/vue-highcharts/dist/vue-highcharts.min.js"></script>
        <!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/highcharts/8.0.4/lib/svg2pdf.min.js" integrity="sha256-mMPMiZjUYMqsaAdzq1xBY3RQNlxORRgQFJvrB4OgXyo=" crossorigin="anonymous"></script> -->
        <script src="https://code.highcharts.com/lib/svg2pdf.js"></script>
        <!-- BEGIN THEME GLOBAL SCRIPTS -->
        <script src="assets/global/scripts/app.min.js" type="text/javascript"></script>
        <!-- END THEME GLOBAL SCRIPTS -->
        <!-- BEGIN THEME LAYOUT SCRIPTS -->
        <script src="assets/layouts/layout3/scripts/layout.min.js" type="text/javascript"></script>
        <script src="assets/layouts/layout3/scripts/demo.min.js" type="text/javascript"></script>
        <script src="assets/layouts/global/scripts/quick-sidebar.min.js" type="text/javascript"></script>
        <script src="assets/layouts/global/scripts/quick-nav.min.js" type="text/javascript"></script>
        <!-- <script src="https://js.arcgis.com/4.14/"></script> -->
        <script src="https://cdn.jsdelivr.net/npm/esri-loader@2.14.0/dist/umd/esri-loader.min.js"></script>
        <script src="js/dashboard_gis.js"></script>
        <script src="js/dashboard_charts.js"></script>
        


        
        <script>
            var useHash = false;
            if (window.location.hash) useHash = true;
            
            function checkHash(hashval) {
                hashvalue = window.location.hash;
                if (hashval) hashvalue = hashval;
                if (hashvalue != "") {
                    //debugger;
                    switch (hashvalue) {
                        case "#Year-2014":
                            dashboardApp.selectedYear = "2014";
                            break;
                        case "#Year-2015":
                            dashboardApp.selectedYear = "2015";
                            break;
                        case "#Year-2016":
                            dashboardApp.selectedYear = "2016";
                            break;
                        
                    }
                }
            }
        </script>
    </body>

    </html>