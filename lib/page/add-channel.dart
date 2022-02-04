import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/models/alert_sheet.dart';
import 'package:tv/models/assets.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/input_style.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/models/user_profile.dart';
import 'package:tv/models/SectionModel.dart';




class addchannel extends StatefulWidget {
  String? uidActiveService;

  @override
  _addchannelState createState() => _addchannelState();
}

class _addchannelState extends State<addchannel> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _userTypeController = TextEditingController();
  late Section section;

  late String titleEN;
  late String titleAR;
  String? streamURL;
  String? _activeDropDownItem;
  List<DropdownMenuItem<String>>? _dropdownMenuItem = [];
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
                              controller: _userTypeController,
                              onTap: () {
                                alertSheet(context, title: " type", items: ["LIVE", "Movies" , "Series"], onTap: (value) {
                                  _userTypeController.text = value;
                                  if (value == "LIVE") {
                                    section = Section.LIVE;
                                  } else if (value == "Movies"){
                                    section = Section.Movies;
                                  }else{
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
                              decoration: customInputForm.copyWith(prefixIcon: Icon(
                                Icons.person_outline,
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: " type"),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              onChanged: (value) => titleAR = value.trim(),
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
                              ).copyWith(hintText: "titleAR"),
                            ),
                            TextFormField(
                              onChanged: (value) => titleEN = value.trim(),
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
                              ).copyWith(hintText: "titleEN"),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              onChanged: (value) => streamURL = value.trim(),
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
                              ).copyWith(hintText: "streamURL"),
                            ),
                            const SizedBox(height: 20,),
                            DropdownButtonFormField(
                              items: _dropdownMenuItem,
                              onChanged: (newValue) {
                                setState(() => _activeDropDownItem = newValue as String?);
                              },
                              value: _activeDropDownItem,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: customInputForm.copyWith(prefixIcon: Icon(
                                Icons.person_outline,
                                color: Theme.of(context).primaryColor,
                              ),
                              ).copyWith(hintText: " list "),

                            ),
                            const SizedBox(height: 20),
                            RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text("ADD",
                                    style: TextStyle(color: Theme.of(context).canvasColor,)),
                                onPressed:   _submitData
                            ),
                            const SizedBox(height: 20,),
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

    List<SectionModel> services = await FirebaseManager.shared.getSection(section: section).first;

    setState(() {
      _dropdownMenuItem = services.map((item) => DropdownMenuItem(child: Text( lang == Language.ARABIC ? item.titleAR : item.titleEN ), value: item.uid.toString())).toList();

      if (widget.uidActiveService != null) {
        _activeDropDownItem = widget.uidActiveService;
      }

    });

  }

  bool _validation() {
    return !(_activeDropDownItem == null || titleAR == ""|| titleEN == "" || section == null  );
  }

  _submitData() async {

    if (!_validation()) {
      _scaffoldKey.showTosta(message: "Please fill in all fields", isError: true);
      return;
    }

    await FirebaseManager.shared.getSectionById(id: _activeDropDownItem!).first;

    FirebaseManager.shared.addOrEditChanne(context,  sectionuid: _activeDropDownItem!,section: section, titleAR: titleAR, titleEN: titleEN, streamURL: streamURL!);

  }

}