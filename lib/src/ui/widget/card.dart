import 'package:flutter/material.dart';
import 'package:safe_reach/src/constants/colors.dart';

class CustomCard extends StatelessWidget {
  final Widget _content;

  const CustomCard({Key key, Widget content})
      : _content = content,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              width: 1, color: AppColor.BORDER_COLOR, style: BorderStyle.solid),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset.fromDirection(3, 0))
          ]),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      child: _content,
    );
  }
}
