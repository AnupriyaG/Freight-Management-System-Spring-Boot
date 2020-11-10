<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<!-- END THEME LAYOUT STYLES -->
<script src="${pageContext.servletContext.contextPath}/assets/global/plugins/jquery.min.js" type="text/javascript"></script>
<!-- development version, includes helpful console warnings -->
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
<div class="page-wrapper-row">
    <div class="page-wrapper-bottom">
        <!-- BEGIN FOOTER -->
        <!-- BEGIN INNER FOOTER -->
        <div class="page-footer">
            <div class="container-fluid">&copy; 2020 NJIT
                <!--Metronic Theme By
                <a target="_blank" href="http://keenthemes.com">Keenthemes</a> &nbsp;|&nbsp;
                <a href="http://themeforest.net/item/metronic-responsive-admin-dashboard-template/4021469?ref=keenthemes" title="Purchase Metronic just for 27$ and get lifetime updates for free" target="_blank">Purchase Metronic!</a-->
            </div>
        </div>
        <div class="scroll-to-top">
            <i class="icon-arrow-up"></i>
        </div>
        <!-- END INNER FOOTER -->
        <!-- END FOOTER -->
    </div>
</div>
<!-- Modal -->
<div class="modal fade" id="timeoutModal" tabindex="-1" role="dialog" aria-labelledby="timeoutModalTitle" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="timeoutModalTitle">Modal title</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="session-expiring alert alert-warning">
              <p>Your session will expire in</p>
              <h1 class="mmss">--:--</h1>
          </div>
          <div class="session-expired alert alert-danger">
              <p>Your session has expired!</p>
          </div>
        </div>
        <div class="modal-footer">
            <div class="session-expiring">
                <button type="button" class="btn btn-primary" id="session-expiring-extend-btn">Extend Session</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal" id="session-expiring-close-btn">Close</button>
            </div>
            <div class="session-expired">
                <button type="button" class="btn btn-primary" id="session-expired-login-btn">Login</button>
            </div>
        </div>
      </div>
    </div>
  </div>
<!--[if lt IE 9]>
    <script src="assets/global/plugins/respond.min.js"></script>
    <script src="assets/global/plugins/excanvas.min.js"></script> 
    <script src="assets/global/plugins/ie8.fix.min.js"></script> 
<![endif]-->
<!-- BEGIN CORE PLUGINS -->
<script src="${pageContext.servletContext.contextPath}/assets/global/plugins/jquery.min.js" type="text/javascript"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" type="text/javascript"></script>
<script src="${pageContext.servletContext.contextPath}/assets/global/plugins/js.cookie.min.js" type="text/javascript"></script>
<script src="${pageContext.servletContext.contextPath}/assets/global/plugins/jquery-slimscroll/jquery.slimscroll.min.js" type="text/javascript"></script>
<script src="${pageContext.servletContext.contextPath}/assets/global/plugins/jquery.blockui.min.js" type="text/javascript"></script>
<script src="${pageContext.servletContext.contextPath}/assets/global/plugins/bootstrap-switch/js/bootstrap-switch.min.js" type="text/javascript"></script>
<!-- END CORE PLUGINS -->
<!-- BEGIN THEME GLOBAL SCRIPTS -->
<script src="${pageContext.servletContext.contextPath}/assets/global/scripts/app.min.js" type="text/javascript"></script>
<!-- END THEME GLOBAL SCRIPTS -->
<!-- BEGIN THEME LAYOUT SCRIPTS -->
<!-- <script src="${pageContext.servletContext.contextPath}/assets/layouts/layout3/scripts/layout.min.js" type="text/javascript"></script>
<script src="${pageContext.servletContext.contextPath}/assets/layouts/layout3/scripts/demo.min.js" type="text/javascript"></script>
<script src="${pageContext.servletContext.contextPath}/assets/layouts/global/scripts/quick-sidebar.min.js" type="text/javascript"></script> -->
<!-- <script src="${pageContext.servletContext.contextPath}/assets/layouts/global/scripts/quick-nav.min.js" type="text/javascript"></script>
 --><!-- END THEME LAYOUT SCRIPTS -->
<!-- VUETIFY -->
<script src="https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.js"></script>
<!-- END VUETIFY -->
<script>
    function getMaxInactiveInterval() {
        return "${pageContext.session.maxInactiveInterval * 1000}";
    }
    resetTimeoutCountdown();
    var timeoutCountdown;
    var sessionExpiryModalClosed = false;
    function resetTimeoutCountdown() {
        timeoutCountdown = parseInt("${pageContext.session.maxInactiveInterval}");
        setTimeout(countdownTick, 1000);
    }
    function countdownTick() {
        if (timeoutCountdown>0) { //there is still time on the countdown
            timeoutCountdown--; //decrement the counter
            if (timeoutCountdown<600) { //if it's less than 10 minutes
                if (!sessionExpiryModalClosed) $('#timeoutModal').modal(); //if modal is closed, open it
                //display expiring soon message and update time val
                $("#timeoutModalTitle").html("Your session is about to expire!");
                $(".session-expiring").show();
                $(".session-expired").hide();
                tcMin = timeoutCountdown/60;
                tcSec = timeoutCountdown%60
                if (tcSec<10) tcSec = "0" + tcSec;
                $(".session-expiring .mmss").html(Math.floor(tcMin) + ":" + tcSec);

            }
            setTimeout(countdownTick, 1000);
        } else { //countdown hit 0, your session has ended
            $('#myModal').modal(); //if modal is closed, open it
            //display expired message
            $("#timeoutModalTitle").html("Your session has expired!");
            $(".session-expiring").hide();
            $(".session-expired").show();
        }
    }

    $("#session-expiring-extend-btn").click(function() {
        fetch("${pageContext.servletContext.contextPath}/session_refresh")
            .then(response => {
                return response.text();
            })
            .then(data => {
                if (data == "REFRESH_OK") {
                    $('#timeoutModal').modal("hide");
                    timeoutCountdown = parseInt("${pageContext.session.maxInactiveInterval}");
                } else {
                    alert("Your session could not be extended. It may have already expired. Refresh the page to login again")
                }
            }).catch(error => {
                console.error(error)
            });
        
        
    })
    $("#session-expiring-close-btn").click(function() {
        sessionExpiryModalClosed = true;
    })
    $("#session-expired-login-btn").click(function() {
        location.reload();
    })
    /* function startCountdown() {
        window.setTimeout(alertSessionTimeout, );
    }
    
    function alertSessionTimeout() {
        alert("You're session is going to timeout in 1 minute.");
    } */
</script>