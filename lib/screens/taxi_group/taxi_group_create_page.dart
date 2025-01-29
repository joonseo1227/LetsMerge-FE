import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/provider/geocoding_provider.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

class TaxiGroupCreatePage extends ConsumerStatefulWidget {
  const TaxiGroupCreatePage({super.key});

  @override
  ConsumerState<TaxiGroupCreatePage> createState() =>
      _TaxiGroupCreatePageState();
}

class _TaxiGroupCreatePageState extends ConsumerState<TaxiGroupCreatePage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final selectedLocations = ref.watch(reverseGeocodingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("택시팟 생성"),
        titleSpacing: 0,
        leading: CInkWell(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => MainPage(),
              ),
              (Route<dynamic> route) => false,
            );
          },
          child: SizedBox(
            width: 32,
            height: 32,
            child: Icon(
              Icons.close,
              size: 28,
              color: ThemeModel.text(isDarkMode),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: ThemeModel.surface(isDarkMode),
                width: double.maxFinite,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              selectedLocations[GeocodingMode.departure]![
                                      'place'] ??
                                  '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: ThemeModel.text(isDarkMode),
                              ),
                            ),
                            Text(
                              selectedLocations[GeocodingMode.departure]![
                                      'address'] ??
                                  '',
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
                              selectedLocations[GeocodingMode.destination]![
                                      'place'] ??
                                  '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: ThemeModel.text(isDarkMode),
                              ),
                            ),
                            Text(
                              selectedLocations[GeocodingMode.destination]![
                                      'address'] ??
                                  '',
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
