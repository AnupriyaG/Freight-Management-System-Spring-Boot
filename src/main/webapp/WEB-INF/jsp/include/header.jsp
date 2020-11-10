<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<style>
	.multiselect__option--selected.multiselect__option--highlight {
		background-color: black !important;
	}
	a {
  	color:orange;
	}
</style>
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
<script src="https://unpkg.com/vue-multiselect@2.1.0"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.16.1/axios.min.js"></script>
<script src="https://unpkg.com/vuetable-2@1.6.0"></script>
<script src="https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.js"></script>
<script src="https://unpkg.com/vue@2.4.2"></script>
<script src="${pageContext.servletContext.contextPath}/js/quick_nav.js"></script>
<div class="page-wrapper-row">
	<div class="page-wrapper-top">
		<!-- BEGIN HEADER -->
		<div class="page-header">
			<!-- BEGIN HEADER TOP -->
			<div class="page-header-top">
				<div class="container-fluid">
					<!-- BEGIN LOGO -->
					<div class="page-logo">
						<a href="${pageContext.servletContext.contextPath}/"><img
								src="${pageContext.servletContext.contextPath}/assets/layouts/layout3/img/titleTELUS.png" alt="logo" class="logo-default"
								style="max-width: 95%;"></a>
					</div>
					<!-- END LOGO -->
					<!-- BEGIN TOP NAVIGATION MENU -->
					<div class="top-menu" >
						<ul class="nav navbar-nav pull-right">
							<!-- <li><a href="${pageContext.servletContext.contextPath}/">
									<i class="fa fa-home"></i>&nbsp;HOME
								</a></li>
							<li><a href="${pageContext.servletContext.contextPath}/gis/" target="_blank">
									<i class="fa fa-globe"></i>&nbsp;GIS
								</a></li> -->
							<li>
								<!-- <div id="menu">
									<v-app>
										<v-menu open-on-hover attach close-on-click dark allow-overflow>
										<template v-slot:activator="{ on }">
										  <v-btn
										  class="btn -btn-xs yellow-gold "
											dark
											v-on="on"
										  >
										  <i class="fas fa-bars"></i>
										  </v-btn>
										</template>
										<v-card width= 300 color="white" elevation="8">
											<ul >
												<li>
													<a href="${pageContext.servletContext.contextPath}/performanceBasedScoring" class="active">
														<i class="fa fa-bar-chart"></i>
														<span>Performance Based Scoring</span>
													</a>
												</li>
												<li>
													<a href="#">
														<i class="fa fa-cogs"></i>
														<span>Score Management</span>
													</a>
												</li>
												<li>
													<a href="${pageContext.servletContext.contextPath}/gis/" target="_blank">
														<i class="fa fa-globe"></i>
														<span>GIS</span>
													</a>
												</li>
												<li>
													<a href="${pageContext.servletContext.contextPath}/DisplaySearchResultsPage">
														<i class="fa fa-book"></i>
														<span>Reports</span>
													</a>
												</li>
												
												
												<li>
													<a href="${pageContext.servletContext.contextPath}/dashboard">
														<i class="fa fa-tachometer"></i>
														<span>Dashboard</span>
													</a>
												</li>
												<sec:authorize access="hasAuthority('telus_agency_admin_grp')">
												<li>
													<a href="${pageContext.servletContext.contextPath}/users/list">
														<i class="fa fa-user"></i>
														<span>Manage User Accounts</span>
													</a>
												</li>
												</sec:authorize>
												<sec:authorize access="hasAuthority('telus_user_grp')">
													<li>
													<a href=${pageContext.servletContext.contextPath}/users/view?username="+uname+">
												
													<i class=\"fa fa-user\"></i>
													<span>Manage User Accounts</span>
													</a></li>
												</sec:authorize>
											</ul>
										</v-card>	
									</v-app>
								</div> -->
							</li>
							<sec:authorize access="!isAuthenticated()">
								<li><a href="${pageContext.servletContext.contextPath}/FMSViewer/help/help.html"
										target="_blank"> <i class="fa fa-question"></i>&nbsp;HELP

									</a></li>
							</sec:authorize>

							<li class="droddown dropdown-separator"><span class="separator"></span></li>
							<li><a href="javascript:;"> <span class="username _username-hide-mobile">
										<sec:authorize access="isAuthenticated()">
											<sec:authentication property="name" />
										</sec:authorize>
									</span>
								</a></li>
							<!-- BEGIN QUICK SIDEBAR TOGGLER -->
							<li id="logoutBtn"><a href="${pageContext.servletContext.contextPath}/logout">
									<i class="fas fa-sign-out-alt fa-lg"></i>&nbsp;Log out
								</a></li>
							<!-- END QUICK SIDEBAR TOGGLER -->
						</ul>
					</div>

					<!-- END TOP NAVIGATION MENU -->

				</div>
			</div>
			<!-- END HEADER TOP -->

			<!-- BEGIN HEADER MENU -->
			<div class="page-header-menu">
				<!-- no head menu display-->
			</div>
			<!-- END HEADER MENU -->
		</div>
		<!-- END HEADER -->
	</div>
</div>