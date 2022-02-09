import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/manger/user-type.dart';
import 'package:tv/models/SectionModel.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/models/user_profile.dart';
import 'package:tv/page/add-section.dart';
import 'package:tv/page/notification.dart';

import '../main.dart';
import 'channel/channel.dart';
import 'channel/channel.dart';

class SectionScreen extends StatefulWidget {
  _SectionScreenState createState() => _SectionScreenState();
  final Section section;
  final String screenTitle;
  bool searchMode = false;
  SectionScreen(this.section, this.screenTitle);
}

class _SectionScreenState extends State<SectionScreen> {
  Language lang = Language.ENGLISH;
  final TextEditingController? searchTextField = TextEditingController();
  Widget? appBarTitle;
  void initState() {
    // TODO: implement initState
    super.initState();
    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        appBarTitle = Text(
          AppLocalization.of(context)!.trans(widget.screenTitle),
          style: TextStyle(color: Theme.of(context).primaryColor),
        );
        lang = value!;
      });
    });
  }

  Icon actionIcon = const Icon(Icons.search);

  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
        key: _scaffoldKey,
        future: UserProfile.shared.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel? user = snapshot.data;

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).canvasColor,
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Theme.of(context).primaryColor,
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.favorite,
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/Profile'),
                ),
                title: appBarTitle,
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: actionIcon,
                    onPressed: () {
                      setState(() {
                        if (actionIcon.icon == Icons.search) {
                          actionIcon = const Icon(Icons.close);
                          appBarTitle = TextField(
                            controller: searchTextField,
                            onChanged: (value) {
                              searchTextField!.text = value;
                              searchTextField!.text.isEmpty
                                  ? widget.searchMode = false
                                  : widget.searchMode = true;
                              searchTextField!.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: searchTextField!.text.length));
                              setState(() {});
                            },
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                            decoration: const InputDecoration(
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.blue),
                                hintText: "Search...",
                                hintStyle: TextStyle(color: Colors.blue)),
                          );
                        } else {
                          actionIcon = const Icon(Icons.search);
                          appBarTitle = Text(
                            AppLocalization.of(context)!
                                .trans(widget.screenTitle),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          );
                        }
                      });
                    },
                  ),
                  const NotificationsWidget(),
                  Visibility(
                    visible: user!.userType == UserType.ADMIN,
                    child: IconButton(
                        icon: Icon(Icons.add,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {
                          showActionsheet();
                        }),
                  ),
                ],
              ),
              body: user.userType == UserType.ADMIN
                  ? _widgetTech(context, searchTextField)
                  : _widgetUser(context, searchTextField),
            );
          }

          return const SizedBox();
        });
  }

  Widget _widgetUser(context , searchController) {
    return StreamBuilder<List<SectionModel>>(
         stream: widget.searchMode
            ? FirebaseManager.shared.getSectionsByName(
                sectionName: searchController.text,
                fieldType: lang == Language.ENGLISH ? "title-en" : "title-ar")
            : FirebaseManager.shared.getSection(section: widget.section),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SectionModel>? section = snapshot.data;
            if (widget.searchMode) {
              for (int i = 0; i < section!.length; i++) {
                // ignore: unrelated_type_equality_checks
                if (section[i].section.index != widget.section.index) {
                  section.removeAt(i);
                }
              }
            }
            if (section!.isEmpty) {
              return Center(
                  child: Text(
                "No  added",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ));
            }
            return ListView.builder(
              itemCount: section.length,
              itemBuilder: (buildContext, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => chanelsection(
                              section[index].uid, widget.screenTitle)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    elevation: 5,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.height * 0.1,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    lang == Language.ENGLISH
                                        ? section[index].titleEN
                                        : section[index].titleAR,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(child: loader(context));
          }
        });
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Widget _widgetTech(context, searchController) {
    return StreamBuilder<List<SectionModel>>(
        stream: widget.searchMode
            ? FirebaseManager.shared.getSectionsByName(
                sectionName: searchController.text,
                fieldType: lang == Language.ENGLISH ? "title-en" : "title-ar")
            : FirebaseManager.shared.getSection(section: widget.section),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SectionModel>? section = snapshot.data;
            if (widget.searchMode) {
              for (int i = 0; i < section!.length; i++) {
                // ignore: unrelated_type_equality_checks
                if (section[i].section.index != widget.section.index) {
                  section.removeAt(i);
                }
              }
            }
            if (section!.isEmpty) {
              return Center(
                  child: Text(
                "No  added",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ));
            }
            return ListView.builder(
              itemCount: section.length,
              itemBuilder: (buildContext, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => chanelsection(
                                section[index].uid,
                                lang == Language.ENGLISH
                                    ? section[index].titleEN
                                    : section[index].titleAR,
                              )));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    elevation: 5,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.14,
                      width: MediaQuery.of(context).size.height * 0.1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    lang == Language.ENGLISH
                                        ? section[index].titleEN
                                        : section[index].titleAR,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                IconButton(
                                  iconSize: 35,
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => addsection(
                                              updateSection: section[index]))),
                                  //  onPressed: ()  { },
                                ),
                                IconButton(
                                  iconSize: 35,
                                  icon: const Icon(Icons.delete_forever),
                                  onPressed: () {
                                    _deleteSection(context, section[index].uid);
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: loader(context),
            );
          }
        });
  }

  _deleteSection(context, String uidSection) {
    FirebaseManager.shared.deleteSection(context, uidSection: uidSection);
  }

  showActionsheet() {
    {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
            title: const Text('Choose An Option'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: const Text('addsection'),
                onPressed: () => Navigator.pushNamed(context, '/addsection'),
              ),
              CupertinoActionSheetAction(
                child: const Text('addchannel'),
                isDestructiveAction: false,
                onPressed: () => Navigator.pushNamed(context, '/addchannel'),
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            )),
      );
    }
  }
}
