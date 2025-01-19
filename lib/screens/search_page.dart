import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_search_bar.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final FocusNode _focusNode = FocusNode();

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
                  hint: '검색',
                  focusNode: _focusNode, // 포커스 노드 전달
                ),
              ),
              SizedBox(
                width: 16,
              ),
            ],
          ),
          titleSpacing: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
          ),
        ),
      ),
    );
  }
}