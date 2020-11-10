stipApp = new Vue({
    el: "#tab_1_1",
    vuetify: new Vuetify(),
    data() {
        return {
            scoreError:false,
            scoreErrorData: {},
            filterField: "All",
            filterValue: "",
            cascadeValue: "All",
            scoringSystemValue: {},
            scoringSystems: [],
            scoringResults: [],
            searching: false,
            searchClicked: false,
            filterOptions: {			//the index of available filters
                All: {
                    name: "All",
                    colName: "All",
                    type: "ALL"
                },
                DBNUM: {
                    name: "DBNUM",
                    colName: "DBNUM",
                    type: "LIST",
                    listURL: "filterValues?filterName=DBNUM",
                    values: []
                },
                PROJECT_NAME: {
                    name: "Project Name",
                    colName: "PROJECT_NAME",
                    type: "LIST",
                    listURL: "filterValues?filterName=ProjectName",
                    values: []
                },
                ROUTE: {
                    name: "Route",
                    colName: "ROUTE",
                    type: "LIST",
                    listURL: "filterValues?filterName=Route",
                    values: []
                },
                COUNTY: {
                    name: "County",
                    colName: "COUNTY",
                    type: "LIST",
                    listURL: "filterValues?filterName=County",
                    values: []
                },
                MUNC1: {
                    name: "Municipality",
                    colName: "MUNC1",
                    type: "LIST",
                    listURL: "filterValues?filterName=Municipality",
                    values: []
                },
                MPO: {
                    name: "MPO",
                    colName: "MPO",
                    type: "LIST",
                    listURL: "filterValues?filterName=MPO",
                    values: []
                },
                CIS_PROGRAM_CATEGORY: {
                    name: "Asset Management Category",
                    colName: "CIS_PROGRAM_CATEGORY",
                    type: "CASCADE",
                    listURL: "filterValues?filterName=CISCategory",
                    values: [],
                    cascadeName: "Asset Sub Category",
                    cascadeColName: "CIS_SUBCATEGORY",
                    cascadeURL: "filterValues?filterName=CISSubCategory&cascadeFilter=",
                    cascadeValues: []
                }
            },
            projectListHeadings: [
                {text:"Year", value:"year"},
                {text:"DBNUM", value:"dbnum"},
                {text:"Project Type", value:"project_Type"},
                {text:"Project Name", value:"project_Name"},
                {text:"Score", value:"score"},
                {text:"System Name", value:"system_Name"},
                {text:"Actions", value:"options"}
            ],
            selectedProjects:[],
            
            tableCSS: {
                tableClass: 'sortable table_b table-striped table-bordered table-hover order-column',
                ascendingIcon: 'glyphicon glyphicon-chevron-up',
                descendingIcon: 'glyphicon glyphicon-chevron-down',
                handleIcon: 'glyphicon glyphicon-menu-hamburger'
            }

        }
    },
    methods: {
        toggleAll () {
            this.selectedProjects = this.selectedProjects.length === this.scoringResults.length
              ? []
              : this.scoringResults
          },
        searchAndScoreStipReports: function () {
            if (this.filterField != "All" && this.filterValue == "") {
                alert("Please select a value for " + this.filterField);
                return;
            }
            if(null == this.scoringSystemValue){
                alert("Please select a value for Scoring System" );
                return;
            }
            this.scoringResults = [];
            this.searchClicked = true;
            this.searching = true;
            this.scoreError = false;

            fetch("generateScores?searchField=" + this.filterField + "&searchValue=" + encodeURIComponent(this.filterValue) + "&cascadeValue=" + this.cascadeValue + "&scoreSystem=" + this.scoringSystemValue.systemID)
                .then(function (response) {
                    this.filterLoading = false;
                    //if (!response.ok) {
                    //    throw Error(response);
                    //}
                    return response.json();
                })
                .then(data => {
                    this.searching = false;
                    if (data.error) {
                        this.scoreError = true;
                        this.scoreErrorData = data;
                    } else {
                        this.scoringResults = data;
                    }
                    this.scoringResults = data;
                    
                }).catch(error => {
                    this.scoreError = true;
                    this.scoreErrorData = error;
                    this.searching = false
                    console.error(error)
                });
        },
        showSTIPReport: function (dbnum) {
            rptfile = "Web_Telus_ScoringReport_chartsonly_FMS";
            var customsql = "DBNUM='" + dbnum + "'&systemID='" + this.scoringSystemValue.systemID + "'";
            var url = "LoadProjectReport?" + customsql + "&rptfile=" + rptfile;
            myPopup = window.open(url, 'popupWindow', 'width=700,height=500,resizable=yes,menubar=no,status=yes,location=no,toolbar=no,scrollbars=no');
            if (!myPopup.opener)
                myPopup.opener = self;
        },
        showSTIPReportMultiple: function () {
            rptfile = "Web_Telus_ScoringReport_chartsonly_FMS_Charts_Multiple";
            customsql = "";
            if (this.selectedProjects.length==0) {
                alert("Please select the projects to download report.");
                return;
            }
            //if (this.stipResultsSelectAll) {
            //    customsql = this.filterField + "='" + this.filterValue + "'";
            //} else {
                customsql = "DBNUM IN ("
                this.selectedProjects.forEach(element => {
                    customsql += "'" + element.dbnum + "',";
                });
                customsql += "'1')";
            //}
            
            customsql += " and SystemID = '" + this.scoringSystemValue.systemID + "'";
            var url = "LoadProjectReportMultiple?customsql=" + customsql + "&rptfile=" + rptfile;
            myPopup = window.open(url, 'popupWindow', 'width=700,height=500,resizable=yes,menubar=no,status=yes,location=no,toolbar=no,scrollbars=no');
            if (!myPopup.opener)
                myPopup.opener = self;
        },
        showExcelReportMultiple: function () {
            if (this.selectedProjects.length==0) {
                alert("Please select the projects to download report.");
                return;
            }
            dbnums = "";
            this.selectedProjects.forEach(element => {
                dbnums += element.dbnum + ",";
            });
                
                dbnums += "1";
                var url = "excelReport?dbnums=" + dbnums + "&systemID=" + this.scoringSystemValue.systemID;
                window.location = url;
            
        },
    },
    watch: {
        filterField: function (value) {
            console.log("Filter Index:" + value);
            this.filterValue = "";
            this.cascadeValue = "";
            if (value != "All") {
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

            if (value != "") {
                if (this.filterOptions[this.filterField].type == "CASCADE") {
                    fetch(this.filterOptions[this.filterField].cascadeURL + value)
                        .then(function (response) {
                            this.filterLoading = false;
                            return response.json();
                        })
                        .then(data => {
                            this.filterOptions[this.filterField].cascadeValues = data
                        }).catch(error => {
                            this.filterError = true;
                            this.filterLoading = false;
                            console.error(error)
                        });
                }

            }
        },


    },
    computed: {
        stipResultsSelectAll: {
            get: function () {
                trueCount = 0;
                falseCount = 0;
                this.scoringResults.forEach(element => {
                    if (element.selectedForDownload) trueCount++;
                    else falseCount++;
                });
                if (falseCount == 0) return true;
                else return false;
            },
            set: function (val) {
                this.scoringResults.forEach(element => {
                    element.selectedForDownload = val;
                });
                return val;
            }
        }
    }
})