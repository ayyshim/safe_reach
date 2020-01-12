import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_reach/src/bloc/contact/bloc.dart';
import 'package:safe_reach/src/ui/widget/phone_contact_item.dart';

class PhoneContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
      child: ListView.separated(
        physics: ClampingScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 12,
          );
        },
        shrinkWrap: true,
        itemCount: BlocProvider.of<ContactBloc>(context).phoneContacts.length,
        itemBuilder: (BuildContext context, int i) {
          Contact c = BlocProvider.of<ContactBloc>(context).phoneContacts[i];
          String phoneNumber;
          if (c.phones.isNotEmpty) {
            phoneNumber = c.phones.first.value;
            return PhoneContactItem(
                name: c.displayName, phoneNumber: phoneNumber);
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
