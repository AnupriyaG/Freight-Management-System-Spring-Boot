var zoomToIntersection;
var mapZoomActive = true;


const url = 'https://js.arcgis.com/4.14/';

// esri-loader options
const options = { url };
esriLoader.loadModules([
    "esri/Map",
        "esri/views/MapView",
        "esri/layers/GeoJSONLayer",
        "esri/layers/FeatureLayer",
        "esri/core/watchUtils",
        "esri/tasks/support/Query",
                    "esri/tasks/QueryTask",
                    "esri/layers/support/LabelClass",
        "dojo/domReady!"
], options).then(([
    Map,
        MapView,
        GeoJSONLayer,
        FeatureLayer,
        WatchUtils,
        Query, QueryTask, LabelClass
]) => {
    var map = new Map({
        basemap: "streets"
    });

    mapView = new MapView({
        container: "mapViewDiv",
        center: [-74.741807, 40.179194],
        zoom: 8,
        map: map,
        padding: {
            top: 50,
            bottom: 0
        },
        ui: { components: [] },
        constraints: {
            snapToZoom: false
        }
    });

    roadRenderer = {
        type: "unique-value",  // autocasts as new UniqueValueRenderer()
        field: "ROUTE_SUBT",
        defaultSymbol: { type: "simple-line" },  // autocasts as new SimpleFillSymbol()
        "uniqueValueInfos": [
            {"symbol": { "type": "simple-line", "color": [0, 77, 168, 255], "width": 0.5 }, "value": "1", "label": "Interstate Highway", "description": ""},
            {"symbol": {"type": "simple-line", "color": [250, 52, 17, 255], "width": 0.5 }, "value": "2", "label": "US Highway", "description": ""},
            {"symbol": {"type": "simple-line", "color": [0, 168, 132, 255], "width": 0.5 }, "value": "3", "label": "State Route", "description": ""},
            {"symbol": {"type": "simple-line", "color": [0, 77, 168, 255], "width": 0.5 }, "value": "4", "label": "GSP", "description": ""}
        ]
    };
    hlRoadRenderer = {
        type: "unique-value",  // autocasts as new UniqueValueRenderer()
        field: "ROUTE_SUBT",
        defaultSymbol: { type: "simple-line" },  // autocasts as new SimpleFillSymbol()
        "uniqueValueInfos": [
            {"symbol": { "type": "simple-line", "color": [0, 77, 168, 255], "width": 3 }, "value": "1", "label": "Interstate Highway", "description": ""},
            {"symbol": {"type": "simple-line", "color": [250, 52, 17, 255], "width": 3 }, "value": "2", "label": "US Highway", "description": ""},
            {"symbol": {"type": "simple-line", "color": [0, 168, 132, 255], "width": 3 }, "value": "3", "label": "State Route", "description": ""},
            {"symbol": {"type": "simple-line", "color": [0, 77, 168, 255], "width": 3 }, "value": "4", "label": "GSP", "description": ""}
        ]
    };

    map.addMany([
        new GeoJSONLayer({
            id: "ROADS",
            url:"json/NJ_Roadway_With_type_1_2_3_4.json",
            renderer: roadRenderer
        }),
        new FeatureLayer({
            id: "ROADS1_HL",
            url:"http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_NJ_Roadway_New/MapServer/0",
            renderer: hlRoadRenderer,
            definitionExpression: "SRI = 'none'"
        }),
        new FeatureLayer({
            id: "ROADS2_HL",
            url:"http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_NJ_Roadway_New/MapServer/1",
            renderer: hlRoadRenderer,
            definitionExpression: "SRI = 'none'"
        }),
        new FeatureLayer({
            id: "ROADS3_HL",
            url:"http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_NJ_Roadway_New/MapServer/2",
            renderer: hlRoadRenderer,
            definitionExpression: "SRI = 'none'"
        }),
        
    ])

    mapView
        .when(function () {
            map.basemap.baseLayers.items[0].opacity = 0.3
            map.basemap.baseLayers.items[1].opacity = 0.3
        })
        .catch(errorCallback);
    //disable zooimng map on double-click
    mapView.on("double-click", function(evt) {
        evt.stopPropagation();
        console.info(evt);
          });
    //disable zooimng map on mouse-wheel
    mapView.on("mouse-wheel", function(event) {
        event.stopPropagation();
        });
    
    mapView.on("click", function (event){
        event.stopPropagation(); 
    });

    /*mapView.on("click", function (event) {
        var screenPoint = event.screenPoint;
        mapView.hitTest(screenPoint)
          .then(function (response) {
              //debugger;
              var graphic = response.results[0].graphic;
              var sldName = graphic.attributes.SLD_NAME;
              if (sldName != "" && sldName != undefined) {
                  dashboardApp.selectedIntersection = sldName;
                  //vueApp.selectedPeriod = -1;
                  
              }
              // do something with the result graphic
              mapView.goTo(graphic.geometry.extent.expand(1.25));
              setMunicipalityView("COUNTY = '"+countyName.toUpperCase()+"'")
              map.findLayerById("MUNICIPALITIES").visible = true;
              map.findLayerById("COUNTIES").visible = false;
              
              //TODO: write code to refrtesh the dashboard panel
          });
    })*/

    mapView.whenLayerView(map.findLayerById("ROADS")).then(function (layerView) {
        jsonLayer = map.findLayerById("ROADS");
        layerView.watch("updating", function(val) {
            layerView.queryExtent().then(function (response) {
                // go to the extent of all the graphics in the layer view
                if (mapZoomActive) {
                    mapView.goTo(response.extent.expand(1.1));
                    mapZoomActive = false;
                }
            });
        });
    });

    //To zoom the map as the intersection and the milepost(Range Slider)
    zoomToIntersection = function (intersectionName, start_mp, end_mp) {
        mapView.when(function () {
            return mapView.map.findLayerById("ROADS").when(function () {
                var query = new Query();
                query.where = "SLD_NAME = '"+intersectionName+"'";
                query.outFields = ["*"];
                query.returnGeometry = true;
                if (start_mp || end_mp) { //To handle the case where if only one end of slider is moved 
                    sql = "SLD_NAME = '" + intersectionName + "' AND MP_START >= " + start_mp + " AND MP_END <= " + end_mp
                    //sql = "SLD_NAME = '" + intersectionName + "'";
                } else if (intersectionName) {
                    sql = "SLD_NAME = '" + intersectionName + "'";
                } else {
                    mapView.whenLayerView(map.findLayerById("ROADS")).then(function (layerView) {
                        jsonLayer = map.findLayerById("ROADS");
                            layerView.queryExtent().then(function (response) {
                                // go to the extent of all the graphics in the layer view
                                    mapView.goTo(response.extent.expand(1.1));
                                    mapZoomActive = false;
                                
                            });
                        
                    });
                }
                console.log("DefinitionExpression: " + sql)
                mapView.map.findLayerById("ROADS1_HL").definitionExpression = sql;
                mapView.map.findLayerById("ROADS2_HL").definitionExpression = sql;
                mapView.map.findLayerById("ROADS3_HL").definitionExpression = sql;
                return mapView.map.findLayerById("ROADS3_HL").queryFeatures(query);
            });
        }).then(function (response) {
            mapView.map.findLayerById("ROADS3_HL")
                .when(function () {
                    return mapView.map.findLayerById("ROADS3_HL").queryExtent();
                })
                .then(function (response) {
                    if (intersectionName) mapView.goTo(response.extent.expand(1.2));
                });
            //mapView.map.findLayerById("ROADS3_HL").queryExtent
            //extent = response.features[0].geometry.extent.expand(2)
            //mapView.goTo(extent);
            
            
        }).catch(errorCallback);
    }

    function errorCallback(error) {
        console.log("error:", error);
    }
});