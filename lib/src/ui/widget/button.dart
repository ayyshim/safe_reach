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

class PrimaryButton extends StatelessWidget {
  final String _label;
  final Function _onPressed;

  PrimaryButton({Key key, @required String label, @required Function onPressed})
      : _label = label,
        _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: this._onPressed,
      child: Text(
        this._label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      color: AppColor.PRIMARY,
      elevation: 5,
      splashColor: AppColor.PRIMARY_DARK,
      highlightElevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
    );
  }
}

class BlueButton extends StatelessWidget {
  final String _label;
  final Function _onPressed;

  BlueButton({Key key, @required String label, @required Function onPressed})
      : _label = label,
        _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: this._onPressed,
      child: Text(
        this._label,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
      color: AppColor.BLUE,
      elevation: 5,
      splashColor: AppColor.BLUE_DARK,
      highlightElevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  final Color _iconColor;
  final IconData _icon;
  final Color _backgroundColor;
  final Function _onPressed;

  RoundedIconButton({
    Key key,
    @required Function onPressed,
    @required IconData icon,
    Color iconColor,
    Color backgroundColor,
  })  : _onPressed = onPressed,
        _backgroundColor = backgroundColor ?? AppColor.PRIMARY,
        _iconColor = iconColor ?? AppColor.BLACK,
        _icon = icon,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: this._backgroundColor, // button color
        child: InkWell(
          // inkwell color
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
                width: 32,
                height: 32,
                child: Icon(
                  this._icon,
                  color: this._iconColor,
                  size: 18,
                )),
          ),
          onTap: this._onPressed,
        ),
      ),
    );
  }
}
