import 'package:flutter/material.dart';
import 'package:tv/main.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/models/assets.dart';
import 'package:tv/manger/status.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/models/user_profile.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      _wrapper();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Image.asset(
            Assets.shared.icLogo,
            width: 225,
            height: 225,
            fit: BoxFit.cover,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Text(
          "OMNI",
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18),
        ),
      ),
    );
  }

  _wrapper() async {
    UserModel? user;
    await UserProfile.shared.getUser().then((value) {
      if (value == null) {
        return;
      } else {
        user = value;
      }
    });

    if (user != null) {
      FirebaseManager.shared.getUserByUid(uid: user!.uid!).then((user) {
        if (user.accountStatus == Status.ACTIVE) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/TabBarPage", (route) => false,
              arguments: user.userType);
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/SignIn", (route) => false);
        }
      });
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/SignIn", (route) => false);
    }
  }
}
