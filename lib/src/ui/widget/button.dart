import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:safe_reach/src/constants/colors.dart';

class LoginWithGoogleButton extends StatelessWidget {
  final Function _onPressed;

  const LoginWithGoogleButton({Key key, Function onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: this._onPressed,
      borderSide: BorderSide(
        color: AppColor.PRIMARY,
      ),
      highlightedBorderColor: AppColor.PRIMARY_DARK,
      textColor: AppColor.PRIMARY,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Icon(MdiIcons.google),
          ),
          Align(
              alignment: Alignment.center,
              child: Text(
                "Login with Google",
                textAlign: TextAlign.center,
              ))
        ],
      ),
    );
  }
}
