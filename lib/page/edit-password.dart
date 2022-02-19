import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/input_style.dart';

import '../models/lang.dart';


class EditPassword extends StatelessWidget {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey();

  String? newPassword;
  String? confirmPassword;

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
        title: Text(AppLocalization.of(context)!.trans("Edit Password"),style: TextStyle(color: Theme
          .of(context)
          .primaryColor),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 30),
              Icon(
                Icons.lock_outline,
                size: 150,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * (100 / 812)),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (value) => newPassword = value!.trim(),
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).accentColor,
                      ),
                      decoration: customInputForm.copyWith(prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Theme.of(context).accentColor,
                      ),
                      ).copyWith(hintText: AppLocalization.of(context)!.trans("New password")),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      onSaved: (value) => confirmPassword = value!.trim(),
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).accentColor,
                      ),
                      decoration: customInputForm.copyWith(prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Theme.of(context).accentColor,
                      ),
                      ).copyWith(hintText: AppLocalization.of(context)!.trans("Confirm password")),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * (100 / 812)),
                    RaisedButton(
                        shape: StadiumBorder(),

                        elevation: 20,
                        focusElevation: 20,
                        hoverElevation: 20,
                        highlightElevation: 20,
                        disabledElevation: 0,
                        color: Theme.of(context).accentColor,
                        child: Text(AppLocalization.of(context)!.trans("Change password"),
                            style: TextStyle(color:  Theme.of(context).scaffoldBackgroundColor,fontWeight: FontWeight.bold,
                              fontSize: 20,)),
                        onPressed: () => _btnChange(context)),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validation() {
    return !(newPassword == "" || confirmPassword == "");
  }

  _btnChange(context) {

    _formKey.currentState!.save();

    if (_validation()) {
      if (newPassword == confirmPassword) {
        FirebaseManager.shared.changePassword(scaffoldKey: _scaffoldKey, newPassword: newPassword!, confirmPassword: confirmPassword!);
      } else {
        _scaffoldKey.showTosta(message: AppLocalization.of(context)!.trans("Passwords do not match"), isError: true);
      }
    } else {
      _scaffoldKey.showTosta(message: AppLocalization.of(context)!.trans("Please fill in all fields"), isError: true);
    }

  }

}
