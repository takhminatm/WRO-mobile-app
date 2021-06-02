import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong/latlong.dart';
import 'ZoomButtonsPluginOption.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'example_popup.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

void main() {
  runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Charging points', style: TextStyle(fontSize: 25),),
          backgroundColor: Color(0xffFF433FA8),
        ),
        body: FindNearbyPage(),
      )
  ));
}

class FindNearbyPage extends StatefulWidget {
  static String id = 'FindNearbyPage';

  @override
  _FindNearbyPage createState() => _FindNearbyPage();
}

class _FindNearbyPage extends State<FindNearbyPage> {
  CenterOnLocationUpdate _centerOnLocationUpdate;
  StreamController<double> _centerCurrentLocationStreamController;
  static final List<LatLng> _points = [
    LatLng(43.263893, 76.881469),
    LatLng(43.263744, 76.881627),
    LatLng(43.262954, 76.882000),
  ];
  static const _markerSize = 40.0;
  List<Marker> _markers;

  // Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();
a
  @override
  void initState() {
    super.initState();
    _markers = _points

        .map(
          (LatLng point) =>
          Marker(
            point: point,
            width: _markerSize,
            height: _markerSize,
            builder: (_) => Icon(Icons.location_on, size: _markerSize),
            anchorPos: AnchorPos.align(AnchorAlign.top),
          ),
    )
        .toList();
    _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    _centerCurrentLocationStreamController =
    StreamController<double>.broadcast();
  }

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          FlutterMap(

            options: MapOptions(
                center: LatLng(43.263537, 76.881678),
                zoom: 20,
                maxZoom: 19,
                minZoom: 11,
                plugins: [
                  ZoomButtonsPlugin(),
                  PopupMarkerPlugin(),
                ],
                onTap: (_) => _popupLayerController.hidePopup(),
                // Stop centering the location marker on the map if user interacted with the map.
                onPositionChanged: (MapPosition position, bool hasGesture) {
                  if (hasGesture) {
                    setState(() =>
                    _centerOnLocationUpdate = CenterOnLocationUpdate.never);
                  }
                }),
            layers: [
              ZoomButtonsPluginOption(
                minZoom: 4,
                maxZoom: 19,
              ),
              PopupMarkerLayerOptions(
                markers: _markers,
                popupSnap: PopupSnap.top,
                popupController: _popupLayerController,
                popupBuilder: (BuildContext _, Marker marker) =>
                    ExamplePopup(marker),
              ),
            ],
            children: [
              TileLayerWidget(
                options: TileLayerOptions(
                  urlTemplate:
                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                  maxZoom: 19,
                  minZoom: 4,
                ),
              ),
              LocationMarkerLayerWidget(
                plugin: LocationMarkerPlugin(
                  centerCurrentLocationStream:
                  _centerCurrentLocationStreamController.stream,
                  centerOnLocationUpdate: _centerOnLocationUpdate,
                ),
              ),
              Positioned(
                right: 20,
                bottom: 20,
                child: SizedBox(
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showPopupForFirstMarker() {
    _popupLayerController.togglePopup(_markers.first);
  }

}



