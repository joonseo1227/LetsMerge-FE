import 'package:flutter/material.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CInkWell(
                  onPressed: () {
                    debugPrint('눌림');
                  },
                  child: Container(
                    color: white,
                    height: 120,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '예약하기',
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
                                color: green20,
                                shape: StadiumBorder(),
                              ),
                              child: Text(
                                'NEW',
                                style: TextStyle(
                                  color: green70,
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
      ),
    );
  }
}
