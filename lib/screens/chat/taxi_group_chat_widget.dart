import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/location_model.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_tag.dart';
import 'package:letsmerge/models/bank_model.dart';
import 'package:letsmerge/widgets/c_map_widget.dart';

class TextMessageWidget extends StatelessWidget {
  final String formattedTime;
  final String content;
  final bool isDarkMode;

  const TextMessageWidget({
    Key? key,
    required this.formattedTime,
    required this.content,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 시간 표시 및 메시지 내용
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formattedTime,
              style: TextStyle(
                color: ThemeModel.sub3(isDarkMode),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
            const SizedBox(width: 8),
            IntrinsicWidth(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ThemeModel.highlight(isDarkMode),
                ),
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AccountMessageWidget extends StatelessWidget {
  final String formattedTime;
  final String content;
  final bool isDarkMode;

  const AccountMessageWidget({
    Key? key,
    required this.formattedTime,
    required this.content,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parts = content.split(' ');
    final String bankName = parts.isNotEmpty ? parts[0].trim() : '';
    final String accountNumber = parts.length > 1 ? parts[1].trim() : content;

    final bankInfo = bankList.firstWhere(
      (bank) => bank.name == bankName,
      orElse: () => BankInfo(name: bankName, color: TagColor.grey),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formattedTime,
              style: TextStyle(
                color: ThemeModel.sub3(isDarkMode),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(
                    text: bankName + accountNumber,
                  ),
                );
              },
              child: IntrinsicWidth(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ThemeModel.highlight(isDarkMode),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '계좌 정보',
                        style: TextStyle(
                          fontSize: 16,
                          color: white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          CTag(
                            text: bankInfo.name,
                            color: bankInfo.color,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            accountNumber,
                            style: TextStyle(
                              fontSize: 16,
                              color: white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "메시지를 누르면 복사됩니다.",
                        style: TextStyle(
                          fontSize: 16,
                          color: white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LocationMessageWidget extends StatelessWidget {
  final String formattedTime;
  final LocationModel locationModel;
  final bool isDarkMode;

  const LocationMessageWidget({
    Key? key,
    required this.formattedTime,
    required this.locationModel,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 시간 표시 및 위치 공유 메시지 내용
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formattedTime,
              style: TextStyle(
                color: ThemeModel.sub3(isDarkMode),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
            const SizedBox(width: 8),
            IntrinsicWidth(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ThemeModel.highlight(isDarkMode),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '위치 공유',
                      style: TextStyle(
                        fontSize: 16,
                        color: white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '정확한 위치와 오차가 발생할 수 있으니 주의하세요.',
                      style: TextStyle(
                        fontSize: 12,
                        color: white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CMapWidget(
                      width: 300,
                      height: 200,
                      isDarkMode: isDarkMode,
                      initialLatitude: locationModel.latitude,
                      initialLongitude: locationModel.longitude,
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}



class OtherAccountMessageWidget extends StatelessWidget {
  final String senderId;
  final String formattedTime;
  final String content;
  final bool isDarkMode;

  const OtherAccountMessageWidget({
    Key? key,
    required this.senderId,
    required this.formattedTime,
    required this.content,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parts = content.split(' ');
    final String bankName = parts.isNotEmpty ? parts[0] : '';
    final String accountNumber = parts.length > 1 ? parts[1] : content;

    final bankInfo = bankList.firstWhere(
          (bank) => bank.name == bankName,
      orElse: () => BankInfo(name: bankName, color: TagColor.grey),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            width: 40,
            height: 40,
            decoration: const ShapeDecoration(
              color: blue20,
              shape: CircleBorder(),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                senderId,
                style: TextStyle(
                  color: ThemeModel.sub3(isDarkMode),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: content));
              },
              child: IntrinsicWidth(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeModel.highlight(isDarkMode),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '계좌 정보',
                        style: TextStyle(
                          fontSize: 16,
                          color: white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            bankInfo.name,
                            style: TextStyle(
                              fontSize: 16,
                              color: white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            accountNumber,
                            style: TextStyle(
                              fontSize: 16,
                              color: white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "메시지를 누르면 복사됩니다.",
                        style: TextStyle(
                          fontSize: 14,
                          color: ThemeModel.sub3(isDarkMode),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formattedTime,
              style: TextStyle(
                color: ThemeModel.sub3(isDarkMode),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OtherLocationMessageWidget extends StatelessWidget {
  final String senderId;
  final String formattedTime;
  final LocationModel locationModel;
  final bool isDarkMode;

  const OtherLocationMessageWidget({
    Key? key,
    required this.senderId,
    required this.formattedTime,
    required this.locationModel,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            width: 40,
            height: 40,
            decoration: const ShapeDecoration(
              color: blue20,
              shape: CircleBorder(),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                senderId,
                style: TextStyle(
                  color: ThemeModel.sub3(isDarkMode),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IntrinsicWidth(
              child: Container(
                padding: const EdgeInsets.all(12),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  color: ThemeModel.highlight(isDarkMode),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '위치 공유',
                      style: TextStyle(
                        fontSize: 16,
                        color: white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CMapWidget(
                      width: 300,
                      height: 200,
                      initialLatitude: locationModel.latitude,
                      initialLongitude: locationModel.longitude,
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formattedTime,
              style: TextStyle(
                color: ThemeModel.sub3(isDarkMode),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OtherTextMessageWidget extends StatelessWidget {
  final String senderId;
  final String formattedTime;
  final String content;
  final bool isDarkMode;

  const OtherTextMessageWidget({
    Key? key,
    required this.senderId,
    required this.formattedTime,
    required this.content,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            width: 40,
            height: 40,
            decoration: const ShapeDecoration(
              color: blue20,
              shape: CircleBorder(),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                senderId,
                style: TextStyle(
                  color: ThemeModel.sub3(isDarkMode),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IntrinsicWidth(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ThemeModel.highlight(isDarkMode),
                ),
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
