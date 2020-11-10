<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>NJDOT FMS | View Score System</title>
    <jsp:include page="../include/head_common.jsp" />
    <!-- BEGIN PAGE LEVEL PLUGINS -->
    <link href="../assets/global/plugins/datatables/datatables.min.css" rel="stylesheet" type="text/css" />
    <link href="../assets/global/plugins/datatables/plugins/bootstrap/datatables.bootstrap.css" rel="stylesheet"
        type="text/css" />
    <!-- END PAGE LEVEL PLUGINS -->
    <style>
        #highlight tr:hover {
            background-color: #efefef;
        }
    </style>
</head>

<body class="page-container-bg-solid page-md">
    <div class="page-wrapper">
        <jsp:include page="../include/header.jsp" />
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
                        <div class="page-content" id="viewPBSApp">
                            <div class="container-fluid">
                                <!-- BEGIN PAGE BREADCRUMBS -->
                                <ul class="page-breadcrumb breadcrumb blk">
                                    <li>
                                        <a href="${pageContext.servletContext.contextPath}/">Home</a>
                                        <i class="fa fa-circle"></i>
                                    </li>
                                    <li>
                                        <a href="${pageContext.servletContext.contextPath}/performanceBasedScoring">Performance
                                            Based Scoring</a>
                                        <i class="fa fa-circle"></i>
                                    </li>
                                    <li>
                                        <span>View System</span>
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
                                                        <span class="caption-subject font-dark bold uppercase">System
                                                            Information</span>
                                                    </div>
                                                    <div class="actions">
                                                        <a class="btn dark btn-circle btn-sm"
                                                            href="${pageContext.servletContext.contextPath}/performanceBasedScoring">
                                                            <i class="fa fa-arrow-left"></i> Back
                                                        </a>
                                                        <!--a class="btn btn-circle btn-icon-only btn-default" href="javascript:;">
                                                                <i class="icon-cloud-upload"></i>
                                                            </a>
                                                            <a class="btn btn-circle btn-icon-only btn-default" href="javascript:;">
                                                                <i class="icon-wrench"></i>
                                                            </a-->
                                                        <a class="btn btn-circle btn-icon-only btn-default fullscreen"
                                                            href="javascript:;"> </a>
                                                        <!--a class="btn btn-circle btn-icon-only btn-default" href="javascript:;">
                                                                <i class="icon-trash"></i>
                                                            </a-->
                                                    </div>
                                                </div>
                                                <div class="portlet-body form">
                                                    <!-- BEGIN FORM-->
                                                    <div class="form-horizontal">
                                                        <!--=================================================-->
                                                        <div class="well"
                                                            style="background-color:#dddddd; padding-bottom: 5px; border: 1px #cccccc solid; margin-bottom: 20px; ">
                                                            <div class="form-group">
                                                                <div class="col-md-8 col-sm-8">
                                                                    <span class="in-line control-label bold">
                                                                        <span
                                                                            class="font-blue-soft col-md-6 col-sm-6">Scoring
                                                                            System Name:</span>
                                                                        <span class="col-md-6 col-sm-6"
                                                                            style="text-align: left;">{{scoreSystem.systemName}}</span></span>
                                                                </div>
                                                                <div class="col-md-4 col-sm-4">
                                                                    <span class="in-line control-label bold"><span
                                                                            class="font-blue-soft col-md-9 col-sm-9">Max
                                                                            Score: </span>
                                                                        <span class="col-md-3 col-sm-3"
                                                                            style="text-align: left;">{{scoreSystem.maxScore}}</span></span>
                                                                </div>
                                                                <div class="col-md-12 col-sm-12">
                                                                    <span class="in-line control-label bold"><span
                                                                            class="font-blue-soft col-md-4 col-sm-4">Description:&nbsp;</span>
                                                                        <span class="col-md-8 col-sm-8"
                                                                            style="text-align: left;">{{scoreSystem.description}}</span></span>
                                                                </div>
                                                            </div>
                                                            <!--END "form-group"-->
                                                        </div>
                                                        <div v-for="category in categories">
                                                            <div class="well"
                                                                style="margin-top: 5px; padding-top: 5px; padding-bottom: 2px; border-top: 4px #f1c40f solid; border-bottom: 1px #cccccc solic; border-radius: 0px; box-shadow: 0 0 5px #888;">
                                                                <div class="form-group">
                                                                    <div class="col-md-12 col-sm-12">
                                                                        <span class="in-line control-label bold"><span
                                                                                class="font-blue-soft col-md-4 col-sm-4">No.:</span>
                                                                            <span class="col-md-8 col-sm-8"
                                                                                style="text-align: left;">
                                                                                {{category.catID}}</span></span>
                                                                    </div>
                                                                    <div class="col-md-8 col-sm-8">
                                                                        <span class="in-line control-label bold"><span
                                                                                class="font-blue-soft col-md-6 col-sm-6">Scoring
                                                                                Factor Name:</span>
                                                                            <span class="col-md-6 col-sm-6"
                                                                                style="text-align: left;">&nbsp;{{category.cat_Name}}</span></span>
                                                                    </div>
                                                                    <div class="col-md-4 col-sm-4">
                                                                        <span class="in-line control-label bold"><span
                                                                                class="font-blue-soft col-md-9 col-sm-9">%
                                                                                of Total Score: </span>
                                                                            <span class="col-md-3 col-sm-3"
                                                                                style="text-align: left;">{{category.weight}}</span></span>
                                                                    </div>
                                                                    <div class="col-md-12 col-sm-12">
                                                                        <span class="in-line control-label bold"><span
                                                                                class="font-blue-soft col-md-4 col-sm-4">Factor
                                                                                Description:</span>
                                                                            <span class="col-md-8 col-sm-8"
                                                                                style="text-align: left;">{{category.cat_Description}}</span></span>
                                                                    </div>
                                                                </div>
                                                                <!--END "form-group"-->
                                                            </div>
                                                            <!--well end-->
                                                            <table width="100%" class="table_b tableText"
                                                                style="box-shadow:0 2px 2px #888888;  margin-top: -20px;"
                                                                id="highlight">
                                                                <thead>
                                                                    <tr>
                                                                        <th style="text-align: center"><strong>Criteria
                                                                                No.</strong></th>
                                                                        <th><strong>Criteria Description</strong></th>
                                                                        <th style="text-align: center"><strong>% of
                                                                                Factor Score</strong></th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <tr v-for="factor in category.scoreFactors">
                                                                        <td align="center">
                                                                            {{factor.factorID}}
                                                                        </td>
                                                                        <td>{{factor.factor_Description}}</td>
                                                                        <td align="center">
                                                                            {{factor.weight}}
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
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
    <!-- BEGIN QUICK NAV -->
    <nav class="quick-nav">
        <a class="quick-nav-trigger" href="#0">
            <span aria-hidden="true"></span>
        </a>
        <jsp:include page="../include/quicknav.jsp" />
        <span aria-hidden="true" class="quick-nav-bg"></span>
    </nav>
    <div class="quick-nav-overlay"></div>
    <jsp:include page="../include/footer_common.jsp" />
    <!-- END QUICK NAV -->
    <!-- BEGIN PAGE LEVEL PLUGINS -->
    <script src="../assets/global/scripts/datatable.js" type="text/javascript"></script>
    <script src="../assets/global/plugins/datatables/datatables.min.js" type="text/javascript"></script>
    <script src="../assets/global/plugins/datatables/plugins/bootstrap/datatables.bootstrap.js"
        type="text/javascript"></script>
    <!-- END PAGE LEVEL PLUGINS -->
    <script>
        $(document).ready(function () {
            $('#clickmewow').click(function () {
                $('#radio1003').attr('checked', 'checked');
            });
            viewPBSApp = new Vue({
                el: "#viewPBSApp",
                data() {
                    return {
                        scoreSystem: {},
                        categories: [],
                        id: -999
                    }
                },
                created: function () {
                    this.id = this.getUrlParameter("SystemID");
                    fetch("details?id=" + this.id)
                        .then(function (response) {
                            return response.json();
                        })
                        .then(data => {
                            Vue.set(this, "scoreSystem", data.scoreSystem[0]);
                            Vue.set(this, "categories", data.categories);
                        })
                },
                methods: {
                    getUrlParameter: function getUrlParameter(sParam) {
                        var sPageURL = window.location.search.substring(1),
                            sURLVariables = sPageURL.split('&'),
                            sParameterName,
                            i;

                        for (i = 0; i < sURLVariables.length; i++) {
                            sParameterName = sURLVariables[i].split('=');

                            if (sParameterName[0] === sParam) {
                                return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
                            }
                        }
                    }
                }
            })
        })

    </script>
</body>

</html>