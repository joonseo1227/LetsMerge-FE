import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';

class TaxiGroupDetailCard extends ConsumerWidget {
  final int remainingSeats;
  final int closingTime;
  final String startLocation;
  final String startTime;
  final int startWalkingTime;
  final String destinationLocation;
  final String destinationTime;

  const TaxiGroupDetailCard({
    Key? key,
    required this.remainingSeats,
    required this.closingTime,
    required this.startLocation,
    required this.startTime,
    required this.startWalkingTime,
    required this.destinationLocation,
    required this.destinationTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return Container(
      color: ThemeModel.surface(isDarkMode),
      width: double.maxFinite,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$remainingSeats자리 남음',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ThemeModel.sub3(isDarkMode),
                ),
              ),
              const SizedBox(
                height: 16,
                child: VerticalDivider(
                  thickness: 1,
                ),
              ),
              Text(
                '$closingTime분 후 마감',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ThemeModel.sub3(isDarkMode),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.all(6),
                decoration: ShapeDecoration(
                  color: ThemeModel.sub2(isDarkMode),
                  shape: const CircleBorder(),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    startLocation,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ThemeModel.text(isDarkMode),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        size: 14,
                        color: ThemeModel.sub2(isDarkMode),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        startTime,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ThemeModel.sub3(isDarkMode),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                        child: VerticalDivider(
                          thickness: 1,
                        ),
                      ),
                      Text(
                        '현재 위치에서 도보 $startWalkingTime분',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ThemeModel.sub3(isDarkMode),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.all(6),
                decoration: ShapeDecoration(
                  color: ThemeModel.highlight(isDarkMode),
                  shape: const CircleBorder(),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destinationLocation,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ThemeModel.text(isDarkMode),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        size: 14,
                        color: ThemeModel.sub2(isDarkMode),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        destinationTime,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ThemeModel.sub3(isDarkMode),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
