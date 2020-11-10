<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>NJDOT FMS | View Users</title>
    <jsp:include page="../include/head_common.jsp" />
    <!-- BEGIN PAGE LEVEL PLUGINS -->
    <link href="../assets/global/plugins/datatables/datatables.min.css" rel="stylesheet" type="text/css" />
    <link href="../assets/global/plugins/datatables/plugins/bootstrap/datatables.bootstrap.css" rel="stylesheet"
        type="text/css" />
    <!-- END PAGE LEVEL PLUGINS -->
    


    <%

 String[] pageNames={"TELUSHome","TELUSHome","Admin", "Admin"};
 String[] actions={"DisplayHomePage","DisplayHomePage","DisplayUsersListPage", "DisplayUsersListPage"};
 String[] groups={"telus_user_grp","telus_manager_grp","telus_agency_admin_grp", "telus_state_admin_grp"};

%>
    <script>
        $('#highlight tr').hover(function () {
            $(this).addClass('hover');
        }, function () {
            $(this).removeClass('hover');
        });
    </script>
    <style>
        #highlight tr:hover {
            background-color: #efefef;
        }

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
                                    <c:choose>
                                        <c:when test="${Role eq 'telus_agency_admin_grp'}">
                                            <li>
                                                <a
                                                    href="list">User
                                                    List</a>
                                                <i class="fa fa-circle"></i>
                                            </li>
                                        </c:when>
                                    </c:choose>
                                    <li>
                                        <span>User Details</span>
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
                                                        <span class="caption-subject font-dark bold uppercase">User
                                                            Details</span>
                                                    </div>
                                                    <c:choose>
                                                        <c:when test="${group_logged_in_user eq 'FMS User'}">
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
                                                        </c:when>
                                                    </c:choose>


                                                    <c:choose>
                                                        <c:when test="${group_logged_in_user eq 'Admin User'}">
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
                                                        </c:when>
                                                    </c:choose>

                                                    <c:choose>
                                                        <c:when test="${group_logged_in_user eq 'Guest User'}">
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
                                                        </c:when>
                                                    </c:choose>

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
                                                                <div class="col-md-8 col-sm-8 col-xs-8">${username}
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label
                                                                    class="col-md-4 col-sm-4 col-xs-4 control-label sbold">
                                                                    <span class="item-status">Full Name<i
                                                                            class="fa fa-male font-red-sunglo"
                                                                            aria-hidden="true"
                                                                            style="margin-left:10px;"></i></span></label>
                                                                <div class="col-md-8 col-sm-8 col-xs-8">${fullname}
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label
                                                                    class="col-md-4 col-sm-4 col-xs-4 control-label sbold">
                                                                    <span class="item-status">Email<i
                                                                            class="fa fa-envelope font-red-sunglo"
                                                                            aria-hidden="true"
                                                                            style="margin-left:10px;"></i></span></label>
                                                                <div class="col-md-8 col-sm-8 col-xs-8">${email}</div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label
                                                                    class="col-md-4 col-sm-4 col-xs-4 control-label sbold">
                                                                    <span class="item-status">Agency<i
                                                                            class="fa fa-building font-red-sunglo"
                                                                            aria-hidden="true"
                                                                            style="margin-left:10px;"></i></span></label>
                                                                <div class="col-md-8 col-sm-8 col-xs-8">${agency}</div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label
                                                                    class="col-md-4 col-sm-4 col-xs-4 control-label sbold">
                                                                    <span class="item-status">Group<i
                                                                            class="fa fa-users font-red-sunglo"
                                                                            aria-hidden="true"
                                                                            style="margin-left:10px;"></i></span></label>
                                                                <div class="col-md-8 col-sm-8 col-xs-8">${group}</div>
                                                            </div>
                                                        </div>
                                                        <div class="form-actions">
                                                            <div class="row">
                                                                <center>
                                                                    <a class="btn yellow-gold"
                                                                        href="modify?username=${username}">Modify
                                                                        User</a>
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
    </div>
    <jsp:include page="../include/footer_common.jsp" />
    <jsp:include page="../include/quicknav.jsp" />
    
    <!-- BEGIN PAGE LEVEL PLUGINS -->
    <script src="assets/global/scripts/datatable.js" type="text/javascript"></script>
    <script src="assets/global/plugins/datatables/datatables.min.js" type="text/javascript"></script>
    <script src="assets/global/plugins/datatables/plugins/bootstrap/datatables.bootstrap.js"
        type="text/javascript"></script>
    <!-- END PAGE LEVEL PLUGINS -->
    
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