import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_reach/src/bloc/authentication/authentication_bloc.dart';
import 'package:safe_reach/src/constants/colors.dart';
import 'package:safe_reach/src/data/model/user_model.dart';
import 'package:safe_reach/src/ui/widget/card.dart';
import 'package:safe_reach/src/ui/widget/section.dart';

class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = BlocProvider.of<AuthenticationBloc>(context).authUser;
    return Section(
        title: "Profile",
        content: CustomCard(
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(user.displayName,
                      style: TextStyle(
                        color: AppColor.BLACK,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text(user.email,
                      style: TextStyle(
                        color: AppColor.BLACK,
                        fontSize: 12,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              )),
              SizedBox(
                width: 18,
              ),
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              )
            ],
          ),
        ));
  }
}
