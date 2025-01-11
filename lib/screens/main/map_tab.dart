import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapTab extends StatelessWidget {
  const MapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: NLatLng(37.451039959670574, 127.12875330395157), // 초기 위치
            zoom: 15.2, // 초기 줌 레벨
          ),
        ),
        onMapReady: (controller) {
          // 추가 코드
          debugPrint('Naver Map is ready');
        },
      ),
    );
  }
}
