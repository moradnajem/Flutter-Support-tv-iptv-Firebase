import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/models/assets.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/input_style.dart';

import '../models/lang.dart';




class SignIn extends StatefulWidget {

  final Object?  message;

  const SignIn({Key? key, this.message}) : super(key: key);
  @override
  _SignInState createState() => _SignInState();
}
class _SignInState extends State<SignIn> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();

  late String email;
  late String password;
  bool isShowPassword = false;
  @override


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.message != null) {
      Future.delayed(const Duration(seconds: 1), () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Done Successfully'),
            content: const Text('Account created successfully, Your account in now under review'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text(
                  "OK",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
      elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            children: [
          Center(
          child: Container(
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
              child: Column(
                children: [
                  Image.asset(Assets.shared.icLogo, fit: BoxFit.cover, height: MediaQuery.of(context).size.height * (250 / 812),),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          children: [
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
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              obscureText: !isShowPassword,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: customInputForm.copyWith(prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: AppLocalization.of(context)!.trans("Password"))
                                  .copyWith(suffixIcon: GestureDetector(
                                onTap: () => setState(() {
                                  isShowPassword = !isShowPassword;
                                }),
                                child: Container(padding: const EdgeInsets.all(10), child: SvgPicture.asset(isShowPassword ? Assets.shared.icInvisible : Assets.shared.icVisibility, color: Theme.of(context).primaryColor, height: 5, width: 5,)),
                              )),
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FlatButton(
                                  child: Text(
                                    AppLocalization.of(context)!.trans("Forgot Password?"),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onPressed: () => Navigator.pushNamed(context, '/ForgotPassword'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text(AppLocalization.of(context)!.trans("Sign In"),
                                    style: TextStyle(color: Theme.of(context).canvasColor,)),
                                onPressed:  _btnSignin),

                        Column(
                          children: [
                            const SizedBox(height: 20),
                            FlatButton(
                                onPressed: () => Navigator.pushNamed(context, '/SignUp'),
                                child: Text(
                                  AppLocalization.of(context)!.trans("Create new account"),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
              ]
                    ),
        )
          ]
              )
        )
          )
            ],
          ),
        ),
      ),
    );
  }

  bool _validation() {
    return !(email == "" || password == "");
  }

  _btnSignin() {

    _formKey.currentState!.save();

    if (!_validation()) {
      _scaffoldKey.showTosta(message: AppLocalization.of(context)!.trans("Please fill in all fields"), isError: true);
      return;
    }

    FirebaseManager.shared.login(scaffoldKey: _scaffoldKey, email: email, password: password);
  }
}
