import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:safe_reach/src/bloc/emergency_contact/bloc.dart';
import 'package:safe_reach/src/constants/colors.dart';
import 'package:safe_reach/src/ui/widget/button.dart';
import 'package:safe_reach/src/ui/widget/card.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactItem extends StatelessWidget {
  final String _id;
  final String _name;
  final String _phoneNumber;

  const ContactItem({
    Key key,
    @required String id,
    @required String name,
    @required String phoneNumber,
  })  : _id = id,
        _name = name,
        _phoneNumber = phoneNumber,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
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
                  print('Delete ${this._id}');
                  BlocProvider.of<EmergencyContactBloc>(context)
                      .add(EmergencyContactEvent.delete(id: this._id));
                },
                icon: MdiIcons.trashCan,
                iconColor: Colors.white,
                backgroundColor: AppColor.RED,
              )
            ],
          )
        ],
      ),
    );
  }
}
