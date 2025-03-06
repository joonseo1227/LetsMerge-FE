import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_detail_card.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_history_card.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_preview_page.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_period_picker.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('이용 내역'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CPeriodPicker(),
              const SizedBox(height: 16),
              CInkWell(
                onTap: () {},
                child: TaxiGroupHistoryCard(
                  dateTime: "2025년 3월 1일",
                  startLocation: '가천대역',
                  startTime: '10:30',
                  destinationLocation: '가천대학교 AI관',
                  destinationTime: '10:35',
                  savedAmount: 1600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
