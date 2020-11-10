<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>NJDOT FMS | Performance Based Scoring</title>
    <jsp:include page="../include/head_common.jsp" />
    
    <script language="JavaScript">
        function selectOption(varForm) {
            valid = true;
            var temp = varForm.SystemID.options[varForm.SystemID.selectedIndex].value;
            if (temp == null || temp == "" || temp == " ") {
                alert("Please select a valid option");
                varForm.SystemID.focus();
                valid = false;
            }
            return valid;
        }
        function copydata(pageValue) {
            document.subForm.Submit.value = pageValue;
        }

        function confirmDelete(deleteForm) {
            var selectedValue = deleteForm.SystemID.options[deleteForm.SystemID.selectedIndex].value;

            if (selectedValue == null || selectedValue == "" || selectedValue == " ") {
                return selectOption(deleteForm);
            }
            else {
                if (confirm("Are you sure you want to DELETE the selected system")) {
                    deleteForm.submit();
                }
            }
        }
        //-->
        function filterTable() {
            selected_id = "NaN";
            selected_id = $("select[name='LoginID'] option:selected").text().trim();
            if (selected_id == "") selected_id = $("#UserFullName").val();
            user_id = $("#UserFullName").val();
            //alert(selected_id);
            $(".tableContents .tableText").each(function () {
                current_id = $(this).find(".created_by").html().trim();
                if (current_id != selected_id) $(this).hide(); else $(this).show();
                //if ($(this).css("background-color") == "rgba(102, 102, 102, 0.8)") $(this).show();

                $(this).find(".created_on").html($(this).find(".created_on").html().split(" ")[0]);
                if (user_id != current_id) {

                    $(this).find(".editBtn").hide();
                    $(this).find(".deleteBtn").hide();
                }
            });
            //$(".created_on_visible").html($(".created_on_visible").html().split(" ")[0]);

        }


    </script>
    <style>
        .scoreSystemItem {
            
            display: table; 
            box-shadow: 0 0 5px #888;
            font-size:14px;
            margin-bottom:10px;
        }
        .default.scoreSystemItem {
            background-color: rgba(102, 102, 102, 0.8); 
            color: #ffffff;
        }
        .all.scoreSystemItem {
            background-color: rgba(255, 255, 255, 0.7); 
            color: #000;
        }
        
        .scoreSystemItem .row {
            padding:8px;
        }
        .default.scoreSystemItem .row {
            border-top: 1px solid #666666;
        }
        .all.scoreSystemItem .row {
            border-top: 1px solid #DDDDDD;
        }
        
    </style>
</head>

<body class="page-container-bg-solid page-md" onload="filterTable()">
    <div class="page-wrapper">
        <jsp:include page="../include/header.jsp" />
        <div class="page-wrapper-row full-height">
            <div class="page-wrapper-middle">
                <!-- BEGIN CONTAINER -->
                <div class="page-container">
                    <!-- BEGIN CONTENT -->
                    <div class="page-content-wrapper">
                        <!-- BEGIN CONTENT BODY -->
                        <!-- BEGIN PAGE CONTENT BODY -->
                        <div class="page-content">
                            <div class="container-fluid">
                                <!-- BEGIN PAGE BREADCRUMBS -->
                                <ul class="page-breadcrumb breadcrumb blk">
                                    <li>
                                        <a href="${pageContext.servletContext.contextPath}/">Home</a>
                                        <i class="fa fa-circle"></i>
                                    </li>
                                    <li>
                                        <span>Performance-Based Scoring</span>
                                    </li>
                                </ul>
                                <!-- END PAGE BREADCRUMBS -->
                                <!-- BEGIN PAGE CONTENT INNER -->
                                <div class="page-content-inner">
                                    <div class="row">
                                        <div class="col-lg-offset-1 col-lg-10 col-md-12 col-sm-12 col-xs-12">
                                            <!-- BEGIN PORTLET-->
                                            <div class="portlet light ">
                                                <div class="portlet-title">
                                                    <div class="caption">
                                                        <i class="icon-share font-dark"></i>
                                                        <span
                                                            class="caption-subject font-dark bold uppercase">Performance-Based
                                                            Scoring</span>
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
                                                    <!-- BEGIN FORM-->
                                                    <div class="form-horizontal">
                                                        <!--=================================================-->
                                                        <div class="table-responsive" id="performanceBasedScoringApp">
                                                            <div class="col-md-12" style="border-top:  1px solid #ffffff;padding:8px">
                                                                <select v-model="loginID" name="LoginID" id="LoginID"
                                                                    style="width: 160px;"
                                                                    class="form-control input-large">
                                                                    <option value="Administrator"> </option>
                                                                    <option v-for="user in scoringUsers" :value="user">{{user}}</option>
                                                                </select>
                                                                <input type="hidden" id="UserFullName" value="${username}" />
                                                            </div>
                                                            <div class="col-xs-12 default scoreSystemItem" v-for="system in defaultScoringSystems">
                                                                <div class="row">
                                                                    <div class="col-sm-3 col-xs-6 text-right"><b>Scoring Method:</b></div>
                                                                    <div class="col-sm-3 col-xs-6">{{system.systemName}}</div>
                                                                    <div class="col-sm-3 col-xs-6 text-right"><b>Max Score:</b></div>
                                                                    <div class="col-sm-3 col-xs-6">{{system.maxScore}}</div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-sm-3 col-xs-12 text-right"><b>Description:</b></div>
                                                                    <div class="col-sm-9 col-xs-12">{{system.description}}</div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-sm-3 col-xs-6 text-right"><b>Created By:</b></div>
                                                                    <div class="col-sm-3 col-xs-6">{{system.loginID}}</div>
                                                                    <div class="col-sm-3 col-xs-6 text-right"><b>Created on:</b></div>
                                                                    <div class="col-sm-3 col-xs-6 created_on_visible" v-if="system.timeStamp">{{system.timeStamp.split(" ")[0]}}</div>
                                                                </div>
                                                                <div class="row text-center">
                                                                    <a class="btn yellow-gold btn-xs" :href="'view?SystemID='+ system.systemID">View</a>
                                                                    <a class="btn btn-xs yellow-gold" :href="'AddExisting?SystemID='+system.systemID">Create New Based on this system</a>
                                                                </div>
                                                            </div>
                                                            <div class="col-xs-12 all scoreSystemItem" v-for="system in scoringSystems" v-if="system.loginID == loginID || loginID == ''">
                                                                <div class="row">
                                                                    <div class="col-sm-3 col-xs-6 text-right"><b>Scoring Method:</b></div>
                                                                    <div class="col-sm-3 col-xs-6">{{system.systemName}}</div>
                                                                    <div class="col-sm-3 col-xs-6 text-right"><b>Max Score:</b></div>
                                                                    <div class="col-sm-3 col-xs-6">{{system.maxScore}}</div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-sm-3 col-xs-12 text-right"><b>Description:</b></div>
                                                                    <div class="col-sm-9 col-xs-12">{{system.description}}</div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-sm-3 col-xs-6 text-right"><b>Created By:</b></div>
                                                                    <div class="col-sm-3 col-xs-6">{{system.loginID}}</div>
                                                                    <div class="col-sm-3 col-xs-6 text-right "><b>Created on:</b></div>
                                                                    <div class="col-sm-3 col-xs-6 created_on_visible" v-if="system.timeStamp">{{system.timeStamp.split(" ")[0]}}</div>
                                                                </div>
                                                                <div class="row text-center">
                                                                    <a class="btn btn-xs btn-outline yellow-gold" :href="'view?SystemID='+system.systemID">View</a>
                                                                    <a class="btn btn-xs btn-outline yellow-gold editBtn" :href="'edit?SystemID='+system.systemID">Edit</a>
                                                                    <a class="btn btn-xs btn-outline yellow-gold deleteBtn"  :href="'delete?SystemID='+system.systemID"
                                                                        onclick="if (!confirm('Are you sure you want to delete this scoring system?')) return false;">Delete</a>
                                                                    <a class="btn btn-xs btn-outline yellow-gold" :href="'AddExisting?SystemID='+system.systemID">Create
                                                                        New Based on this system</a>
                                                                </div>
                                                            </div>
                                                            
                                                        </div>
                                                        <!--======================================================================-->
                                                    </div>
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
        
    </div>
    <jsp:include page="../include/footer_common.jsp" />
    <jsp:include page="../include/quicknav.jsp" />
    
    <!-- BEGIN PAGE LEVEL PLUGINS -->
    <script src="../assets/global/scripts/datatable.js" type="text/javascript"></script>
    <script src="../assets/global/plugins/datatables/datatables.min.js" type="text/javascript"></script>
    <script src="../assets/global/plugins/datatables/plugins/bootstrap/datatables.bootstrap.js"
        type="text/javascript"></script>
    <!-- END PAGE LEVEL PLUGINS -->
    
    <script>
        var performanceBasedScoringApp = new Vue({
            el: "#performanceBasedScoringApp",
            data: {
                loginID: "Administrator",
                defaultScoringSystems:[],
                scoringSystems:[],
                loggedInUser:"",
                scoringUsers: []
            },
            created: function() {
                fetch("data")
                    .then(function (response) {
                        return response.json();
                    })
                    .then(data => {
                        this.defaultScoringSystems = data.default;
                        this.scoringSystems = data.all;
                        this.loggedInUser = data.loggedInUser;
                        this.scoringUsers = data.scoringUsers;
                    })
            }
        });
    </script>
    <script>
        $(document).ready(function () {
            $('#clickmewow').click(function () {
                $('#radio1003').attr('checked', 'checked');
            });
            $("select[name='LoginID']").change(function () {
                filterTable();
            });

        })
    </script>
</body>

</html>