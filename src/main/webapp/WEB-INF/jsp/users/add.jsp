<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>NJDOT FMS | Add User</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta content="width=device-width, initial-scale=1" name="viewport" />
    <!-- BEGIN GLOBAL MANDATORY STYLES -->
    <link href="http://fonts.googleapis.com/css?family=Open+Sans:400,300,600,700&subset=all" rel="stylesheet"
        type="text/css" />
    <link href="../assets/global/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="../assets/global/plugins/simple-line-icons/simple-line-icons.min.css" rel="stylesheet" type="text/css" />
    <link href="../assets/global/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="../assets/global/plugins/bootstrap-switch/css/bootstrap-switch.min.css" rel="stylesheet" type="text/css" />
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
    <link href="../assets/layouts/layout3/css/themes/default.min.css" rel="stylesheet" type="text/css" id="style_color" />
    <link href="../assets/layouts/layout3/css/custom.css" rel="stylesheet" type="text/css" />

    <script Language="JavaScript">
        function Form1_Validator(theForm) {
            if (theForm.userName.value == "") {
                alert("Please enter a Username");
                theForm.userName.focus();
                return (false);
            }

            if (theForm.fullName.value == "") {
                alert("Please enter the Full Name");
                theForm.fullName.focus();
                return (false);
            }

            if (theForm.password.value == "") {
                alert("Please enter a Password");
                theForm.password.focus();
                return (false);
            }

            if (theForm.password.value != theForm.P2.value) {
                alert("The two passwords are not the same.");
                theForm.P2.focus();
                return (false);
            }
            if (theForm.email.value == "") {
                alert("Please enter a value for Email ");
                theForm.email.focus();
                return (false);
            }


            // test if valid email address, must have @ and .
            var checkEmail = "@.";
            var checkStr = theForm.email.value;
            var EmailValid = false;
            var EmailAt = false;
            var EmailPeriod = false;
            for (i = 0; i < checkStr.length; i++) {
                ch = checkStr.charAt(i);
                for (j = 0; j < checkEmail.length; j++) {
                    if (ch == checkEmail.charAt(j) && ch == "@")
                        EmailAt = true;
                    if (ch == checkEmail.charAt(j) && ch == ".")
                        EmailPeriod = true;
                    if (EmailAt && EmailPeriod)
                        break;
                    if (j == checkEmail.length)
                        break;
                }
                // if both the @ and . were in the string
                if (EmailAt && EmailPeriod) {
                    EmailValid = true
                    break;
                }
            }
            if (!EmailValid) {
                alert("The Email field must contain an \"@\" and a \".\".");
                theForm.email.focus();
                return (false);
            }


            /* 	if (theForm.agencyName.selectedIndex < 0)
                {
                alert("Please select an Agency");
                theForm.agencyName.focus();
                return (false);
                }
            
                // check if the first drop down is selected, if so, invalid selection
                if (theForm.agencyName.selectedIndex == 0)
                {
                alert("Please select an Agency");
                theForm.agencyName.focus();
                return (false);
                }
            
            
                if (theForm.level < 0)
                {
                alert("Please select a Group");
                theForm.group.focus();
                return (false);
                } */

            // check if the first drop down is selected, if so, invalid selection
            if (theForm.level.value == "Select-Level") {
                alert("Please select a Group");
                theForm.level.focus();
                return (false);
            }



        }

    </script>

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
                                        <a href="${pageContext.servletContext.contextPath}/users/list">User
                                            List</a>
                                        <i class="fa fa-circle"></i>
                                    </li>
                                    <li>
                                        <span>Add User</span>
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
                                                        <span class="caption-subject font-dark bold uppercase">Add
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

                                                        <form action="AddUser"
                                                            method="post" onsubmit="return Form1_Validator(this)"
                                                            name="Form1">
                                                            <div class="form-body"
                                                                style="background-color: rgba(255, 255, 255, 0.8); padding-left: 5px;">
                                                                <div class="form-group">
                                                                    ${Error}
                                                                    <label
                                                                        class="col-md-5 col-sm-5 control-label sbold">
                                                                        <span class="item-status">Username<i
                                                                                class="fa fa-user font-red-sunglo"
                                                                                aria-hidden="true"
                                                                                style="margin-left:10px;"></i></span>
                                                                    </label>
                                                                    <div class="col-md-7 col-sm-7 ">
                                                                        <div class="input-medium"><input type="text"
                                                                                name="userName" size="15"></div>
                                                                    </div>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label
                                                                        class="col-md-5 col-sm-5  control-label sbold">
                                                                        <span class="item-status">Full Name<i
                                                                                class="fa fa-male font-red-sunglo"
                                                                                aria-hidden="true"
                                                                                style="margin-left:10px;"></i></span></label>
                                                                    <div class="col-md-7 col-sm-7">
                                                                        <div class="input-medium"><input type="text"
                                                                                name="fullName" size="15"></div>
                                                                    </div>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label
                                                                        class="col-md-5 col-sm-5 control-label sbold">
                                                                        <span class="item-status">Password<i
                                                                                class="fa fa-unlock-alt font-red-sunglo"
                                                                                aria-hidden="true"
                                                                                style="margin-left:10px;"></i></span></label>
                                                                    <div class="col-md-7 col-sm-7">
                                                                        <div class="input-medium"><input type="password"
                                                                                name="password" size="15"></div>
                                                                    </div>
                                                                </div>

                                                                <div class="form-group">
                                                                    <label
                                                                        class="col-md-5 col-sm-5 control-label sbold">
                                                                        <span class="item-status">Re-enter Password<i
                                                                                class="fa fa-unlock-alt font-red-sunglo"
                                                                                aria-hidden="true"
                                                                                style="margin-left:10px;"></i></span></label>
                                                                    <div class="col-md-7 col-sm-7">
                                                                        <div class="input-medium"><input type="password"
                                                                                name="P2" size="15"></div>
                                                                    </div>
                                                                </div>

                                                                <div class="form-group">
                                                                    <label
                                                                        class="col-md-5 col-sm-5 control-label sbold">
                                                                        <span class="item-status">Email<i
                                                                                class="fa fa-envelope font-red-sunglo"
                                                                                aria-hidden="true"
                                                                                style="margin-left:10px;"></i></span></label>
                                                                    <div class="col-md-7 col-sm-7">
                                                                        <div class="input-medium"><input type="text"
                                                                                name="email" size="15"></div>
                                                                    </div>
                                                                </div>

                                                                <div class="form-group">
                                                                    <label
                                                                        class="col-md-5 col-sm-5 control-label sbold">
                                                                        <span class="item-status">Phone No.<i
                                                                                class="fa fa-phone font-red-sunglo"
                                                                                aria-hidden="true"
                                                                                style="margin-left:10px;"></i></span></label>
                                                                    <div class="col-md-7 col-sm-7">
                                                                        <div class="input-medium"><input name="phone"
                                                                                type="text" id="phone" size="15"></div>
                                                                    </div>
                                                                </div>

                                                                <!-- 		<div class="form-group">
          <label class="col-md-5 col-sm-5 control-label sbold">
          <span class="item-status">Agency<i class="fa fa-building font-red-sunglo" aria-hidden="true" style="margin-left:10px;"></i></span></label>
          <div class="col-md-7 col-sm-7">
          <div class="input-medium"><telus:StringArraySelect container="object" alias="agencyList" name="agencyName"/></div>
			</div>
         </div> -->
                                                                <div class="form-group">
                                                                    <label
                                                                        class="col-md-5 col-sm-5 control-label sbold">
                                                                        <span class="item-status">Group<i
                                                                                class="fa fa-users font-red-sunglo"
                                                                                aria-hidden="true"
                                                                                style="margin-left:10px;"></i></span></label>
                                                                    <div class="col-md-7 col-sm-7">
                                                                        <div class="input-medium">
                                                                            <select name="level" id="level">
                                                                                <option value="Select-Level"
                                                                                    selected="selected"></option>
                                                                                <option value="Guest_User">Guest User
                                                                                </option>
                                                                                <option value="FMS_User">FMS User
                                                                                </option>
                                                                                <option value="Admin_User">Admin User
                                                                                </option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                            </div><!-- END "form-body� -->


                                                            <div class="form-actions">
                                                                <div class="row">
                                                                    <center>
                                                                        <%-- <a class="btn yellow-gold" href="<xw:GetUrl page="Admin" action="DisplayAddUserPage"/>">Reset</a> --%>
                                                                        <input class="btn yellow-gold" name="imageField"
                                                                            type="submit" value="Add User"
                                                                            style="width: auto;">
                                                                    </center>
                                                                </div>
                                                            </div>




                                                        </form>
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
    <!-- BEGIN QUICK NAV -->
    <nav class="quick-nav">
        <a class="quick-nav-trigger" href="#0">
            <span aria-hidden="true"></span>
        </a>
        <ul>
            <li>
                <a href="${pageContext.servletContext.contextPath}/DisplayManageScoreSystemPage" class="active">
                    <span>Performance Based Scoring</span>
                    <i class="icon-graph"></i>
                </a>
            </li>
            <li>
                <a href="${pageContext.servletContext.contextPath}/FMSViewer/index.html" target="_blank">
                    <span>GIS</span>
                    <i class="icon-map"></i>
                </a>
            </li>
            <li>
                <a href="#">
                    <span>Reports</span>
                    <i class="icon-user"></i>
                </a>
            </li>
            <li>
                <a href="${pageContext.servletContext.contextPath}/DisplayUsersListPage">
                    <span>Manage User Accounts</span>
                    <i class="icon-users"></i>
                </a>
            </li>
            <li>
                <a href="#">
                    <span>Score Management</span>
                    <i class="icon-graph"></i>
                </a>
            </li>
        </ul>
        <span aria-hidden="true" class="quick-nav-bg"></span>
    </nav>
    <div class="quick-nav-overlay"></div>
    <!-- END QUICK NAV -->
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
    <script src="../assets/global/scripts/app.min.js" type="text/javascript"></script>
    <!-- END THEME GLOBAL SCRIPTS -->
    <!-- BEGIN THEME LAYOUT SCRIPTS -->
    <script src="../assets/layouts/layout3/scripts/layout.min.js" type="text/javascript"></script>
    <script src="../assets/layouts/layout3/scripts/demo.min.js" type="text/javascript"></script>
    <script src="../assets/layouts/global/scripts/quick-sidebar.min.js" type="text/javascript"></script>
    <script src="../assets/layouts/global/scripts/quick-nav.min.js" type="text/javascript"></script>
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