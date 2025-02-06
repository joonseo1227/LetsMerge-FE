import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/provider/theme_provider.dart';

class MarkerPage extends ConsumerStatefulWidget {
  final String title;
  final double mapX;
  final double mapY;

  const MarkerPage({
    super.key,
    required this.title,
    required this.mapX,
    required this.mapY,
  });

  @override
  ConsumerState<MarkerPage> createState() => _MarkerPageState();
}

class _MarkerPageState extends ConsumerState<MarkerPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return AnnotatedRegion(
      value: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: NaverMap(
          options: NaverMapViewOptions(
            indoorEnable: false,
            locationButtonEnable: true,
            scrollGesturesEnable: true,
            consumeSymbolTapEvents: true,
            initialCameraPosition: NCameraPosition(
              target: NLatLng(widget.mapY, widget.mapX),
              zoom: 10,
              bearing: 0,
              tilt: 0,
            ),
            mapType: NMapType.basic,
            activeLayerGroups: [NLayerGroup.building, NLayerGroup.transit],
          ),
          onMapReady: (controller) {
            final marker = NMarker(
                id: 'test', position: NLatLng(widget.mapY, widget.mapX));
            controller.addOverlayAll({marker});
            final onMarkerInfoWindow =
                NInfoWindow.onMarker(id: marker.info.id, text: widget.title);
            marker.openInfoWindow(onMarkerInfoWindow);
          },
        ),
      ),
    );
  }
}
