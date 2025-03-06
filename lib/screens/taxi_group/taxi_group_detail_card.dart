import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';

class TaxiGroupDetailCard extends ConsumerWidget {
  final int remainingSeats;
  final String departurePlace;
  final String departureAdress;
  final String arrivalPlace;
  final String arrivalAddress;
  final DateTime startTime;

  const TaxiGroupDetailCard({
    super.key,
    required this.remainingSeats,
    required this.departurePlace,
    required this.departureAdress,
    required this.arrivalPlace,
    required this.arrivalAddress,
    required this.startTime,
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
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(
                  departureAdress,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ThemeModel.sub4(isDarkMode),
                  ),
                ),
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
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(
                  arrivalAddress,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ThemeModel.sub4(isDarkMode),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _formatDateTime(startTime),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ThemeModel.sub4(isDarkMode),
                ),
              ),
              SizedBox(
                height: 12,
                child: VerticalDivider(
                  thickness: 1,
                  color: ThemeModel.sub2(isDarkMode),
                  width: 20,
                ),
              ),
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
