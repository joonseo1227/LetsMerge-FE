import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:letsmerge/widgets/c_skeleton_loader.dart';
class CMapWidget extends StatefulWidget {

  final bool isDarkMode;
  final double? width;
  final double? height;
  final double? initialLatitude;
  final double? initialLongitude;

  const CMapWidget({
    Key? key,
    required this.isDarkMode,
    this.width,
    this.height,
    this.initialLatitude,
    this.initialLongitude,
  }) : super(key: key);

  @override
  CMapWidgetState createState() => CMapWidgetState();
}

class CMapWidgetState extends State<CMapWidget> {
  NaverMapController? _mapController;
  bool _showSkeleton = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showSkeleton = false;
        });
      }
    });
  }

  void _onMapReady(NaverMapController controller) {
    _mapController = controller;
    controller.setLocationTrackingMode(NLocationTrackingMode.noFollow);

    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      controller.updateCamera(
        NCameraUpdate.scrollAndZoomTo(
          target: NLatLng(widget.initialLatitude!, widget.initialLongitude!),
          zoom: 15.0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _showSkeleton
          ? const CSkeleton()
          : NaverMap(
        onMapReady: _onMapReady,
        options: NaverMapViewOptions(
          mapType: NMapType.navi,
          nightModeEnable: widget.isDarkMode,
          initialCameraPosition: NCameraPosition(
            target: NLatLng(
              widget.initialLatitude ?? 37.5665,
              widget.initialLongitude ?? 126.9780,
            ),
            zoom: 15.0,
          ),
        ),
      ),
    );
  }
}