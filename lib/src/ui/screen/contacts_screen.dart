import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_reach/src/bloc/contact/bloc.dart';
import 'package:safe_reach/src/constants/colors.dart';
import 'package:safe_reach/src/data/repository/contact_repository.dart';
import 'package:safe_reach/src/ui/widget/appBar.dart';
import 'package:safe_reach/src/ui/widget/loading_screen.dart';
import 'package:safe_reach/src/ui/widget/phone_contacts.dart';
import 'package:safe_reach/src/ui/widget/progress_dialog.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final ContactRepository _contactRepository = ContactRepository();
  ContactBloc _contactBloc;

  @override
  void initState() {
    super.initState();
    _contactBloc = ContactBloc(contactRepository: _contactRepository);
    _contactBloc.add(ContactEvent.requestPermission());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _contactBloc,
      child: Scaffold(
          appBar:
              customAppBar(backgroundColor: Colors.white, title: "Contacts"),
          body: BlocListener(
            listener: (BuildContext context, ContactState state) {
              if (state is AddError) {
                Navigator.pop(context);
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text("Oops! Error occured."),
                    backgroundColor: AppColor.RED,
                    duration: Duration(seconds: 2),
                  ));
              }

              if (state is AddSuccess) {
                Navigator.pop(context);
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text("Added"),
                    backgroundColor: AppColor.GREEN,
                    duration: Duration(seconds: 2),
                  ));
              }

              if (state is Adding) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => ProgressDialog(
                          title: "Adding...",
                        ));
              }
            },
            bloc: _contactBloc,
            child: BlocBuilder(
              bloc: _contactBloc,
              builder: (BuildContext context, ContactState state) {
                if (state is Loading) {
                  return LoadingScreen();
                }
                return state.whenPartial(
                  addSuccess: (_) => PhoneContacts(),
                  addError: (_) => PhoneContacts(),
                  adding: (_) => PhoneContacts(),
                  initial: (_) => Container(),
                  loaded: (s) => PhoneContacts(),
                  error: (_) => Container(
                    child: Center(
                      child: Text("Oops!"),
                    ),
                  ),
                );
              },
            ),
          )),
    );
  }

  @override
  void dispose() {
    _contactBloc.close();
    super.dispose();
  }
}
