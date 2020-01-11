import 'package:flutter/material.dart';
import 'package:safe_reach/src/constants/colors.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/splash_screen_cloud.png'),
                  fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo_dark.png',
                  height: 75,
                  width: 75,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Safe Reach",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColor.PRIMARY_DARK),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
