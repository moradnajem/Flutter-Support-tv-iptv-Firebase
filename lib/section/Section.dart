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
import 'package:tv/page/notification.dart';

import '../main.dart';
import 'channel/channel.dart';

class SectionScreen extends StatefulWidget {
  _SectionScreenState createState() => _SectionScreenState();
  final Section section;
  final String screenTitle;
  SectionScreen(this.section , this.screenTitle);
}

class _SectionScreenState extends State<SectionScreen> {
  Language lang = Language.ENGLISH;

  void initState() {
    // TODO: implement initState
    super.initState();
    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        lang = value!;
      });
    });
  }

  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
        key: _scaffoldKey,
        future: UserProfile.shared.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel? user = snapshot.data;

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme
                    .of(context)
                    .canvasColor,
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.person,
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/Profile'),
                ),
                title: Text(
                  AppLocalization.of(context)!.trans(widget.screenTitle),
                  style: TextStyle(color: Theme
                      .of(context)
                      .primaryColor),),
                centerTitle: true,
                actions: [
                  const NotificationsWidget(),
                  Visibility(visible: user!.userType == UserType.ADMIN,
                      child: IconButton(
                          icon: Icon(
                              Icons.add,
                              color: Theme
                                  .of(context)
                                  .primaryColor
                          ),
                          onPressed: () {
                            showActionsheet();
                          }
                      ),),
                ],
              ),
              body: user.userType == UserType.ADMIN
                  ? _widgetTech(context)
                  : _widgetUser(context),
            );
          }

          return SizedBox();
        }
    );
  }

  Widget _widgetUser(context) {
    return StreamBuilder<List<SectionModel>>(
        stream: FirebaseManager.shared.getSection(section: widget.section),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List? section = snapshot.data;
            if (section!.isEmpty) {
              return Center(child: Text(
                "No  added", style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor, fontSize: 18),));
            }
            return ListView.builder(
              itemCount: section.length,
              itemBuilder: (buildContext, index) =>
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => channel(section[index].uid)));
                    }, child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      elevation: 5,
                      child: SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.1,
                        width: MediaQuery
                            .of(context)
                            .size
                            .height * 0.1,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(lang == Language.ENGLISH
                                      ? section[index].titleEN
                                      : section[index].titleAR,
                                      style: TextStyle(color: Theme
                                          .of(context)
                                          .primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight
                                              .w500)
                                  )
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
        }
    );
  }


  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Widget _widgetTech(context) {
    return StreamBuilder<List<SectionModel>>(
        stream: FirebaseManager.shared.getSection(section: widget.section),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List? section = snapshot.data;
            if (section!.isEmpty) {
              return Center(child: Text(
                "No  added", style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor, fontSize: 18),));
            }
            return ListView.builder(
              itemCount: section.length,
              itemBuilder: (buildContext, index) =>
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => channel(section[index].uid)));
                    }, child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      elevation: 5,
                      child: SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.1,
                        width: MediaQuery
                            .of(context)
                            .size
                            .height * 0.1,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(lang == Language.ENGLISH
                                      ? section[index].titleEN
                                      : section[index].titleAR,
                                      style: TextStyle(color: Theme
                                          .of(context)
                                          .primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight
                                              .w500)
                                  )
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
        }
    );
  }
  showActionsheet() {
    {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) =>
            CupertinoActionSheet(
                title: Text('Choose An Option'),
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
                )
            ),
      );
    }
  }}