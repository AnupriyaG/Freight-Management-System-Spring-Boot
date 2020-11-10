<!-- BEGIN FORM-->
<div class="form-horizontal" role="form">
    <input type="hidden" name="hdnSystemID" />
<div style="background-color: rgba(102, 102, 102, 0.8); box-shadow: 0 0 5px #888; color:white; padding:20px 20px 10px 20px;">	
    <table class="table">
        <tr id="Proj_Desc_User">
            <td width="160" style="border-top: 0px solid #666; line-height: 2.5;" ><b>Project Description:</b>
            </td>
            <td style="border-top: 0px solid #666;"><input type="text" v-model="customProjectDescription" style="height:42px; background-color: #ffffff;"></td>
        </tr>
        <tr id="Route">
            <td style="border-top: 0px solid #666; line-height: 2.5;"><b>ROUTE:</b></td>
            <td style="border-top: 0px solid #666;">
                <vue-multiselect v-model="selectedCustomRoute" :options="customRoutes" :searchable="true" label="title"
                    :close-on-select="true" :show-labels="false" placeholder="Select Value">
                </vue-multiselect>

            </td>
        </tr>
        <tr id="Start_Mile_Post" v-if="fromMPValues.length > 0">
            <td style="border-top: 0px solid #666; line-height: 2.5;"><b>Start Mile Post:</b></td>
            <td style="border-top: 0px solid #666;">
                <vue-multiselect v-model="selectedFromMPValue" :options="fromMPValues" :searchable="true"
                    :close-on-select="true" :show-labels="false" placeholder="Select Start Milepost">
                </vue-multiselect>
            </td>
        </tr>
        <tr id="End_Mile_Post" v-if="toMPValues.length > 0">
            <td style="border-top: 0px solid #666; line-height: 2.5;"><b>End Mile Posts:</b></td>
            <td style="border-top: 0px solid #666;">
                <vue-multiselect v-model="selectedToMPValue" :options="toMPValues" :searchable="true"
                    :close-on-select="true" :show-labels="false" placeholder="Select End Milepost">
                </vue-multiselect>
            </td>
        </tr>
        <tr id="Scoring_System">
            <td style="border-top: 0px solid #666; line-height: 2.5;"><b>Scoring System:</b></td>
            <td style="border-top: 0px solid #666;">
                <vue-multiselect v-model="customSelectedScoringSystem" :options="scoringSystems" :searchable="true"
                    label="systemName" track-by="systemID" :close-on-select="true" :show-labels="false" :allow-empty="false"
                    placeholder="Select Value">
                </vue-multiselect>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center" style="border-top: 0px solid #666;">
                <button v-on:click="showCustomReport" class="btn yellow-gold">Download
                    Custom Report</button>

            </td>
        </tr>
    </table>
</div>
</div>
<table class="table" style="background-color: rgba(102, 102, 102, 0.8); margin-top: 0px;" id="Segment_Info"
    style="display:none">
</table>