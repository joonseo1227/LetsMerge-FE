import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/map_model.dart';
import 'package:letsmerge/provider/map_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/marker_page.dart';
import 'package:letsmerge/server/rest_api.dart';
import 'package:letsmerge/widgets/c_search_bar.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
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
      List<NaverSearchResult> results = await provider.SearchPlace(query: query);
      setState(() => _searchResults = results);
    } catch (e) {
      print("[Error] 검색 실패: $e");
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
                  hint: '검색',
                  focusNode: _focusNode, // 포커스 노드 전달
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(place.address),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>MarkerPage(title: place.title, mapX: place.mapX / 1e7, mapY: place.mapY / 1e7,))
                        );
                      },
                    );
                  },
                  separatorBuilder: (context,index) {
                    return Divider();
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
