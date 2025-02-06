import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/map_model.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/geocoding_provider.dart';
import 'package:letsmerge/provider/map_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/select_place_page.dart';
import 'package:letsmerge/widgets/c_search_bar.dart';

class SearchPlacePage extends ConsumerStatefulWidget {
  final GeocodingMode mode;

  const SearchPlacePage({
    super.key,
    required this.mode,
  });

  @override
  ConsumerState<SearchPlacePage> createState() => _SearchPlacePageState();
}

class _SearchPlacePageState extends ConsumerState<SearchPlacePage> {
  final TextEditingController _searchController = TextEditingController();
  List<NaverSearchResult> _searchResults = [];
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 페이지가 열릴 때 자동으로 포커스 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _searchPlaces() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final provider = NaverSearchProvider();
      List<NaverSearchResult> results =
          await provider.searchPlace(query: query);
      setState(() => _searchResults = results);
    } catch (e) {
      debugPrint("[Error] 검색 실패: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return AnnotatedRegion(
      value: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: CSearchBar(
                  hint: '장소 검색',
                  focusNode: _focusNode,
                  controller: _searchController,
                  onSubmitted: (value) {
                    _searchPlaces();
                  },
                ),
              ),
              SizedBox(
                width: 16,
              ),
            ],
          ),
          titleSpacing: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final place = _searchResults[index];
                  return ListTile(
                    title: Text(
                      place.title,
                      style: TextStyle(
                        color: ThemeModel.text(isDarkMode),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      place.address,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ThemeModel.sub4(isDarkMode),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => SelectPlacePage(
                            mode: widget.mode,
                            longitude: place.mapX / 1e7,
                            latitude: place.mapY / 1e7,
                          ),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    indent: 16,
                    endIndent: 16,
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
