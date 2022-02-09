import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/models/SectionModel.dart';
import 'package:tv/models/alert_sheet.dart';
import 'package:tv/models/assets.dart';
import 'package:tv/models/channelModel.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/input_style.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/models/loader.dart';

import '../main.dart';
import 'SubscriptionsModel.dart';


class add extends StatefulWidget {
  SubscriptionsModel? updateSubscription;
  add({this.updateSubscription});
  @override
  _addState createState() => _addState();
}

class _addState extends State<add> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();

  late String SubscriptionEN = "";
  late String SubscriptionAR = "";
  late String details = "";

  String buttonMode = "ADD";



  @override
  void initState() {
    super.initState();
    if (widget.updateSubscription != null) {
      SubscriptionEN = widget.updateSubscription!.SubscriptionEN;
      SubscriptionAR = widget.updateSubscription!.SubscriptionAR;
      details = widget.updateSubscription!.details;
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
                              initialValue: SubscriptionEN,
                              onSaved: (value) => SubscriptionEN = value!.trim(),
                              keyboardType: TextInputType.name,
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
                              initialValue: SubscriptionAR,
                              onSaved: (value) => SubscriptionAR = value!.trim(),
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
                              initialValue: details,
                              onSaved: (value) => details = value!.trim(),
                              keyboardType: TextInputType.name,
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
                                  .copyWith(hintText: "details"),
                            ),
                            RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text(buttonMode,
                                    style: TextStyle(
                                      color: Theme.of(context).canvasColor,
                                    )),
                                onPressed: () => widget.updateSubscription != null
                                    ? _section(uid: widget.updateSubscription!.uid)
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
    return !(SubscriptionEN == "" || SubscriptionAR == "");
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

    FirebaseManager.shared.Subscription(context, uid: uid,scaffoldKey: _scaffoldKey,
      SubscriptionEN: SubscriptionEN,
      SubscriptionAR: SubscriptionAR, details: details,
    );
  }
}
