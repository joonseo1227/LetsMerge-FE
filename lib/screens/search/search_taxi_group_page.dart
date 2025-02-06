import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_search_bar.dart';

class SearchTaxiGroupPage extends ConsumerStatefulWidget {
  const SearchTaxiGroupPage({super.key});

  @override
  ConsumerState<SearchTaxiGroupPage> createState() =>
      _SearchTaxiGroupPageState();
}

class _SearchTaxiGroupPageState extends ConsumerState<SearchTaxiGroupPage> {
  final TextEditingController _searchController = TextEditingController();
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
                  hint: '택시팟 검색',
                  focusNode: _focusNode,
                  controller: _searchController,
                  onSubmitted: (value) {},
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
          children: [],
        ),
      ),
    );
  }
}
