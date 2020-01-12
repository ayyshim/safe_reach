import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_reach/src/bloc/emergency_contact/bloc.dart';
import 'package:safe_reach/src/bloc/emergency_contact/emergency_contact_bloc.dart';
import 'package:safe_reach/src/constants/colors.dart';
import 'package:safe_reach/src/ui/screen/contacts_screen.dart';
import 'package:safe_reach/src/ui/widget/button.dart';
import 'package:safe_reach/src/ui/widget/emergency_contact_item.dart';
import 'package:safe_reach/src/ui/widget/loading_screen.dart';
import 'package:safe_reach/src/ui/widget/progress_dialog.dart';
import 'package:safe_reach/src/ui/widget/section.dart';

class EmergencyContacts extends StatefulWidget {
  @override
  _EmergencyContactsState createState() => _EmergencyContactsState();
}

class _EmergencyContactsState extends State<EmergencyContacts> {
  @override
  Widget build(BuildContext context) {
    return Section(
      title: "Emergency Contacts",
      content: BlocListener(
        bloc: BlocProvider.of<EmergencyContactBloc>(context),
        listener: (BuildContext context, EmergencyContactState state) {
          if (state is Error) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text("Error..."),
                backgroundColor: AppColor.RED,
                duration: Duration(seconds: 2),
              ));
          }

          if (state is Deleting) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) => ProgressDialog(
                      title: "Deleting...",
                    ));
          }

          if (state is DeleteSuccess) {
            Navigator.pop(context);
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text("Deleted"),
                backgroundColor: AppColor.GREEN,
                duration: Duration(seconds: 2),
              ));
          }

          if (state is DeleteError) {
            Navigator.pop(context);
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text("Something went wrong!"),
                backgroundColor: AppColor.RED,
                duration: Duration(seconds: 2),
              ));
          }
        },
        child: Column(
          children: <Widget>[
            Container(
              child: BlocBuilder(
                  bloc: BlocProvider.of<EmergencyContactBloc>(context),
                  builder: (BuildContext context, EmergencyContactState state) {
                    if (state is Loading) {
                      return LoadingScreen();
                    }

                    return this._listView();
                  }),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                PrimaryButton(
                  label: "Add",
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return ContactsScreen();
                    }));
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _listView() {
    return ListView.separated(
      separatorBuilder: (_, int i) {
        return SizedBox(
          height: 12,
        );
      },
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: BlocProvider.of<EmergencyContactBloc>(context)
          .emergencyContacts
          .length,
      itemBuilder: (BuildContext context, int index) {
        final contact = BlocProvider.of<EmergencyContactBloc>(context)
            .emergencyContacts[index];
        return ContactItem(
          id: contact.id,
          name: contact.title,
          phoneNumber: contact.phoneNumber,
        );
      },
    );
  }
}
