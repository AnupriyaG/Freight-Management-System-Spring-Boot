<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>NJDOT FMS | Home</title>
    <jsp:include page="include/head_common.jsp" />
    <!-- Sonhlab Style -->
    <link rel="stylesheet" href="css/Metro/sonhlab-base.css" type="text/css" />
    <!-- Style For OneMenu -->
    <link rel="stylesheet" href="css/Metro/onemenu.css" type="text/css" />
    <style>
        .om-showitem i, .om-showitem span {
            color: rgba(255,255,255,0.6) ;
        }
    </style>
</head>

<body class="page-container-bg-solid page-md">

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
                            <!-- BEGIN TOP NAVIGATION MENU -->
                            <div class="top-menu">
                                <ul class="nav navbar-nav pull-right">
                                    <sec:authorize access="!isAuthenticated()">
                                        <li>
                                            <a href="${pageContext.servletContext.contextPath}/FMSViewer/help/help.html"
                                                target="_blank">
                                                <i class="fa fa-question"></i>HELP
                                            </a>
                                        </li>
                                    </sec:authorize>
                                    <li class="droddown dropdown-separator">
                                        <span class="separator"></span>
                                    </li>
                                    <li>
                                        <a href="javascript:;">
                                            <span class="username _username-hide-mobile">
                                                <sec:authorize access="isAuthenticated()">
                                                    <sec:authentication property="name" />
                                                </sec:authorize>
                                            </span>
                                        </a>
                                    </li>
                                    <!-- BEGIN QUICK SIDEBAR TOGGLER -->
                                    <li>
                                        <a href="${pageContext.servletContext.contextPath}/logout">
                                            <i class="fas fa-sign-out-alt fa-lg"></i>Log out
                                        </a>
                                    </li>
                                    <!-- END QUICK SIDEBAR TOGGLER -->
                                </ul>
                            </div>
                            <!-- END TOP NAVIGATION MENU -->
                        </div>
                    </div>
                    <!-- END HEADER TOP -->
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
                        <div class="clear"></div>
                        <sec:authorize access="hasAuthority('telus_user_grp')">
                            <nav id="om-nav" class="om-nav img-trans">
                                <!-- Control Bar -->
                                <div class="om-ctrlbar">
                                    <div class="om-controlitems">
                                        <div class="om-ctrlitems light-text" style="display: none;">
                                            <div class="om-centerblock">
                                                <div class="om-ctrlitem" data-groupid="group1">
                                                    <i class="fa fa-home"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- End Control Bar -->
                                <!-- Item Holder -->
                                <div class="om-itemholder">
                                    <!-- Item List -->
                                    <div class="om-itemlist">
                                        <div class="tile-bt-extralarge solid-green om-item" data-group="group1">
                                            <a href="${pageContext.servletContext.contextPath}/performanceBasedScoring">
                                                <i class="fa fa-bar-chart fa-3x" aria-hidden="true"></i>
                                                <span class="light-text">Performance Based Scoring</span>
                                            </a>
                                        </div>
                                        <div class="tile-bt-extralarge solid-orange om-item" data-group="group1">
                                            <a href="${pageContext.servletContext.contextPath}/DisplaySearchResultsPage">
                                                <i class="fa fa-book fa-3x" aria-hidden="true"></i>
                                                <span class="light-text">Reports</span>
                                            </a>
                                        </div>
                                        <div class="tile-bt-extralarge solid-slate om-item" data-group="group1">
                                            <a href="${pageContext.servletContext.contextPath}/dashboard">
                                                <i class="fas fa-tachometer-alt fa-3x" aria-hidden="true"></i>
                                                <span class="light-text">Dashboard</span>
                                            </a>
                                        </div>
                                        <div class="tile-bt-extralarge solid-red om-item" data-group="group1">
                                            <a href="${pageContext.servletContext.contextPath}/gis/" target="blank">
                                                <i class="fa fa-globe fa-3x" aria-hidden="true"></i>
                                                <span class="light-text">GIS</span>
                                            </a>
                                        </div>
                                        <div class="tile-bt-extralarge solid-brown om-item" data-group="group1">
                                            <a href="${pageContext.servletContext.contextPath}/ViewUser?username=${uname}">
                                                <i class="fa fa-user fa-3x" aria-hidden="true"></i>
                                                <span class="light-text">Manage User Accounts </span>
                                            </a>
                                        </div>
                                        <div class="clearspace"></div>
                                    </div>
                                    <!-- End Item List -->
                                </div>
                                <!-- End Item Holder -->
                            </nav>
                            <!-- END NAV -->
                        </sec:authorize>
                        <sec:authorize access="hasAuthority('telus_guest_grp')">
                            <nav id="om-nav" class="om-nav img-trans">
                                <!-- Control Bar -->
                                <div class="om-ctrlbar">
                                    <div class="om-controlitems">
                                        <div class="om-ctrlitems light-text" style="display: none;">
                                            <div class="om-centerblock">
                                                <div class="om-ctrlitem" data-groupid="group1">
                                                    <i class="fa fa-home"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- End Control Bar -->
                                <!-- Item Holder -->
                                <div class="om-itemholder">
                                    <!-- Item List -->
                                    <div class="om-itemlist">
                                        <div class="tile-bt-extralarge solid-green om-item" data-group="group1">
                                            <a href="${pageContext.servletContext.contextPath}/performanceBasedScoring">
                                                <i class="fa fa-bar-chart fa-3x" aria-hidden="true"></i>
                                                <span class="light-text">Performance Based Scoring</span>
                                            </a>
                                        </div>
                                        <div class="tile-bt-extralarge solid-orange om-item" data-group="group1">
                                            <!--a href="<xw:GetUrl page="ProjectSelection" action="DisplaySearchResultsPage"/>"-->
                                            <a href="${pageContext.servletContext.contextPath}/DisplaySearchResultsPage">
                                                <i class="fa fa-book fa-3x" aria-hidden="true"></i>
                                                <span class="light-text">Reports</span>
                                            </a>
                                        </div>
                                        <div class="tile-bt-extralarge solid-slate om-item" data-group="group1">
                                            <a href="${pageContext.servletContext.contextPath}/dashboard">
                                                <i class="fas fa-tachometer-alt fa-3x" aria-hidden="true"></i>
                                                <span class="light-text">Dashboard
                                                </span>
                                            </a>
                                        </div>
                                        <div class="tile-bt-extralarge solid-red om-item" data-group="group1">
                                            <a href="${pageContext.servletContext.contextPath}/gis/" target="blank">
                                                <i class="fa fa-globe fa-3x" aria-hidden="true"></i>
                                                <span class="light-text">GIS</span>
                                            </a>
                                        </div>
                                        <div class="clearspace"></div>
                                    </div>
                                    <!-- End Item List -->
                                </div>
                                <!-- End Item Holder -->
                            </nav>
                            <!-- END NAV -->
                        </sec:authorize>
                        <sec:authorize access="hasAuthority('telus_agency_admin_grp')">
                            <telus:IF>
                                <telus:CONDITION container="object" alias="profile" attribute="groupname"
                                    key="userGroup" toCompare="telus_state_admin_grp,telus_agency_admin_grp" />
                                <telus:THEN>
                                    <nav id="om-nav" class="om-nav img-trans">
                                        <!-- Control Bar -->
                                        <div class="om-ctrlbar">
                                            <div class="om-controlitems">
                                                <div class="om-ctrlitems light-text" style="display: none;">
                                                    <div class="om-centerblock">
                                                        <div class="om-ctrlitem" data-groupid="group1">
                                                            <i class="fa fa-home"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- End Control Bar -->
                                        <!-- Item Holder -->
                                        <div class="om-itemholder">
                                            <!-- Item List -->
                                            <div class="om-itemlist">
                                                <div class="tile-bt-extralarge solid-green om-item" data-group="group1">
                                                    <a href="${pageContext.servletContext.contextPath}/performanceBasedScoring">
                                                        <i class="fa fa-bar-chart fa-3x" aria-hidden="true"></i>
                                                        <span class="light-text">Performance Based Scoring</span>
                                                    </a>
                                                </div>
                                                <div class="tile-bt-extralarge solid-blue om-item" data-group="group1">
                                                    <!--a href="<xw:GetUrl page="ScenarioAdmin" action="LoadGDH"/>"-->
                                                    <a href="${pageContext.servletContext.contextPath}/ScoreManagement">
                                                        <i class="fa fa-cogs fa-3x" aria-hidden="true"></i>
                                                        <span class="light-text">Score Management</span>
                                                    </a>
                                                </div>
                                                <div class="tile-bt-extralarge solid-orange om-item" data-group="group1">
                                                    <!--a href="<xw:GetUrl page="ProjectSelection" action="DisplaySearchResultsPage"/>"-->
                                                    <a href="${pageContext.servletContext.contextPath}/DisplaySearchResultsPage">
                                                        <i class="fa fa-book fa-3x" aria-hidden="true"></i>
                                                        <span class="light-text">Reports</span>
                                                    </a>
                                                </div>
                                                <div class="tile-bt-extralarge solid-slate om-item" data-group="group1">
                                                    <a href="${pageContext.servletContext.contextPath}/dashboard">
                                                        <i class="fas fa-tachometer-alt fa-3x" aria-hidden="true"></i>
                                                        <span class="light-text">Dashboard </span>
                                                    </a>
                                                </div>
                                                <div class="tile-bt-extralarge solid-red om-item" data-group="group1">
                                                    <a href="${pageContext.servletContext.contextPath}/gis/" target="blank">
                                                        <i class="fa fa-globe fa-3x" aria-hidden="true"></i>
                                                        <span class="light-text">GIS</span>
                                                    </a>
                                                </div>
                                                <div class="tile-bt-extralarge solid-brown om-item" data-group="group1">
                                                    <a href="${pageContext.servletContext.contextPath}/users/list">
                                                        <i class="fa fa-user fa-3x" aria-hidden="true"></i>
                                                        <span class="light-text">Manage User Accounts</span>
                                                    </a>
                                                </div>
                                                <div class="clearspace"></div>
                                            </div>
                                            <!-- End Item List -->
                                        </div>
                                        <!-- End Item Holder -->
                                    </nav>
                                    <!-- END NAV -->
                                </telus:THEN>
                            </telus:IF>
                        </sec:authorize>
                        <!--============================================================-->
                    </div>
                    <!-- END CONTENT -->
                </div>
                <!-- END CONTAINER -->
            </div>
        </div>
        <jsp:include page="include/footer_common.jsp" />
    </div>

    <!-- Masonry Plugin -->
    <script type="text/javascript" src="js/Metro/masonry/masonry.min.js"></script>

    <!-- MoreMenu -->
    <script type="text/javascript" src="js/Metro/onemenu.min.js"></script>


    <!-- Call OneMenu -->
    <script type="text/javascript">
        $(window).load(function () {

            $('body').onemenu({
                autoshow: 'om-nav',
                openstyle: 'pushdown',
                ctrlalign: 'right',
                closemenu: 'hide',
                _submenu: 'hide',
                animEffect: 'slide'
            });
            $(".om-itemholder").css("width", "100%");
        });
    </script>
</body>

</html>