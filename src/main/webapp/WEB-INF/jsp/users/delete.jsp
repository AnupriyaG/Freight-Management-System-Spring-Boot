<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>NJDOT FMS | Delete User</title>
    <jsp:include page="../include/head_common.jsp" />
    <!-- BEGIN GLOBAL MANDATORY STYLES -->
    <link href="../assets/global/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="../assets/global/plugins/simple-line-icons/simple-line-icons.min.css" rel="stylesheet"
        type="text/css" />
    <link href="../assets/global/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../assets/global/plugins/bootstrap-switch/css/bootstrap-switch.min.css" rel="stylesheet"
        type="text/css" />
    <!-- END GLOBAL MANDATORY STYLES -->
    <!-- BEGIN PAGE LEVEL PLUGINS -->
    <link href="../assets/global/plugins/datatables/datatables.min.css" rel="stylesheet" type="text/css" />
    <link href="../assets/global/plugins/datatables/plugins/bootstrap/datatables.bootstrap.css" rel="stylesheet"
        type="text/css" />
    <!-- END PAGE LEVEL PLUGINS -->
    <!-- BEGIN THEME GLOBAL STYLES -->
    <link href="../assets/global/css/components-md.min.css" rel="stylesheet" id="style_components" type="text/css" />
    <link href="../assets/global/css/plugins-md.min.css" rel="stylesheet" type="text/css" />
    <!-- END THEME GLOBAL STYLES -->
    <!-- BEGIN THEME LAYOUT STYLES -->
    <link href="../assets/layouts/layout3/css/layout.min.css" rel="stylesheet" type="text/css" />
    <link href="../assets/layouts/layout3/css/themes/default.min.css" rel="stylesheet" type="text/css"
        id="style_color" />
    <link href="../assets/layouts/layout3/css/custom.css" rel="stylesheet" type="text/css" />
    <style>
        .form-horizontal .control-label {
            padding-top: 0px;
            height: 35px;
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
                                        <a
                                            href="${pageContext.servletContext.contextPath}/DisplayAdminMainPage">Home</a>
                                        <i class="fa fa-circle"></i>
                                    </li>
                                    <li>
                                        <a href="${pageContext.servletContext.contextPath}/DisplayUsersListPage">User
                                            List</a>
                                        <i class="fa fa-circle"></i>
                                    </li>
                                    <li>
                                        <span>Delete User</span>
                                    </li>
                                </ul>
                                <!-- END PAGE BREADCRUMBS -->
                                <!-- BEGIN PAGE CONTENT INNER -->
                                <div class="page-content-inner">
                                    <div class="row">
                                        <div
                                            class="col-lg-offset-3 col-lg-6 col-md-offset-2 col-md-8 col-sm-12 col-xs-12">

                                            <!-- BEGIN PORTLET-->
                                            <div class="portlet light ">
                                                <div class="portlet-title">
                                                    <div class="caption">
                                                        <i class="icon-share font-dark"></i>
                                                        <span class="caption-subject font-dark bold uppercase">Delete
                                                            User</span>
                                                    </div>
                                                    <div class="actions">
                                                        <a class="btn dark btn-circle btn-sm"
                                                            href="${pageContext.servletContext.contextPath}/users/list">
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
                                                        <div class="form-body"
                                                            style="background-color: rgba(255, 255, 255, 0.8); padding-left: 5px; box-shadow: 0 0 5px #888;">
                                                            <div class="form-group">
                                                                <label
                                                                    class="col-md-4 col-sm-4 col-xs-4 control-label sbold">
                                                                    <span class="item-status">Username<i
                                                                            class="fa fa-user font-red-sunglo"
                                                                            aria-hidden="true"
                                                                            style="margin-left:10px;"></i></span>
                                                                </label>
                                                                <div class="col-md-8 col-sm-8 col-xs-8">${data[0]}</div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label
                                                                    class="col-md-4 col-sm-4 col-xs-4 control-label sbold">
                                                                    <span class="item-status">Full Name<i
                                                                            class="fa fa-male font-red-sunglo"
                                                                            aria-hidden="true"
                                                                            style="margin-left:10px;"></i></span></label>
                                                                <div class="col-md-8 col-sm-8 col-xs-8">${data[1]}</div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label
                                                                    class="col-md-4 col-sm-4 col-xs-4 control-label sbold">
                                                                    <span class="item-status">Email<i
                                                                            class="fa fa-envelope font-red-sunglo"
                                                                            aria-hidden="true"
                                                                            style="margin-left:10px;"></i></span></label>
                                                                <div class="col-md-8 col-sm-8 col-xs-8">${data[4]}</div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label
                                                                    class="col-md-4 col-sm-4 col-xs-4 control-label sbold">
                                                                    <span class="item-status">Agency<i
                                                                            class="fa fa-building font-red-sunglo"
                                                                            aria-hidden="true"
                                                                            style="margin-left:10px;"></i></span></label>
                                                                <div class="col-md-8 col-sm-8 col-xs-8">${data[3]}</div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label
                                                                    class="col-md-4 col-sm-4 col-xs-4 control-label sbold">
                                                                    <span class="item-status">Group<i
                                                                            class="fa fa-users font-red-sunglo"
                                                                            aria-hidden="true"
                                                                            style="margin-left:10px;"></i></span></label>
                                                                <div class="col-md-8 col-sm-8 col-xs-8">${data[2]}</div>
                                                            </div>
                                                        </div>
                                                        <div class="form-actions">
                                                            <div class="row">
                                                                <center>
                                                                    <a class="btn yellow-gold"
                                                                        href="DeleteUser?username=${data[0]}">Delete</a>
                                                                </center>
                                                            </div>
                                                        </div>

                                                    </div>
                                                </div><!-- END "portlet-body form" -->



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
    </div>
    <jsp:include page="../include/quicknav.jsp" />
    <!--[if lt IE 9]>
<script src="assets/global/plugins/respond.min.js"></script>
<script src="assets/global/plugins/excanvas.min.js"></script> 
<script src="assets/global/plugins/ie8.fix.min.js"></script> 
<![endif]-->
    <!-- BEGIN CORE PLUGINS -->
    <script src="../assets/global/plugins/jquery.min.js" type="text/javascript"></script>
    <script src="../assets/global/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="../assets/global/plugins/js.cookie.min.js" type="text/javascript"></script>
    <script src="../assets/global/plugins/jquery-slimscroll/jquery.slimscroll.min.js" type="text/javascript"></script>
    <script src="../assets/global/plugins/jquery.blockui.min.js" type="text/javascript"></script>
    <script src="../assets/global/plugins/bootstrap-switch/js/bootstrap-switch.min.js" type="text/javascript"></script>
    <!-- END CORE PLUGINS -->
    <!-- BEGIN PAGE LEVEL PLUGINS -->
    <script src="../assets/global/scripts/datatable.js" type="text/javascript"></script>
    <script src="../assets/global/plugins/datatables/datatables.min.js" type="text/javascript"></script>
    <script src="../assets/global/plugins/datatables/plugins/bootstrap/datatables.bootstrap.js"
        type="text/javascript"></script>
    <!-- END PAGE LEVEL PLUGINS -->
    <!-- BEGIN THEME GLOBAL SCRIPTS -->
    <script src="assets/global/scripts/app.min.js" type="text/javascript"></script>
    <!-- END THEME GLOBAL SCRIPTS -->
    <!-- BEGIN THEME LAYOUT SCRIPTS -->
    <script src="assets/layouts/layout3/scripts/layout.min.js" type="text/javascript"></script>
    <script src="assets/layouts/layout3/scripts/demo.min.js" type="text/javascript"></script>
    <script src="assets/layouts/global/scripts/quick-sidebar.min.js" type="text/javascript"></script>
    <script src="assets/layouts/global/scripts/quick-nav.min.js" type="text/javascript"></script>
    <!-- END THEME LAYOUT SCRIPTS -->
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
    <script>
        $(document).ready(function () {
            $('input[type="text"],input[type="password"],select,input[type="submit"],TEXTAREA').addClass("form-control").addClass("form-control");
        });



    </script>
</body>

</html>