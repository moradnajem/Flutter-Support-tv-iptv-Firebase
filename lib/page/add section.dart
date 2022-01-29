// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/models/SectionModel.dart';
import 'package:tv/models/alert_sheet.dart';
import 'package:tv/models/assets.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/input_style.dart';
import 'package:tv/manger/Section.dart';

import '../main.dart';

class addsection extends StatefulWidget {
  SectionModel? updateSection;
  addsection({this.updateSection});
  @override
  _addsectionState createState() => _addsectionState();
}

class _addsectionState extends State<addsection> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _userTypeController = TextEditingController();

  late Section section;
  late String titleEN = "";
  late String titleAR = "";
  String buttonMode = "ADD";

  @override
  void dispose() {
    // TODO: implement dispose
    _userTypeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.updateSection != null) {
      _userTypeController =
          TextEditingController(text: widget.updateSection!.section.name);
      titleEN = widget.updateSection!.titleEN;
      titleAR = widget.updateSection!.titleAR;
      section = widget.updateSection!.section;
      buttonMode = "UPDATE";
    }
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
                      SizedBox(
                          height:
                          MediaQuery.of(context).size.height * (60 / 812)),
                      Image.asset(
                        Assets.shared.icLogo,
                        fit: BoxFit.cover,
                        height:
                        MediaQuery.of(context).size.height * (250 / 812),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: titleEN,
                              onSaved: (value) => titleEN = value!.trim(),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: customInputForm
                                  .copyWith(
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                                  .copyWith(hintText: "titleEN"),
                            ),
                            TextFormField(
                              initialValue: titleAR,
                              onSaved: (value) => titleAR = value!.trim(),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: customInputForm
                                  .copyWith(
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                                  .copyWith(hintText: "titleAR"),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _userTypeController,
                              onTap: () {
                                alertSheet(context,
                                    title: " type",
                                    items: ["LIVE", "Movies" , "Series"], onTap: (value) {
                                      _userTypeController.text = value;
                                      if (value == "LIVE") {
                                        section = Section.LIVE;
                                      } else if (value == "Movies"){
                                        section = Section.Movies;
                                      }else{
                                        section = Section.Series;
                                      }
                                      return;
                                    });
                              },
                              readOnly: true,
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              decoration: customInputForm
                                  .copyWith(
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                                  .copyWith(hintText: " type"),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text(buttonMode,
                                    style: TextStyle(
                                      color: Theme.of(context).canvasColor,
                                    )),
                                onPressed: () => widget.updateSection != null
                                    ? _section(uid: widget.updateSection!.uid)
                                    : _section()),
                            const SizedBox(
                              height: 20,
                            ),
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
    return !(titleEN == "" || titleAR == "");
  }

  _section({String uid = ""}) {
    _formKey.currentState!.save();

    if (!validation()) {
      _scaffoldKey.showTosta(
          message:
          AppLocalization.of(context)!.trans("Please fill in all fields"),
          isError: true);
      return;
    }

    FirebaseManager.shared.section(
      context,
      uid: uid,
      scaffoldKey: _scaffoldKey,
      section: section,
      titleEN: titleEN,
      titleAR: titleAR,
    );
  }
}
