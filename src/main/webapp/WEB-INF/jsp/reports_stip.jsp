<!-- BEGIN FORM-->
<div class="form-horizontal" role="form" v-cloak>
    <!--=================================================-->

    <input type="hidden" name="hdnSystemID" />
    <table class="table" style="background-color: rgba(102, 102, 102, 0.8); box-shadow: 0 0 5px #888;color:white; ">
        <tr>
            <td style="border-top: 0px solid #666;">
                <div class="col-md-12"
                    style="">
                    <div class="row">
                        <div class="col-sm-3">
                            <b>Search Category</b>
                        </div>
                        <div class="col-sm-9">
                            <vue-multiselect v-model="filterField"
                                :options="Object.keys(filterOptions)"
                                :searchable="true"
                                :close-on-select="true"
                                :show-labels="false"
                                placeholder="Select Value">
                            </vue-multiselect>
                        </div>
                    </div>
                    <div class="row" v-if="filterField!='All'"
                        >
                        <div class="col-sm-3">
                            <b>{{filterOptions[filterField].name}}</b>
                        </div>
                        <div class="col-sm-9">
                            <vue-multiselect v-model="filterValue"
                                :options="filterOptions[filterField].values"
                                :searchable="true"
                                :close-on-select="true"
                                :show-labels="false"
                                placeholder="Select Value">
                            </vue-multiselect>

                        </div>
                    </div>
                    <div class="row"
                        v-if="filterField!='All' && filterOptions[filterField].type=='CASCADE' && filterValue!=''"
                        >
                        <div class="col-sm-3">
                            <b>{{filterOptions[filterField].cascadeName}}</b>
                        </div>
                        <div class="col-sm-9">
                            <select class="form-control"
                                v-model="cascadeValue">
                                <option value="All">All</option>
                                <option
                                    v-for="option in filterOptions[filterField].cascadeValues"
                                    :value="option">{{option}}
                                </option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3">
                            <b>Scoring System</b>
                        </div>
                        <div class="col-sm-9">
                            <vue-multiselect
                                v-model="scoringSystemValue"
                                :allow-empty="false"
                                :options="scoringSystems"
                                :searchable="true" label="systemName"
                                track-by="systemID"
                                :close-on-select="true"
                                :show-labels="false"
                                placeholder="Select Value">
                            </vue-multiselect>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <input class="btn btn-md yellow-gold"
                                type="button" value="Search and Score"
                                v-on:click="searchAndScoreStipReports" />
                        </div>
                    </div>
                </div>
            </td>
        </tr>
    </table>
    
    <div class="col-md-12" v-if="scoreError" style="padding-left:30px;float:none;background-color:rgb(255, 164, 164);">
        <h3>{{scoreErrorData.status}} - {{scoreErrorData.error}}</h3>
        <p>Exception: {{scoreErrorData.exception}}</p>
        <p>Message: {{scoreErrorData.message}}</p>
    </div>
    <div class="col-md-12" v-cloak v-if="searchClicked"
        style="float:none; background-color: rgba(255, 255, 255, 0.8);">
        <div class="row" v-if="searching">
            <img style='max-width: 10%;margin: 0 auto;display: block;'
                src='images/loading.gif' alt='loading' />
        </div>
        <div class="row"
            v-if="!searching && scoringResults.length==0">
            <div class="bg-blue-chambray"
                style="margin: 10px 0 5px 15px; padding: 15px">
                <span id="ResMsg"
                    class="bg-font-blue-chambray font-sm">
                    Your search did not return any results.
                </span>
            </div>
        </div>
        <div class="row"
            v-if="!searching && scoringResults.length>0">
            <div class="bg-blue-chambray"
                style="margin: 10px 0 5px 12px; padding: 5px">
                <span id="ResMsg"
                    class="bg-font-blue-chambray font-sm">
                    Your search returned
                    {{scoringResults.length}} results.
                </span>
            </div>
        
        <div class="col-md-12"
            v-if="scoringResults.length>0">
            <div>
                <!-- <vuetable ref="vuetable" :api-mode="false"
                    :fields="stipResultsFields"
                    :data="scoringResults"
                    pagination-path="" track-by="dbnum"
                    :css="tableCSS">
                    <template slot="actions" scope="props">
                        <div class="custom-actions">
                            <a class="btn btn-xs btn-outline yellow-gold"
                                href="#"
                                v-on:click="showSTIPReport(props.rowData.dbnum)"
                                style="font-size:0.8em;text-transform: initial"><i
                                    class="fa fa-file-pdf-o"
                                    style="color:red"></i>&nbsp;Download</a>

                        </div>
                    </template>
                </vuetable> -->
            </div>
            <v-app>
                <v-data-table
                    v-model="selectedProjects"
                    :items="scoringResults"
                    :headers="projectListHeadings"
                    class="elevation-1"
                    ref="table"
                    :items-per-page="10"
                    show-select
                    item-key="dbnum"
                    >
                    <template v-slot:header.data-table-select="{ props }">
                        <v-checkbox
                                  :input-value="props.all"
                                  :indeterminate="props.indeterminate"
                                  primary
                                  hide-details
                                  @click.native="toggleAll" style="padding-bottom:10px; margin-top:10px;"
                                  ></v-checkbox>
                    </template>
                    <template v-slot:item.options="{ item }">
                        <a class="btn btn-xs btn-outline yellow-gold"
                                    href="#"
                                    v-on:click="showSTIPReport(item.dbnum)"
                                    style="font-size:0.8em;text-transform: initial"><i
                                        class="fa fa-file-pdf-o"
                                        style="color:red"></i>&nbsp;Download</a>
                    </template>
                    <!-- 
                    :items="cdpProjectsList"
                    show-expand
                    v-on:item-expanded="loadDBNUMSystems"
                       --> 
                </v-data-table>
            </v-app>
            <div align="center" style="margin-top: 20px;">
                <button
                    class="btn btn-md yellow-gold btn-outline"
                    type="button"
                    v-on:click="showSTIPReportMultiple()"
                    style="font-size:1.1em;text-transform: initial"><i
                        class="fa fa-file-pdf-o"
                        style="color:red"></i>&nbsp;Download
                    Selected</button></td>
                <button
                    class="btn btn-md yellow-gold btn-outline"
                    type="button" id="excelReportBtn"
                    v-on:click="showExcelReportMultiple"
                    style="font-size:1.1em;text-transform: initial"><i
                        class="fa fa-file-excel-o"
                        style="color:green"></i>&nbsp;Download
                    Selected Items as Excel</button></td>
                <!-- Added by Bhaumik Starts -->
                <!--input type="button" name="Submit" value="System Generate Selected" onclick="submitForm();" /-->
                <!-- Added by Bhaumik Ends -->
            </div>
            <br>
            <p style="text-align:center;color:red;">* NOTE:
                Scoring and Generating reports from the
                "All" search category will take several
                minutes to complete.</p>
        </div>
    </div>
</div>
</div>