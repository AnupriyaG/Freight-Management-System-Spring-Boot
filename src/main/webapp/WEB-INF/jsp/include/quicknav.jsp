
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<div id="menu" v-cloak>
    
        <v-menu  attach  dark allow-overflow offset-y bottom left transition="slide-x-transition" close-on-click>
        <template v-slot:activator="{ on }">
            <v-btn color="warning" dark v-on="on" fab>
                <i class="fas fa-bars"></i>
            </v-btn>
        </template>
        <v-card>
            
            <div class="menu-items">
                <div class="menu-item">
                    <a href="${pageContext.servletContext.contextPath}/performanceBasedScoring" class="active">
                        <span>Performance Based Scoring</span>
                        <v-btn dark>
                            <i class="fa fa-bar-chart"></i>
                        </v-btn>
                    </a>
                </div>
                <div class="menu-item">
                    <a href="${pageContext.servletContext.contextPath}/ScoreManagement">
                        <span>Score Management</span>
                        <v-btn dark>
                            <i class="fa fa-cogs"></i>
                        </v-btn>
                    </a>
                </div>
                <div class="menu-item">
                    <a href="${pageContext.servletContext.contextPath}/gis/" target="_blank">
                        <span>GIS</span>
                        <v-btn dark>
                            <i class="fa fa-globe"></i>
                        </v-btn>
                    </a>
                </div>
                <div class="menu-item">
                    <a href="${pageContext.servletContext.contextPath}/DisplaySearchResultsPage">
                        <span>Reports</span>
                        <v-btn dark>
                            <i class="fa fa-book"></i>
                        </v-btn>
                    </a>
                </div>
                <div class="menu-item">
                    <a href="${pageContext.servletContext.contextPath}/dashboard">
                        <span>Dashboard</span>
                        <v-btn dark>
                            <i class="fa fa-tachometer"></i>
                        </v-btn>
                    </a>
                </div>
                <sec:authorize access="hasAuthority('telus_agency_admin_grp')">
                    <div class="menu-item">
                        <a href="${pageContext.servletContext.contextPath}/users/list">
                            <span>Manage User Accounts</span>
                            <v-btn dark>
                                <i class="fa fa-user"></i>
                            </v-btn>
                        </a>
                    </div>
                </sec:authorize>
                <sec:authorize access="hasAuthority('telus_user_grp')">
                    <div class="menu-item">
                        <a href=${pageContext.servletContext.contextPath}/users/view?username="+uname+">
                            <span>Manage User Accounts</span>
                            <v-btn dark>
                                <i class="fa fa-user"></i>
                            </v-btn>
                        </a>
                    </div>
                </sec:authorize>
            </div>
        </v-card>
       
    
</div>
