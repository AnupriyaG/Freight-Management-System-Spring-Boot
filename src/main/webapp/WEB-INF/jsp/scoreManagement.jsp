<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<title>NJDOT FMS | Score Management</title>
	<jsp:include page="include/head_common.jsp" />
	<!-- VUETIFY -->
	<link href="https://cdn.jsdelivr.net/npm/@mdi/font@4.x/css/materialdesignicons.min.css" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.min.css" rel="stylesheet">
	<!-- END VUETIFY -->
</head>
<style>
	.tab button.active {
		background-color: #ccc;
	}

	input.error {
		border-color: red;
		background-color: rgb(255, 167, 167)
	}
</style>

<style>
	.priority_div_wrapper {
		text-align: center;
	}
</style>

<style>
	input[type=text]{
		border: 1px solid #DDDDDD;
	}
	.priority_div2_wrapper {
		text-align: center;
	}
	.v-application, .v-tabs-bar {
		background-color: rgba(0,0,0,0) !important;
	}
	.v-application--wrap {
		min-height: 10px !important;
	}
	#primaryTabs .v-tab {
		    color: #000 !important;

	}
	#primaryTabs .v-tab--active {
		background-color: rgba(255, 255, 255, 0.3);
    border-bottom: none;
    font-weight: bold;
    border: 1px solid #000000;
	}
	#primaryTabs .v-tabs {
		border-bottom: 1px solid black;
	}
	#secondaryTabs .v-tab {
    color: #000000 !important;
		background-color: rgba(102,102,102,0.3)
		}
	#secondaryTabs .v-tab.v-tab--active {
    color: #ffffff !important;
			font-weight: bold;
		background-color: rgba(25,118,210,0.5);
		}
</style>

<script>
	function openCity(evt, cityName) {
		var i, tabcontent, tablinks;
		tabcontent = document.getElementsByClassName("table-responsive");
		for (i = 0; i < tabcontent.length; i++) {
			tabcontent[i].style.display = "none";
		}
		tablinks = document.getElementsByClassName("btn blue-hoki");
		for (i = 0; i < tablinks.length; i++) {
			tablinks[i].className = tablinks[i].className.replace(" active", "");
		}
		document.getElementById(cityName).style.display = "block";
		evt.currentTarget.className += " active";
	}

	function add_rng_row(button_id_add, button_id_add_new) {
		document.getElementById(button_id_add_new).style.display = '';
		document.getElementById(button_id_add).disabled = true;
	}

	function upd_rng_row(existing_row, New_update_row) {
		document.getElementById(New_update_row).style.display = '';
		document.getElementById(existing_row).style.display = 'none';
		document.getElementById(disable_upd_bttn).disabled = true;
	}



	function upd_all_priority_rng_row() {
		document.getElementById('new_acceptable_row').style.display = '';
		document.getElementById('new_low_row').style.display = '';
		document.getElementById('new_medium_row').style.display = '';
		document.getElementById('new_high_row').style.display = '';
		document.getElementById('Acceptable_row').style.display = 'none';
		document.getElementById('Low_row').style.display = 'none';
		document.getElementById('Medium_row').style.display = 'none';
		document.getElementById('High_row').style.display = 'none';
		document.getElementById('priority_first_update').style.display = 'none';
		document.getElementById('priority_second_update').style.display = '';
		document.getElementById(disable_upd_bttn).disabled = true;
	}

	function checkFloat(strValue) {
		var value = parseFloat(strValue);
		var val1;
		if (isNaN(value)) {
			return false;
		}
		else {
			for (var i = 0; i < strValue.length; i++) {
				val1 = strValue.charCodeAt(i);
				if (val1 == 46)
					continue;
				if ((val1 < 48) || (val1 > 57)) {
					return false;
				}
			}
			return true;
		}
	}


	function validateForm(form_name) {
		var x = document.forms[form_name]["start_range"].value;
		var y = document.forms[form_name]["end_range"].value;
		var z = document.forms[form_name]["perc_weight"].value;

		if (x == "") {
			alert("Start_Range must be filled out");
			return false;
		}

		if (y == "") {
			alert("End_Range must be filled out");
			return false;
		}
		if (z == "") {
			alert("Score must be filled out");
			return false;
		}
		if (z < 0 || z > 100) {
			alert("Score must be in the range 0-100");
			return false;
		}
		if (x > 99999) {
			alert("Start range is too high");
			return false;
		}
		if (y > 99999) {
			alert("End range is too high");
			return false;
		}
		if ((checkFloat(x) == false) || (checkFloat(y) == false) || (checkFloat(z) == false)) {
			alert("Only Numeric values must be filled out");
			return false;
		}
	}

	function make_link(id, start_rng, end_rng, score, mode) {

		var ID = id;
		var strt = document.getElementById(start_rng).value;
		var end = document.getElementById(end_rng).value;
		var scr = document.getElementById(score).value;



		if (strt == "") {
			alert("Start_Range must be filled out");
			return false;
		}

		if (end == "") {
			alert("End_Range must be filled out");
			return false;
		}
		if (scr == "") {
			alert("Score must be filled out");
			return false;
		}
		if (scr < 0 || scr > 100) {
			alert("Score must be in the range 0-100");
			return false;
		}
		if (strt > 99999) {
			alert("Start range is too high");
			return false;
		}
		if (end > 99999) {
			alert("End range is too high");
			return false;
		}

		if ((checkFloat(strt) == false) || (checkFloat(end) == false) || (checkFloat(scr) == false)) {
			alert("Only Numeric values must be filled out");
			return false;
		}
		var link = "Update_Range?ID=" + ID + "&start_range=" + strt + "&end_range=" + end + "&perc_weight=" + scr + "&mode=" + mode;
		window.location = link;
		return true;
	}


	function make_scr_rng_link(acp_frm, acp_to, lw_frm, lw_to, med_frm, med_to, high_frm, high_to, mode) {

		var acpt_from = document.getElementById(acp_frm).value;
		var acpt_to = document.getElementById(acp_to).value;
		var low_from = document.getElementById(lw_frm).value;
		var low_to = document.getElementById(lw_to).value;
		var med_from = document.getElementById(med_frm).value;
		var med_to = document.getElementById(med_to).value;
		var high_from = document.getElementById(high_frm).value;
		var high_to = document.getElementById(high_to).value;



		if ((acpt_from == "") || (acpt_to == "") || (low_from == "") || (low_to == "") || (med_from == "") || (med_to == "") || (high_from == "") || (high_to == "")) {
			alert("All Score Ranges must be filled out");
			return false;
		}


		if (acpt_from < 0 || acpt_from > 100 || acpt_to < 0 || acpt_to > 100 || low_from < 0 || low_from > 100 || low_to < 0 || low_to > 100 || med_from < 0 || med_from > 100 || med_to < 0 || med_to > 100 || high_from < 0 || high_from > 100 || high_to < 0 || high_to > 100) {
			alert("Score must be in the range 0-100");
			return false;
		}

		if ((checkFloat(acpt_from) == false) || (checkFloat(acpt_to) == false) || (checkFloat(low_from) == false) || (checkFloat(low_to) == false) || (checkFloat(med_from) == false) || (checkFloat(med_to) == false) || (checkFloat(high_from) == false) || (checkFloat(high_to) == false)) {
			alert("Only Numeric values must be filled out");
			return false;
		}
		var link = "Update_Score_Range?acpt_from=" + acpt_from + "&acpt_to=" + acpt_to + "&low_from=" + low_from + "&low_to=" + low_to + "&medium_from=" + med_from + "&medium_to=" + med_to + "&high_from=" + high_from + "&high_to=" + high_to + "&mode=" + mode;
		window.location = link;
		return true;
	}





	function update_acceptable_rng(acp_frm, acp_to, mode) {
		var acpt_from = document.getElementById(acp_frm).value;
		var acpt_to = document.getElementById(acp_to).value;

		if ((acpt_from == "") || (acpt_to == "")) {
			alert("All Score Ranges must be filled out");
			return false;
		}


		if (acpt_from < 0 || acpt_from > 100 || acpt_to < 0 || acpt_to > 100) {
			alert("Score must be in the range 0-100");
			return false;
		}

		if ((checkFloat(acpt_from) == false) || (checkFloat(acpt_to) == false)) {
			alert("Only Numeric values must be filled out");
			return false;
		}
		var link = "Update_Individual_Priority_Score_Range?from=" + acpt_from + "&to=" + acpt_to + "&priority=Acceptable" + "&mode=" + mode;
		window.location = link;
		return true;
	}

	function update_low_rng(lw_frm, lw_to, mode) {
		var low_from = document.getElementById(lw_frm).value;
		var low_to = document.getElementById(lw_to).value;

		if ((low_from == "") || (low_to == "")) {
			alert("All Score Ranges must be filled out");
			return false;
		}


		if (low_from < 0 || low_from > 100 || low_to < 0 || low_to > 100) {
			alert("Score must be in the range 0-100");
			return false;
		}

		if ((checkFloat(low_from) == false) || (checkFloat(low_to) == false)) {
			alert("Only Numeric values must be filled out");
			return false;
		}
		var link = "Update_Individual_Priority_Score_Range?from=" + low_from + "&to=" + low_to + "&priority=Low" + "&mode=" + mode;
		window.location = link;
		return true;
	}

	function update_medium_rng(med_frm, med_to, mode) {
		var med_from = document.getElementById(med_frm).value;
		var med_to = document.getElementById(med_to).value;


		if ((med_from == "") || (med_to == "")) {
			alert("All Score Ranges must be filled out");
			return false;
		}


		if (med_from < 0 || med_from > 100 || med_to < 0 || med_to > 100) {
			alert("Score must be in the range 0-100");
			return false;
		}

		if ((checkFloat(med_from) == false) || (checkFloat(med_to) == false)) {
			alert("Only Numeric values must be filled out");
			return false;
		}
		var link = "Update_Individual_Priority_Score_Range?from=" + med_from + "&to=" + med_to + "&priority=Medium" + "&mode=" + mode;
		window.location = link;
		return true;
	}

	function update_high_rng(high_frm, high_to, mode) {
		var high_from = document.getElementById(high_frm).value;
		var high_to = document.getElementById(high_to).value;

		if ((high_from == "") || (high_to == "")) {
			alert("All Score Ranges must be filled out");
			return false;
		}


		if (high_from < 0 || high_from > 100 || high_to < 0 || high_to > 100) {
			alert("Score must be in the range 0-100");
			return false;
		}

		if ((checkFloat(high_from) == false) || (checkFloat(high_to) == false)) {
			alert("Only Numeric values must be filled out");
			return false;
		}
		var link = "Update_Individual_Priority_Score_Range?from=" + high_from + "&to=" + high_to + "&priority=High" + "&mode=" + mode;
		window.location = link;
		return true;
	}
</script>

<body class="page-container-bg-solid page-md">
	<div class="page-wrapper">
		<jsp:include page="include/header.jsp" />

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
										<span>Score Management</span>
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
														<span class="caption-subject font-dark bold uppercase">Decision
															Variables and Score Allocation</span>
													</div>
													<div class="actions">
														<a class="btn dark btn-circle btn-sm"
															href="${pageContext.servletContext.contextPath}/DisplayAdminMainPage">
															<i class="fa fa-arrow-left"></i> Back </a>
														<a class="btn btn-circle btn-icon-only btn-default fullscreen"
															href="javascript:;"> </a>
													</div>
												</div>
												<div class="portlet-body form">
													<div id="scoreManagementApp">
														<div class="form-horizontal">
															<div class="form-body">
																<v-app>
																	<v-tabs id="primaryTabs" v-model="primaryTab" fixed-tabs v-on:change="secondaryTab=0">
																		<v-tab>Safety</v-tab>
																		<v-tab>Accessibility</v-tab>
																		<v-tab>Mobility</v-tab>
																		<v-tab>Priority Score Range</v-tab>
																	</v-tabs>
																	<template v-if="primaryTab==3">
																		<table class="table_b table-bordered table-hover">
																			<thead>
																				<tr align="center">
																					<td style="background-color:#999999;">
																						<font color="#FFFFFF">
																							<strong>Priority</strong></font>
																					</td>
																					<td style="background-color:#999999;">
																						<font color="#FFFFFF">
																							<strong>From</strong></font>
																					</td>
																					<td style="background-color:#999999;">
																						<font color="#FFFFFF">
																							<strong>To</strong></font>
																					</td>
																				</tr>
																			</thead>
																			<tbody>
																				<tr>
																					<td>Acceptable</td>
																					<td>
																						<div
																							v-if="priorityScoreRangeEditing">
																							<input type="text"
																								v-bind:class="{ error: priorityScoreRange.acceptableFromError}"
																								v-on:change="validatePriorityScore()"
																								v-on:keyup="validatePriorityScore()"
																								v-model="data['Priority Score Range'][0]['acceptable_Range_From']">
																						</div>
																						<div v-else>
																							{{priorityScoreRange['acceptable_Range_From']}}
																						</div>
																					</td>
																					<td>
																						<div
																							v-if="priorityScoreRangeEditing">
																							<input type="text"
																								v-on:keyup="validatePriorityScore()"
																								v-on:change="validatePriorityScore()"
																								v-bind:class="{ error: priorityScoreRange.acceptableToError}"
																								v-model="data['Priority Score Range'][0]['acceptable_Range_To']">
																						</div>
																						<div v-else>
																							{{priorityScoreRange['acceptable_Range_To']}}
																						</div>
																					</td>
																				</tr>
																				<tr>
																					<td>Low</td>
																					<td>
																						<div
																							v-if="priorityScoreRangeEditing">
																							<input type="text"
																							v-on:keyup="validatePriorityScore()"
																							v-on:change="validatePriorityScore()"
																							v-bind:class="{ error: priorityScoreRange.lowFromError}"
																								v-model="data['Priority Score Range'][0]['low_Range_From']">
																						</div>
																						<div v-else>
																							{{priorityScoreRange['low_Range_From']}}
																						</div>
																					</td>
																					<td>
																						<div
																							v-if="priorityScoreRangeEditing">
																							<input type="text"
																								v-bind:class="{ error: priorityScoreRange.lowToError}"
																								v-on:keyup="validatePriorityScore()"
																								v-on:change="validatePriorityScore()"
																								v-model="data['Priority Score Range'][0]['low_Range_To']">
																						</div>
																						<div v-else>
																							{{priorityScoreRange['low_Range_To']}}
																						</div>
																					</td>
																				</tr>
																				<tr>
																					<td>Medium</td>
																					<td>
																						<div
																							v-if="priorityScoreRangeEditing">
																							<input type="text"
																								v-bind:class="{ error: priorityScoreRange.mediumFromError}"
																								v-on:keyup="validatePriorityScore()"
																								v-on:change="validatePriorityScore()"
																								v-model="data['Priority Score Range'][0]['medium_Range_From']">
																						</div>
																						<div v-else>
																							{{priorityScoreRange['medium_Range_From']}}
																						</div>
																					</td>
																					<td>
																						<div
																							v-if="priorityScoreRangeEditing">
																							<input type="text"
																								v-bind:class="{ error: priorityScoreRange.mediumToError}"
																								v-on:keyup="validatePriorityScore()"
																								v-on:change="validatePriorityScore()"
																								v-model="data['Priority Score Range'][0]['medium_Range_To']">
																						</div>
																						<div v-else>
																							{{priorityScoreRange['medium_Range_To']}}
																						</div>
																					</td>
																				</tr>
																				<tr>
																					<td>High</td>
																					<td>
																						<div
																							v-if="priorityScoreRangeEditing">
																							<input type="text"
																								v-bind:class="{ error: priorityScoreRange.highFromError}"
																								v-on:keyup="validatePriorityScore()"
																								v-on:change="validatePriorityScore()"
																								v-model="data['Priority Score Range'][0]['high_Range_From']">
																						</div>
																						<div v-else>
																							{{priorityScoreRange['high_Range_From']}}
																						</div>
																					</td>
																					<td>
																						<div
																							v-if="priorityScoreRangeEditing">
																							<input type="text"
																								v-bind:class="{ error: priorityScoreRange.highToError}"
																								v-on:keyup="validatePriorityScore()"
																								v-on:change="validatePriorityScore()"
																								v-model="data['Priority Score Range'][0]['high_Range_To']">
																						</div>
																						<div v-else>
																							{{priorityScoreRange['high_Range_To']}}
																						</div>
																					</td>
																				</tr>
																			</tbody>
																		</table>
																		
																		<div class="priority_div_wrapper"
																		>
																		<button align="center" class="btn yellow-gold"
																			v-if="!priorityScoreRangeEditing"
																			v-on:click="startUpdatePriorityScore">Update</button>
																		<button align="center" class="btn yellow-gold"
																			v-if="priorityScoreRangeEditing"
																			v-on:click="priorityScoreRangeEditing = true">Save</button>
																		<button align="center" class="btn yellow-gold"
																			v-if="priorityScoreRangeEditing"
																			v-on:click="priorityScoreRangeEditing = false">Cancel</button>
																	</div>
																	</template>
																	<template v-else>
																		<p>&nbsp;</p>
																		<v-tabs id="secondaryTabs" v-model="secondaryTab" >
																			<v-tab v-for="sTab in tabMap[primaryTab]" :key="sTab">{{sTab}}</v-tab>
																		</v-tabs>
																		<table class="table_b table-bordered table-hover">
																			<thead>
																				<tr align="center">
																					<td width="25%"
																						style="background-color:#999999;">
																						<font color="#FFFFFF"><strong>Start
																								Range</strong></font>
																					</td>
																					<td width="25%"
																						style="background-color:#999999;">
																						<font color="#FFFFFF"><strong>End
																								Range</strong></font>
																					</td>
																					<td width="25%"
																						style="background-color:#999999;">
																						<font color="#FFFFFF">
																							<strong>Percentage of
																								Weight</strong></font>
																					</td>
																					<td width="25%"
																						style="background-color:#999999;">
																						<font color="#FFFFFF">
																							<strong>Action</strong></font>
																					</td>
																				</tr>
																			</thead>
																			<tbody v-if="activeScoreCategory != ''">
																				<tr v-for="score in data[tabMap[primaryTab][secondaryTab]]">
																					<td>
																						<div v-if="!score.editing">{{score.start_range}}</div>
																						<div v-if="score.editing">
																							<input
																								type="text"
																								v-bind:class="{ error: score.startRangeError}"
																								v-on:keyup="validateScore(score)"
																								v-on:change="validateScore(score)"
																								v-model="score.start_range">
																						</div>
																					</td>
																					<td>
																						<div v-if="!score.editing">{{score.end_range}}</div>
																						<div v-if="score.editing">
																							<input
																								type="text"
																								v-bind:class="{ error: score.endRangeError}"
																								v-on:keyup="validateScore(score)"
																								v-on:change="validateScore(score)"
																								v-model="score.end_range">
																						</div>
																					</td>
																					<td>
																						<div v-if="!score.editing">{{score.score}}</div>
																						<div v-if="score.editing">
																							<input
																								type="text"
																								v-bind:class="{ error: score.scoreError}"
																								v-on:keyup="validateScore(score)"
																								v-on:change="validateScore(score)"
																								v-model="score.score">
																						</div>
																					</td>
																					<td>
																						<a class="btn yellow-gold"
																							v-if="!score.editing"
																							v-on:click="startUpdateScore(score)">Update</a>
																						<a class="btn yellow-gold"
																							v-if="score.editing"
																							v-on:click="updateScore(score)">
																							<div v-if="score.newRecord">Add
																							</div>
																							<div v-else>Save</div>
																						</a>
																						<a class="btn yellow-gold"
																							v-if="score.editing"
																							v-on:click="cancelUpdateScore(score)">Cancel</a>
																						<a class="btn yellow-gold"
																							v-if="!score.editing"
																							v-on:click="deleteScore(score)">Delete</a>
																					</td>
																				</tr>
																			</tbody>
																		</table>
																		<div
																		v-if="activeScoreCategory != '' && activeScoreCategory != 'Priority Score Range'">
																		<button align="center" class="btn yellow-gold"
																			v-on:click="addScore">Add</button>
																	</div>
																	</template>
																	

																</v-app>

																<!-- <div class="tab"
																	style="background-color:#dddddd; padding-top: 15px; padding-bottom: 10px; border: 1px #cccccc solid;">
																	<button type="button" class="btn blue-hoki"
																		v-for="catName in scoreCategoriesOrder"
																		v-on:click="activeScoreCategory = catName">
																		{{catName}}
																	</button>
																</div> -->
																<!-- <div class="table-responsive"
																	id="National_Highway_Freight_Network">
																	<table width="100%" class="table_b table-bordered table-hover">
																		<thead v-if="activeScoreCategory != '' && activeScoreCategory != 'Priority Score Range'">
																			<tr align="center">
																				<td width="25%"
																					style="background-color:#999999;">
																					<font color="#FFFFFF"><strong>Start
																							Range</strong></font>
																				</td>
																				<td width="25%"
																					style="background-color:#999999;">
																					<font color="#FFFFFF"><strong>End
																							Range</strong></font>
																				</td>
																				<td width="25%"
																					style="background-color:#999999;">
																					<font color="#FFFFFF">
																						<strong>Percentage of
																							Weight</strong></font>
																				</td>
																				<td width="25%"
																					style="background-color:#999999;">
																					<font color="#FFFFFF">
																						<strong>Action</strong></font>
																				</td>
																			</tr>
																		</thead>
																		<thead v-if="activeScoreCategory == 'Priority Score Range'">
																			<tr align="center">
																				<td style="background-color:#999999;">
																					<font color="#FFFFFF">
																						<strong>Priority</strong></font>
																				</td>
																				<td style="background-color:#999999;">
																					<font color="#FFFFFF">
																						<strong>From</strong></font>
																				</td>
																				<td style="background-color:#999999;">
																					<font color="#FFFFFF">
																						<strong>To</strong></font>
																				</td>
																			</tr>
																		</thead>
																		<tbody v-if="activeScoreCategory != '' && activeScoreCategory != 'Priority Score Range'">
																			<tr v-for="score in data[activeScoreCategory]">
																				<td>
																					<div v-if="!score.editing">{{score.start_range}}</div>
																					<div v-if="score.editing">
																						<input
																							type="text"
																							v-bind:class="{ error: score.startRangeError}"
																							v-on:keyup="validateScore(score)"
																							v-on:change="validateScore(score)"
																							v-model="score.start_range">
																					</div>
																				</td>
																				<td>
																					<div v-if="!score.editing">{{score.end_range}}</div>
																					<div v-if="score.editing">
																						<input
																							type="text"
																							v-bind:class="{ error: score.endRangeError}"
																							v-on:keyup="validateScore(score)"
																							v-on:change="validateScore(score)"
																							v-model="score.end_range">
																					</div>
																				</td>
																				<td>
																					<div v-if="!score.editing">{{score.score}}</div>
																					<div v-if="score.editing">
																						<input
																							type="text"
																							v-bind:class="{ error: score.scoreError}"
																							v-on:keyup="validateScore(score)"
																							v-on:change="validateScore(score)"
																							v-model="score.score">
																					</div>
																				</td>
																				<td>
																					<a class="btn yellow-gold"
																						v-if="!score.editing"
																						v-on:click="startUpdateScore(score)">Update</a>
																					<a class="btn yellow-gold"
																						v-if="score.editing"
																						v-on:click="updateScore(score)">
																						<div v-if="score.newRecord">Add
																						</div>
																						<div v-else>Save</div>
																					</a>
																					<a class="btn yellow-gold"
																						v-if="score.editing"
																						v-on:click="cancelUpdateScore(score)">Cancel</a>
																					<a class="btn yellow-gold"
																						v-if="!score.editing"
																						v-on:click="deleteScore(score)">Delete</a>
																				</td>
																			</tr>
																		</tbody>
																		<tbody v-if="activeScoreCategory == 'Priority Score Range'">
																			<tr>
																				<td>Acceptable</td>
																				<td>
																					<div
																						v-if="priorityScoreRangeEditing">
																						<input type="text"
																							v-bind:class="{ error: priorityScoreRange.acceptableFromError}"
																							v-on:change="validatePriorityScore()"
																							v-on:keyup="validatePriorityScore()"
																							v-model="data['Priority Score Range'][0]['acceptable_Range_From']">
																					</div>
																					<div v-else>
																						{{priorityScoreRange['acceptable_Range_From']}}
																					</div>
																				</td>
																				<td>
																					<div
																						v-if="priorityScoreRangeEditing">
																						<input type="text"
																							v-on:keyup="validatePriorityScore()"
																							v-on:change="validatePriorityScore()"
																							v-bind:class="{ error: priorityScoreRange.acceptableToError}"
																							v-model="data['Priority Score Range'][0]['acceptable_Range_To']">
																					</div>
																					<div v-else>
																						{{priorityScoreRange['acceptable_Range_To']}}
																					</div>
																				</td>
																			</tr>
																			<tr>
																				<td>Low</td>
																				<td>
																					<div
																						v-if="priorityScoreRangeEditing">
																						<input type="text"
																						v-on:keyup="validatePriorityScore()"
																						v-on:change="validatePriorityScore()"
																						v-bind:class="{ error: priorityScoreRange.lowFromError}"
																							v-model="data['Priority Score Range'][0]['low_Range_From']">
																					</div>
																					<div v-else>
																						{{priorityScoreRange['low_Range_From']}}
																					</div>
																				</td>
																				<td>
																					<div
																						v-if="priorityScoreRangeEditing">
																						<input type="text"
																							v-bind:class="{ error: priorityScoreRange.lowToError}"
																							v-on:keyup="validatePriorityScore()"
																							v-on:change="validatePriorityScore()"
																							v-model="data['Priority Score Range'][0]['low_Range_To']">
																					</div>
																					<div v-else>
																						{{priorityScoreRange['low_Range_To']}}
																					</div>
																				</td>
																			</tr>
																			<tr>
																				<td>Medium</td>
																				<td>
																					<div
																						v-if="priorityScoreRangeEditing">
																						<input type="text"
																							v-bind:class="{ error: priorityScoreRange.mediumFromError}"
																							v-on:keyup="validatePriorityScore()"
																							v-on:change="validatePriorityScore()"
																							v-model="data['Priority Score Range'][0]['medium_Range_From']">
																					</div>
																					<div v-else>
																						{{priorityScoreRange['medium_Range_From']}}
																					</div>
																				</td>
																				<td>
																					<div
																						v-if="priorityScoreRangeEditing">
																						<input type="text"
																							v-bind:class="{ error: priorityScoreRange.mediumToError}"
																							v-on:keyup="validatePriorityScore()"
																							v-on:change="validatePriorityScore()"
																							v-model="data['Priority Score Range'][0]['medium_Range_To']">
																					</div>
																					<div v-else>
																						{{priorityScoreRange['medium_Range_To']}}
																					</div>
																				</td>
																			</tr>
																			<tr>
																				<td>High</td>
																				<td>
																					<div
																						v-if="priorityScoreRangeEditing">
																						<input type="text"
																							v-bind:class="{ error: priorityScoreRange.highFromError}"
																							v-on:keyup="validatePriorityScore()"
																							v-on:change="validatePriorityScore()"
																							v-model="data['Priority Score Range'][0]['high_Range_From']">
																					</div>
																					<div v-else>
																						{{priorityScoreRange['high_Range_From']}}
																					</div>
																				</td>
																				<td>
																					<div
																						v-if="priorityScoreRangeEditing">
																						<input type="text"
																							v-bind:class="{ error: priorityScoreRange.highToError}"
																							v-on:keyup="validatePriorityScore()"
																							v-on:change="validatePriorityScore()"
																							v-model="data['Priority Score Range'][0]['high_Range_To']">
																					</div>
																					<div v-else>
																						{{priorityScoreRange['high_Range_To']}}
																					</div>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																	
																	
																</div> -->
															</div>
														</div>

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
			</div>
			<jsp:include page="include/footer_common.jsp" />
			<jsp:include page="include/quicknav.jsp" />
			
			
			<script src="https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.js"></script>

			<script>
				$(document).ready(function () {
					$('input[type="text"],input[type="password"],select,input[type="submit"],TEXTAREA').addClass("form-control input-sm").addClass("form-control input-sm");

					scoreManagementApp = new Vue({
						el: "#scoreManagementApp",
						vuetify: new Vuetify(),
						data() {
							return {
								primaryTab:null,
								secondaryTab:null,
								tabMap: {
									0:{
										0:"Large Truck Crash Rate",
										1:"Large Truck Severity Rate"
									},
									1:{
										0: "National Highway Network",
										1: "New Jersey Access Network",
										2: "Intermodal Connector",
										3: "National Highway Freight Network"
									},
									2:{
										0:"Percentage of Large Truck Volume",
										1:"Truck Travel Time Reliability Index",
										2:"Overweight Truck Permits"
									}
								},
								scoreCategoryHeadings: [
									{text:"Start Range", value:"start"},
									{text:"End Range", value:"end"},
									{text:"Percentage of Weight", value:"perc"},
									{text:"Action", value:""}

								],
								priorityScoreRangeHeadings: [
									{text:"Priority", value:"priority"},
									{text:"From", value:"from"},
									{text:"To", value:"to"}
								],
								priorityScoreRangeData: [
									{priority:"Acceptable", from:0, to:0},
									{priority:"Low", from:0, to:0},
									{priority:"Medium", from:0, to:0},
									{priority:"High", from:0, to:0},
								],
								scoreCategoriesOrder: [
									"National Highway Freight Network",
									"Intermodal Connector",
									"Large Truck Crash Rate",
									"Large Truck Severity Rate",
									"National Highway Network",
									"New Jersey Access Network",
									"Overweight Truck Permits",
									"Percentage of Large Truck Volume",
									"Truck Travel Time Reliability Index",
									"Priority Score Range"],
								activeScoreCategory: "",
								data: {},
								priorityScoreRangeEditing: false,
								priorityScoreRange: {},
								prevPriorityScoreRangeData: {},
								prevData: {}
							}
						},
						created: function () {
							fetch("scoreManagementData")
								.then(function (response) {
									return response.json();
								})
								.then(data => {
									Vue.set(this, "data", data);
									Vue.set(this, "priorityScoreRange", data['Priority Score Range'][0]);
									
								})
						},
						methods: {
							startUpdateScore: function (score) {
								Vue.set(score, "startRangeError", false);
								Vue.set(score, "endRangeError", false);
								Vue.set(score, "scoreError", false);
								score.prev = {
									start_range: score.start_range,
									end_range: score.end_range,
									score: score.score
								}
								score.editing = true;
							},
							startUpdatePriorityScore: function() {
								this.priorityScoreRangeEditing = true;
								Vue.set(this.priorityScoreRange, "acceptableFromError", 	false);
								Vue.set(this.priorityScoreRange, "acceptableToError", 	false);
								Vue.set(this.priorityScoreRange, "lowFromError", 		false);
								Vue.set(this.priorityScoreRange, "lowToError", 			false);
								Vue.set(this.priorityScoreRange, "mediumFromError", 		false);
								Vue.set(this.priorityScoreRange, "mediumToError", 		false);
								Vue.set(this.priorityScoreRange, "highFromError", 		false);
								Vue.set(this.priorityScoreRange, "highToError", 			false);
								this.prevPriorityScoreRangeData = {
									acceptable_Range_From: this.priorityScoreRange.acceptable_Range_From,
									acceptable_Range_To: this.priorityScoreRange.acceptable_Range_To,
									low_Range_From: this.priorityScoreRange.low_Range_From,
									low_Range_To: this.priorityScoreRange.low_Range_To,
									medium_Range_From: this.priorityScoreRange.medium_Range_From,
									medium_Range_To: this.priorityScoreRange.medium_Range_To,
									high_Range_From: this.priorityScoreRange.high_Range_From,
									high_Range_To: this.priorityScoreRange.high_Range_To,
									
								}
							},
							validateScore: function (score) {
								Vue.set(score, "startRangeError", false);
								Vue.set(score, "endRangeError", false);
								Vue.set(score, "scoreError", false);
								if (score.start_range === "") score.startRangeError = true;
								if (score.end_range === "") score.endRangeError = true;
								if (score.score === "") score.scoreError = true;
								if (!this.checkFloat(score.start_range)) score.startRangeError = true;
								if (!this.checkFloat(score.end_range)) score.endRangeError = true;
								if (!this.checkFloat(score.score)) score.scoreError = true;

							},
							validatePriorityScore: function() {
								Vue.set(this.priorityScoreRange, "acceptableFromError", false);
								Vue.set(this.priorityScoreRange, "acceptableToError", 	false);
								Vue.set(this.priorityScoreRange, "lowFromError", 		false);
								Vue.set(this.priorityScoreRange, "lowToError", 			false);
								Vue.set(this.priorityScoreRange, "mediumFromError", 	false);
								Vue.set(this.priorityScoreRange, "mediumToError", 		false);
								Vue.set(this.priorityScoreRange, "highFromError", 		false);
								Vue.set(this.priorityScoreRange, "highToError", 		false);

								if (this.priorityScoreRange['acceptable_Range_From'] === "") 	this.priorityScoreRange.acceptableFromError = true;
								if (this.priorityScoreRange['acceptable_Range_To'] === "") 		this.priorityScoreRange.acceptableToError = true;
								if (this.priorityScoreRange['low_Range_From'] === "") 			this.priorityScoreRange.lowFromError = true;
								if (this.priorityScoreRange['low_Range_To'] === "") 			this.priorityScoreRange.lowToError = true;
								if (this.priorityScoreRange['medium_Range_From'] === "") 		this.priorityScoreRange.mediumFromError = true;
								if (this.priorityScoreRange['medium_Range_To'] === "") 			this.priorityScoreRange.mediumToError = true;
								if (this.priorityScoreRange['high_Range_From'] === "") 			this.priorityScoreRange.highFromError = true;
								if (this.priorityScoreRange['high_Range_To'] === "") 			this.priorityScoreRange.highToError = true;
								
								if (!this.checkFloat(this.priorityScoreRange['acceptable_Range_From'])) this.priorityScoreRange.acceptableFromError = true;
								if (!this.checkFloat(this.priorityScoreRange['acceptable_Range_To'])) this.priorityScoreRange.acceptableToError = true;
								if (!this.checkFloat(this.priorityScoreRange['low_Range_From'])) this.priorityScoreRange.lowFromError = true;
								if (!this.checkFloat(this.priorityScoreRange['low_Range_To'])) this.priorityScoreRange.lowToError = true;
								if (!this.checkFloat(this.priorityScoreRange['medium_Range_From'])) this.priorityScoreRange.mediumFromError = true;
								if (!this.checkFloat(this.priorityScoreRange['medium_Range_To'])) this.priorityScoreRange.mediumToError = true;
								if (!this.checkFloat(this.priorityScoreRange['high_Range_From'])) this.priorityScoreRange.highFromError = true;
								if (!this.checkFloat(this.priorityScoreRange['high_Range_To'])) this.priorityScoreRange.highToError = true;
								
							},
							cancelUpdateScore: function (score) {
								Vue.set(score, "startRangeError", false);
								Vue.set(score, "endRangeError", false);
								Vue.set(score, "scoreError", false);
								score.editing = false;
								if (score.prev) { //this is not a new record
									score.start_range = score.prev.start_range;
									score.end_range = score.prev.end_range;
									score.score = score.prev.score;
									score.prev = undefined;
								} else { //this is a new record
									//TODO: add code to handle delete
									//To Remove newly added row on click of 'Cancel'
									this.data[this.tabMap[this.primaryTab][this.secondaryTab]].splice(this.data[this.tabMap[this.primaryTab][this.secondaryTab]].indexOf(score),1);
								}
								
							},
							updateScore: function (score) {
								if (score.startRangeError || score.endRangeError || score.scoreError) {
									alert("Please ensure that you have entered valid numeric values");
									return;
								}
								// To Check Start Range,End Range values are not overlapping with other ranges
								var overlappingStartRange = false;
								var overlappingEndRange = false;
								var newStartRange = score.start_range;
								var newEndRange = score.end_range;
								for(var i =0; i<this.data[this.tabMap[this.primaryTab][this.secondaryTab]].length ; i++){
									currentScore =this.data[this.tabMap[this.primaryTab][this.secondaryTab]][i];
									console.log("Current score : "+currentScore.start_range+" -- "+currentScore.end_range);
									if(!currentScore.newRecord && currentScore != score){
										if(currentScore.start_range<= newStartRange && newEndRange <= currentScore.end_range){
											alert("This Range already present in "+currentScore.start_range+" - "+currentScore.end_range);
											return;
										}
										if(newStartRange === newEndRange){
											alert("Start Range and the End Range cannot be same");
											return;
										}
										if (currentScore.start_range <= newStartRange && newStartRange < currentScore.end_range){
											alert("Start Range is overlapping with an existing range");
											return;
										}
										if(newStartRange > newEndRange){
											alert("Start Range cannot be greater than End Range");
											return;
										}
									}
								}
								url = "";
								if (score.newRecord) {
									url = "Add_Range?start_range=" + score.start_range + "&end_range=" + score.end_range + "&perc_weight=" + score.score + "&mode=" + score.category_name;
								} else {
									url = "Update_Range?ID=" + score.id + "&start_range=" + score.start_range + "&end_range=" + score.end_range + "&perc_weight=" + score.score + "&mode=" + score.category_name;
								}
								fetch(url)
									.then(function (response) {
										return response.json();
									})
									.then(data => {
										if(score.newRecord){
											score.id= data.saved_score_id
										}
										if (data.status == "OK") {
											this.processSuccessfullUpdate(score);
										} else {
											this.processFailedUpdate(score);
										}
									})
							},
							processSuccessfullUpdate: function(score) {
								Vue.set(score, "startRangeError", false);
								Vue.set(score, "endRangeError", false);
								Vue.set(score, "scoreError", false);
								score.editing = false;
								score.updateFailed = false;
								score.prev = undefined;
							},
							processFailedUpdate: function(score) {
								score.updateFailed = true;
							},
							deleteScore: function (score) {
								result = confirm("Are you sure you want to delete this record?")
								if (result) {
									fetch("Delete_Range?ID=" + score.id)
									.then(function (response) {
										return response.json();
									})
									.then(data => {
										if (data.status == "OK") {
											this.processSuccessfullDelete(score);
										} else {
											alert("This record could not be deleted.")
										}	
									})
								}
							},
							processSuccessfullDelete: function(score) {
								this.data[score.category_name] = this.data[score.category_name].filter(function (value, index, arr) {
									return value.id != score.id;
								})
							},
							addScore: function () {
								this.data[this.activeScoreCategory].push({
									category_name: this.activeScoreCategory,
									editing: true,
									end_range: 0,
									id: -1000,
									score: "0.0",
									start_range: 0,
									newRecord: true
								});
							},
							checkFloat: function (strValue) {
								var value = parseFloat(strValue);
								var val1;
								if (isNaN(value)) {
									return false;
								}
								else {
									for (var i = 0; i < strValue.length; i++) {
										val1 = strValue.charCodeAt(i);
										if (val1 == 46)
											continue;
										if ((val1 < 48) || (val1 > 57)) {
											return false;
										}
									}
									return true;
								}
							}
						},
						watch: {
							secondaryTab: function(val) {
								this.activeScoreCategory = this.tabMap[this.primaryTab][this.secondaryTab];
							}
						}
					})
				});
			</script>
		</div>
		<!--End "page-wrapper"-->
</body>

</html>