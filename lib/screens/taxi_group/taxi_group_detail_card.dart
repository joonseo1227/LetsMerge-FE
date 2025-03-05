import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';

class TaxiGroupDetailCard extends ConsumerWidget {
  final int remainingSeats;
  final String departurePlace;
  final DateTime startTime;
  final String arrivalPlace;

  const TaxiGroupDetailCard({
    super.key,
    required this.remainingSeats,
    required this.departurePlace,
    required this.startTime,
    required this.arrivalPlace,
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
                    departurePlace,
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
                    _formatDateTime(startTime),
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
                    arrivalPlace,
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$remainingSeats자리 남음',
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
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
