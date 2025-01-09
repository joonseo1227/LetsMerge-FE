import 'package:flutter/material.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                CInkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(16),
                    color: white,
                    child: Row(
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          decoration: ShapeDecoration(
                            color: blue20,
                            shape: CircleBorder(),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          '홍길동',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: grey100,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.navigate_next,
                          color: grey100,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
