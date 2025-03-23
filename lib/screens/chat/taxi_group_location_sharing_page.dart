import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/provider/user_fetch_notifier.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_skeleton_loader.dart';
import 'package:letsmerge/widgets/c_tag.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 참여자 데이터를 위한 모델
class ParticipantLocation {
  final String userId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  ParticipantLocation({
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory ParticipantLocation.fromJson(Map<String, dynamic> json) {
    debugPrint('가공 전 데이터: $json');
    debugPrint('user_id 값: ${json['user_id']}');
    debugPrint('user_id 타입: ${json['user_id']?.runtimeType}');

    if (json['user_id'] == null) {
      throw Exception('user_id가 null입니다. 전체 데이터: $json');
    }

    return ParticipantLocation(
      userId: json['user_id'],
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class TaxiGroupLocationSharingPage extends ConsumerStatefulWidget {
  final String groupId;

  const TaxiGroupLocationSharingPage({super.key, required this.groupId});

  @override
  ConsumerState<TaxiGroupLocationSharingPage> createState() =>
      _TaxiGroupLocationSharingPageState();
}

class _TaxiGroupLocationSharingPageState
    extends ConsumerState<TaxiGroupLocationSharingPage> {
  NaverMapController? _mapController;
  Position? _currentPosition;
  Position? _initialPosition;
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<List<Map<String, dynamic>>>? _participantsStream;
  bool _showSkeleton = true;

  final Map<String, NMarker> _markers = {};
  final Map<String, ParticipantLocation> _participants = {};

  final _supabase = Supabase.instance.client;
  final _currentUser = Supabase.instance.client.auth.currentUser;

  @override
  void initState() {
    super.initState();
    _initializeInitialPosition();
    _startLocationStream();
    _listenToParticipantsLocation();
  }

  Future<void> _initializeInitialPosition() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _initialPosition = pos;
        });

        // 내 위치 정보 서버에 업데이트
        _updateMyLocation(pos);
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  void _startLocationStream() {
    try {
      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 2, // 2미터마다 업데이트
        ),
      ).listen((pos) {
        setState(() {
          _currentPosition = pos;
        });

        // 내 위치 정보 서버에 업데이트
        _updateMyLocation(pos);
      });
    } catch (e) {
      debugPrint('$e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('GPS 상태를 확인하세요.'),
        ),
      );
    }
  }

  // 내 위치 정보를 서버에 업데이트
  Future<void> _updateMyLocation(Position position) async {
    if (_currentUser == null) return;

    try {
      await _supabase.from('taxi_group_locations').upsert({
        'group_id': widget.groupId,
        'user_id': _currentUser.id,
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    } catch (e) {
      debugPrint('위치 업데이트 오류: $e');
    }
  }

  // 참여자들의 위치 정보를 실시간으로 수신
  void _listenToParticipantsLocation() {
    _participantsStream = _supabase
        .from('taxi_group_locations')
        .stream(primaryKey: ['group_id', 'user_id'])
        .eq('group_id', widget.groupId)
        .listen((data) {
          debugPrint('수신된 데이터의 길이: ${data.length}');

          if (data.isEmpty) {
            debugPrint('수신된 데이터가 없습니다');
            return;
          }

          for (var item in data) {
            debugPrint(
                '참여자 항목: $item, user_id 타입: ${item['user_id'].runtimeType}');

            try {
              final location = ParticipantLocation.fromJson(item);
              _participants[item['user_id']] = location;
            } catch (e) {
              debugPrint('ParticipantLocation 변환 오류: $e');
            }
          }

          // 마커 업데이트 로직
          _updateMarkers();

          if (mounted) {
            setState(() {
              _showSkeleton = false;
            });
          }
        });
  }

  // 마커 업데이트
  Future<void> _updateMarkers() async {
    final isDarkMode = ref.watch(themeProvider);

    if (_mapController == null) return;

    _markers.clear();

    // 모든 참여자에 대한 마커 생성
    for (final participant in _participants.values) {
      final marker = NMarker(
        id: 'marker_${participant.userId}',
        position: NLatLng(participant.latitude, participant.longitude),
      );

      // 내 위치이면 다른 마커 스타일 적용
      if (participant.userId == _currentUser?.id) {
        marker.setIcon(
          await NOverlayImage.fromWidget(
            widget: SizedBox.shrink(),
            size: Size(48, 48),
            context: context,
          ),
        );
      } else {
        marker.setIcon(
          await NOverlayImage.fromWidget(
            widget: Container(
              color: ThemeModel.surface(!isDarkMode).withValues(alpha: 0.9),
              child: Text(
                ref.watch(userInfoProvider(participant.userId)).nickname!,
                style: TextStyle(
                  color: ThemeModel.text(!isDarkMode),
                ),
              ),
            ),
            size: Size(80, 16),
            context: context,
          ),
        );
      }

      // 마커에 정보창 추가
      final infoWindow = NInfoWindow.onMarker(
        id: 'info_${participant.userId}',
        text: participant.userId,
      );

      _mapController!.addOverlay(marker);
      _mapController!.addOverlay(infoWindow);
      _markers[participant.userId] = marker;
    }
  }

  void _onMapReady(NaverMapController controller) {
    _mapController = controller;
    controller.setLocationTrackingMode(NLocationTrackingMode.noFollow);
    if (_initialPosition != null) {
      controller.updateCamera(
        NCameraUpdate.scrollAndZoomTo(
          target:
              NLatLng(_initialPosition!.latitude, _initialPosition!.longitude),
          zoom: 15.0,
        ),
      );
    }

    // 마커 초기화
    _updateMarkers();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showSkeleton = false;
        });
      }
    });
  }

  Future<void> _goToCurrentLocation() async {
    if (_mapController != null && _currentPosition != null) {
      await _mapController!.updateCamera(
        NCameraUpdate.scrollAndZoomTo(
          target: NLatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          zoom: 15.0,
        ),
      );
    } else {
      debugPrint('Failed to get current location');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('GPS 상태를 확인하세요.'),
        ),
      );
    }
  }

  // 모든 참여자가 보이도록 카메라 조정
  Future<void> _fitAllParticipants() async {
    if (_mapController != null && _participants.isNotEmpty) {
      final bounds = NLatLngBounds(
        southWest: NLatLng(
          _participants.values
              .map((p) => p.latitude)
              .reduce((a, b) => a < b ? a : b),
          _participants.values
              .map((p) => p.longitude)
              .reduce((a, b) => a < b ? a : b),
        ),
        northEast: NLatLng(
          _participants.values
              .map((p) => p.latitude)
              .reduce((a, b) => a > b ? a : b),
          _participants.values
              .map((p) => p.longitude)
              .reduce((a, b) => a > b ? a : b),
        ),
      );

      await _mapController!.updateCamera(
        NCameraUpdate.fitBounds(
          bounds,
          padding: EdgeInsets.all(50),
        ),
      );
    }
  }

  void _moveToParticipantLocation(ParticipantLocation participant) {
    if (_mapController == null) return;

    _mapController!.updateCamera(
      NCameraUpdate.withParams(
        target: NLatLng(participant.latitude, participant.longitude),
        zoom: 15,
      ),
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _participantsStream?.cancel();
    super.dispose();
  }

  double _bottomSheetSize = 0.1;

  @override
  Widget build(BuildContext context) {
    final double bottomPadding =
        MediaQuery.of(context).size.height * _bottomSheetSize -
            MediaQuery.of(context).padding.bottom;

    final isDarkMode = ref.watch(themeProvider);

    return AnnotatedRegion(
      value: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          systemOverlayStyle: isDarkMode
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            if (_initialPosition != null)
              NaverMap(
                onMapReady: _onMapReady,
                options: NaverMapViewOptions(
                  mapType: NMapType.navi,
                  nightModeEnable: isDarkMode,
                  contentPadding: EdgeInsets.only(bottom: bottomPadding),
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(
                      _initialPosition!.latitude,
                      _initialPosition!.longitude,
                    ),
                    zoom: 15.0,
                  ),
                ),
              )
            else
              const Center(
                child: CSkeleton(),
              ),
            if (_showSkeleton) const CSkeleton(),
            Positioned(
              right: 16,
              bottom: bottomPadding + 16,
              child: SafeArea(
                child: Column(
                  children: [
                    CButton(
                      style: CButtonStyle.secondary(isDarkMode),
                      onTap: _goToCurrentLocation,
                      icon: Icons.my_location,
                    ),
                    const SizedBox(height: 8),
                    CButton(
                      style: CButtonStyle.secondary(isDarkMode),
                      onTap: _fitAllParticipants,
                      icon: Icons.people,
                    ),
                  ],
                ),
              ),
            ),
            NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                setState(() {
                  _bottomSheetSize = notification.extent;
                });
                return true;
              },
              child: DraggableScrollableSheet(
                initialChildSize: 0.2,
                minChildSize: 0.2,
                maxChildSize: 0.8,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: ThemeModel.surface(isDarkMode),
                      boxShadow: [
                        BoxShadow(
                          color: black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              // 드래그 핸들
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16),
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: ThemeModel.sub2(isDarkMode),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              // 제목 부분
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '위치 공유 참여자',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: ThemeModel.text(isDarkMode),
                                      ),
                                    ),
                                    Text(
                                      '${_participants.length}명',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: ThemeModel.sub4(isDarkMode),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_participants.isEmpty)
                          SliverFillRemaining(
                            child: Center(
                              child: Text(
                                '참여자 없음',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ThemeModel.sub4(isDarkMode),
                                ),
                              ),
                            ),
                          )
                        else
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final participantId =
                                    _participants.keys.elementAt(index);
                                final participant =
                                    _participants[participantId]!;
                                final isCurrentUser =
                                    participantId == _currentUser?.id;

                                final userInfo = ref.watch(
                                  userInfoProvider(participantId),
                                );

                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: blue30,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        userInfo.nickname ?? '알 수 없음',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: ThemeModel.text(isDarkMode),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (isCurrentUser)
                                        Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: CTag(
                                            text: '나',
                                            color: TagColor.blue,
                                          ),
                                        ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    '최근 위치 갱신: ${_formatTimeAgo(participant.timestamp)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeModel.sub4(isDarkMode),
                                    ),
                                  ),
                                  onTap: () => _moveToParticipantLocation(
                                    participant,
                                  ),
                                );
                              },
                              childCount: _participants.length,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatTimeAgo(DateTime time) {
  final now = DateTime.now();
  final difference = now.difference(time);

  if (difference.inSeconds < 60) {
    return '방금 전';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}분 전';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}시간 전';
  } else {
    return '${difference.inDays}일 전';
  }
}
