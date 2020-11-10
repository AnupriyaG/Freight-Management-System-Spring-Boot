<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>NJDOT FMS | Modify User</title>
    <jsp:include page="../include/head_common.jsp" />

    <!-- BEGIN PAGE LEVEL PLUGINS -->
    <link href="../assets/global/plugins/datatables/datatables.min.css" rel="stylesheet" type="text/css" />
    <link href="../assets/global/plugins/datatables/plugins/bootstrap/datatables.bootstrap.css" rel="stylesheet"
        type="text/css" />
    <!-- END PAGE LEVEL PLUGINS -->
    
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
                                    <c:choose>
                                        <c:when test="${Role eq 'telus_agency_admin_grp'}">
                                            <li>
                                                <a
                                                    href="${pageContext.servletContext.contextPath}/DisplayUsersListPage">User
                                                    List</a>
                                                <i class="fa fa-circle"></i>
                                            </li>
                                        </c:when>
                                    </c:choose>
                                    <li>
                                        <a href="#">User Details</a>
                                        <i class="fa fa-circle"></i>
                                    </li>
                                    <li>
                                        <span>Modify User</span>
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
                                                        <span class="caption-subject font-dark bold uppercase">Modify
                                                            User</span>
                                                    </div>
                                                    <div class="actions">
                                                        <a class="btn dark btn-circle btn-sm"
                                                            href="${pageContext.servletContext.contextPath}/users/view?username=${username}">
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
                                                        <form
                                                            action="${pageContext.servletContext.contextPath}/ModifyUser"
                                                            method="post" onsubmit="return Form1_Validator(this)"
                                                            name="Form1">
                                                            <div class="form-body"
                                                                style="background-color: rgba(255, 255, 255, 0.8); padding-left: 5px;box-shadow: 0 0 5px #888;">
                                                                <div class="form-group">
                                                                    <label
                                                                        class="col-md-5 col-sm-5 control-label sbold">
                                                                        <span class="item-status">Username<i
                                                                                class="fa fa-user font-red-sunglo"
                                                                                aria-hidden="true"
                                                                                style="margin-left:10px;"></i></span>
                                                                    </label>
                                                                    <div class="col-md-7 col-sm-7 ">
                                                                        <div class="input-medium"><input type="text"
                                                                                name="userName" value="${username}">
                                                                        </div>
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
                                                                                name="fullName" value="${fullname}">
                                                                        </div>
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
                                                                                name="password" value="${password}">
                                                                        </div>
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
                                                                                name="P2" value="${password}"></div>
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
                                                                                name="email" value="${email}"></div>
                                                                    </div>
                                                                </div>
                                                                <c:choose>
                                                                    <c:when test="${Role eq 'telus_agency_admin_grp'}">
                                                                        <div class="form-group">
                                                                            <label
                                                                                class="col-md-5 col-sm-5 control-label sbold">
                                                                                <span class="item-status">Agency<i
                                                                                        class="fa fa-building font-red-sunglo"
                                                                                        aria-hidden="true"
                                                                                        style="margin-left:10px;"></i></span></label>
                                                                            <div class="col-md-7 col-sm-7">
                                                                                <div class="input-medium"><input
                                                                                        type=text name="agencyName"
                                                                                        value="${agency}"></div>
                                                                            </div>
                                                                        </div>
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
                                                                                            selected="selected">${group}
                                                                                        </option>
                                                                                        <option value="Guest_User">Guest
                                                                                            User</option>
                                                                                        <option value="FMS_User">FMS
                                                                                            User</option>
                                                                                        <option value="Admin_User">Admin
                                                                                            User</option>
                                                                                    </select>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <input type="hidden" name="level"
                                                                            value="${group}" />
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div><!-- END "form-body� -->


                                                            <div class="form-actions">
                                                                <div class="row">
                                                                    <center>
                                                                        <input class="btn yellow-gold" name="imageField"
                                                                            type="submit" value="Modify User"
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



    </script>
</body>

</html>