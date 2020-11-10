cdpApp = new Vue({
    el: "#tab_1_3",
    vuetify: new Vuetify(),
    data() {
        return {
            projectName: "",
            projectNameError:true,

            routes: [],
            selectedRoute: "",

            fromMPs:[],
            selectedFromMP: "",
            fromMPLoading: false,
            fromMPError: false,
            fromMPErrorData: null,

            toMPs: [],
            selectedToMP: "",
            toMPLoading: false,
            toMPError: false,
            toMPErrorData: null,

            addIndividualProjLoading: false,
            addIndividualProjError: false,
            addIndividualProjResult: null,

            scoringSystems:[],
            cdpSelectedScoringSystem:"",
            cdpUploader: false,
            showLinearLoader: false,
            scoring: false,
            scoringInProcess:false,
			cdpProjectsList:[],
			cdpUploadResults:{
				success: [],
				failed: []
            },
            editedIndex: -1,
            dialog: false,
            editedItem: {
                projectName: '',
                sri: 0,
                mpStart: 0,
                mpEnd: 0,
            },
            defaultItem: {
                projectName: '',
                sri: 0,
                mpStart: 0,
                mpEnd: 0,
              },
            mpStartError: false,
            mpEndError: false,
            sriError: false,

            interval: {},
            downloadingText: "",
            downloading:false,
            overlay:false,
            projectListHeadings: [
                {text:"Project Name", value: "projectName"},
                {text:"SRI", value:"sri"},
                {text:"MP Start", value:"mpStart"},
                {text:"MP End", value:"mpEnd"},
                {text:"Scoring System", value:"ssystem"},
                {text:"Score", value:"score"},
                {text:"Actions", value:"actions"}
            ],
            scoringSystemListHeadings: [
                {text:"Scoring System", value:"systemName"},
                {text:"Score", value:"score"},
                {text:"Actions", value:"actions"}
            ],
            uploadProcessing: false,
            uploadResultsDialog: false,
            selectedProjects:[],
            showDeleteButton: true
        }
    },
    created: function() {
        //this.$vuetify.theme.dark = true;
    },
    methods: {
        toggleAll () {
            this.selectedProjects = this.selectedProjects.length === this.cdpProjectsList.length
              ? []
              : this.cdpProjectsList
          },
        refreshProjectList: function() {
            fetch("CDPGetProjects?system_id=" + this.cdpSelectedScoringSystem.systemID, {redirect:"error"})
			    .then(function (response) {
			    	this.filterLoading = false;
			    	return response.json();
			    })
			    .then(data => {
                    this.cdpProjectsList = [];
                    this.cdpProjectsList = data;
			    }).catch(error => {
                
			    	console.error(error)
			    });
        },
        cdpScoreProjects: function() {
            selectedDBNUMs = [];
            this.selectedProjects.forEach(item => selectedDBNUMs.push(item.dbnum));
            
            if(selectedDBNUMs.length == 0){
                alert("Please select project(s) to score");
                return;
            }
            this.scoring = true;
            var data = new FormData()
            data.append("system_id", this.cdpSelectedScoringSystem.systemID);
            data.append("dbnum", selectedDBNUMs.join());
            fetch(
                "CDPScoreProjects", 
                {
                    redirect:"error",
                    method: "POST",
                    body: data
                }
            )
            .then(
                response => response.json() // if the response is a JSON object
            ).then(
                data => {
                    //alert("Projects scored successfully");
                    this.scoring = false;
                    this.refreshProjectList();  
                }
            ).catch(
                error => console.log(error), // Handle the error response object
            );
        },
        cdpProcessUpload: function(evtarget) {
            var data = new FormData()
            data.append('file', evtarget.files[0]);
            if(evtarget.files.length > 0){
                this.showLinearLoader = true;
            }
            this.uploadProcessing = true;
            fetch('CDPFileUpload', { // Your POST endpoint
                method: 'POST',
                headers: {
                    // Content-Type may need to be completely **omitted**
                    // or you may need something
                    //"Content-Type": "You will perhaps need to define a content-type here"
                },
                redirect: "error",
                body: data	// This is your file object
            }).then(
                response => {
                    this.uploadProcessing = false;
                    return response.json() // if the response is a JSON object
                }
            ).then(
                data => {
                    this.cdpUploadResults.success = data.success;
                    this.cdpUploadResults.failed = data.failed;
                    this.uploadResultsDialog = true;
                    if(this.uploadResultsDialog){
                        this.showLinearLoader = false;
                    }
                    this.refreshProjectList();
                }
            ).catch(
                error => {
                    console.log(error) // Handle the error response object
                    alert(error);
                }
            );
            evtarget.value = null;
            //evtarget.files[0]
        },
        addIndividualProject: function() {
            if (this.projectNameError) {
                alert("Please specify a project name.")
                return;
            }
            if (this.selectedRoute == "") {
                alert("Please specify the project's route.")
                return;
            }
            if (this.selectedFromMP == "") {
                alert("Please specify the starting milepost.")
                return;
            }
            if (this.selectedToMP == "") {
                alert("Please specify the ending milepost.")
                return;
            }
            this.addIndividualProjLoading = true
            fetch("CDPAddIndividualProject?"+
                "name="+ this.projectName +
                "&route=" + this.selectedRoute.title +
                "&sri=" + this.selectedRoute.value +
                "&startMP=" + this.selectedFromMP +
                "&endMP=" + this.selectedToMP, {redirect:"error"}
            )
			    .then(function (response) {
			    	this.addIndividualProjLoading = false;
			    	if (response.ok) return response.json();
                    else if (response.type == "opaqueredirect") throw new Error('Your session has expired. Refresh the page to login again.');
			    })
			    .then(data => {
                    if (data.failureMessage) {
                        this.addIndividualProjError = true;
                        this.addIndividualProjResult = data.failureMessage;
                        alert("ERROR: " + data.failureMessage);
                    } else {
                        alert("Project Added");
                        this.addIndividualProjError = false;
                        this.refreshProjectList();

                    }
			    }).catch(error => {
                    this.addIndividualProjError = true;
			    	console.error(error)
			    });
        },
        showIndividualCDPReport: function (item) { //Download PDF using system from dropdown
            if (item.isExpanded) {
                systems = item.systemData.map(item => item.systemId).join()
                url = "DownloadCDPReportPDF?dbnum=" + item.dbnum +
                "&scoresystem=" + systems;
            } else {
                url = "DownloadCDPReportPDF?dbnum=" + item.dbnum +
                "&scoresystem=" + this.cdpSelectedScoringSystem.systemID;
            }
            //alert(item);
            //console.log(item);
            
            window.location = url;
        },
        showIndividualCDPReportWithSystem: function(item) { //Download PDF button in sub tables
            url = "DownloadCDPReportPDF?dbnum=" + item.dbnum +
                "&scoresystem=" + item.systemId;
            window.location = url;
        },
        downloadCDPMultiple: function() {
            dbnum = "";
            projects_unscored = false;
            Object.keys(this.$refs.table.selection).forEach(element => {
                if (this.$refs.table.selection[element].systemId == null) {
                    projects_unscored = true;
                    
                }
                 dbnum += this.$refs.table.selection[element].dbnum + ",";
            });
            dbnum += "1";

            if (projects_unscored) {
                alert("One or more of the selected projects has not been scored. Please score these projects before generating a report.")
                return;
            }
            
            if (this.$refs.table.selection.length == 0) {
                alert("Please select the projects to download report.");
                return;
            }
           /*  $("#downloadForm").attr("action", "DownloadCDPReportPDF");
            $("#downloadForm input[name=dbnum]").val(dbnum);
            $("#downloadForm input[name=scoresystem]").val(this.cdpSelectedScoringSystem.systemID);
            $("#downloadForm").submit(); */
             /*var url = "DownloadCDPReportPDF?dbnum=" + dbnum + "&scoresystem=" + this.cdpSelectedScoringSystem.systemID;
            alert(url);
            window.location = url; */
            this.downloading = true;
            this.downloadingText = 'Downloading Projects...'
            fetch("DownloadCDPReportPDF?dbnum=" + dbnum + "&scoresystem=" + this.cdpSelectedScoringSystem.systemID)
                .then(resp => resp.blob())
                .then(blob => {
                                this.downloading = false;
                                this.overlay= false;
                                console.log("Length = "+blob.length);
                                const url = window.URL.createObjectURL(blob);
                                if (window.navigator && window.navigator.msSaveOrOpenBlob) {
                                    window.navigator.msSaveOrOpenBlob(blob,"CDP_Project(s).pdf");
                                } else {
                                    const url = window.URL.createObjectURL(blob);
                                }
                                const a = document.createElement('a');
                                a.style.display = 'none';
                                a.href = url;
                                // the filename you want
                                a.download = 'CDP_Projects.pdf';
                                document.body.appendChild(a);
                                a.click();
                                window.URL.revokeObjectURL(url);
                                clearInterval(this.interval)
                                //alert('Projects downloaded successfully!');
                            })
                .catch(() => alert('Downloading Project(s)')); 
         },
        loadDBNUMSystems: function(e) {
            if (e.value) {
                Vue.set(e.item, "isExpanded", true);
                fetch("CDPGetProjectsByDBNUM?dbnum=" + e.item.dbnum, {redirect:"error"})
			        .then(function (response) {
			        	this.filterLoading = false;
			        	return response.json();
			        })
			        .then(data => {
                        Vue.set(e.item, "systemData", data);
			        	//e.item.systemData = data
			        }).catch(error => {
			        	console.error(error)
                    });
            } else {
                Vue.set(e.item, "isExpanded", false);
            }
        },
        showExcelReportMultiple: function () {
            dbnum = "";
            projects_unscored = false;
            Object.keys(this.$refs.table.selection).forEach(element => {
                if (this.$refs.table.selection[element].systemId == null) {
                    projects_unscored = true;
                    
                }
                dbnum += this.$refs.table.selection[element].dbnum + ",";
            });
            if (projects_unscored) {
                alert("One or more of the selected projects has not been scored. Please score these projects before generating a report.")
                return;
            }
            dbnum += "1";
           
           if (this.$refs.table.selection.length == 0) {
               alert("Please select the projects to download report.");
               return;
           }
           $("#downloadForm").attr("action", "excelReportForCDP");
            $("#downloadForm input[name=dbnum]").val(dbnum);
            $("#downloadForm input[name=scoresystem]").val(this.cdpSelectedScoringSystem.systemID);
            $("#downloadForm").submit();
           // generate excel sheet report for selected CDP prdbnums_To_Deleteojects
            /* var url = "excelReportForCDP?dbnum=" + dbnum + "&systemID=" + this.cdpSelectedScoringSystem.systemID;
            window.location = url; */
        },
        deleteCDPProject: function (item) {
            const index = this.cdpProjectsList.indexOf(item);
            result = confirm('Are you sure you want to delete this project?') ;
            if(result){
                fetch("Delete_CDPProject?ID=" + item.id).then(
                    function(response){
                            return response.json();}
                    ).then(data =>{
                        console.log("Status : "+data.status);
                        if (data.status == "OK") {
                            console.log("Its deleted");
                            this.cdpProjectsList.splice(index, 1);
                            this.refreshProjectList();
                            alert("Project deleted")
                        } else {
                            alert("This record could not be deleted.")
                        }
                    })
            }
        },
        deleteMultipleCDPProjects: function (){
            if(this.selectedProjects.length > 1){
                //delete multiple CDP projects
                result = confirm('Are you sure you want to delete all the selected projects? This process cannot be undone.');
                if(result){
                    dbnums_To_Delete = []
                    this.selectedProjects.forEach(item => dbnums_To_Delete.push(item.dbnum));
                    fetch("Delete_CDPProjects?dbnums=" + dbnums_To_Delete).then(
                        function(response){
                                return response.json();}
                        ).then(data =>{
                            console.log("Status : "+data.status);
                            if (data.status == "OK") {
                                console.log("multiple projects  deleted");
                                alert("All the selected projects are deleted.")
                                this.refreshProjectList();
                                this.selectedProjects = []
                            } else {
                                alert("These records could not be deleted.")
                            }
                        })
                }
            }
        },
        editProject: function(item){
            this.editedIndex = this.cdpProjectsList.indexOf(item)
            this.editedItem = Object.assign({}, item)
            this.dialog = true
        },
        close: function() {
            this.dialog = false
            setTimeout(() => {
              this.editedItem = Object.assign({}, this.defaultItem)
              this.editedIndex = -1
            }, 300)
          },
        save: function() {
            if (this.editedIndex > -1) {
                this.mpStartError = false
                this.mpEndError = false
                this.sriError = false
                if(!this.checkFloat(this.editedItem.mpStart)) this.mpStartError = true;
                if(!this.checkFloat(this.editedItem.mpEnd)) this.mpEndError = true;
                if(this.mpStartError){
                    alert(" Please enter valid numeric value in MP START");
                    return;
                } 
                if(this.mpEndError) {
                    alert(" Please enter valid numeric value in MP END");
                    return;
                }
                if(this.editedItem.sri==""){
                    alert("SRI cannot be empty");
                    return;
                }else if(this.editedItem.sri.length < 10){
                    alert("SRI must be at least 10 characters");
                    return;
                }else{
                    fetch("sri_present?sri="+this.editedItem.sri)
                    .then(function(response){
                        //console.log("response text is :"+response.text())
                        return response.json();
                    }).then(data =>{
                        if(data.status == "NOT FOUND"){
                            console.log("status :"+data.status);
                            alert("SRI entered could not be found");
                            return;
                        }else{
                            console.log("edited "+this.editedItem.projectName);
                            fetch("Update_CDPProject?ID="+this.editedItem.id+"&project="+this.editedItem.projectName+"&sri="+this.editedItem.sri+"&mpStart="+this.editedItem.mpStart+"&mpEnd="+this.editedItem.mpEnd)
									.then(function (response) {
                                        return response.json();
									})
									.then(data => {
										if (data.status == "OK") {
                                            this.close();
                                            alert('Changes saved successfully');
											this.refreshProjectList()
										} else {
                                            alert('Changes were not saved');
                                            return;
										}
									})
                        }
                    })
                }
                
            }
          },
         
          checkFloat: function (strValue) {
            var value = parseFloat(strValue);
            var val1;
            if (isNaN(value)) {
                return false;
            }
            else {
                for (var i = 0; i < strValue.length; i++) {
                    val1 = strValue.charCodeAt(i);
                    if (val1 == 46)
                        continue;
                    if ((val1 < 48) || (val1 > 57)) {
                        return false;
                    }
                }
                return true;
            }
        },
    },
    watch: {
        projectName: function(val) {
            if (this.projectName == "") this.projectNameError = true;
            else this.projectNameError = false;
        },
        cdpSelectedScoringSystem: function(val) {
            this.refreshProjectList();
        },
        selectedRoute: function(val) {
            this.fromMPs = [],
            this.toMPs = [],
            this.selectedFromMP = "";
            this.selectedToMP = "";
            this.fromMPLoading = true;
            this.fromMPError = false;
            fetch("fromMPList?route=" + val.value, {redirect:"manual"})
                .then(response => {
                    this.fromMPLoading = false;
                    if (response.ok) return response.json();
                    else if (response.type == "opaqueredirect") throw new Error('Your session has expired. Refresh the page to login again.');
                })
                .then(data => {
                    this.fromMPs = data
                }).catch(error => {
                    this.fromMPError = true;
                    this.fromMPErrorData = error;
                    console.error(error)
                });
        },
        selectedFromMP: function (value) {
            this.toMPLoading = true;
            this.toMPError = false;
            fetch("toMPList?route=" + this.selectedRoute.value + "&from=" + value, {redirect:"error"})
                .then(response => {
                    this.toMPLoading = false;
                    if (response.ok) return response.json();
                    else if (response.type == "opaqueredirect") throw new Error('Your session has expired. Refresh the page to login again.');
                })
                .then(data => {
                    this.toMPs = data;
                }).catch(error => {
                    this.toMPError = true;
                    this.toMPErrorData = error;
                    console.error(error)
                });
        },
        //Updates selectedProjects when an unscored project is scored
        cdpProjectsList:{
            handler: function(newValue,oldValue){
                this.selectedProjects.forEach(item1=>{
                    newValue.forEach(item =>{
                        if(item.dbnum == item1.dbnum){
                            if(item.systemId != item1.systemId){
                                item1.systemId = item.systemId;
                            }
                        }
                    })
                })
                /* if(this.selectedProjects.length > 1){
                    this.showDeleteButton = true;
                }
                else{
                    this.showDeleteButton = false;
                } */
            },
            deep: true
        },
        multipleProjectDelete:function(val) {
            if(this.selectedProjects.length > 1){
                this.showDeleteButton = true
            }
        }
    }
})