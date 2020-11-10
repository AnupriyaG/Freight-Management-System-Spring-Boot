<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>NJDOT FMS | List Users</title>
    <jsp:include page="../include/head_common.jsp" />
    <!-- BEGIN PAGE LEVEL PLUGINS -->
    <link href="../assets/global/plugins/datatables/datatables.min.css" rel="stylesheet" type="text/css" />
    <link href="../assets/global/plugins/datatables/plugins/bootstrap/datatables.bootstrap.css" rel="stylesheet"
        type="text/css" />
    <!-- END PAGE LEVEL PLUGINS -->
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
                                        <span>User List</span>
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
                                                            List</span>
                                                    </div>
                                                    <div class="actions">
                                                        <a class="btn dark btn-circle btn-sm"
                                                            href="${pageContext.servletContext.contextPath}/DisplayAdminMainPage">
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

                                                        <table class="table_b table-bordered table-hover table-striped"
                                                            id="table_1">
                                                            <thead>
                                                                <tr>
                                                                    <th style="background-color:#999999;">
                                                                        <font color="#FFFFFF"><strong>User Name</strong>
                                                                        </font>
                                                                    </th>
                                                                    <th style="background-color:#999999;">
                                                                        <font color="#FFFFFF"><strong>Full Name</strong>
                                                                        </font>
                                                                    </th>
                                                                    <th style="background-color:#999999;">
                                                                        <font color="#FFFFFF"><strong>Agency</strong>
                                                                        </font>
                                                                    </th>
                                                                    <th
                                                                        style="background-color:#999999; text-align: center">
                                                                        <font color="#FFFFFF"><strong>Actions</strong>
                                                                        </font>
                                                                    </th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach items="${users}" var="user">
                                                                    <tr>
                                                                        <td>${user.getLoginid()}</td>
                                                                        <td>${user.getFullname()}</td>
                                                                        <td>${user.getGroupid()}</td>
                                                                        <td align="center">
                                                                            <a 
                                                                                href="view?username=${user.getLoginid()}"><span
                                                                                    class="btn yellow-gold btn-outline btn-xs">View</span>
                                                                            </a>
                                                                            <a
                                                                                href="delete?username=${user.getLoginid()}&fullname=${user.getFullname()}"><span
                                                                                    class="btn red btn-outline btn-xs">Delete</span>
                                                                            </a>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                                <!--tr>
					   <td colspan="4" align="center">&nbsp;</td>
											</tr-->
                                                            </tbody>
                                                        </table>
                                                        <div class="form-actions">
                                                            <center><a href="add"><button
                                                                        class="btn yellow-gold" type="button">Add
                                                                        User</button></a></center>
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

        $('#table_1').dataTable({

            responsive: true,
            "bPaginate": false,
            "sDom": '<"col-md-12 col-sm-12 col-xs-12"frt>',
            "columnDefs": [
                { "orderable": false, "targets": 3 },
            ],

        });

    </script>
</body>

</html>