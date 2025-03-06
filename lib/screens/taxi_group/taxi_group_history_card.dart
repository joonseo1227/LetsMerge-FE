import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';

class TaxiGroupHistoryCard extends ConsumerWidget {
  final String dateTime;
  final String startLocation;
  final String startTime;
  final String destinationLocation;
  final String destinationTime;
  final int savedAmount;

  const TaxiGroupHistoryCard({
    super.key,
    required this.dateTime,
    required this.startLocation,
    required this.startTime,
    required this.destinationLocation,
    required this.destinationTime,
    required this.savedAmount
  });

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateTime,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ThemeModel.text(isDarkMode),
                ),
              ),
              const SizedBox(height: 16),
              Row(
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
                  Text(
                    startLocation,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ThemeModel.text(isDarkMode),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 32),
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
                      color: ThemeModel.sub4(isDarkMode),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  Text(
                    destinationLocation,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ThemeModel.text(isDarkMode),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 32),
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
                      color: ThemeModel.sub4(isDarkMode),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '4,800원 - 3,200원',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ThemeModel.sub4(isDarkMode),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(
                    '절약한 금액 ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: ThemeModel.text(isDarkMode),
                    ),
                  ),
                  Text(
                    '$savedAmount원',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: ThemeModel.text(isDarkMode),
                    ),
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
