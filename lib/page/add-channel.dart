// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tv/main.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/models/alert_sheet.dart';
import 'package:tv/models/assets.dart';
import 'package:tv/models/channelModel.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/input_style.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/models/user_profile.dart';
import 'package:tv/models/SectionModel.dart';

class addchannel extends StatefulWidget {
  String? uidActiveService;
  ChannelModel? channelSelected;
  addchannel({this.channelSelected});
  @override
  _addchannelState createState() => _addchannelState();
}

class _addchannelState extends State<addchannel> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _userTypeController = TextEditingController();
  TextEditingController _dropDownController = TextEditingController();
  late Section section;

  late String titleEN = "";
  late String titleAR = "";
  String? streamURL = "";
  String? _activeDropDownItem = "";
  String? sectionUid = "";
  String buttonMode = "ADD";
  List<SectionModel>? _dropdownMenuItem = [];
  SectionModel? currentSection;
  Language lang = Language.ENGLISH;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        lang = value!;
      });
    });

    if (widget.channelSelected != null) {
      _userTypeController =
          TextEditingController(text: widget.channelSelected!.section.name);
      _dropDownController = TextEditingController(text: _activeDropDownItem);
      titleEN = widget.channelSelected!.titleEN;
      titleAR = widget.channelSelected!.titleAR;
      streamURL = widget.channelSelected!.streamURL;
      section = widget.channelSelected!.section;
      getSection(widget.channelSelected!.sectionuid).then((value) {
        if (lang == Language.ENGLISH) {
          _activeDropDownItem = value.titleEN;
        } else {
          _activeDropDownItem = value.titleAR;
        }
        setState(() {
          _dropDownController =
              TextEditingController(text: _activeDropDownItem);
        });
      });

      getSectionList(widget.channelSelected!.section).then((value) {
        for (var element in value) {
          _dropdownMenuItem!.add(element);
        }
      });
    
      buttonMode = "UPDATE";
    }
  }

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
                              controller: _userTypeController,
                              onTap: () {
                                alertSheet(context,
                                    title: " type",
                                    items: ["LIVE", "Movies", "Series"],
                                    onTap: (value) {
                                      print("omar${value}");
                                  _userTypeController.text = value;
                                  if (value == "LIVE") {
                                    section = Section.LIVE;
                                  } else if (value == "Movies") {
                                    section = Section.Movies;
                                  } else {
                                    section = Section.Series;
                                  }
                                  _getServiceData(section);
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
                            TextFormField(
                              initialValue: titleAR,
                              onChanged: (value) => titleAR = value.trim(),
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
                            TextFormField(
                              initialValue: titleEN,
                              onChanged: (value) => titleEN = value.trim(),
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
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              initialValue: streamURL,
                              onChanged: (value) => streamURL = value.trim(),
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
                                  .copyWith(hintText: "streamURL"),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _dropDownController,
                              onTap: () {
                                alertSheet(context,
                                    addChannel: true,
                                    title: " type",
                                    items: _dropdownMenuItem!, onTap: (value) {
                                  lang == Language.ENGLISH
                                      ? _dropDownController.text = value.titleEN
                                      : _dropDownController.text =
                                          value.titleAR;

                                  currentSection = value;

                                  _getServiceData(section);
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
                            const SizedBox(height: 20),
                            RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text(buttonMode,
                                    style: TextStyle(
                                      color: Theme.of(context).canvasColor,
                                    )),
                                onPressed: () => widget.channelSelected != null
                                    ? _submitData(
                                        uid: widget.channelSelected!.uid)
                                    : _submitData()),
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

  _getServiceData(section) async {
    await FirebaseManager.shared
        .getSection(section: section)
        .first
        .then((value) {
      if (lang == Language.ARABIC) {
        for (int i = 0; i < value.length; i++) {
          _dropdownMenuItem!.clear();
          _dropdownMenuItem!.add(value[i]);
        }
      } else {
        for (int i = 0; i < value.length; i++) {
          _dropdownMenuItem!.clear();
          _dropdownMenuItem!.add(value[i]);
        }
      }
    });

    setState(() {
      if (widget.uidActiveService != null) {
        _activeDropDownItem = widget.uidActiveService;
      }
    });
  }

  bool _validation() {
    return !(_activeDropDownItem == null ||
        titleAR == "" ||
        titleEN == "" ||
        section == null);
  }

  _submitData({String uid = ""}) async {
    _formKey.currentState!.save();

    if (!_validation()) {
      _scaffoldKey.showTosta(
          message:
              AppLocalization.of(context)!.trans("Please fill in all fields"),
          isError: true);
      return;
    }

    //await FirebaseManager.shared.getSectionById(id: _activeDropDownItem!).first;

    FirebaseManager.shared.addOrEditChanne(context,
        scaffoldKey: _scaffoldKey,
        uid: uid,
        sectionuid: currentSection!.uid,
        section: section,
        titleAR: titleAR,
        titleEN: titleEN,
        streamURL: streamURL!);
  }

  Future<SectionModel> getSection(id) async {
    return await FirebaseManager.shared.getSectionById(id: id).first;
  }

  Future<List<SectionModel>> getSectionList(section) async {
    return await FirebaseManager.shared.getSection(section: section).first;
  }
}
