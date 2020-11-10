<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
  <title>NJDOT FMS | Edit Scoring System</title>
  <jsp:include page="../include/head_common.jsp" />
  
  <!-- BEGIN PAGE LEVEL PLUGINS -->
  <link href="../assets/global/plugins/datatables/datatables.min.css" rel="stylesheet" type="text/css" />
  <link href="../assets/global/plugins/datatables/plugins/bootstrap/datatables.bootstrap.css" rel="stylesheet"
    type="text/css" />
  <!-- END PAGE LEVEL PLUGINS -->
  <style>
    input.error {
      border-color: red;
      background-color: rgb(255, 167, 167)
    }

    #editPBSApp table {
      margin-bottom: 0px;
    }

    [v-cloak]>* {
      display: none;
    }

    [v-cloak]::before {
      content: " ";
      display: block;
      position: absolute;
      width: 80px;
      height: 80px;
      background-image: url(/images/ajax-loader.gif);
      background-size: cover;
      left: 50%;
      top: 50%;
    }
  </style>
  <script language="JavaScript">
    function checkInteger(strValue) {
      var value = parseInt(strValue);
      var val1;
      if (isNaN(value)) {
        return false;
      }
      else {
        for (var i = 0; i < strValue.length; i++) {
          val1 = strValue.charCodeAt(i);
          if ((val1 < 48) || (val1 > 57)) {
            return false;
          }
        }
        return true;
      }
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

    function validateSystemSubmit() {
      var result = checkInteger(document.UpdateSystemForm.MaxScore.value);
      if (result == true) {
        checkTotal(document.TotalForm.Total.value);
        alert("Submitted");
        return true;
      }
      else {
        alert("Max Score must be an integer value" + document.UpdateSystemForm.MaxScore.value + ".");
        document.UpdateSystemForm.MaxScore.focus();
        return false;
      }
    }


    function validateCategorySubmit() {
      var result = checkFloat(document.UpdateCategoryForm.Weight.value);
      if (result == true) {

        checkTotal(document.TotalForm.Total.value);
        alert("Submitted");
        return true;
      }
      else {
        alert("Weight must be a value in the format 123.456" + document.UpdateCategoryForm.Weight.value);
        document.UpdateCategoryForm.Weight.focus();
        return false;
      }
    }

    function checkTotal(totals) {
      var total = parseInt(totals);
      if (total != 100) {
        alert("WARNING: Total of all Weights  not equal 100%");
        return true;
      }
      else return false;
    }


    function validateFactorSubmit(here) {
      var result = checkFloat(here.Weight.value);
      if (result == true) {
        return true;
      }
      else {
        alert("Weight must be a value in the format 123.456" + here.Weight.value);
        here.Weight.focus();
        return false;

      }
    }

    function validateNewCategory(varForm) {
      var isValid = true;

      if (varForm.Cat_Name.value == null || varForm.Cat_Name.value == "" || varForm.Cat_Name.value == " ") {
        alert("Enter valid Category Name");
        varForm.Cat_Name.focus();
        return false;
      }

      var result = checkFloat(varForm.Weight.value);

      if (result == true) {
        checkTotal(document.TotalForm.Total.value);
        return true;
      }
      else {
        alert("Weight must be a value in the format 123.456");
        varForm.Weight.focus();
        return false;
      }

    }
  </script>
  <script>
    function factorDetailsbyCatID(cat_id, sys_id, size) {
      document.getElementById("SubmitChanges_Btn").disabled = true;
      var cat_table = document.getElementById("CategoryDetailsTable" + cat_id).id;
      if (document.getElementById(cat_table).style.display == "none") {
        document.getElementById(cat_table).style.display = "";
      }
      else {
        document.getElementById(cat_table).style.display = "none";
      }
      for (var i = 1; i <= size; i++) {
        if (cat_id != i) {
          document.getElementById("CategoryDetailsTable" + i).style.display = "none";
        }
      }
    }

  </script>
  <script>
    function updateCategoryDetails(cat_id, size) {
      document.getElementById("SubmitChanges_Btn").disabled = false;
      var category_weight = document.getElementById("Category_ID" + cat_id).value;
      if (checkFloat(category_weight) == false) {
        alert("Category Weight of Category " + cat_id + " must be a numberic value");
        document.getElementById("SubmitChanges_Btn").disabled = true;
        return false;
      }
      else {
        document.getElementById("Category_weight_inside_list" + cat_id).innerHTML = category_weight;
        var total = 0;
        for (var i = 1; i <= size; i++) {
          //category_array.push(document.getElementById("Criteria_ID"+cat_id+i).value);
          if (checkFloat(document.getElementById("Criteria_ID" + cat_id + i).value) == false) {
            alert("Weight of Factor " + i + " of category " + cat_id + " must be a numeric value");
            document.getElementById("SubmitChanges_Btn").disabled = true;
            return false;
          }
          total = total + parseFloat(document.getElementById("Criteria_ID" + cat_id + i).value);
        }
        if (total != 100) {
          document.getElementById("SubmitChanges_Btn").disabled = true;
          alert("Factor of Category" + cat_id + " must sum up to 100 (Max Score)");
          return false;
        }
      }

    }
    function validateform(size) {
      var total = 0;
      for (var i = 1; i <= size; i++) {
        total = total + parseFloat(document.getElementById("Category_ID" + i).value);
      }
      if (total != 100) {
        document.getElementById("SubmitChanges_Btn").disabled = true;
        alert("Categories must sum up to 100(Max Score)");
        return false;
      }
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
  </script>
  <style>
    #highlight tr:hover {
      background-color: #efefef;
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
                    <a href="${pageContext.servletContext.contextPath}/">Home</a>
                    <i class="fa fa-circle"></i>
                  </li>
                  <li>
                    <a href="${pageContext.servletContext.contextPath}/performanceBasedScoring">Performance Based
                      Scoring</a>
                    <i class="fa fa-circle"></i>
                  </li>
                  <li>
                    <span>Edit System</span>
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
                            <span class="caption-subject font-dark bold uppercase">Scoring System Information</span>
                          </div>
                          <div class="actions">
                            <a class="btn dark btn-circle btn-sm"
                              href="${pageContext.servletContext.contextPath}/performanceBasedScoring">
                              <i class="fa fa-arrow-left"></i> Back to Scoring Menu
                            </a>
                            <a class="btn btn-circle btn-icon-only btn-default fullscreen" href="javascript:;"> </a>
                          </div>
                        </div>
                        <div class="portlet-body form">
                          <div id="editPBSApp" v-cloak>
                            <div class="row"
                              style="background-color:#dddddd; padding-bottom: 10px; border: 1px #cccccc solid;">
                              <div class="row">
                                <div class="col-sm-6 font-blue-soft">Scoring Method Name:</div>
                                <div class="col-sm-6"><input type="text" v-model="scoreSystem.systemName" /></div>
                              </div>
                              <div class="row">
                                <div class="col-sm-6 font-blue-soft">Description:</div>
                                <div class="col-sm-6"><input type="text" v-model="scoreSystem.description" /></div>
                              </div>
                              <div class="row">
                                <div class="col-sm-6 font-blue-soft">Created By:</div>
                                <div class="col-sm-2">{{scoreSystem.loginID}}</div>
                                <div class="col-sm-2 font-blue-soft">Max Score:</div>
                                <div class="col-sm-2">{{scoreSystem.maxScore}}</div>
                              </div>
                            </div>
                            <div class="row">
                              <div class="bg-blue-chambray"
                                style="margin: 10px 0 5px 0; padding: 5px; box-shadow: 0 0 5px #888;">
                                <span class="bg-font-blue-chambray font-sm">
                                  NOTE: Click on the Save Changes button after updating the factor details in order to
                                  save the scoring system
                                </span>
                              </div>
                            </div>
                            <div class="row">
                              <table class="table_b table-bordered table-hover" style="box-shadow: 0 0 5px #888;">
                                <thead>
                                  <tr align="center">
                                    <td width="10%" style="background-color:#999999;">
                                      <font color="#FFFFFF"><strong>No.</strong></font>
                                    </td>
                                    <td width="20%" style="background-color:#999999;">
                                      <font color="#FFFFFF"><strong>Scoring Factor</strong></font>
                                    </td>
                                    <td width="50%" style="background-color:#999999;">
                                      <font color="#FFFFFF"><strong>Description</strong></font>
                                    </td>
                                    <td width="13%" style="background-color:#999999;">
                                      <font color="#FFFFFF"><strong><acronym title="Percent of the Total Score">% of
                                            Score</acronym></strong></font>
                                    </td>
                                    <td width="7%" style="background-color:#999999;">
                                      <font color="#FFFFFF"><strong>Action</strong></font>
                                    </td>
                                  </tr>
                                </thead>
                              </table>
                              <table width="100%" v-for="category in categories"
                                class="table_b table-bordered table-hover">
                                <tr bgcolor="#FFFFFF">
                                  <td width="10%" align="center">{{category.catID}}</td>
                                  <td width="20%">{{category.cat_Name}}</td>
                                  <td width="50%">{{category.cat_Description}}</td>
                                  <td width="13%" align="center" id="Category_weight_inside_list${ val }">
                                    {{category.weight}}</td>
                                  <td width="7%" align="center">
                                    <button class="btn btn-xs btn-outline yellow-gold" type="button"
                                      v-on:click="category.expanded = !category.expanded">
                                      <div v-if="category.expanded">Close</div>
                                      <div v-else>Edit</div>
                                    </button>
                                  </td>
                                </tr>
                                <tr v-if="category.expanded">
                                  <td colspan="5">
                                    <table class="table_b table-bordered" style="border: 2px #F1C40F solid;">
                                      <tr>
                                        <td align="left" colspan="2">
                                          <b>Scoring Factor Name: </b>
                                        </td>
                                        <td align="left" colspan="2">{{category.cat_Name}}</td>
                                      </tr>
                                      <tr>
                                        <td align="left" colspan="2">
                                          <b>Factor Description: </b>
                                        </td>
                                        <td align="left" colspan="2">{{category.cat_Description}}</td>
                                      </tr>
                                      <tr>
                                        <td align="left" colspan="2">
                                          <b>Percent of Total Score:</b>
                                        </td>
                                        <td align="left" colspan="2">
                                          <input type="text" v-bind:class="{ error: category.weightError}"
                                            v-on:keyup="validateWeightField(category)"
                                            v-on:change="validateWeightField(category)"
                                            v-model="category.weightField" />
                                        </td>
                                      </tr>
                                      <tr>
                                        <td align="center" style="background-color: #cccccc; font-weight: bold;">
                                          <span class="font-yellow-gold">Criteria No.</span>
                                        </td>
                                        <td align="center" colspan="2"
                                          style="background-color: #cccccc; font-weight: bold;">
                                          <span class="font-yellow-gold">Criteria Description</span>
                                        </td>
                                        <td align="center" style="background-color: #cccccc; font-weight: bold;">
                                          <span class="font-yellow-gold">% of Factor Score</span>
                                        </td>
                                      </tr>
                                      <tr v-for="factor in category.scoreFactors">
                                        <td align="center">
                                          {{factor.factorID}}
                                        </td>
                                        <td colspan="2">
                                          {{factor.factor_Description}}
                                        </td>
                                        <td align="center">
                                          <input type="text" v-bind:class="{ error: factor.weightError}"
                                            v-on:keyup="validateWeightField(factor)"
                                            v-on:change="validateWeightField(factor)" v-model="factor.weightField"
                                            style="width: 60px;" />
                                        </td>
                                      </tr>
                                      <tr>
                                        <td colspan="5" align="center">
                                          <input class="btn yellow-gold btn-xs" type="button"
                                            v-on:click="updateFactorsInCategory(category)" value="Update Factor">
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                              </table>
                              <div class="col-md-12">
                                <center>
                                  <a href="#" v-on:click="updateSystem()" class="btn yellow-gold btn-sm">Save Changes</a>
                                </center>
                              </div>
                            </div>
                          </div>
                          <!-- BEGIN FORM-->
                          <div class="form-horizontal">
                            </form>


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
  <!-- BEGIN QUICK NAV -->
  <nav class="quick-nav">
    <a class="quick-nav-trigger" href="#0">
      <span aria-hidden="true"></span>
    </a>
    <jsp:include page="../include/quicknav.jsp" />
    <span aria-hidden="true" class="quick-nav-bg"></span>
  </nav>
  <div class="quick-nav-overlay"></div>
  <jsp:include page="../include/footer_common.jsp" />
  <!-- END QUICK NAV -->
  <!-- BEGIN PAGE LEVEL PLUGINS -->
  <script src="../assets/global/scripts/datatable.js" type="text/javascript"></script>
  <script src="../assets/global/plugins/datatables/datatables.min.js" type="text/javascript"></script>
  <script src="../assets/global/plugins/datatables/plugins/bootstrap/datatables.bootstrap.js"
    type="text/javascript"></script>
  <!-- END PAGE LEVEL PLUGINS -->
  <script>
    $(document).ready(function () {
      editPBSApp = new Vue({
        el: "#editPBSApp",
        data() {
          return {
            scoreSystem: {},
            categories: [],
            id: -999,
            sumError: false
          }
        },
        created: function () {
          this.id = this.getUrlParameter("SystemID");
          fetch("details?id=" + this.id)
            .then(function (response) {
              return response.json();
            })
            .then(data => {
              Vue.set(this, "scoreSystem", data.scoreSystem[0]);
              Vue.set(this, "categories", data.categories);
              this.categories.forEach(elem => {
                Vue.set(elem, "expanded", false);
                Vue.set(elem, "weightField", elem.weight);
                Vue.set(elem, "weightError", false);
                Vue.set(elem, "sumError", false);
                elem.scoreFactors.forEach(fact => {
                  Vue.set(fact, "weightField", fact.weight);
                  Vue.set(fact, "weightError", false);
                })
              })
            })
        },
        methods: {
          validateWeightField: function (item) {
            if (item.weightField == "") {
              item.weightError = true;
              return;
            }
            if (checkFloat(item.weightField)) item.weightError = false;
            else item.weightError = true;
          },
          updateFactorsInCategory: function (category) {
            if (category.weightError) {
              alert("Please fix the highlighted errors before saving this score factor");
              return;
            }
            total = 0.0
            category.scoreFactors.forEach(factor => {
              if (factor.weightError) {
                alert("Please fix the highlighted errors before saving this score factor");
                return;
              }
              total += parseFloat(factor.weightField);
            })
            if (total != 100) {
              alert("Score factor weights must add up to 100%");
              return;
            }

            category.weight = category.weightField;
            category.scoreFactors.forEach(factor => {
              factor.weight = factor.weightField;
            })
          },
          updateSystem: function () {
            categoryWeightTotal = 0;

            this.categories.forEach(category => {
              categoryWeightTotal += parseFloat(category.weight);
            })
            if (categoryWeightTotal != 100) {
              alert("Score category weights must add up to 100%");
              return;
            }
            var payload = {
              id: this.id,
              name: this.scoreSystem.systemName,
              description: this.scoreSystem.description,
              categories: []
            }
            this.categories.forEach(category => {
              factors=[];
              category.scoreFactors.forEach(factor => {
                factors.push({
                  id: factor.factorID,
                  description: factor.factor_Description,
                  weight: factor.weight
                })
              })
              payload.categories.push({
                id: category.catID,
                name: category.cat_Name,
                description: category.cat_Description,
                weight: category.weight,
                factors: factors
              })
            })
            var data = new FormData();
            data.append("json", JSON.stringify(payload));
            fetch("updatetest",
              {
                method: "POST",
                body: JSON.stringify(payload),
                'Content-Type': 'text/plain'
              })
              .then(function (res) { alert("Changes Saved!") })
          },
          getUrlParameter: function getUrlParameter(sParam) {
            var sPageURL = window.location.search.substring(1),
              sURLVariables = sPageURL.split('&'),
              sParameterName,
              i;

            for (i = 0; i < sURLVariables.length; i++) {
              sParameterName = sURLVariables[i].split('=');

              if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
              }
            }
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
        }
      })
    })

  </script>
  <script>
    $(document).ready(function () {
      $('input[type="text"],input[type="password"],select,input[type="submit"],TEXTAREA').addClass("form-control input-sm").addClass("form-control input-sm");
    });
  </script>

</body>

</html>