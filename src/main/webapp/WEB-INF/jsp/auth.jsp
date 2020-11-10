<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>

    <title>NJDOT FMS | Login</title>
    <jsp:include page="include/head_common.jsp" />
    
    <!-- BEGIN PAGE LEVEL STYLES -->
    <link href="assets/pages/css/login-4.min.css" rel="stylesheet" type="text/css" />
    <!-- END PAGE LEVEL STYLES -->
    <link href="css/ghost-buttons.css" rel="stylesheet" type="text/css" />

    <script language="JavaScript" src="js/rollover.js"></script>
    <script language="JavaScript" src="js/footer.js"></script>

    <style>
        .login ._page-content-wrapper {
            background-color: transparent;
        }

        /** On a phone (portrait or landscape), the username and password fields should take up all the space **/
        @media (max-width: 768px) {
            .login .content {
                margin: 0px;
                width: 100%;
            }

            .login ._page-content-wrapper {
                padding-top: 0px;
            }
        }

        /** On larger screens we shrink the login box force the footer to the bottom of the page **/
        @media (min-width: 768px) and (min-height:500px) {
            .login ._page-content-wrapper {
                padding-top: 150px;
            }

            .footer {
                position: fixed;
                left: 0px;
                right: 0px;
                bottom: 0px;
            }
        }
    </style>
</head>
<!-- END HEAD -->

<body class="page-container-bg-solid page-md login">
    <div class="page-wrapper">
        <div class="page-wrapper-row">
            <div class="page-wrapper-top">
                <!-- BEGIN HEADER -->
                <div class="page-header">
                    <!-- BEGIN HEADER TOP -->
                    <div class="page-header-top">
                        <div class="container-fluid">
                            <!-- BEGIN LOGO -->
                            <div class="page-logo">
                                <img src="assets/layouts/layout3/img/titleTELUS.png" alt="logo" class="logo-default"
                                    style="max-width: 95%;">
                            </div>
                            <!-- END LOGO -->
                        </div>
                    </div>
                    <!-- END HEADER TOP -->


                    <!-- BEGIN HEADER MENU -->
                    <div class="page-header-menu">
                        <!-- no head menu display-->
                    </div>
                    <!-- END HEADER MENU -->


                    <!-- BEGIN HEADER MENU -->

                    <!-- END HEADER MENU -->
                </div>
                <!-- END HEADER -->
            </div>
        </div>

        <div class="page-wrapper-row full-height">
            <div class="page-wrapper-middle">
                <!-- BEGIN CONTAINER -->
                <div class="page-container">
                    <!-- BEGIN CONTENT -->
                    <div class="page-content-wrapper">
                        <!-- BEGIN CONTENT BODY -->
                        <row>
                            <div class="col-lg-offset-2 col-lg-4 col-md-offset-2 col-md-4 col-sm-12 col-xs-12">
                                <!-- BEGIN LOGIN -->
                                <div class="content">
                                    <!-- BEGIN LOGIN FORM -->
                                    <center><img src="images/logo_multimodal.png"></center>
                                    <br>
                                    <form class="login-form" method="post">
                                        <!--h3 class="form-title">Login to your account</h3-->
                                        <div class="alert alert-danger display-hide">
                                            <button class="close" data-close="alert"></button>
                                            <span> Enter any username and password. </span>
                                        </div>
                                        <c:if test="${param.error ne null}">
                                            <div style="color: red">Invalid credentials.</div>
                                        </c:if>
                                        <c:if test="${param.expired ne null}">
                                            <div class="alert alert-danger">Your session has expired. Please login again to continue.</div>
                                        </c:if>
                                        <div class="form-group">
                                            <!--ie8, ie9 does not support html5 placeholder, so we just show field title for that-->
                                            <label class="control-label visible-ie8 visible-ie9">Username</label>
                                            <div class="input-icon">
                                                <i class="fa fa-user"></i>
                                                <input class="form-control placeholder-no-fix" type="text"
                                                    autocomplete="off" placeholder="Username" name="username" /> </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="control-label visible-ie8 visible-ie9">Password</label>
                                            <div class="input-icon">
                                                <i class="fa fa-lock"></i>
                                                <input class="form-control placeholder-no-fix" type="password"
                                                    autocomplete="off" value="" placeholder="Password"
                                                    name="password" /> </div>
                                        </div>
                                        <div class="form-actions">
                                            <!--label class="rememberme mt-checkbox mt-checkbox-outline">
                        <input type="checkbox" name="remember" value="1" /> Remember me
                        <span></span>
                    </label-->
                                            <button type="submit" class="btn yellow-gold pull-right"> Login </button>
                                        </div>
                                        <div style="margin-top: 50px; margin-bottom: 30px;">
                                            <a class="btn ghost-button-semi-transparent-orange" href="arcgis/"
                                                target="blank">Click here to login as Guest</a>
                                        </div>

                                    </form>
                                    <!-- END LOGIN FORM -->
                                </div>
                                <!-- END LOGIN -->
                            </div>
                        </row>
                        <!-- END FOOTER -->
                    </div>
                    <!-- END CONTENT -->
                </div>
                <!-- END CONTAINER -->
            </div>
        </div>

        <div class="page-wrapper-row" style="width:100%">
            <div class="page-wrapper-bottom">
                <!-- BEGIN FOOTER -->
                <!-- BEGIN PRE-FOOTER -->
                <div class="page-prefooter">
                    <div class="container-fluid">


                        <div class="row">

                            <center class="footer-inner">

                                <jsp:include page="include/logoFooter.jsp" />

                            </center>
                        </div>
                    </div>
                </div>
                <!-- END PRE-FOOTER -->
                <!-- BEGIN INNER FOOTER -->
                <div class="scroll-to-top">
                    <i class="icon-arrow-up"></i>
                </div>
                <!-- END INNER FOOTER -->
                <!-- END FOOTER -->
            </div>
        </div>
    </div>
    <!--============================================================-->
    <!--[if lt IE 9]>
<script src="/FMS/assets/global/plugins/respond.min.js"></script>
<script src="/FMS/assets/global/plugins/excanvas.min.js"></script> 
<script src="/FMS/assets/global/plugins/ie8.fix.min.js"></script> 
<![endif]-->
</body>

</html>