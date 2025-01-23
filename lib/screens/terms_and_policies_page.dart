import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/provider/theme_provider.dart';

class TermsAndPoliciesPage extends ConsumerStatefulWidget {
  const TermsAndPoliciesPage({super.key});

  @override
  ConsumerState<TermsAndPoliciesPage> createState() =>
      _TermsAndPoliciesPageState();
}

class _TermsAndPoliciesPageState extends ConsumerState<TermsAndPoliciesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('약관 및 정책'),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
