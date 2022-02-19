import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/models/assets.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/input_style.dart';


import '../models/lang.dart';


class ForgotPassword extends StatelessWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _emailController = TextEditingController();

  late String email;

  ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
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
                  SizedBox(height: MediaQuery.of(context).size.height * (40 / 812)),
                  Image.asset(Assets.shared.icLogo, fit: BoxFit.cover, height: MediaQuery.of(context).size.height * (250 / 812),),

                  const SizedBox(height: 50,),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          onSaved: (value) => email = value!.trim(),
                          keyboardType: TextInputType.emailAddress,
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
                        SizedBox(height: MediaQuery.of(context).size.height * (120 / 812)),
                      RaisedButton(
                          shape: StadiumBorder(),

                          elevation: 20,
                          focusElevation: 20,
                          hoverElevation: 20,
                          highlightElevation: 20,
                          disabledElevation: 0,
                          color: Theme.of(context).primaryColor,
                          child: Text(AppLocalization.of(context)!.trans("Reset password"),
                              style: TextStyle(color: Theme.of(context).canvasColor,)),
                          onPressed:  _btnForgotPassword),
                        const SizedBox(height: 35,),
                      ],
                    ),
                  ),
                ],
              ),
             )
          )
            ],
          ),
        ),
      ),
    );
  }

  _btnForgotPassword() async {

    _formKey.currentState!.save();

    if (email != "") {
      bool success = await FirebaseManager.shared.forgotPassword(scaffoldKey: _scaffoldKey, email: email);

      if (success) {
        _emailController.text = "";
        _scaffoldKey.showTosta(message: AppLocalization.of(_scaffoldKey.currentContext!)!.trans("The appointment link has been sent to your email"));
      }

    } else {
      _scaffoldKey.showTosta(message: AppLocalization.of(_scaffoldKey.currentContext!)!.trans("Please enter your email"), isError: true);
    }

  }

}