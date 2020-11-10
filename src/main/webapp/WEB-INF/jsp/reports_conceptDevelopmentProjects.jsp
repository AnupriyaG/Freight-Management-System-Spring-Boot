<v-app>
    
<!-- BEGIN FORM-->
<div class="form-horizontal" role="form" style="background-color: transparent;">
        <v-tabs show-arrows>
            <v-tab>Add a Custom Project</v-tab>
            <v-tab>Add Multiple Custom Projects</v-tab>
            <v-tab-item>
                <v-card style="margin-top: 10px;  border-radius:0;">
                    <v-card-text style="background-color: rgba(102, 102, 102, 0.8);">
                        <div class="row" style="display: _flex; align-items: center;">
                            <div class="col-md-6" style="">
                                <table class="table _dark-bg" style="margin-bottom:0px !important;">
                                    <tr>
                                        <td colspan="2" valign="top" style="border-top: 0px solid #666; height: 70px; font-weight: bold; text-transform: uppercase; font-size:20px;">Add a Custom Project</td>
                                    </tr>
                                    <tr>
                                        <td style="border-top: 0px solid #666; font-weight: bold; line-height: 2.7;" width="120">Project Name:</td>
                                        <td style="border-top: 0px solid #666;"><input style="border: 1px #999999 solid; background-color: #ffffff; border-radius:5px; height:43px;" type="text" v-model="projectName"></td>
                                    </tr>
                                    <tr style="border-top: 0px solid #666;">
                                        <td style="border-top: 0px solid #666; font-weight: bold; line-height: 2.5;">Route:</td>
                                        <td style="border-top: 0px solid #666;">
                                            <vue-multiselect
                                                v-model="selectedRoute" 
                                                :options="routes" 
                                                :searchable="true" 
                                                label="title"
                                                :close-on-select="true" 
                                                :show-labels="false" 
                                                placeholder="Select Value"
                                            ></vue-multiselect>
                                        </td>
                                    </tr>
                                    <tr v-if="fromMPs.length>0 || fromMPError">
                                        <td style="border-top: 0px solid #666; font-weight: bold; line-height: 2.5;">Start Mile Post:</td>
                                        <td v-if="!fromMPLoading && !fromMPError" style="border-top: 0px solid #666;">
                                            <vue-multiselect  
                                                v-model="selectedFromMP" 
                                                :options="fromMPs" 
                                                :searchable="true"
                                                :close-on-select="true" 
                                                :show-labels="false" 
                                                :allow-empty="false"
                                                placeholder="Select Start Milepost"
                                            ></vue-multiselect>
                                        </td>
                                        <td v-if="fromMPLoading" style="border-top: 0px solid #666;">LOADING...</td>
                                        <td v-if="fromMPError" style="border-top: 0px solid #666; line-height: 2.5;">{{fromMPErrorData.message}} - {{fromMPErrorData.status}}</td>
                                    </tr>
                                    <tr v-if="toMPs.length>0 || toMPError">
                                        <td style="border-top: 0px solid #666; font-weight: bold; line-height: 2.5;">End Mile Post:</td>
                                        <td style="border-top: 0px solid #666;">
                                            <vue-multiselect  
                                                v-model="selectedToMP" 
                                                :options="toMPs" 
                                                :searchable="true"
                                                :close-on-select="true" 
                                                :show-labels="false" 
                                                placeholder="Select End Milepost"
                                            ></vue-multiselect>
                                        </td>
                                        <td v-if="toMPLoading" style="border-top: 0px solid #666;">LOADING...</td>
                                        <td v-if="toMPError" style="border-top: 0px solid #666;">{{toMPErrorData.message}} - {{toMPErrorData.status}}</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="border-top: 0px solid #666; text-align: right;"><button v-on:click="addIndividualProject" class="btn yellow-gold">Add</button></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-5" style="margin-top:-20px;">
                                <div class="_panel" style="padding:10px 5px 10px 35px; margin-top:30px; border-left: 4px #000000 solid; background-color: transparent; margin-left: 20px; color:#ffffff;">
									<ol>
									  <li>Use the form on the left to add a custom project (all fields must be filled in i.e. project name, route, start MP and end MP).</li>
									  <li>Click 'Add' to add the project to the project list below.</li>
									  <li>Score projects in the project list by selecting the checkboxes, choosing a scoring system and clicking the 'Score' button.</li>
									  <li>Once a project is scored, you can download the results in a PDF or Excel Report.</li>
									</ol>
									
									
									
									
                                    <!--table>
                                        <tr>
                                            <td>STEP 1</td>
                                            <td>Add one or more projects using the form on the left</td>
                                        </tr>
                                        <tr>
                                            <td>STEP 2</td>
                                            <td>Select a scoring system from the scoring system dropdown</td>
                                        </tr>
                                        <tr>
                                            <td>STEP 3</td>
                                            <td>Select the projects you would like to score and select "Score projects"</td>
                                        </tr>
                                        <tr>
                                            <td>STEP 4</td>
                                            <td>Click on the download button to generate a report</td>
                                        </tr>
                                    </table-->
                                </div>
                            </div>
                        </div>
                        
                    </v-card-text>
                </v-card>
                
            </v-tab-item>

            <v-tab-item style="margin-top: 10px;">
                <v-card style="margin-top: 10px;  border-radius:0;">
                    <v-card-text style="background-color: rgba(102, 102, 102, 0.8);">
                        <div class="row" style="display: flex; align-items: center;">
                            <div class="col-md-6" style="">
                                <div class="row">
                                    <div class="col-md-12">
                                        <p style="color: #ffffff; margin-left: 10px; font-weight: bold; text-transform: uppercase; font-size:20px; vertical-align: top:">Add Multiple Custom Projects</p>
                                    </div>
								</div>
									<div class="row">
                                    <div class="col-lg-6" style="text-align: center;">
                                        <!--center><a class="btn yellow-gold" style="padding-top:11px; padding-bottom: 11px; width: 250px;" href="CDPFileTemplate.xlsx"><i class="fas fa-file-excel fa-lg" style="color:green"></i>&nbsp;Download CDP File Template</a></center-->
										<a class="btn btn-outline yellow-gold" style="padding-top:13px; padding-bottom: 11px; width: 250px; display: inline; line-height: 46px; margin-left:20px;" href="CDPFileTemplate.xlsx"><i class="fas fa-file-excel" style="color:green; font-size: 1.1rem;"></i>&nbsp;Download Custom Projects File Template</a>
									</div>
									<div class="col-lg-6">
                                        <center>
                                            <div v-if="uploadProcessing" style="background-color: #ffffff;width:100%;height:100%;">
                                                <div class="col-md-12">Uploading</div>
                                                <div class="col-md-12">
                                                    <v-progress-linear v-show="uploadProcessing" color="grey darken-1"indeterminate rounded height="6"></v-progress-linear>
                                                </div>
                                            </div>
                                            <input v-if="!uploadProcessing" type="file" v-on:change.stop="cdpProcessUpload($event.target)" style="background-color: #ffffff; border:2px #E87E04 solid; padding: 8px 0 8px 10px; color: #000000; width: 250px; margin-left:20px;">
                                        </center>
                                    </div>
									</div>
                                </div>

							<div class="col-md-5" style="margin-top:-20px;">
                                <div class="_panel" style="padding:10px 5px 10px 35px; margin-top:30px; border-left: 4px #000000 solid; background-color: transparent; margin-left: 20px; color:#ffffff;">
									<ol>
									  <li>Click on the 'Download Custom File Template' button to download an excel file where you can insert multiple custom projects.</li>
									  <li>Ensure all columns in the table are filled and then use the upload button to add the projects from the excel spreadsheet.</li>
									  <li>All uploaded projects will appear in the project list. If there is an error, the system will inform you if any uploads have failed.</li>
									  <li>To score projects, select the checkbox next to the project name in the project list, select a scoring system and click the 'Score' button.</li>
									  <li>Once a project is scored, you can download the results in a PDF or Excel Report.</li>
									</ol>
                                </div>
                            </div>
                        </div>
                    </v-card-text>
                </v-card>
                
                
                
            </v-tab-item>
        </v-tabs>
    

    
    <input type="hidden" name="hdnSystemID" />
    <p>&nbsp;</p>
	<div style="margin-top: -20px;">
    
    <v-card style="margin-top: 15px;">
            <!-- <v-autocomplete
                v-model="cdpSelectedScoringSystem"
                :items="scoringSystems"
                item-text="systemName"
                item-value="systemID"
                label="Scoring System"
                attach
                return-object
            >

            </v-autocomplete> -->
            <v-data-table
                v-model="selectedProjects"
                :headers="projectListHeadings"
                :items="cdpProjectsList"
                :items-per-page="10"
                show-select
                class="elevation-1"
                ref="table"
                show-expand
                v-on:item-expanded="loadDBNUMSystems"
                item-key="dbnum"
                :footer-props="{
                    disableItemsPerPage: true
                }"
            >
            <template v-slot:no-data>
                No projects found
                <center>
                    <v-col cols="6">
                        <v-progress-linear v-show="showLinearLoader" color="grey darken-1"indeterminate rounded height="6"></v-progress-linear>
                      </v-col>
                </center>
                
            </template>
            <template v-slot:header.data-table-select="{ props }">
                <v-checkbox
                          :input-value="props.all"
                          :indeterminate="props.indeterminate"
                          primary
                          hide-details
                          @click.native="toggleAll" style="padding-bottom:10px; margin-top:10px;"
                          ></v-checkbox>
            </template>
            <template v-slot:item.ssystem="{ item }">
                <div v-if="item.score==null">UNSCORED</div>
                <div v-else>{{ cdpSelectedScoringSystem.systemName }}</div>
                
            </template>
            <template v-slot:item.score="{ item }">
                <div v-if="item.score==null">UNSCORED</div>
                <div v-else>{{ parseFloat(item.score).toFixed(2) }}</div>
            </template>
            <!--Edit project pop up-->
            <template v-slot:top>
                <v-dialog v-model="dialog" max-width="500px">
                    <template v-slot:activator="{ on }">
                    </template>
                    <v-card>
                        <v-card-title style="background: #4B77BE; color:#ffffff;">
                            <span class="headline">Edit Project</span>
                        </v-card-title>
                  
                        <v-card-text style="padding-bottom: 0;">
                            <v-container>
                                <v-row>
                                    <v-col cols="12" sm="10" md="12" style="padding-top: 10px; padding-bottom:0;">
                                      <v-text-field v-model="editedItem.projectName" label="PROJECT NAME"></v-text-field>
                                    </v-col>
                                    <v-col cols="12" sm="10" md="12" style="padding-top: 0; padding-bottom:0;">
                                      <v-text-field filled readonly v-model="editedItem.sri" label="SRI"></v-text-field>
                                    </v-col>
                                    <v-col cols="12" sm="10" md="12" style="padding-top: 0; padding-bottom:0;">
                                      <v-text-field v-model="editedItem.mpStart" label="MP START"></v-text-field>
                                    </v-col>
                                    <v-col cols="12" sm="10" md="12" style="padding-top: 0; padding-bottom:0;">
                                      <v-text-field v-model="editedItem.mpEnd" label="MP END"></v-text-field>
                                    </v-col>
                                </v-row>
                            </v-container>
                        </v-card-text>
                  
                        <v-card-actions style="padding-bottom:20px;">
                            <v-spacer style="flex-grow: .5 !important;"></v-spacer>
                                <v-btn class="btn blue-steel" text @click="close">Cancel</v-btn>
                                <v-btn class="btn blue-steel" color="white" text @click="save">Save</v-btn>
                        </v-card-actions>
                    </v-card>
                </v-dialog>
            </template>
            <!--Edit project pop up End-->
            <template class="col-md-6" v-slot:item.actions="{ item }">
                <div style="width: 150px;;">
                    <a 
                        v-if="item.score!=null" 
                        class="btn btn-xs btn-outline red-mint"
                        href="#"
                        v-on:click="showIndividualCDPReport(item)"
                        style="font-size:0.8em;text-transform: initial"
                    >
                        <i class="fa fa-file-pdf-o" style="padding-left: 2px;"></i>
                        <span v-if="item.isExpanded">
                            <img src="assets/layouts/layout3/img//multi_pdf.png" width="12" style="margin-left:-18px; padding-bottom:1px; ">
                        </span>
                    </a>
                    <span>
                        <a 
                            class="btn btn-xs btn-outline blue-steel _blue-madison" 
                            v-on:click="editProject(item)" 
                            style="font-size:0.8em;text-transform: initial; margin-right:3px; padding-right:6px; padding-left: 7px;"
                        >
                            <i class="fas fa-pencil-alt" ></i>
                        </a>
                        <span>
                            <a 
                                class="btn btn-xs btn-outline red-thunderbird" 
                                v-on:click="deleteCDPProject(item)" 
                                style="font-size:0.8em;text-transform: initial;"
                            >
                                <i class="fas fa-trash-alt"></i>
                            </a>
                        </span>	
                    </span>

                </div>
            </template>

            <template v-slot:expanded-item="{ item, headers }">
                <td :colspan="headers.length">
                    <v-data-table
                        :headers="scoringSystemListHeadings"
                        :items="item.systemData"
                        hide-default-footer
                        dense
                    >
                    <template v-slot:item.score="{ item }">
                        {{ parseFloat(item.score).toFixed(2) }}
                    </template>
                        <template v-slot:item.actions="{ item }">
                            <a class="btn btn-xs btn-outline red-mint"
                                href="#"
                                v-on:click="showIndividualCDPReportWithSystem(item)"
                                style="font-size:0.8em;text-transform: initial; margin-top:4px;"><i
                                class="fa fa-file-pdf-o"
                                style="_color:red"></i></a>
                        </template>
                    </v-data-table>
                </td>
              </template>
        </v-data-table>
        <!-- Delete Multiple CDP Projects-->
        <template v-if="selectedProjects.length > 1">
            <div class="text-center pt-2" style="padding-bottom: 0;">
                <button v-show ="showDeleteButton"
                        class="btn -btn-xs yellow-gold "
                        type="button"
                        v-on:click="deleteMultipleCDPProjects()"
                        style="-font-size:0.8em;-text-transform: initial; padding-top:7px; padding-bottom: 7px; margin-top: 3px;">DELETE SELECTED PROJECTS</button>
            </div>
        </template>


        <!-- <div class="text-center pt-2">
            <v-btn color="primary" class="mr-2">Delete Selected</v-btn>
        </div> -->
        </v-card-text>
        
    </v-card>
    <p>&nbsp;</p>
    <v-card style="margin-top: -20px;">
        <v-card-text style="border: 0px;">
            <table width="100%" style="margin:0px;padding:0px;" class="table light-bg">
                <tr>
                    <td colspan="3">
                        <div class="col-md-8">
                            <div class="col-md-5" style="font-weight: bold; font-size:16px; margin-top: 10px; text-align: right;padding-bottom: 0;">Select a Scoring System:</div>
                            <div class="col-md-5">
                                <vue-multiselect
                                    v-model="cdpSelectedScoringSystem"
                                    :options="scoringSystems"
                                    :searchable="true" label="systemName"
                                    track-by="systemID"
                                    :close-on-select="true"
                                    :show-labels="false"
                                    :allow-empty="false"
                                    placeholder="Select Value">
                                </vue-multiselect>
                            </div>
                            <div class="col-md-2" style="padding-bottom: 0;">
                                <button :disabled="scoring"
                                    class="btn -btn-xs yellow-gold "
                                    type="button"
                                    v-on:click="cdpScoreProjects"
                                    style="-font-size:0.8em;-text-transform: initial; padding-top:7px; padding-bottom: 7px; margin-top: 3px;">SCORE</button>   
                            </div>
                        </div>
                        <div class="col-md-4" style="padding-top: 30px; padding-left: 10px;">
                            <span style="font-weight: bold; font-size:16px;">Download Projects:</span>
                                <button
                                class="btn btn-xs btn-outline red-mint"
                                type="button"
                                :disabled="selectedProjects.length == 0"
                                v-on:click="downloadCDPMultiple()"
                                style="font-size:0.8em;text-transform: initial; padding-top:5px; padding-bottom: 5px; margin-left:20px;"><i
                                class="fa fa-file-pdf-o"></i></button>
                            <button
                                class="btn btn-xs btn-outline green-jungle"
                                type="button" 
                                :disabled="selectedProjects.length == 0"
                                v-on:click="showExcelReportMultiple()"
                                style="font-size:0.8em;text-transform: initial; padding-top:5px; padding-bottom: 5px;"><i
                                class="fa fa-file-excel-o"
                                ></i></button>
                                <form action="unset-target" method="post" id="downloadForm">
                                    <input type="hidden" name="dbnum">
                                    <input type="hidden" name="scoresystem">
                                </form>
                            
                        </div>   
                    </td>
                </tr>
                <tr>
                    <div class="center">
                        <v-progress-circular :size="80" color="grey darken-1" v-show="scoring" indeterminate color="primary">Scoring...</v-progress-circular>
                    </div>
                    <v-row align-content="center" justify="center">
                        <v-col class="subtitle-1 text-center" v-show="downloading" cols="6">
                            <p>{{downloadingText}}</p>
                            <v-progress-linear v-show="downloading" color="grey darken-1" indeterminate rounded height="6" ></v-progress-linear>
                        </v-col>
                    </v-row>
                </tr>
                
            </table>
            
    </v-card>
    </div>
	<v-card>
        
    </v-card>
</div>
    <v-dialog
        v-model="uploadResultsDialog"
    >
        <v-card>
            <v-card-title class="headline">Upload Results</v-card-title>
            <v-card-text>
                <table>
                    <tr v-if="cdpUploadResults.success.length>0">
                        <td colspan="2">
                            <div class="col-md-12">{{cdpUploadResults.success.length}} project were successfully uploaded</div>
                            <div class="col-md-12">
                                <table width="100%" class="sortable table_b table-striped table-bordered table-hover order-column">
                                    <thead>
                                        <tr>
                                            <th style="text-align:center;">Project Name</th>
                                            <th style="text-align:center;">SRI</th>
                                            <th style="text-align:center;">MP start</th>
                                            <th style="text-align:center;">MP end</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="result in cdpUploadResults.success">
                                            <td style="text-align:center;">{{result.projectName}}</td>
                                            <td style="text-align:center;">{{result.sri}}</td>
                                            <td style="text-align:center;">{{result.mpStart}}</td>
                                            <td style="text-align:center;">{{result.mpEnd}}</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr v-if="cdpUploadResults.failed.length>0">
                        <td colspan="2">
                            <div class="col-md-12">{{cdpUploadResults.failed.length}} failed to upload</div>
                            <div class="col-md-12">
                                <table width="100%" class="sortable table_b table-striped table-bordered table-hover order-column">
                                    <thead>
                                        <tr>
                                            <th style="text-align:center;">Project Name</th>
                                            <th style="text-align:center;">SRI</th>
                                            <th style="text-align:center;">MP start</th>
                                            <th style="text-align:center;">MP end</th>
                                            <th style="text-align:center;">Message</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="result in cdpUploadResults.failed">
                                            <td style="text-align:center;">{{result.projectName}}</td>
                                            <td style="text-align:center;">{{result.sri}}</td>
                                            <td style="text-align:center;">{{result.mpStart}}</td>
                                            <td style="text-align:center;">{{result.mpEnd}}</td>
                                            <td style="text-align:center;">{{result.failureMessage}}</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </v-card-text>
            <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="green darken-1" text @click="uploadResultsDialog = false">Continue</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</v-app>

