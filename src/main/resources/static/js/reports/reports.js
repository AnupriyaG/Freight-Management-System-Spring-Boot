Vue.component('vue-multiselect', window.VueMultiselect.default);
Vue.use(Vuetable)

$(document).ready(function () {
    $('input[type="text"],input[type="password"],select,input[type="submit"],TEXTAREA').addClass("form-control input-md").addClass("form-control input-md");
});