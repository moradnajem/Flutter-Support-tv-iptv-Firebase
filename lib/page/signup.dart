import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/alert_sheet.dart';
import 'package:tv/manger/assets.dart';
import 'package:tv/manger/extensions.dart';
import 'package:tv/manger/input_style.dart';
import 'package:tv/manger/user-type.dart';


import '../main.dart';


class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _userTypeController = TextEditingController();

  late String username;
  late String email;
  late String password;
  late String city;
  late String phoneNumber;
  late UserType userType;
  bool agreeToPrivacy = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _userTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * (60 / 812)),
                      Image.asset(Assets.shared.icLogo, fit: BoxFit.cover, height: MediaQuery.of(context).size.height * (250 / 812),),
                      const SizedBox(height: 50,),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              onSaved: (value) => username = value!.trim(),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: customInputForm.copyWith(prefixIcon: Icon(
                                Icons.person_outline,
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: AppLocalization.of(context)!.trans("User name")),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              onSaved: (value) => email = value!.trim(),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: customInputForm.copyWith(prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: AppLocalization.of(context)!.trans("Email")),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              onSaved: (value) => password = value!.trim(),
                              textInputAction: TextInputAction.next,
                              obscureText: true,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: customInputForm.copyWith(prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: AppLocalization.of(context)!.trans("Password")),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              onSaved: (value) => city = value!.trim(),
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: customInputForm.copyWith(prefixIcon: Icon(
                                Icons.location_city_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: AppLocalization.of(context)!.trans("City")),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              onSaved: (value) => phoneNumber = value!.trim(),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: customInputForm.copyWith(prefixIcon: Icon(
                                Icons.phone_outlined,
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: AppLocalization.of(context)!.trans("Phone Number")),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              controller: _userTypeController,
                              onTap: () {
                                alertSheet(context, title: "User type", items: ["ADMIN", "USER"], onTap: (value) {
                                  _userTypeController.text = value;
                                  if (value == "ADMIN") {
                                    userType = UserType.ADMIN;
                                  } else {
                                    userType = UserType.USER;
                                  }
                                  return;
                                });
                              },
                              readOnly: true,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: customInputForm.copyWith(prefixIcon: Icon(
                                Icons.person_outline,
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: "User type"),
                            ),
                            SizedBox(height: 20,),
                            Row(
                              children: [
                                Checkbox(value: agreeToPrivacy, activeColor: Theme.of(context).primaryColor, onChanged: (value) => {
                                  setState(() {
                                    agreeToPrivacy = value!;
                                  })
                                }),
                                Text("agree to the ", style: TextStyle(fontSize: 16),),
                                InkWell(onTap: () {
                                  Navigator.of(context).pushNamed("/PrivacyTerms");
                                }, child: Text("terms of privacy", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, decoration: TextDecoration.underline,),)),
                              ],
                            ),
                            SizedBox(height: 20,),
                            RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text(AppLocalization.of(context)!.trans("Sign Up"),
                                    style: TextStyle(color: Theme.of(context).canvasColor,)),
                                onPressed:  _btnSignup
                            ),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool validation() {
    return !(username.isEmpty || email.isEmpty || password.isEmpty || city.isEmpty || phoneNumber.isEmpty || userType == null);
  }

  _btnSignup() {

    _formKey.currentState!.save();

    if (!validation()) {
      _scaffoldKey.showTosta(message: AppLocalization.of(context)!.trans("Please fill in all fields"), isError: true);
      return;
    }

    if (!agreeToPrivacy) {
      _scaffoldKey.showTosta(message: AppLocalization.of(context)!.trans("Please agree to the privacy terms"), isError: true);
      return;
    }

    FirebaseManager.shared.createAccountUser(scaffoldKey: _scaffoldKey, name: username, phone: phoneNumber, email: email, city: city, password: password, imagePath: '', userType: userType);

  }

}