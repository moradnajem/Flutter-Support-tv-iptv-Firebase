import 'package:flutter/material.dart';
import 'package:tv/front/test.dart';
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

   late String title;
   String? streamURL;
   String? _activeDropDownItem;
  List<DropdownMenuItem<String>>? _dropdownMenuItem = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getServiceData();
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
                                alertSheet(context, title: " type", items: ["LIVE", "Movies"], onTap: (value) {
                                  _userTypeController.text = value;
                                  if (value == "LIVE") {
                                    section = Section.LIVE;
                                  } else {
                                    section = Section.Movies;
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
                              ).copyWith(hintText: " type"),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              onChanged: (value) => title = value.trim(),
                              maxLines: null,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                labelText: "title",
                              ),
                            ),
                            TextFormField(
                              onChanged: (value) => streamURL = value.trim(),
                              maxLines: null,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                labelText: "streamURL",
                              ),
                            ),
                            DropdownButtonFormField(
                              items: _dropdownMenuItem,
                              onChanged: (newValue) {
                                setState(() => _activeDropDownItem = newValue as String?);
                              },
                              value: _activeDropDownItem,
                              decoration: const InputDecoration(
                                labelText: "list",
                              ),
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

  _getServiceData() async {

    List<SectionModel> services = await FirebaseManager.shared.getSection(section: Section.LIVE).first;

    setState(() {
      _dropdownMenuItem = services.map((item) => DropdownMenuItem(child: Text( lang == Language.ARABIC ? item.titleAR : item.titleEN ), value: item.uid.toString())).toList();

      if (widget.uidActiveService != null) {
        _activeDropDownItem = widget.uidActiveService;
      }

    });

  }

  bool _validation() {
    return !(_activeDropDownItem == null || title == "" || section == null  );
  }

  _submitData() async {

    if (!_validation()) {
      _scaffoldKey.showTosta(message: "Please fill in all fields", isError: true);
      return;
    }

    await FirebaseManager.shared.getSectionById(id: _activeDropDownItem!).first;

    FirebaseManager.shared.addOrEditChanne(context,  sectionuid: _activeDropDownItem!,section: section, title: title, streamURL: streamURL!);

  }

}