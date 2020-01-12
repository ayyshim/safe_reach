import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:safe_reach/src/bloc/authentication/authentication_bloc.dart';
import 'package:safe_reach/src/bloc/contact/bloc.dart';
import 'package:safe_reach/src/constants/colors.dart';
import 'package:safe_reach/src/ui/widget/button.dart';
import 'package:safe_reach/src/ui/widget/card.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneContactItem extends StatelessWidget {
  final String _name;
  final String _phoneNumber;

  const PhoneContactItem({
    Key key,
    @required String name,
    @required String phoneNumber,
  })  : _name = name,
        _phoneNumber = phoneNumber,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  this._name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  this._phoneNumber,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              RoundedIconButton(
                onPressed: () {
                  launch('tel:${this._phoneNumber}');
                },
                icon: MdiIcons.phone,
              ),
              SizedBox(
                width: 8,
              ),
              RoundedIconButton(
                onPressed: () {
                  Map<String, dynamic> data = {
                    "title": this._name,
                    "phoneNumber": this._phoneNumber,
                    "uid": BlocProvider.of<AuthenticationBloc>(context)
                        .authUser
                        .uid,
                  };

                  BlocProvider.of<ContactBloc>(context)
                      .add(ContactEvent.contactAdd(data: data));
                },
                icon: MdiIcons.plus,
                iconColor: Colors.white,
                backgroundColor: AppColor.GREEN,
              )
            ],
          )
        ],
      ),
    );
  }
}
