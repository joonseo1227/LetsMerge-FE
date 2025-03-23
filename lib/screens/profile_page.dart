import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/provider/user_fetch_notifier.dart';
import 'package:letsmerge/provider/user_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_list_tile.dart';
import 'package:letsmerge/widgets/c_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final TextEditingController _nicknameController = TextEditingController();
  final supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();
  final User? user = Supabase.instance.client.auth.currentUser;
  bool _isLoading = false;

  Future<void> _uploadImage() async {
    final userId = user?.id;
    final userInfo = ref.watch(userInfoProvider(user?.id ?? ''));

    final imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (imageFile == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {

      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toString().replaceAll(RegExp(r'[-:. ]'), '')}.$fileExt';
      final filePath = '$userId/$fileName';
      await supabase.storage.from('profiles').uploadBinary(
        filePath,
        bytes,
        fileOptions: FileOptions(contentType: imageFile.mimeType),
      );

      final imageUrl = supabase.storage.from('profiles').getPublicUrl(filePath);
      
      if (userInfo.avatarUrl != null) {
        final originUrl = userInfo.avatarUrl;
        final uri = Uri.parse(originUrl!);

        final segments = uri.pathSegments;
        final startIndex = segments.indexOf('profiles');

        if (startIndex != -1 && startIndex + 1 < segments.length) {
          final filePath = segments.sublist(startIndex + 1).join('/');
          await supabase.storage.from('profiles').remove([filePath]);
        } else {
          debugPrint('profiles 경로를 찾을 수 없음');
        }
      }

      ref.read(userProvider.notifier).updateUserProfileImg(context, ref, imageUrl);

    } catch (error) {
      if (mounted) {
        debugPrint('Unexpected error occurred: $error');
      }
    }
    setState(() => _isLoading = false);
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CInkWell(
                onTap: _uploadImage,
                child: Container(
                  height: 128,
                  width: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: blue20,
                    image: userInfo.avatarUrl != null
                        ? DecorationImage(
                            image: NetworkImage(
                              userInfo.avatarUrl!,
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: userInfo.avatarUrl == null
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
                  if (userInfo.name.isEmpty) {
                    return Text('정보 없음', style: infoTextStyle);
                  } else {
                    return Text(userInfo.name, style: infoTextStyle);
                  }
                }(),
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
                              debugPrint(_nicknameController.text);
                              ref
                                  .read(userProvider.notifier)
                                  .updateUserNickname(
                                      context, ref, _nicknameController.text);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                trailing: () {
                  if (userInfo.nickname == null) {
                    return Text('정보 없음', style: infoTextStyle);
                  } else {
                    return Text(userInfo.nickname!, style: infoTextStyle);
                  }
                }(),
              ),
              CListTile(
                title: '이메일',
                trailing: () {
                  if (userInfo.email.isEmpty) {
                    return Text('정보 없음', style: infoTextStyle);
                  } else {
                    return Text(userInfo.email, style: infoTextStyle);
                  }
                }(),
              ),
              CListTile(
                title: '렛츠머지와 함께한지',
                trailing: () {
                  if (userInfo.createdAt.isEmpty) {
                    return Text('정보 없음', style: infoTextStyle);
                  }
                  try {
                    DateTime createdDate = DateTime.parse(userInfo.createdAt);
                    int days = DateTime.now().difference(createdDate).inDays;
                    return Text('$days일', style: infoTextStyle);
                  } catch (e) {
                    return Text('날짜 오류', style: infoTextStyle);
                  }
                }(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
