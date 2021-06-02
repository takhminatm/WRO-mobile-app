import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:google_fonts/google_fonts.dart';

class ZoomButtonsPluginOption extends LayerOptions {
  final int minZoom;
  final int maxZoom;
  final IconData zoomInIcon;
  final IconData zoomOutIcon;

  ZoomButtonsPluginOption({
    Key key,
    this.minZoom = 1,
    this.maxZoom = 15,
    this.zoomInIcon = Icons.add,
    this.zoomOutIcon = Icons.remove,
    rebuild,
  }) : super(key: key, rebuild: rebuild);
}

class ZoomButtonsPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is ZoomButtonsPluginOption) {
      return ZoomButtons(options, mapState, stream);
    }
    throw Exception('Unknown options type for ZoomButtonsPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is ZoomButtonsPluginOption;
  }
}

class ZoomButtons extends StatelessWidget {
  final ZoomButtonsPluginOption zoomButtonsOpts;
  final MapState map;
  final Stream<Null> stream;
  final FitBoundsOptions options =
  const FitBoundsOptions(padding: EdgeInsets.all(12.0));

  ZoomButtons(this.zoomButtonsOpts, this.map, this.stream)
      : super(key: zoomButtonsOpts.key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 60,
      child: SizedBox(
        width: 40,
        height: 120,
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'zoomInButton',
              //mini: zoomButtonsOpts.mini,
              backgroundColor: Color(0xffFF433FA8),
              onPressed: () {
                var bounds = map.getBounds();
                var centerZoom = map.getBoundsCenterZoom(bounds, options);
                var zoom = centerZoom.zoom + 1;
                if (zoom < zoomButtonsOpts.minZoom) {
                  zoom = zoomButtonsOpts.minZoom as double;
                } else {
                  map.move(centerZoom.center, zoom);
                }
              },
              child: Icon(zoomButtonsOpts.zoomInIcon, size: 40, color: Colors.white),
            ),
            FloatingActionButton(
              heroTag: 'zoomOutButton',
              //mini: zoomButtonsOpts.mini,
              backgroundColor: Color(0xffFF433FA8),
              onPressed: () {
                var bounds = map.getBounds();
                var centerZoom = map.getBoundsCenterZoom(bounds, options);
                var zoom = centerZoom.zoom - 1;
                if (zoom > zoomButtonsOpts.maxZoom) {
                  zoom = zoomButtonsOpts.maxZoom as double;
                } else {
                  map.move(centerZoom.center, zoom);
                }
              },
              child: Icon(zoomButtonsOpts.zoomOutIcon, size: 40, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
