import 'package:flutter/material.dart';
import 'package:safe_reach/src/constants/colors.dart';

class Section extends StatelessWidget {
  final Widget _content;
  final String _title;
  const Section({Key key, @required Widget content, @required String title})
      : _content = content,
        _title = title,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(this._title,
              style: TextStyle(
                color: AppColor.GREY,
                fontSize: 14,
              )),
          SizedBox(
            height: 18,
          ),
          this._content
        ],
      ),
    );
  }
}
