import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/provider/user_provider.dart';
import 'package:letsmerge/widgets/c_list_tile.dart';
import 'package:letsmerge/widgets/c_skeleton_loader.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final user = UserProvider();

    final infoTextStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: ThemeModel.sub4(isDarkMode),
    );

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: const ShapeDecoration(
                  color: blue20,
                  shape: CircleBorder(),
                ),
              ),
              const SizedBox(height: 16),
              CListTile(
                title: '이름',
                trailing: Text(
                  user.getUserName() ?? '',
                  style: infoTextStyle,
                ),
              ),
              CListTile(
                title: '닉네임',
                trailing: FutureBuilder<String?>(
                  future: user.getUserNickname(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        width: 80,
                        height: 20,
                        child: CSkeleton(),
                      );
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return Text('정보 없음', style: infoTextStyle);
                    } else {
                      return Text(
                        snapshot.data ?? '정보 없음',
                        style: infoTextStyle,
                      );
                    }
                  },
                ),
              ),
              CListTile(
                title: '이메일',
                trailing: FutureBuilder<String?>(
                  future: user.getUserEmail(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        width: 80,
                        height: 20,
                        child: CSkeleton(),
                      );
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return Text('정보 없음', style: infoTextStyle);
                    } else {
                      return Text(
                        snapshot.data ?? '정보 없음',
                        style: infoTextStyle,
                      );
                    }
                  },
                ),
              ),
              CListTile(
                title: '렛츠머지와 함께한지',
                trailing: FutureBuilder<String?>(
                  future: user.getUserCreatedAt(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        width: 80,
                        height: 20,
                        child: CSkeleton(),
                      );
                    } else if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data == null) {
                      return Text('정보 없음', style: infoTextStyle);
                    } else {
                      try {
                        DateTime createdDate = DateTime.parse(snapshot.data!);
                        int days =
                            DateTime.now().difference(createdDate).inDays;
                        return Text('$days일', style: infoTextStyle);
                      } catch (e) {
                        return Text('날짜 오류', style: infoTextStyle);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
