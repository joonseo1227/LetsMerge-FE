import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/user_fetch_notifier.dart';
import 'package:letsmerge/widgets/c_tag.dart';

class TaxiGroupParticipantCard extends ConsumerWidget {
  final String creatorUserId;
  final dynamic createdUser;
  final List<dynamic> participants;
  final bool isDarkMode;
  final bool isParticipation;

  const TaxiGroupParticipantCard({
    super.key,
    required this.creatorUserId,
    required this.createdUser,
    required this.participants,
    required this.isDarkMode,
    required this.isParticipation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: ThemeModel.surface(isDarkMode),
      width: double.maxFinite,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 대표 사용자 정보
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: ShapeDecoration(
                  color: blue20,
                  shape: CircleBorder(),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                createdUser.nickname!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ThemeModel.text(isDarkMode),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              CTag(
                text: '대표',
                color: TagColor.blue,
              ),
              Spacer(),
              Icon(
                Icons.star,
                size: 16,
                color: ThemeModel.sub2(isDarkMode),
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                '4.5/5.0',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ThemeModel.sub4(isDarkMode),
                ),
              ),
            ],
          ),

          // 참여자 목록
          ...participants.map((participant) {
            final userinfo = ref.watch(userInfoProvider(participant.userId));

            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: ShapeDecoration(
                      color: blue20,
                      shape: CircleBorder(),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    userinfo.nickname!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ThemeModel.text(isDarkMode),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Spacer(),
                  Icon(
                    Icons.star,
                    size: 16,
                    color: ThemeModel.sub2(isDarkMode),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    '4.5/5.0',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ThemeModel.sub4(isDarkMode),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
