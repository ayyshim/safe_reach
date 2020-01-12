import 'package:flutter/material.dart';
import 'package:safe_reach/src/constants/colors.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: AppColor.PRIMARY_DARK,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Loading...",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColor.GREY),
            )
          ],
        ),
      ),
    );
  }
}
