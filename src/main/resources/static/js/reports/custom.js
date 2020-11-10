customApp = new Vue({
    el: "#tab_1_2",
    data() {
        return {
            scoringSystems: [],
            customProjectDescription: "",
            selectedCustomRoute: "",
            customRoutes: [],
            customSelectedScoringSystem: "9",
            selectedFromMPValue: "",
            fromMPValues: [],
            selectedToMPValue: "",
            toMPValues: [],
            filterError: false,
            filterLoading: false,
        }
    },
    created: function () {
        this.filterLoading = true;
        fetch("getCustomRoutes")
            .then(response => {
                this.filterLoading = false;
                return response.json();
            })
            .then(data => {
                fixedData = [];
                data.forEach(val => {
                    fixedData.push({
                        title: val[0],
                        value: val[1]
                    })
                })
                this.customRoutes = fixedData
            }).catch(error => {
                this.filterError = true;
                console.error(error)
            });
    },
    methods: {
        showCustomReport: function () {
            url = "DownloadCustomReport?route=" + this.selectedCustomRoute.value +
                "&from=" + this.selectedFromMPValue +
                "&to=" + this.selectedToMPValue +
                "&scoresystem=" + this.customSelectedScoringSystem.systemID +
                "&projdesc=" + this.customProjectDescription;
            window.location = url;
        },
    },
    watch: {
        selectedCustomRoute: function (value) {
            this.fromMPValues = [],
                this.toMPValues = [],
                this.selectedFromMPValue = "";
            this.selectedToMPValue = "";
            fetch("fromMPList?route=" + value.value)
                .then(function (response) {
                    this.filterLoading = false;
                    return response.json();
                })
                .then(data => {
                    this.fromMPValues = data
                }).catch(error => {
                    this.filterError = true;
                    this.filterLoading = false;
                    console.error(error)
                });
        },
        selectedFromMPValue: function (value) {
            fetch("toMPList?route=" + this.selectedCustomRoute.value + "&from=" + value)
                .then(function (response) {
                    this.filterLoading = false;
                    return response.json();
                })
                .then(data => {
                    this.toMPValues = data
                }).catch(error => {
                    this.filterError = true;
                    this.filterLoading = false;
                    console.error(error)
                });
        },
    },
})