import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/models/userinfo/userinfo.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/provider/user_fetch_notifier.dart';
import 'package:letsmerge/provider/user_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_list_tile.dart';
import 'package:letsmerge/widgets/c_skeleton_loader.dart';
import 'package:letsmerge/widgets/c_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final TextEditingController _nicknameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final User? user = Supabase.instance.client.auth.currentUser;
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
      // TODO: 선택된 이미지를 서버에 업로드하는 로직 추가
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final userInfo = ref.watch(userInfoProvider(user?.id ?? ''));

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CInkWell(
                onTap: _pickImage,
                child: Container(
                  height: 128,
                  width: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: blue20,
                    image: _selectedImagePath != null
                        ? DecorationImage(
                            image: FileImage(File(_selectedImagePath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImagePath == null
                      ? const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 64,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              CListTile(
                title: '이름',
                trailing: () {
                  if (userInfo == null) {
                    return Text('정보 없음', style: infoTextStyle);
                  } else {
                    return Text(userInfo.name, style: infoTextStyle);
                  }
                } (),
              ),
              CListTile(
                title: '닉네임',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CDialog(
                        title: '닉네임 수정',
                        content: CTextField(
                          controller: _nicknameController,
                          label: '닉네임',
                          backgroundColor: ThemeModel.background(isDarkMode),
                          hint: '새 닉네임 입력',
                        ),
                        buttons: [
                          CButton(
                            style: CButtonStyle.secondary(isDarkMode),
                            size: CButtonSize.extraLarge,
                            label: '취소',
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          CButton(
                            size: CButtonSize.extraLarge,
                            label: '저장',
                            onTap: () {
                              ref.read(userProvider.notifier).updateUserNickname(context, ref, _nicknameController.text);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                trailing: () {
                  if (userInfo == null) {
                    return Text('정보 없음', style: infoTextStyle);
                  } else {
                    return Text(userInfo.nickname, style: infoTextStyle);
                  }
                } (),
              ),
              CListTile(
                title: '이메일',
                trailing: () {
                  if (userInfo == null) {
                    return Text('정보 없음', style: infoTextStyle);
                  } else {
                    return Text(userInfo.email, style: infoTextStyle);
                  }
                } (),
              ),
              CListTile(
                title: '렛츠머지와 함께한지',
                trailing: () {
                  if (userInfo == null) {
                    return Text('정보 없음', style: infoTextStyle);
                  }
                  try {
                    DateTime createdDate = DateTime.parse(userInfo.createdAt);
                    int days = DateTime.now().difference(createdDate).inDays;
                    return Text('$days일', style: infoTextStyle);
                  } catch (e) {
                    return Text('날짜 오류', style: infoTextStyle);
                  }
                } (),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
