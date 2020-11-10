/**
 * BEGIN PATCH FROM HIGHCHARTS SUPPORT
 */
// Portrait patches
function getScript(scriptLocation, callback) {
    var head = document.getElementsByTagName('head')[0],
      script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = scriptLocation;
    script.onload = callback;
    script.onerror = function() {
      Highcharts.error('Error loading script ' + scriptLocation);
    };
    head.appendChild(script);
  }

  Highcharts.downloadSVGLocal = function(svg, options, failCallback, successCallback) {
    var svgurl, blob, objectURLRevoke = true,
      finallyHandler, libURL = (options.libURL || Highcharts.getOptions().exporting.libURL),
      dummySVGContainer = document.createElement('div'),
      imageType = options.type || 'image/png',
      filename = ((options.filename || 'chart') +
        '.' +
        (imageType === 'image/svg+xml' ? 'svg' : imageType.split('/')[1])),
      scale = options.scale || 1;
  
    libURL = libURL.slice(-1) !== '/' ? libURL + '/' : libURL;
  
    function svgToPdf(svgElement, margin) {
      var width = svgElement.width.baseVal.value + 2 * margin,
        height = svgElement.height.baseVal.value + 2 * margin,
        pdf = new window.jsPDF(
          'portrait', 'pt', [width, height] // CHANGED TO PORTRAIT FROM LANDSCAPE
        );
  
      [].forEach.call(svgElement.querySelectorAll('*[visibility="hidden"]'), function(node) {
        node.parentNode.removeChild(node);
      });
      window.svg2pdf(svgElement, pdf, {
        removeInvalid: true
      });
      return pdf.output('datauristring');
    }
  
    function downloadPDF() {
      dummySVGContainer.innerHTML = svg;
      var textElements = dummySVGContainer.getElementsByTagName('text'),
        titleElements,
        svgData,
        setStylePropertyFromParents = function(el, propName) {
          var curParent = el;
          while (curParent && curParent !== dummySVGContainer) {
            if (curParent.style[propName]) {
              el.style[propName] =
                curParent.style[propName];
              break;
            }
            curParent = curParent.parentNode;
          }
        };
  
      [].forEach.call(textElements, function(el) {
        ['font-family', 'font-size'].forEach(function(property) {
          setStylePropertyFromParents(el, property);
        });
        el.style['font-family'] = (el.style['font-family'] &&
          el.style['font-family'].split(' ').splice(-1));
        titleElements = el.getElementsByTagName('title');
        [].forEach.call(titleElements, function(titleElement) {
          el.removeChild(titleElement);
        });
      });
      svgData = svgToPdf(dummySVGContainer.firstChild, 0);
      try {
        Highcharts.downloadURL(svgData, filename);
        if (successCallback) {
          successCallback();
        }
      } catch (e) {
        failCallback(e);
      }
    }
    if (imageType === 'image/svg+xml') {
      try {
        if (typeof window.navigator.msSaveOrOpenBlob !== 'undefined') {
          blob = new MSBlobBuilder();
          blob.append(svg);
          svgurl = blob.getBlob('image/svg+xml');
        } else {
          svgurl = Highcharts.svgToDataUrl(svg);
        }
        Highcharts.downloadURL(svgurl, filename);
        if (successCallback) {
          successCallback();
        }
      } catch (e) {
        failCallback(e);
      }
    } else if (imageType === 'application/pdf') {
      if (window.jsPDF && window.svg2pdf) {
        downloadPDF();
      } else {
        objectURLRevoke = true;
        getScript(libURL + 'jspdf.js', function() {
          getScript(libURL + 'svg2pdf.js', function() {
            downloadPDF();
          });
        });
      }
    } else {
      svgurl = Highcharts.svgToDataUrl(svg);
      finallyHandler = function() {
        try {
          window.url.revokeObjectURL(svgurl);
        } catch (e) {
          // Ignore
        }
      };
  
      Highcharts.imageToDataUrl(svgurl, imageType, {}, scale, function(imageURL) {
          try {
            Highcharts.downloadURL(imageURL, filename);
            if (successCallback) {
              successCallback();
            }
          } catch (e) {
            failCallback(e);
          }
        }, function() {
          var canvas = document.createElement('canvas'),
            ctx = canvas.getContext('2d'),
            imageWidth = svg.match(/^<svg[^>]*width\s*=\s*\"?(\d+)\"?[^>]*>/)[1] * scale,
            imageHeight = svg.match(/^<svg[^>]*height\s*=\s*\"?(\d+)\"?[^>]*>/)[1] * scale,
            downloadWithCanVG = function() {
              ctx.drawSvg(svg, 0, 0, imageWidth, imageHeight);
              try {
                Highcharts.downloadURL(window.navigator.msSaveOrOpenBlob ?
                  canvas.msToBlob() :
                  canvas.toDataURL(imageType), filename);
                if (successCallback) {
                  successCallback();
                }
              } catch (e) {
                failCallback(e);
              } finally {
                finallyHandler();
              }
            };
          canvas.width = imageWidth;
          canvas.height = imageHeight;
          if (window.canvg) {
            downloadWithCanVG();
          } else {
            objectURLRevoke = true;
            getScript(libURL + 'rgbcolor.js', function() {
              getScript(libURL + 'canvg.js', function() {
                downloadWithCanVG();
              });
            });
          }
        },
        failCallback,
        failCallback,
        function() {
          if (objectURLRevoke) {
            finallyHandler();
          }
        });
    }
  };
  
  
/**
 * Create a global getSVG method that takes an array of charts as an argument. The SVG is returned as an argument in the callback.
 */
Highcharts.getSVG = function(charts, options, callback) {
    var svgArr = [],
        top = 0,
        width = 0,
        line = false,
        addSVG = function(svgres, i) {
            // Grab width/height from exported chart
            var svgWidth = +svgres.match(
                    /^<svg[^>]*width\s*=\s*\"?(\d+)\"?[^>]*>/
                )[1],
                svgHeight = +svgres.match(
                    /^<svg[^>]*height\s*=\s*\"?(\d+)\"?[^>]*>/
                )[1],
                // Offset the position of this chart in the final SVG
                svg;
            //console.log("Chart Height: " + svgHeight);
            midWidth = 600;
            height1 = 400;
            height2 = 800;
            curTop = 0;
            curLeft = 0;
            switch (i) {
                case 0:
                    curTop = 0;
                    curLeft = 0;
                    break;
                case 1:
                    curTop = height1;
                    curLeft = 0;
                    break;
                case 2:
                    curTop = height2;
                    curLeft = 0;
                    break;
                
            }
            svg = svgres.replace('<svg', '<g transform="translate(' + curLeft + ', ' + curTop + ')"');
            

            svg = svg.replace('</svg>', '</g>');
            svgArr.push(svg);
        },
        exportChart = function(i) {
            if (i === charts.length) {
                return callback('<svg height="1200" width="600" version="1.1" xmlns="http://www.w3.org/2000/svg">' + svgArr.join('') + '</svg>');
            }
            charts[i].chart.getSVGForLocalExport(options, {}, function(err) {
                console.log("Failed to get SVG");
                console.error(err);
            }, function(svg) {
                addSVG(svg, i);
                return exportChart(i + 1); // Export next only when this SVG is received
            });
        };
    exportChart(0);
};              
/**
 * Create a global exportCharts method that takes an array of charts as an argument,
 * and exporting options as the second argument
 */
Highcharts.exportCharts = function(charts, options) {
    options = Highcharts.merge(Highcharts.getOptions().exporting, options);

    // Get SVG asynchronously and then download the resulting SVG
    Highcharts.getSVG(charts, options, function(svg) {
        //console.log(svg);
        Highcharts.downloadSVGLocal(svg, options, function(err) {
            console.log("Failed to export on client side");
        });
    });
};
Highcharts.setOptions({
    exporting: {
        enabled: false
    },
    credits: {
        enabled:false
    },
    lang: {
        //noData: "Your custom message" // no display way 1
    },
    plotOptions: {
        series: {
            tooltip: {
                valueDecimals: 2
            },
            dataLabels: {
                format: '{point.y:,.2f}'
            }

        },
        column: {
            dataLabels: {
                crop: false,
                overflow: 'none'
            }
        }
    },
    noData: {
        style: {
            fontWeight: 'bold',
            fontSize: '15px',
            color: '#303030'
        }
    },
})
Vue.component("intersection-autocomplete", {
    template:"#intersection-autocomplete",
    props: ["model", "items", "label"],
    data: function() {
        return {
            autocompleteModel:null
        }
    },
    created: function() {
        this.autocompleteModel = this.model;
    },
    watch: {
        autocompleteModel: function(val) {
            this.$emit('update:model', this.autocompleteModel);
        }
    }
});
Vue.component("direction-autocomplete", {
    template:"#direction-autocomplete",
    props: ["model", "items", "label"],
    data: function() {
        return {
            autocompleteModel:null
        }
    },
    created: function() {
        this.autocompleteModel = this.model;
    },
    watch: {
        model: function(val) {
            this.autocompleteModel = this.model;
        },
        autocompleteModel: function(val) {
            this.$emit('update:model', this.autocompleteModel);
        }
    }
});

var dashboardApp = new Vue({
    el: "#dashboardApp",
    vuetify: new Vuetify(),
    data: {
        helpDrawer:false,
        helpMode:"WELCOME",
        min: 0, //Minimum value of the slikder - Mileposts always start from 0
        max: 10, //Maximum value of the slider - this value will be overwritten
        slider: 40,
        range:[0,100], //The positions of the selectors in the slider
        
        stateTTTRIOptions: {
            chart:{type:"column"},
            title: {text: "Truck Travel Time Reliability Index"},
            plotOptions:{series:{dataLabels:{enabled:true}}},
            yAxis:{title:{text:"TTTRI"}},
            series:[{name:"TTTRI", data:[]}],
            plotOptions:{
                series:{
                    dataLabels:{
                        enabled:true, 
                        formatter: function () {
                            return Highcharts.numberFormat(this.y,2);
                        }
                    }, 
                    events:{
                        click: evt => {dashboardApp.mode="ROUTE_SUMMARY"}
                    }
                }
            },
            colors: ["rgb(72,103,130)"],
            legend:{enabled:false}
        },
        stateMilesUnconOptions: {
            chart:{type:"column"},
            title:{text: "Miles Uncongested (%)"},
            plotOptions:{series:{dataLabels:{enabled:true}}},
            yAxis:{title:{text:"Miles Uncongested (%)"}},
            series:[{name:"Miles Uncongested", data:[]}],
            plotOptions:{series:{dataLabels:{enabled:true},events:{click: evt => {dashboardApp.mode="ROUTE_SUMMARY"}}}},
            colors: ["rgb(242,222,133)"],
            legend:{enabled:false},
            tooltip: {valueSuffix: " %"}
        },
        statePercTotalCrashesOptions: {
            chart:{type:"column"},
            title:{text: "Truck Crashes (% of Total)"},
            plotOptions:{series:{dataLabels:{enabled:true}, events:{click: evt => {dashboardApp.mode="ROUTE_SUMMARY"}}}},
            yAxis:{title:{text:"% Tot. Crashes"}},
            series:[{name:"Truck Crashes", data:[]}],
            colors: ["rgb(192,5,5)"],
            legend:{enabled:false},
            tooltip: {valueSuffix: " %"}
        },

        routeTTTRIOptions: {
            chart:{type:"column"},
            title: {text: "Truck Travel Time Reliability Index"},
            plotOptions:{series:{dataLabels:{enabled:true}}},
            yAxis:{title:{text:"TTTRI"}},
            series:[{name:"TTTRI", data:[]}],
            plotOptions:{series:{dataLabels:{enabled:true},events:{click: evt => {dashboardApp.mode="ROUTE_DETAIL"}}}},
            colors: ["rgb(72,103,130)"],
            legend: {enabled:false}
        },
        routeMilesUnconOptions: {
            chart:{type:"column"},
            title:{text: "Miles Uncongested (%)"},
            plotOptions:{series:{dataLabels:{enabled:true}}},
            yAxis:{title:{text:"Miles Uncongested"}},
            series:[{name:"Miles Uncongested", data:[]}],
            plotOptions:{series:{dataLabels:{enabled:true},events:{click: evt => {dashboardApp.mode="ROUTE_DETAIL"}}}},
            colors: ["rgb(242,222,133)"],
            tooltip: {valueSuffix: " %"},
            legend: { enabled: false}
        },
        routePercTotalCrashesOptions: {
            chart:{type:"column"},
            title:{text: "Truck Crashes (% of Total)"},
            plotOptions:{series:{dataLabels:{enabled:true}, events:{click: evt => {dashboardApp.mode="ROUTE_DETAIL"}}}},
            yAxis:[{title:{text:"% Tot. Crashes"}}/*, {title:{text:"Passengers"}, opposite:true}*/], 
            series:[{name:"Large Truck", data:[]}/*,{name:"Other Truck", data:[]} ,{name:"Passenger", yAxis:1, type:"spline", data:[]}*/], 
            colors:["rgb(192,5,5)"],
            legend:{enabled:false},
            tooltip: {valueSuffix: " %"}
        },

        routeTttriByMilepostOptions: {
            title:{text:"Truck Travel Time Reliability (TTTR)"},
            plotOptions: {
                exporting:{sourceWidth:500, sourceHeight:100},
                exporting: {
                    enabled: false
                },
                series: {
                    point: {
                        events: {
                            click: function(event) {
                                dashboardApp.selectedYear = this.series.name;
                                dashboardApp.mode = "YEAR_DETAIL";
                            }
                        }
                    }
                }
            },
            yAxis:{ title:{ text:"TTTR" } },
            series:[],
            tooltip:{headerFormat:"<span style='font-size: 10px'>MP: {point.key}</span><br/>."}
        },
        routeCrashesByMilepostOptions: {
            title:{text:"Truck Crashes (% of Total) by Milepost"},
            plotOptions: {
                series: {
                    lineWidth: 0,
                    marker: {
                        enabled: true,
                        radius: 4
                    },
                    tooltip: {
                        valueSuffix: " %"
                    },
                    states: {
                        hover: {
                            lineWidthPlus: 0
                        }
                    },
                    /* marker: {
                        //radius: 0
                    }, */
                    point: {
                        events: {
                            click: function(event) {
                                dashboardApp.selectedYear = this.series.name;
                                dashboardApp.mode = "YEAR_DETAIL";
                                //dashboardApp.getTTTRDrilldown(this.series.name);
                                //dashboardApp.getCrashesDrilldown(this.series.name);
                            }
                        }
                    }
                }
            },
            noData: {
                style: {
                    fontWeight: 'bold',
                    fontSize: '15px',
                    color: '#303030'
                }
            },
            yAxis:{ title:{ text:"Crashes" } },
            series:[],
            tooltip:{headerFormat:"<span style='font-size: 10px'>MP: {point.key}</span><br/>."}
        },
        routeVolumeByMilepostOptions: {
            title:{text:"Truck Volume by Milepost"},
            plotOptions: {
                series: {
                    marker: {
                        radius: 0
                    },
                    tooltip: {
                        valueSuffix: " %"
                    },
                }
            },
            
            yAxis:{ title:{ text:"Truck Volume" } },
            series:[],
            tooltip:{headerFormat:"<span style='font-size: 10px'>MP: {point.key}</span><br/>."},
            legend:{enabled:false}
        },

        routeTttriCategoriesByMilepostOptions: {
            title:{text:"Truck Travel Time Reliability (TTTR)"},
            yAxis:{
                title:{
                    text:"TTTR"
                }
            },
            series: [],
            tooltip:{headerFormat:"<span style='font-size: 10px'>MP: {point.key}</span><br/>."}
        },
        routeCrashesCategoriesByMilepostOptions: {
            title:{text:"Crashes by Milepost"},
            yAxis:{ title:{ text:"Crash Rate" } },
            series:[],
            plotOptions: {
                series: {
                    lineWidth: 0,
                    marker: {
                        enabled: true,
                        radius: 4
                    },
                    tooltip: {
                        valueDecimals: 2
                    },
                    states: {
                        hover: {
                            lineWidthPlus: 0
                        }
                    },
                }
            },
            tooltip:{headerFormat:"<span style='font-size: 10px'>MP: {point.key}</span><br/>."},
            legend:{enabled:false}
        }, 
        routeSeverityByMilepostOptions: {
            title:{text:"Severity"},
            series:[],
            yAxis:{ title:{ text:"Severity Rate" } },
            plotOptions: {
                series: {
                    lineWidth: 0,
                    marker: {
                        enabled: true,
                        radius: 4
                    },
                    tooltip: {
                        valueDecimals: 2
                    },
                    states: {
                        hover: {
                            lineWidthPlus: 0
                        }
                    },
                }
            },
            tooltip:{headerFormat:"<span style='font-size: 10px'>MP: {point.key}</span><br/>."},
            legend:{enabled:false}
        },

        selectedIntersection: "",
        intersections: [],
        selectedDirection: "",
        directions: [],
        selectedYear: 0,
        years: ["2014", "2015", "2016"],
        mode:""
    },
    created: function() {
        fetch("dashboard/intersections")
            .then(function(response) {
                return response.json();
            })
            .then(data => {
                Vue.set(this, "intersections", data);
                this.selectedIntersection = this.intersections[0];
                this.selectedIntersectionForBar = this.intersections[0];
            })
        fetch("dashboard/year")
            .then(function(response) {
                return response.json();
            })
            .then(data => {
                Vue.set(this, "years", data);
                
                
            })
        this.mode = "STATE_SUMMARY"
        
        

    },
    methods: {
        loadStateTttriChart : function() {
            fetch("state_tttri")
                .then(function(response) {
                    return response.json();
                })
                .then(data => {
                    this.stateTTTRIOptions.series[0].data = data;
                })
        },
        loadStatePercTotalCrashesChart: function() {
            fetch("state_perc_total_crashes")
                .then(function(response) {
                    return response.json();
                })
                .then(data => {
                    this.statePercTotalCrashesOptions.series[0].data = [];
                    //this.statePercTotalCrashesOptions.series[1].data = [];
                    data.forEach(item => {
                        this.statePercTotalCrashesOptions.series[0].data.push([item[0], item[1]]);
                        //this.statePercTotalCrashesOptions.series[1].data.push([item[0], item[2]]);
                    })
                })
        },
        loadStateMilesUncongestedChart: function() {
            fetch("state_miles_uncongested")
                .then(function(response) {
                    return response.json();
                })
                .then(data => {
                    this.stateMilesUnconOptions.series[0].data = data;
                })
        },
        loadRouteTttriChart : function() {
            fetch("route_tttri?road=" + this.selectedIntersection + "&direction=" + this.selectedDirection[0])
                .then(function(response) {
                    return response.json();
                })
                .then(data => {
                    this.routeTTTRIOptions.series[0].data = [];
                    data.forEach(item => {
                        this.routeTTTRIOptions.series[0].data.push([item[0], item[1]]);
                    })
                })
        },
        loadRoutePercTotalCrashesChart: function() {
            fetch("route_perc_total_crashes?sri=" + this.selectedDirection[1])
                .then(function(response) {
                    return response.json();
                })
                .then(data => {
                    //debugger;
                    this.routePercTotalCrashesOptions.series[0].data = [];
                    //this.routePercTotalCrashesOptions.series[1].data = [];
                    //this.routePercTotalCrashesOptions.series[2].data = [];
                    //this.statePercTotalCrashesOptions.series[1].data = [];
                    data.forEach(item => {
                        this.routePercTotalCrashesOptions.series[0].data.push([item[0], item[1]]);
                        //this.routePercTotalCrashesOptions.series[1].data.push([item[0], item[2]]);
                        //this.routePercTotalCrashesOptions.series[2].data.push([item[0], item[3]]);
                        //this.statePercTotalCrashesOptions.series[1].data.push([item[0], item[2]]);
                    })
                })
        },
        loadRouteMilesUncongestedChart: function() {
            fetch("route_miles_uncongested?road=" + this.selectedIntersection + "&direction=" + this.selectedDirection[0])
                .then(function(response) {
                    return response.json();
                })
                .then(data => {
                    this.routeMilesUnconOptions.series[0].data = [];
                    data.forEach(item => {
                        this.routeMilesUnconOptions.series[0].data.push([item[0], item[1]]);
                    })
                })
        },
        loadRouteTttriByMilepostChart : function() {
            fetch("routeTttriByMilepost?intersection=" + this.selectedIntersection + "&direction=" + this.selectedDirection[0])
                .then(function(response) {
                    return response.json();
                })
                .then(data => {
                    this.routeTttriByMilepostDrilldown = false;
                    this.routeTttriByMilepostOptions.series = [];
                    Object.keys(data).forEach(seriesName => {
                        this.routeTttriByMilepostOptions.series.push({
                            name: seriesName,
                            type:"spline",
                            data: data[seriesName]
                        })
                    })
                    //this.milepostFilterChartOptions.series[0].data = data["2016"];
                    //debugger;
                    this.resetMilepostRangeSlider(data);
                    
                })
        },
        loadRouteCrashesByMilepostChart : function() {
            fetch("routeCrashesByMilepost?sri=" + this.selectedDirection[1])
                .then(function(response) {
                    return response.json();
                })
                .then(data => {
                    this.crashesByMilepostDrilldown = false;
                    this.routeCrashesByMilepostOptions.series = [];
                    Object.keys(data).forEach(seriesName => {
                        this.routeCrashesByMilepostOptions.series.push({
                            name: seriesName,
                            data: data[seriesName]
                        })
                    })
                    key = Object.keys(data)[0]
                    if (key == undefined) { // no display way 3
                        this.routeCrashesByMilepostOptions.lang.text="No Data To Dispaly";
                        //Vue.set(this.crashesByMilepostOptions, lang, {text:"No Data To Dispaly"})
                    } else {
                        //dashboardApp.max = Math.ceil(data[key][data[key].length-1][0]);
                        //dashboardApp.min = Math.floor(data[key][0][0]);
                        //dashboardApp.range = [dashboardApp.min, dashboardApp.max];
                    }
                })
        },
        loadRouteVolumeByMilepostChart : function() {
            fetch("routeVolumeByMilepost?sri=" + this.selectedDirection[1])
                .then(function(response) {
                    return response.json();
                })
                .then(data => {
                    this.volumeByMilepostDrilldown = false;
                    this.routeVolumeByMilepostOptions.series = [];
                    this.routeVolumeByMilepostOptions.series.push({
                            name: "Volume",
                            type:"spline",
                            data: data
                        })
                    
                    //key = Object.keys(data)[0]
                    //dashboardApp.max = Math.ceil(data[key][data[key].length-1][0]);
                    //dashboardApp.min = Math.floor(data[key][0][0]);
                    //dashboardApp.range = [dashboardApp.min, dashboardApp.max];
                })
        },
        loadRouteCategoriesTttriByMilepostChart: function() {
            fetch("routeTttriCategoriesByMilepost?intersection=" + this.selectedIntersection + "&direction=" + this.selectedDirection[0] + "&year=" + this.selectedYear)
                .then(function(response) {
                    return response.json();
                })
                .then(data => {
                    this.routeTttriByMilepostDrilldown = true;
                    this.routeTttriCategoriesByMilepostOptions.title.text = "Truck Travel Time Reliability (TTTR) - " + this.selectedYear;
                    this.routeTttriCategoriesByMilepostOptions.series = [];
                    Object.keys(data).forEach(seriesName => {
                        this.routeTttriCategoriesByMilepostOptions.series.push({
                            name: seriesName,
                            type:"spline",
                            data: data[seriesName]
                        })
                    })
                    this.resetMilepostRangeSlider(data);
                })
        },
        loadRouteCategoriesCrashesByMilepostChart: function() {
            fetch("routeCrashesCategoriesByMilepost?sri=" + this.selectedDirection[1] + "&year=" + this.selectedYear)
                .then(function(response) {
                    return response.json();
                })
                .then(data => {
                    this.crashesByMilepostDrilldown = true;
                   this.routeCrashesCategoriesByMilepostOptions.title.text = "Crash Rate by Milepost (Large Truck) - " + this.selectedYear;
                    this.routeCrashesCategoriesByMilepostOptions.series = [];
                    this.routeCrashesCategoriesByMilepostOptions.series.push({
                            name: "Large Truck",
                            data: data
                        })
                })
        },
        loadRouteSeverityByMilepostChart: function() {
            fetch("routeLargeTruckSeverityByMilepost?sri=" + this.selectedDirection[1] + "&year=" + this.selectedYear)
                .then(function(response) {
                    return response.json();
                })
                .then(data => {
                    this.crashesByMilepostDrilldown = true;
                   this.routeSeverityByMilepostOptions.title.text = "Severity Rate by Milepost (Large Truck) - " + this.selectedYear;
                    this.routeSeverityByMilepostOptions.series = [];
                    this.routeSeverityByMilepostOptions.series.push({
                            name: "Large Truck",
                            data: data
                        })
                })
        },
        
        resetMilepostRangeSlider: function(data) {
            key = Object.keys(data)[0]
            dashboardApp.max = Math.ceil(data[key][data[key].length-1][0]);
            dashboardApp.min = Math.floor(data[key][0][0]);
            dashboardApp.range = [dashboardApp.min, dashboardApp.max];
        },
        exportCharts: function() {
            //debugger;
            var chart1,chart2,chart3;
            if (this.mode == "STATE_SUMMARY") {
                chart1 = this.$refs.stateTTTRI;
                chart2 = this.$refs.statePercTotalCrashes;
                chart3 = this.$refs.stateMilesUncon;
            } else if (this.mode == "ROUTE_SUMMARY") {
                chart1 = this.$refs.routeTTTRI;
                chart2 = this.$refs.routePercTotalCrashes;
                chart3 = this.$refs.routeMilesUncon;
            } else if (this.mode == "ROUTE_DETAIL") {
                chart1 = this.$refs.routeTttriByMilepost;
                chart2 = this.$refs.routeCrashesByMilepost;
                chart3 = this.$refs.routeVolumeByMilepost;
            } else if (this.mode == "YEAR_DETAIL") {
                chart1 = this.$refs.routeTttriCategoriesByMilepost;
                chart2 = this.$refs.routeCrashesCategoriesByMilepost;
                chart3 = this.$refs.routeSeverityByMilepost;
            }
            /* if (this.routeTttriByMilepostDrilldown) {
                chart1 = this.$refs.routeTttriCategoriesByMilepost;
            } else {
                chart1 = this.$refs.routeTttriByMilepost;
            }
            if (this.crashesByMilepostDrilldown) {
                chart2 = this.$refs.routeCrashesCategoriesByMilepost;
            } else {
                chart2 = this.$refs.routeCrashesByMilepost;
            }
            if (this.volumeByMilepostDrilldown) {
                chart3 = this.$refs.routeVolumeCategoriesByMilepost;
            } else {
                chart3 = this.$refs.routeVolumeByMilepost;
            } */
            
            
            Highcharts.exportCharts([chart1, chart2, chart3], {
                type: 'application/pdf'
            });

        },
        exportExcel: function() {
            intersection = this.selectedIntersection;
            yearVal = this.selectedYear;
            direction = this.selectedDirection;
            if(this.mode == "STATE_SUMMARY"){
                window.location = "OnlyStateSummaryExcelReport";
            }else{
                window.location = "DashboardExcelReport?roadway="+this.selectedIntersection+"&direction=" + this.selectedDirection[0]+"&sri="+this.selectedDirection[1]+"&year="+this.selectedYear;
                console.log("ROute it is !!!!"+  this.selectedDirection[0]+this.selectedYear)
            }
            
        },
        gotoPrevStage: function() {
            if (this.mode == "STATE_SUMMARY") {
                
            } else if (this.mode == "ROUTE_SUMMARY") {
                this.mode = "STATE_SUMMARY"
            } else if (this.mode == "ROUTE_DETAIL") {
                this.mode = "ROUTE_SUMMARY"
            } else if (this.mode == "YEAR_DETAIL") {
                this.mode = "ROUTE_DETAIL"
            }
        }
    },
    watch: {
        mode: function(val) {
            if (this.mode == "STATE_SUMMARY") {
                this.loadStateTttriChart();
                this.loadStatePercTotalCrashesChart();
                this.loadStateMilesUncongestedChart();
                if (zoomToIntersection!=undefined) zoomToIntersection();
            } else if (this.mode == "ROUTE_SUMMARY") {
                this.loadRouteTttriChart();
                this.loadRoutePercTotalCrashesChart();
                this.loadRouteMilesUncongestedChart();
                if (zoomToIntersection!=undefined) zoomToIntersection(this.selectedIntersection);
            } else if (this.mode == "ROUTE_DETAIL") {
                this.loadRouteTttriByMilepostChart();
                this.loadRouteCrashesByMilepostChart();
                this.loadRouteVolumeByMilepostChart();
                if (zoomToIntersection!=undefined) zoomToIntersection(this.selectedIntersection);
            } else if (this.mode == "YEAR_DETAIL") {
                this.loadRouteCategoriesTttriByMilepostChart();
                this.loadRouteCategoriesCrashesByMilepostChart();
                this.loadRouteSeverityByMilepostChart();
                if (zoomToIntersection!=undefined) zoomToIntersection(this.selectedIntersection);
            }
        },
        selectedIntersection: function(value) {
            //mapZoomActive = false;
            if (zoomToIntersection!=undefined) zoomToIntersection(value);
            fetch("dashboard/directions?road=" + value)
                .then(function(response) {
                    return response.json();
                })
                .then(data => {
                    Vue.set(this, "directions", data);
                    this.selectedDirection = this.directions[0];
                    //this.loadFilterCharts();
                })
            
            
        },
        selectedDirection: function(value) {
            if (this.mode == "ROUTE_SUMMARY") {
                this.loadRouteTttriChart();
                this.loadRoutePercTotalCrashesChart();
                this.loadRouteMilesUncongestedChart();
            } else if (this.mode == "ROUTE_DETAIL") {
                this.loadRouteTttriByMilepostChart();
                this.loadRouteCrashesByMilepostChart();
                this.loadRouteVolumeByMilepostChart();
            } else if (this.mode == "YEAR_DETAIL") {
                this.loadRouteCategoriesTttriByMilepostChart();
                this.loadRouteCategoriesCrashesByMilepostChart();
                this.loadRouteSeverityByMilepostChart();
            }
            /* if (useHash) {
                checkHash();
                useHash = false;
            } else {
                this.selectedYear = "2014";
                this.loadFilterCharts();
            } */
            
            
            
            
            
        },
        selectedYear: function(value) {
            if (this.mode == "YEAR_DETAIL") {
                this.loadRouteCategoriesTttriByMilepostChart();
                this.loadRouteCategoriesCrashesByMilepostChart();
                this.loadRouteSeverityByMilepostChart();
            }
        },
        range: function(val) {
            if (this.mode == "ROUTE_DETAIL") {
                if (dashboardApp.$refs.routeTttriByMilepost) dashboardApp.$refs.routeTttriByMilepost.chart.xAxis[0].setExtremes(val[0], val[1]);
                if (dashboardApp.$refs.routeCrashesByMilepost) dashboardApp.$refs.routeCrashesByMilepost.chart.xAxis[0].setExtremes(val[0], val[1]);
                if (dashboardApp.$refs.routeVolumeByMilepost) dashboardApp.$refs.routeVolumeByMilepost.chart.xAxis[0].setExtremes(val[0], val[1]);
            } else if (this.mode == "YEAR_DETAIL") {
                if (dashboardApp.$refs.routeTttriCategoriesByMilepost) dashboardApp.$refs.routeTttriCategoriesByMilepost.chart.xAxis[0].setExtremes(val[0], val[1]);
                if (dashboardApp.$refs.routeCrashesCategoriesByMilepost) dashboardApp.$refs.routeCrashesCategoriesByMilepost.chart.xAxis[0].setExtremes(val[0], val[1]);
                if (dashboardApp.$refs.routeSeverityByMilepost) dashboardApp.$refs.routeSeverityByMilepost.chart.xAxis[0].setExtremes(val[0], val[1]);
            }
            /* if (dashboardApp.$refs.routeTttriByMilepost) 
            if (dashboardApp.$refs.routeTttriCategoriesByMilepost) 
            if (dashboardApp.$refs.routeCrashesByMilepost) 
            if (dashboardApp.$refs.routeVolumeByMilepost) 
            if (dashboardApp.$refs.routeCrashesCategoriesByMilepost)  */
            if (zoomToIntersection!=undefined) zoomToIntersection(this.selectedIntersection,val[0],val[1]);
            
        }
    }

})
                