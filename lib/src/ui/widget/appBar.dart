import 'package:flutter/material.dart';
import 'package:safe_reach/src/constants/colors.dart';

Widget customAppBar(
    {List<Widget> actions, String title, Color backgroundColor}) {
  return AppBar(
    backgroundColor: backgroundColor ?? AppColor.PRIMARY,
    primary: true,
    actions: actions ?? [],
    title: Text(
      title ?? "",
      style: TextStyle(
        fontFamily: 'Ubuntu',
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
  );
}
