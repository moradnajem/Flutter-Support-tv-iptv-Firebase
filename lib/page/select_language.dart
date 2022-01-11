import 'package:flutter/material.dart';
import 'package:tv/models/assets.dart';
import 'package:tv/manger/language.dart';

import 'package:tv/models/user_profile.dart';

import '../main.dart';


class SelectLanguage extends StatelessWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * (60 / 812)),
            Expanded(child: Image.asset(Assets.shared.icLogo)),
            SizedBox(height: MediaQuery.of(context).size.height * (60 / 812)),
            RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text("English",
                    style: TextStyle(color: Theme.of(context).canvasColor,)),
                onPressed: () => _btnSelectLanguage(context, lang: Language.ENGLISH),),
         //   BtnMain(title: "English", onTap: () => _btnSelectLanguage(context, lang: Language.ENGLISH),),
            const SizedBox(height: 20),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text("عربي",
                  style: TextStyle(color: Theme.of(context).canvasColor,)),
              onPressed: () => _btnSelectLanguage(context, lang: Language.ARABIC),),
         //   BtnMain(title: "عربي", onTap: () => _btnSelectLanguage(context, lang: Language.ARABIC),),
          ],
        ),
      ),
    );
  }

  _btnSelectLanguage(context, { required Language lang }) {
    MyApp.setLocale(context, Locale(lang == Language.ARABIC ? "ar" : "en"));
    UserProfile.shared.setLanguage(language: lang);
    Navigator.of(context).pushReplacementNamed("/Front");
  }

}
