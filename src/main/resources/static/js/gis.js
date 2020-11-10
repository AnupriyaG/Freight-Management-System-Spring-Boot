var map;
var mapView;
var performQuery;
var focusSTIPFilterLayer;
var select;
var grid;
var selectFeatureFromGraphicSearch;
let highlight, csvLayerView, roads0LayerView, roads1LayerView, roads2LayerView;
var segmentSelectionMode = false;
var selectedSegmentsForCustomReport;
var generateSelectedSegmentList;
var arcgisSelectAllFeaturesInLayerView, arcgisSelectByGeometryInLayerView, arcgisSelectByFieldValueInLayerView, arcgisSelectBySQLInLayerView, arcgisGetQueryResults, arcgisUnhighlightAllFeatures;
require([
    // ArcGIS
    "esri/WebMap",
    "esri/views/MapView",
    // Layers
    "esri/layers/FeatureLayer",
    "esri/layers/GroupLayer",
    "esri/layers/GraphicsLayer",
    "esri/Graphic",
    // Widgets
    "esri/widgets/Home",
    "esri/widgets/Zoom",
    "esri/widgets/Compass",
    "esri/widgets/Search",
    "esri/widgets/Legend",
    "esri/widgets/BasemapToggle",
    "esri/widgets/BasemapGallery/support/PortalBasemapsSource",
    "esri/widgets/ScaleBar",
    "esri/widgets/Attribution",
    "esri/widgets/LayerList",
    "esri/widgets/BasemapGallery",
    "esri/widgets/Sketch/SketchViewModel",
    "esri/geometry/Circle","esri/geometry/Polyline",
    "dgrid/OnDemandGrid",
    "dgrid/Selection",
    "dgrid/extensions/ColumnHider",
    "dstore/legacy/StoreAdapter",
    "dojo/store/Memory",
    // Bootstrap
    "bootstrap/Collapse",
    "bootstrap/Dropdown",
    "esri/layers/support/Field",
    "esri/layers/support/LabelClass",
    // Calcite Maps
    "calcite-maps/calcitemaps-v0.10",
    // Calcite Maps ArcGIS Support
    "calcite-maps/calcitemaps-arcgis-support-v0.10",
    "dojo/domReady!"
], function (
    WebMap, MapView,
    FeatureLayer, GroupLayer, GraphicsLayer, Graphic,
    Home, Zoom, Compass, Search, Legend, BasemapToggle, PortalBasemapsSource, ScaleBar,
    Attribution, LayerList, BasemapGallery, SketchViewModel, Circle, Polyline,
    OnDemandGrid, Selection, ColumnHider, StoreAdapter, Memory,
    Collapse, Dropdown, Field, LabelClass,
    CalciteMaps, CalciteMapArcGISSupport
) {
    var paths = [
         [  // second path
         [-97.06326,32.759],
         [-97.06298,32.755]
        ]
       ];
       
       var line = new Polyline({
         hasZ: false,
         hasM: true,
         paths: paths,
         spatialReference: { wkid: 4326 }
       });
    var segmentGraphic = new Graphic({
        geometry: line,
        attributes: {
            "OBJECTID": 1,
            "SRI":"something here",
            "MP_START": 1.0,
            "MP_END": 1.1,
            "SLD_NAME": "",
            "DIRECTION" : ""
        }
      });
    var stipGraphic = new Graphic({
        geometry: line,
        attributes: {
            "OID":1,
            "YEAR":"",
            "DBNUM":"",
            "CIS_PROGRAM_CATEGORY":"",
            "PROJECT_NAME":""
        }
    })
    selectedSegmentsForCustomReport = [segmentGraphic]
    selectedSTIPProjects=[stipGraphic]
    /******************************************************************
     * Create the map, view and widgets
     ******************************************************************/
    map = new WebMap({
        basemap: "topo-vector"
    });

    // View
    mapView = new MapView({
        container: "mapViewDiv",
        center: [-74.741807, 40.179194],
        zoom: 9,
        map: map,
        padding: {
            top: 50,
            bottom: 0
        },
        ui: { components: [] }
    });

    // Popup and panel sync
    mapView.when(function () {
        CalciteMapArcGISSupport.setPopupPanelSync(mapView);
    });

    // Search - add to navbar
    var searchWidget = new Search({
        container: "searchWidgetDiv",
        view: mapView
    });
    CalciteMapArcGISSupport.setSearchExpandEvents(searchWidget);

    // Map widgets
    var home = new Home({
        view: mapView
    });
    mapView.ui.add(home, "top-left");

    var zoom = new Zoom({
        view: mapView
    });
    mapView.ui.add(zoom, "top-left");

    var compass = new Compass({
        view: mapView
    });
    mapView.ui.add(compass, "top-left");

    var basemapToggle = new BasemapToggle({
        view: mapView,
        secondBasemap: "satellite"
    });
    mapView.ui.add(basemapToggle, "bottom-right");

    var scaleBar = new ScaleBar({
        view: mapView
    });
    mapView.ui.add(scaleBar, "bottom-left");

    var attribution = new Attribution({
        view: mapView
    });
    mapView.ui.add(attribution, "manual");

    // Panel widgets - add legend
    var legendWidget = new Legend({
        container: "legendDiv",
        view: mapView
    });
    var basemapGallery = new BasemapGallery({
        container: "basemapDiv",
        view: mapView,
        source: {
            portal: {
              url: "https://www.arcgis.com",
              useVectorBasemaps: true  // Load vector tile basemaps
            },
            //query: "title:\"United States Basemaps\" AND owner:Esri_cy_US",
            filterFunction: function(item) {
                baseLayers = ["0120_Imagery_Hybrid_Title", "0130_Streets_Title", "0210_Topographic_Title", "0320_Light_Gray_Canvas_Title", "0420_OpenStreetMap"]
                if (baseLayers.includes(item.portalItem.name)) return true;
                else return false;
            }
          }
    });

    var uniqueParentItems = [];
    var layerList = new LayerList({
        container: "layerListDiv",
        view: mapView,
        listItemCreatedFunction: function (event) {
            const item = event.item;
            //debugger;
            if (item.layer.type != "group") {
                // don't show legend twice
                item.panel = {
                    content: "legend",
                    open: false
                };
            } else {
                if(!item.parent){
                    //only add the item if it has not been added before
                    if(!uniqueParentItems.includes(item.title)){
                      uniqueParentItems.push(item.title);
                      item.watch("visible", function(event){
                        subLayers = item.layer.layers.items;
                        subLayers.forEach(subLayer => {
                            subLayer.visible = event
                        })
                        //console.info(event);
                      });
                    }
                  }
                /* subLayers.forEach(subLayer => {
                    subLayer.visible
                }) */
            }
        }
    });

    layerList.on("trigger-action", function(a,b) {
        alert("Triggered!!!!")
    })

    criticalFreightPopupTemplate = {
        title: "Critical Freight",
        content: [
            {
                type: "fields",
                fieldInfos: [
                    {
                        fieldName: "SLD_NAME",
                        label: "Route"
                    },
                    {
                        fieldName: "DIRECTION",
                        label: "Direction"
                    },
                    {
                        fieldName: "Start",
                        label: "Start"
                    },
                    {
                        fieldName: "End",
                        label: "End"
                    },
                    {
                        fieldName: "MPO",
                        label: "MPO"
                    },
                    {
                        fieldName: "County",
                        label: "COUNTY"
                    },
                    {
                        fieldName: "Municipali",
                        label: "MUNICIPALITY"
                    }
                ]
            }
        ]
    };
    truckParkingPopupTemplate = {
        title: "Truck Parking",
        content: [
            {
                type: "fields",
                fieldInfos: [
                    {
                        fieldName: "Name",
                        label: "Name"
                    },
                    {
                        fieldName: "Route",
                        label: "Route"
                    },
                    {
                        fieldName: "Direction",
                        label: "Direction"
                    },
                    {
                        fieldName: "Mile_Post",
                        label: "Milepost"
                    },
                    {
                        fieldName: "Total_Spac",
                        label: "Total Spaces"
                    },
                    {
                        fieldName: "Truck_Spac",
                        label: "Truck Spaces"
                    }
                ]
            }
        ]
    };
    roadwayPopupTemplate = {
        title: "Roadway",
        content: [
            {
                type: "fields",
                fieldInfos: [
                    {
                        fieldName: "RTE_LABEL",
                        label: "Route"
                    },
                    {
                        fieldName: "MP_START",
                        label: "Start Milepost",
                        format: {
                            places:2
                        }
                    },
                    {
                        fieldName: "MP_END",
                        label: "End Milepost",
                        format: {
                            places:2
                        }
                    },
                    {
                        fieldName: "DIRECTION",
                        label: "Direction"
                    },
                    {
                        fieldName: "SRI",
                        label: "SRI"
                    }
                ]
            }
        ]
    };

    map.addMany([
        new GraphicsLayer({ //Layer used for graphic selection highlight
            id: "DRAW",
            listMode: "hide"
        }),
        new FeatureLayer({
            id: "STIP_HL",
            listMode: "hide",
            geometryType: "polyline",
            objectIdField : "OBJECTID",
            legendEnabled:false,
            fields:[
                {
                    name: "OID",
                    type: "oid",
                    editable:true
                },
                {
                    name: "YEAR",
                    type: "string",
                    editable:true
                },
                {
                    name: "DBNUM",
                    type: "string",
                    editable:true
                },
                {
                    name: "CIS_PROGRAM_CATEGORY",
                    type: "string",
                    editable:true
                },
                {
                    name: "PROJECT_NAME",
                    type: "string",
                    editable:true
                },
                
            ],
            outFields: ["*"],
            source: selectedSTIPProjects,
            renderer: {
                type: "simple",
                symbol: { type: "simple-line", width: 10, color: [170, 255, 0, 0.53] }
            },
        }),
        new FeatureLayer({
            id: "SEGMENT_HL",
            listMode: "hide",
            geometryType: "polyline",
            objectIdField : "OBJECTID",
            legendEnabled:false,
            fields: [
                {
                    name: "OBJECTID",
                    type: "oid",
                    editable: true
                }, {
                    name: "SRI",
                    type: "string",
                    editable: true
                }, {
                    name: "MP_START",
                    type: "double",
                    editable: true
                }, {
                    name: "MP_END",
                    type: "double",
                    editable: true
                }, {
                    name: "SLD_NAME",
                    type: "string",
                    editable: true
                }, {
                    name: "DIRECTION",
                    type: "string",
                    editable: true
                }
            ],
            outFields: ["*"],
            source: selectedSegmentsForCustomReport,
            renderer: {
                type: "simple",
                symbol: { type: "simple-line", width: 10, color: [170, 255, 0, 0.53] }
            },
            labelingInfo: [
                new LabelClass({
                    labelExpressionInfo: { expression: "Round($feature.MP_START,2)" },
                    symbol: {
                      type: "text",  // autocasts as new TextSymbol()
                      color: "black",
                      haloSize: 1,
                      haloColor: "white"
                    }
                  })
            ]
            //popupTemplate: roadwayPopupTemplate
        }),
        new GroupLayer({
            title: "Roadway Network",
            layers: [
                new FeatureLayer({
                    id: "ROADWAY0",
                    url: "http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_NJ_Roadway_New/MapServer/0",
                    outFields: ["*"],
                    popupEnabled: true,
                    renderer: {
                        type: "unique-value",  // autocasts as new UniqueValueRenderer()
                        field: "ROUTE_SUBT",
                        defaultSymbol: { type: "simple-line" },  // autocasts as new SimpleFillSymbol()
                        legendOptions: {
                            title: "Road Type"
                        },
                        uniqueValueInfos: [
                            {
                                "symbol": {
                                    "type": "simple-line",
                                    "color": [0, 77, 168, 255],
                                    "width": 0.5
                                },
                                "value": "1",
                                "label": "Interstate Highway",
                                "description": ""
                            },
                            {
                                "symbol": {
                                    "type": "simple-line",
                                    "color": [250, 52, 17, 255],
                                    "width": 0.5
                                },
                                "value": "2",
                                "label": "US Highway",
                                "description": ""
                            }
                        ]
                    },
                    popupTemplate: roadwayPopupTemplate
                }), new FeatureLayer({
                    id: "ROADWAY1",
                    url: "http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_NJ_Roadway_New/MapServer/1",
                    outFields: ["*"],
                    popupEnabled: true,
                    renderer: {
                        type: "unique-value",  // autocasts as new UniqueValueRenderer()
                        field: "ROUTE_SUBT",
                        defaultSymbol: { type: "simple-line" },  // autocasts as new SimpleFillSymbol()
                        legendOptions: {
                            title: "Road Type"
                        },
                        "uniqueValueInfos": [
                            {
                                "symbol": {
                                    "type": "simple-line",
                                    "color": [0, 77, 168, 255],
                                    "width": 0.5
                                },
                                "value": "1",
                                "label": "Interstate Highway",
                                "description": ""
                            },
                            {
                                "symbol": {
                                    "type": "simple-line",
                                    "color": [250, 52, 17, 255],
                                    "width": 0.5
                                },
                                "value": "2",
                                "label": "US Highway",
                                "description": ""
                            },
                            {
                                "symbol": {
                                    "type": "simple-line",
                                    "color": [0, 168, 132, 255],
                                    "width": 0.5
                                },
                                "value": "3",
                                "label": "State Route",
                                "description": ""
                            },
                            {
                                "symbol": {
                                    "type": "simple-line",
                                    "color": [0, 77, 168, 255],
                                    "width": 0.5
                                },
                                "value": "4",
                                "label": "GSP",
                                "description": ""
                            }
                        ]

                    },
                    popupTemplate: roadwayPopupTemplate
                }), new FeatureLayer({
                    id: "ROADWAY2",
                    url: "http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_NJ_Roadway_New/MapServer/2",
                    outFields: ["*"],
                    popupEnabled: true,
                    renderer: {
                        type: "unique-value",  // autocasts as new UniqueValueRenderer()
                        field: "ROUTE_SUBT",
                        defaultSymbol: { type: "simple-line" },  // autocasts as new SimpleFillSymbol()
                        legendOptions: {
                            title: "Road Type"
                        },
                        "uniqueValueInfos": [
                            {
                                "symbol": {
                                    "type": "simple-line",
                                    "color": [
                                        0,
                                        77,
                                        168,
                                        255
                                    ],
                                    "width": 0.5
                                },
                                "value": "1",
                                "label": "Interstate Highway",
                                "description": ""
                            },
                            {
                                "symbol": {
                                    "type": "simple-line",
                                    "color": [
                                        250,
                                        52,
                                        17,
                                        255
                                    ],
                                    "width": 0.5
                                },
                                "value": "2",
                                "label": "US Highway",
                                "description": ""
                            },
                            {
                                "symbol": {
                                    "type": "simple-line",
                                    "color": [
                                        0,
                                        168,
                                        132,
                                        255
                                    ],
                                    "width": 1
                                },
                                "value": "3",
                                "label": "State Route",
                                "description": ""
                            },
                            {
                                "symbol": {
                                    "type": "simple-line",
                                    "color": [
                                        0,
                                        77,
                                        168,
                                        255
                                    ],
                                    "width": 0.5
                                },
                                "value": "4",
                                "label": "GSP",
                                "description": ""
                            },
                            {
                                "symbol": {
                                    "type": "simple-line",
                                    "color": [
                                        230,
                                        230,
                                        0,
                                        255
                                    ],
                                    "width": 0.5
                                },
                                "value": "5",
                                "label": "County Road",
                                "description": ""
                            }
                        ]
                    },
                    popupTemplate: roadwayPopupTemplate
                }),
            ]
        }),
        new GroupLayer({
            title: "Truck Parking",
            visible: false,
            layers: [
                new FeatureLayer({
                    id: "TRUCKPARKPUBLIC",
                    title: "Public Truck Parking",
                    url: "http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_Combined/MapServer/5",
                    outFields: ["*"],
                    popupEnabled: true,
                    popupTemplate: truckParkingPopupTemplate
                }), new FeatureLayer({
                    id: "TRUCKPARKPRIVATE",
                    title: "Private Truck Parking",
                    url: "http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_Combined/MapServer/6",
                    outFields: ["*"],
                    popupEnabled: true,
                    popupTemplate: truckParkingPopupTemplate
                }),
            ]
        }),
        new GroupLayer({
            title: "Critical Freight Corrridors",
            visible: false,
            layers: [
                new FeatureLayer({
                    ID: "CRITICALFREIGHTRURAL",
                    title: "Critical Rural Freight Corridors",
                    url: "http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_Combined/MapServer/1",
                    outFields: ["*"],
                    popupEnabled: true,
                    popupTemplate: criticalFreightPopupTemplate
                }), new FeatureLayer({
                    ID: "CRITICALFREIGHTRURALURBAN",
                    title: "Critical Rural/Urban Freight Corridors",
                    url: "http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_Combined/MapServer/2",
                    outFields: ["*"],
                    popupEnabled: true,
                    popupTemplate: criticalFreightPopupTemplate
                }), new FeatureLayer({
                    ID: "CRITICALFREIGHTURBAN",
                    title: "Critical Urban Freight Corridors",
                    url: "http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_Combined/MapServer/3",
                    outFields: ["*"],
                    popupEnabled: true,
                    popupTemplate: criticalFreightPopupTemplate
                }),
            ]
        }),
        new FeatureLayer({
            ID: "counties",
            title: "Counties",
            url: "http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_Combined/MapServer/7",
            outFields: ["*"],
            popupEnabled: true,
            visible: false,
            popupTemplate: {
                // autocasts as new PopupTemplate()
                title: "{COUNTY_LAB}"
            }
        }),
        new FeatureLayer({
            id: "STIP",
            title: "STIP Projects",
            visible: false,
            url: "http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/STIP_FMS/FeatureServer/0",
            outFields: [
                "DBNUM", "YEAR", "COUNTY",
                "MPO", "MUNC1", "CIS_PROGRAM_CATEGORY",
                "CIS_SUBCATEGORY", "ROUTE", "STIPCATEGORY", "PROJECT_NAME"
            ],
            popupEnabled: true,
            popupTemplate: {
                // autocasts as new PopupTemplate()
                title: "{PROJECT_NAME}",
                content: [
                    {
                        type: "fields",
                        fieldInfos: [
                            {
                                fieldName: "DBNUM",
                                label: "DBNUM"
                            },
                            {
                                fieldName: "YEAR",
                                label: "YEAR"
                            }
                        ]
                    }
                ]
            }
        }), ,
        new FeatureLayer({
            id: "CUSTOM",
            title: "Custom Projects",
            visible: false,
            url: "http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_Custom_Projects/MapServer/0",
            outFields: [
                "*"
            ],
            popupEnabled: true,
            popupTemplate: {
                // autocasts as new PopupTemplate()
                title: "{ROUTE}",
                content: [
                    {
                        type: "fields",
                        fieldInfos: [
                            {
                                fieldName: "ROUTE",
                                label: "Route"
                            },
                            {
                                fieldName: "SRI",
                                label: "SRI"
                            },
                            {
                                fieldName: "MP_START",
                                label: "MP Start"
                            },
                            {
                                fieldName: "MP_END",
                                label: "MP end"
                            },
                            {
                                fieldName: "TOTAL_SCORE",
                                label: "Total Score"
                            }
                        ]
                    }
                ]
            }
        }),
    ]);

    /**
     * Performs a query based on a given field and zooms to the extent
     */
    performQuery = function (field, value) {
        arcgisLayerViewFromLayer("STIP", layerView => {
            arcgisSelectByFieldValueInLayerView(layerView, field, value, result => {
                arcGISHighlightFeatures("STIP_HL", result.features, true)
            })
        })
        stipLayer = map.findLayerById("STIP");
        stipLayer.definitionExpression = field + " = '" + value + "'";
        /* mapView.whenLayerView(stipLayer).then(function (layerView) {
            setTimeout(function () {
                layerView.queryExtent().then(function (response) {
                    console.log(response);
                    if (response.count > 0) mapView.goTo(response.extent);
                });
            }, 1000)
        }); */
    }

    /**
     * Hides roadways to make STIP projects more prominent
     */
    focusSTIPFilterLayer = function (enable) {
        if (enable) {
            map.findLayerById("ROADWAY0").visible = false;
            map.findLayerById("ROADWAY1").visible = false;
            map.findLayerById("ROADWAY2").visible = false;
            map.findLayerById("STIP").visible = true;
        } else {
            map.findLayerById("ROADWAY0").visible = true;
            map.findLayerById("ROADWAY1").visible = true;
            map.findLayerById("ROADWAY2").visible = true;
        }
    }


    map.findLayerById("STIP").on("layerview-create", function(event){csvLayerView = event.layerView;});
    map.findLayerById("ROADWAY0").on("layerview-create", function(event){roads0LayerView = event.layerView;});
    map.findLayerById("ROADWAY1").on("layerview-create", function(event){roads1LayerView = event.layerView;});
    map.findLayerById("ROADWAY2").on("layerview-create", function(event){roads2LayerView = event.layerView;});
    // Listen to the click event on the map view.
    mapView.on("click", function(evt) {
        if (segmentSelectionMode) {
            if (evt.native.ctrlKey) {
                map.findLayerById("ROADWAY0").popupEnabled = false;
                map.findLayerById("ROADWAY1").popupEnabled = false;
                map.findLayerById("ROADWAY2").popupEnabled = false;
                queryGeometry = new Circle({center: evt.mapPoint, radius:5})
                arcgisSelectByGeometryInLayer("SEGMENT_HL", queryGeometry, results => {
                    if (results.features.length>0) { //delete highlight if it already exists
                        arcgisUnhighlightFeatures("SEGMENT_HL", results.features, generateSelectedSegmentList);
                    } else { //add highlight
                        roadsResultHandler = function(results) {
                            arcGISHighlightFeatures("SEGMENT_HL", results.features, false, generateSelectedSegmentList);
                            console.log(results)
                        }
                        arcgisSelectByGeometryInLayerView(roads0LayerView, queryGeometry, roadsResultHandler, true);
                        arcgisSelectByGeometryInLayerView(roads1LayerView, queryGeometry, roadsResultHandler, true);
                        arcgisSelectByGeometryInLayerView(roads2LayerView, queryGeometry, roadsResultHandler, true);
                        
                    }
                })
                
            }
        }
            
    });

    generateSelectedSegmentList = function() {
        arcgisSelectAllFeaturesInLayer("SEGMENT_HL", results => {
            console.log("Generating segment list: " + results.features.length);
            segmentResults = {};
            results.features.forEach(item => {
                sri = item.attributes.SRI;
                mp_start = item.attributes.MP_START;
                mp_end = item.attributes.MP_END;
                if (segmentResults[sri]) {
                    this_selection = segmentResults[sri];
                    if (this_selection[2] > mp_start) this_selection[2] = mp_start;
                    if (this_selection[3] < mp_end) this_selection[3] = mp_end;
                } else {
                    segmentResults[sri] = [item.attributes.SLD_NAME, item.attributes.DIRECTION, mp_start, mp_end];
                }
            })
            vueApp.segmentSearchResults = segmentResults;
        })
    }

    setUpSketchViewModel();
    function setUpSketchViewModel() {
        // polygonGraphicsLayer will be used by the sketchviewmodel
        // show the polygon being drawn on the view
        polygonGraphicsLayer = new GraphicsLayer({ listMode: "hide" });
        map.add(polygonGraphicsLayer);

        // create a new sketch view model set its layer
        sketchViewModel = new SketchViewModel({
            view: mapView,
            layer: polygonGraphicsLayer,
            pointSymbol: {
                type: "simple-marker",
                color: [255, 255, 255, 0],
                size: "1px",
                outline: {
                    color: "gray",
                    width: 0
                }
            }
        });
    }
    select = function (type) {
        map.findLayerById("DRAW").removeAll()
        mapView.popup.close();
        // ready to draw a polygon
        sketchViewModel.create(type);
    }
    sketchViewModel.on("create", function (event) {
        if (event.state === "complete") {
            // this polygon will be used to query features that intersect it
            polygonGraphicsLayer.remove(event.graphic);
            selectFeatures(event.graphic.geometry);
        }
    });
    function selectFeatures(geometry) {
        segmentSelectionMode = true;
        mapView.graphics.removeAll();
        if (csvLayerView) {
            // create a query and set its geometry parameter to the
            // polygon that was drawn on the view
            const query = {
                geometry: geometry,
                outFields: ["*"],
                returnGeometry:true
            };

            // query graphics from the csv layer view. Geometry set for the query
            // can be polygon for point features and only intersecting geometries are returned
            csvLayerView
                .queryFeatures(query)
                .then(function (results) {
                    const graphics = results.features;
                    if (graphics.length > 0) {
                        mapView.goTo(geometry.extent.expand(2));
                        
                    }

                    // remove existing highlighted features
                    if (highlight) {
                        highlight.remove();
                    }

                    // highlight query results
                    highlight = csvLayerView.highlight(graphics);

                    const data = graphics.map(function (feature, i) {
                        return (
                            Object.keys(feature.attributes)
                                .filter(function (key) {
                                    // get fields that exist in the grid
                                    return gridFields.indexOf(key) !== -1;
                                })
                                // need to create key value pairs from the feature
                                // attributes so that info can be displayed in the grid
                                .reduce(function (obj, key) {
                                    obj[key] = feature.attributes[key];
                                    return obj;
                                }, {})
                        );
                    });

                    vueApp.graphicsSearchResults = data;


                })
                .catch(errorCallback);
                roads0LayerView.queryFeatures(query).then(results => processRoadSegmentsGeometryQueryResults(results)).catch(errorCallback);
                roads1LayerView.queryFeatures(query).then(results => processRoadSegmentsGeometryQueryResults(results)).catch(errorCallback);
                roads2LayerView.queryFeatures(query).then(results => processRoadSegmentsGeometryQueryResults(results)).catch(errorCallback);
                
        }
    }

    function processRoadSegmentsGeometryQueryResults(results) {
        if (results.features.length>0) {
            arcGISHighlightFeatures("SEGMENT_HL", results.features, true, generateSelectedSegmentList)
            //generateSelectedSegmentList();
            //processSegmentSelection(results);
        }
        
    }

    

    /* function processSegmentSelection(results) {
        segmentResults = {};
        results.features.forEach(item => {
            sri = item.attributes.SRI;
            mp_start = item.attributes.MP_START;
            mp_end = item.attributes.MP_END;
            if (segmentResults[sri]) {
                //debugger;
                this_selection = segmentResults[sri];
                if (this_selection[2] > mp_start) this_selection[2] = mp_start;
                if (this_selection[3] < mp_end) this_selection[3] = mp_end;
            } else {
                segmentResults[sri] = [item.attributes.SLD_NAME, item.attributes.DIRECTION, mp_start, mp_end];
            }
        })
        vueApp.segmentSearchResults = segmentResults;

        combinedSegmentResults = {};
        results.features.forEach(item => {
            sri = item.attributes.SRI;
            mp_start = item.attributes.MP_START;
            mp_end = item.attributes.MP_END;
            if (combinedSegmentResults[sri]) {
                //debugger;
                this_segment_array = combinedSegmentResults[sri][2];
                if (! this_segment_array.includes(mp_start)) this_segment_array.push(mp_start);
                
            } else {
                combinedSegmentResults[sri] = [item.attributes.SLD_NAME, item.attributes.DIRECTION, [mp_start]];
            }
        })
        vueApp.combinedSegmentSearchResults = combinedSegmentResults;
    } */

    const gridFields = [
        "OID",
        "DBNUM",
        "COUNTY",
        "PROJECT_NAME"
    ];
    

    function clearUpSelection() {
        mapView.graphics.removeAll();
    }

    function errorCallback(error) {
        console.log("error:", error);
    }

    selectFeatureFromGraphicSearch = function (id) {
        const query = {
            objectIds: [parseInt(id)],
            outFields: ["*"],
            returnGeometry: true
        };

        // query the csvLayerView using the query set above
        csvLayerView
            .queryFeatures(query)
            .then(function (results) {
                const graphics = results.features;
                // remove all graphics to make sure no selected graphics
                mapView.graphics.removeAll();

                // create a new selected graphic
                const selectedGraphic = new Graphic({
                    geometry: graphics[0].geometry,
                    attributes: graphics[0].attributes,
                    layer: graphics[0].layer,
                    popupTemplate: graphics[0].layer.popupTemplate,
                    symbol: {
                        type: "simple-line",
                        style: "solid",
                        color: "orange",
                        size: "12px", // pixels
                        outline: {
                            // autocasts as new SimpleLineSymbol()
                            color: [255, 255, 0],
                            width: 2 // points
                        }
                    }
                });

                // add the selected graphic to the view
                // this graphic corresponds to the row that was clicked
                mapView.graphics.add(selectedGraphic);
                mapView.popup.open({
                    fetchFeatures: true,
                    features: [selectedGraphic],
                    updateLocationEnabled: true
                });
                //mapView.goTo(graphics[0].geometry.extent.expand(2));
            })
            .catch(errorCallback);
    }

    arcgisLayerViewFromLayer = function(layerID, resultHandler) {
        mapView.
            whenLayerView(map.findLayerById(layerID)).
            then(layerView => {
               resultHandler(layerView);
            });
    }

    arcgisLayerViewFromLayer("STIP", function(layerView) {
        layerView.watch("updating", function (newVal, oldVal, prop, target) {
            if (!newVal) {
                vueApp.filterResultsLoading = false;
                layerView.queryExtent().then(function (response) {
                    console.log("Layer Updated: " + response);
                    if (layerView.layer.definitionExpression) if (response.count > 0) mapView.goTo(response.extent);
                });
            }
        })
    })

    /**
     * Executes a function after getting all the features in a specified layer
     */
    arcgisSelectAllFeaturesInLayer = function(layerID, resultHandler,  returnGeometry = false) {
        mapView.
            whenLayerView(map.findLayerById(layerID)).
            then(layerView => {
                arcgisSelectAllFeaturesInLayerView(layerView, resultHandler, returnGeometry);
            });
    }

    /**
     * Executes a function after getting all the features in a specified layerView
     */
    arcgisSelectAllFeaturesInLayerView = function(layerView, resultHandler,  returnGeometry = false) {
        const query = {
            where: "1=1",
            outFields: layerView.availableFields,            //["*"],
            returnGeometry: returnGeometry
        };
        arcgisGetQueryResults(layerView, query, resultHandler)
    }

    /**
     * Executes a function after getting all the features that intersect a geometry in a specified layer
     */
    arcgisSelectByGeometryInLayer = function(layerID, geometry, resultHandler, returnGeometry = false) {
        mapView.
            whenLayerView(map.findLayerById(layerID)).
            then(layerView => {
                arcgisSelectByGeometryInLayerView(layerView, geometry, resultHandler, returnGeometry);
            });
    }

    /**
     * Executes a function after getting all the features that intersect a geometry in a specified layerView
     */
    arcgisSelectByGeometryInLayerView = function(layerView, geometry, resultHandler, returnGeometry = false) {
        const query = {
            geometry: geometry,
            outFields: ["*"],
            returnGeometry:true
        };
        arcgisGetQueryResults(layerView, query, resultHandler)
    }

    /**
     * Executes a function after getting all the features where a attribute matches a provided value in a specified layerView
     */
    arcgisSelectByFieldValueInLayerView = function(layerView, fieldName, fieldValue, resultHandler, returnGeometry = false) {
        const query = {
            where: fieldName + "=" + fieldValue,
            outFields: ["*"],
            returnGeometry: returnGeometry
        };
        arcgisGetQueryResults(layerView, query, resultHandler)
    }

    /**
     * Executes a function after getting all the features from an SQL-like query in a specified layerView
     */
    arcgisSelectBySQLInLayerView = function(layerView, sql, resultHandler, returnGeometry = false) {
        const query = {
            where: sql,
            outFields: ["*"],
            returnGeometry: returnGeometry
        };
        arcgisGetQueryResults(layerView, query, resultHandler)
    }

    /**
     * Executes a function on the results of a queryFeatures operation
     */
    arcgisGetQueryResults = function(layerView, query, resultHandler) {
        layerView.layer
            .queryFeatures(query)
            .then(results => {
                console.log("Query output")
                console.log(results);
                if (!resultHandler) {
                    console.log("No result handler")
                    console.log(results);
                } else {
                    resultHandler(results)
                }
            })
            .catch(errorCallback);
    }

    /**
     * Highlights features on a map
     */
    arcGISHighlightFeatures = function(highlightLayerID, features, clearPreviousHighlights = false, postHighlightScript) {
        addFeatures = function(features, postHighlightScript) {
            console.log("Entered add script")
            return map.findLayerById(highlightLayerID).applyEdits({
                addFeatures: features
            }).then(function(editsResult) {
                console.log("Added")
                console.log(editsResult)
                if (postHighlightScript) postHighlightScript();
                
            }).catch(errorCallback);            
        }
        if (clearPreviousHighlights) {
            mapView.
                whenLayerView(map.findLayerById(highlightLayerID)).
                then(layerView => {
                    arcgisSelectAllFeaturesInLayerView(layerView, allFeatures => {
                        if (allFeatures.features.length > 0) {
                            map.findLayerById(highlightLayerID).applyEdits({
                                "deleteFeatures": allFeatures.features
                            }).then(result => {
                                addFeatures(features, postHighlightScript);
                            }).catch(errorCallback);
                        } else {
                            addFeatures(features, postHighlightScript);
                        }
                    })
                });
            
        } else {
            addFeatures(features, postHighlightScript);
        }
        
    }

    /**
     * Removes highlighting from features on a map
     */
    arcgisUnhighlightFeatures = function(highlightLayerID, features, postUnhighlightScript) {
        map.findLayerById(highlightLayerID).applyEdits({
            "deleteFeatures": features
        }).then(function(editsResult) {
            console.log("Deleted")
            console.log(editsResult)
            if (postUnhighlightScript) postUnhighlightScript();
            
        }).catch(errorCallback);
    }

    /**
     * Removes all highlighting on a map
     */
    arcgisUnhighlightAllFeatures = function(highlightLayerID, postUnhighlightScript) {
        arcgisSelectAllFeaturesInLayer(highlightLayerID, function(result) {
            arcgisUnhighlightFeatures(highlightLayerID, result.features, postUnhighlightScript)
        })
    }
});