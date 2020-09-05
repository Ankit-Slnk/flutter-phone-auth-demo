import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/utility/appColors.dart';

class UserProfileScreen extends StatefulWidget {
  User user;
  UserProfileScreen({@required this.user});
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.blackColor,
        ),
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.whiteColor,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            widget.user.toString(),
          ),
        ),
      ),
    );
  }
}
