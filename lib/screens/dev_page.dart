import 'package:flutter/material.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/screens/auth/log_in_page.dart';
import 'package:letsmerge/screens/auth/sign_up_page.dart';
import 'package:letsmerge/screens/settings_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_switch.dart';

class DevPage extends StatefulWidget {
  const DevPage({super.key});

  @override
  State<DevPage> createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DEV'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CSwitch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
              SizedBox(height: 16),
              CButton(
                label: 'Default Button',
                onTap: () {
                  debugPrint('Default Button Clicked');
                },
              ),
              SizedBox(height: 16),
              CButton(
                style: CButtonStyle.primary,
                label: 'Primary Button',
                icon: Icons.home,
                width: 300,
                onTap: () {
                  debugPrint('Primary Button Clicked');
                },
              ),
              SizedBox(height: 16),
              CButton(
                style: CButtonStyle.secondary,
                icon: Icons.settings,
                size: CButtonSize.medium,
                onTap: () {
                  debugPrint('Secondary Button Clicked');
                },
              ),
              SizedBox(height: 16),
              CButton(
                style: CButtonStyle.tertiary,
                label: 'Tertiary Button',
                icon: Icons.info,
                size: CButtonSize.medium,
                onTap: () {
                  debugPrint('Tertiary Button Clicked');
                },
              ),
              SizedBox(height: 16),
              CButton(
                style: CButtonStyle.danger,
                label: 'Danger Button',
                size: CButtonSize.x2Large,
                onTap: () {
                  debugPrint('Danger Button Clicked');
                },
              ),
              SizedBox(height: 16),
              CButton(
                style: CButtonStyle.ghost,
                label: 'Ghost Button',
                onTap: () {
                  debugPrint('Ghost Button Clicked');
                },
              ),
              SizedBox(height: 16),
              CButton(
                style: CButtonStyle.primary,
                label: 'Small Button',
                size: CButtonSize.small,
                onTap: () {
                  debugPrint('Small Button Clicked');
                },
              ),
              SizedBox(height: 16),
              CButton(
                style: CButtonStyle.secondary,
                label: 'Extra Large Button',
                size: CButtonSize.extraLarge,
                onTap: () {
                  debugPrint('Extra Large Button Clicked');
                },
              ),
              SizedBox(height: 16),
              CButton(
                style: CButtonStyle.tertiary,
                label: 'Custom Width',
                icon: Icons.star,
                width: 250,
                onTap: () {
                  debugPrint('Custom Width Button Clicked');
                },
              ),
              SizedBox(height: 16),
              CInkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LogInPage(),
                    ),
                  );
                },
                child: Container(
                  color: white,
                  height: 120,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '로그인',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: grey100,
                        ),
                      ),
                      Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                            decoration: ShapeDecoration(
                              color: blue20,
                              shape: StadiumBorder(),
                            ),
                            child: Text(
                              'DEV',
                              style: TextStyle(
                                color: blue70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.navigate_next,
                            color: grey100,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              CInkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignUpPage(),
                    ),
                  );
                },
                child: Container(
                  color: white,
                  height: 120,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '회원 가입',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: grey100,
                        ),
                      ),
                      Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                            decoration: ShapeDecoration(
                              color: blue20,
                              shape: StadiumBorder(),
                            ),
                            child: Text(
                              'DEV',
                              style: TextStyle(
                                color: blue70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.navigate_next,
                            color: grey100,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              CInkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ),
                  );
                },
                child: Container(
                  color: white,
                  height: 120,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '설정',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: grey100,
                        ),
                      ),
                      Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                            decoration: ShapeDecoration(
                              color: blue20,
                              shape: StadiumBorder(),
                            ),
                            child: Text(
                              'DEV',
                              style: TextStyle(
                                color: blue70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.navigate_next,
                            color: grey100,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
