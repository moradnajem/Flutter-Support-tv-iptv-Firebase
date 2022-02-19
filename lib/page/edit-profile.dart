import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/input_style.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/models/user_profile.dart';

import '../main.dart';
import '../models/lang.dart';


class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey();

  File? _imagePerson;
  String? name;
  String? city;
  String? phone;





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
        title: Text(AppLocalization.of(context)!.trans("Edit Profile"),style: TextStyle(color: Theme
            .of(context)
            .primaryColor),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: FutureBuilder<UserModel?>(
              future: UserProfile.shared.getUser(),
              builder: (context, snapshot) {

                if (snapshot.hasData) {

                  UserModel? user = snapshot.data;

                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            child: _imagePerson != null
                                ? Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: FileImage(_imagePerson!),
                                      fit: BoxFit.cover)),
                            )
                                : Icon(
                              Icons.person,
                              size: 52,
                              color: Theme.of(context).accentColor,
                            ),
                            radius: 50,
                            backgroundColor: Color(0xFFF0F4F8),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * (100 / 812)),
                      TextFormField(
                        initialValue: user!.name,
                        onSaved: (value) => name = value!.trim(),
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).accentColor,
                        ),
                        decoration: customInputForm.copyWith(prefixIcon: Icon(
                          Icons.person_outline,
                          color: Theme.of(context).accentColor,
                        ),
                        ).copyWith(hintText: AppLocalization.of(context)!.trans("Name")),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        initialValue: user.city,
                        onSaved: (value) => city = value!.trim(),
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).accentColor,
                        ),
                        decoration: customInputForm.copyWith(prefixIcon: Icon(
                          Icons.location_city_outlined,
                          color: Theme.of(context).accentColor,
                        ),
                        ).copyWith(hintText: AppLocalization.of(context)!.trans("City")),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        initialValue: user.phone,
                        onSaved: (value) => phone = value!.trim(),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).accentColor,
                        ),
                        decoration: customInputForm.copyWith(prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: Theme.of(context).accentColor,
                        ),
                        ).copyWith(hintText: AppLocalization.of(context)!.trans("Phone Number")),
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
                          child: Text(AppLocalization.of(context)!.trans("Edit Profile"),
                              style: TextStyle(color:  Theme.of(context).scaffoldBackgroundColor,fontWeight: FontWeight.bold,
                                fontSize: 20,)),
                          onPressed: () => _btnEdit()),
                      SizedBox(height: 20,),
                    ],
                  ),
                );
              } else {
                return Center(child: loader(context));
              }

            }
          ),
        ),
      ),
    );
  }





  bool _validation() {
    return !(name == "" || city == "" || phone == "");
  }

  _btnEdit() {
    _formKey.currentState!.save();



    if (_validation()) {
      FirebaseManager.shared.updateAccount(scaffoldKey: _scaffoldKey, name: name!, city: city!, phoneNumber: phone!,);
    } else {
      _scaffoldKey.showTosta(message: AppLocalization.of(context)!.trans("Please fill in all fields"), isError: true);
    }

  }

}
