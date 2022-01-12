import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/models/assets.dart';
import 'package:tv/manger/status.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/models/user_profile.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      _wrapper();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(Assets.shared.icLogo, width: 225, height: 225, fit: BoxFit.cover,),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text("Ms", textAlign: TextAlign.center, style: TextStyle(color:Theme.of(context).colorScheme.secondary,fontSize: 18),),
      ),
    );
  }

  _wrapper() async {
    await UserProfile.shared.getLanguage().then((lang) {
    });

    UserModel? user = await UserProfile.shared.getUser();

    if (user != null) {

      FirebaseManager.shared.getUserByUid(uid: user.uid).then((user) {
        if (user.accountStatus == Status.ACTIVE) {
          Navigator.of(context).pushNamedAndRemoveUntil("/TabBarPage", (route) => false, arguments: user.userType);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil("/Front", (route) => false);
        }
      });

    } else {
      Navigator.of(context).pushNamedAndRemoveUntil("/Front", (route) => false);
    }

  }

}
