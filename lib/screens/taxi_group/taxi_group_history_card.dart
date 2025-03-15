import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
    required this.savedAmount,
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
          Row(
            children: [
              Text(
                '출발',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ThemeModel.sub4(isDarkMode),
                ),
              ),
              Spacer(),
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
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '도착',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ThemeModel.sub4(isDarkMode),
                ),
              ),
              Spacer(),
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
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '날짜',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ThemeModel.sub4(isDarkMode),
                ),
              ),
              Spacer(),
              Text(
                dateTime,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ThemeModel.text(isDarkMode),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '시간',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ThemeModel.sub4(isDarkMode),
                ),
              ),
              Spacer(),
              Text(
                '$startTime - $destinationTime',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ThemeModel.text(isDarkMode),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '절약한 금액',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ThemeModel.sub4(isDarkMode),
                ),
              ),
              Spacer(),
              Text(
                '${NumberFormat('#,###', 'ko_KR').format(savedAmount)}원',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ThemeModel.text(isDarkMode),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
