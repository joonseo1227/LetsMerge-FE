import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letsmerge/screens/auth/log_in_page.dart';
import 'package:letsmerge/screens/main/all_tab.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );
        }

        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return AllTab();
        } else {
          return LogInPage();
        }
      },
    );
  }
}
