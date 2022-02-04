import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/manger/user-type.dart';
import 'package:tv/models/channelModel.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/models/user_profile.dart';

import 'package:tv/page/notification.dart';

import '../../main.dart';
import 'channel-Details.dart';


class chanelsection extends StatefulWidget {
  _chanelsectionState createState() => _chanelsectionState();
  final String Channel;
  final String screenTitle;
  chanelsection(this.Channel, this.screenTitle,);
}

class _chanelsectionState extends State<chanelsection> {

  Language lang = Language.ENGLISH;
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
  @override
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

                  title: appBarTitle,
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(
                      icon: actionIcon,
                      onPressed: () {
                        setState(() {
                          if (actionIcon.icon == Icons.search) {
                            actionIcon = const Icon(Icons.close);
                            appBarTitle = const TextField(
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                                  hintText: "Search...",
                                  hintStyle: TextStyle(color: Colors.blue)),
                            );
                          } else {
                            actionIcon = const Icon(Icons.search);
                            appBarTitle = Text(
                              AppLocalization.of(context)!.trans('Live'),
                              style: TextStyle(color: Theme.of(context).primaryColor),
                            );
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.favorite,
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/Profile'),
                    ),                  ]
              ),
              body: user?.userType == UserType.ADMIN
                  ? _widgetTech(context)
                  : _widgetUser(context),
            );
          }

          return SizedBox();
        });
  }

  Widget _widgetUser(context) {
    return StreamBuilder<List<ChannelModel>>(
        stream: FirebaseManager.shared.getchannelByStatus(
            channel: widget.Channel),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List? Channel = snapshot.data;
            if (Channel!.isEmpty) {
              return Center(child: Text(
                "No  added", style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor, fontSize: 18),));
            }
            return ListView.builder(
              itemCount: Channel.length,
              itemBuilder: (buildContext, index) =>
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  cchannelDetails(Channel: Channel[index],)));
                    },
                    child: Padding(
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
                                  Text(
                                      lang == Language.ENGLISH
                                          ? Channel[index].titleEN
                                          : Channel[index].titleAR,
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
    return StreamBuilder<List<ChannelModel>>(
        stream: FirebaseManager.shared.getchannelByStatus(
            channel: widget.Channel),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List? Channel = snapshot.data;
            if (Channel!.isEmpty) {
              return Center(
                  child: Text(
                    "No  added",
                    style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColor, fontSize: 18),
                  ));
            }
            return ListView.builder(
              itemCount: Channel.length,
              itemBuilder: (buildContext, index) =>
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  cchannelDetails(Channel: Channel[index],)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        elevation: 5,
                        child: SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.14,
                          width: MediaQuery
                              .of(context)
                              .size
                              .height * 0.1,
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
                                            ? Channel[index].titleEN
                                            : Channel[index].titleAR,
                                        style: TextStyle(
                                            color: Theme
                                                .of(context)
                                                .primaryColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500)),
                                   /* IconButton(
                                      iconSize: 35,
                                      icon: const Icon(Icons.edit),
                                      onPressed: () =>
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                     addchannel(
                                                         updatechannel: Channel[index]))),
                                    ),*/
                                    IconButton(
                                      iconSize: 35,
                                      icon: const Icon(Icons.delete_forever),
                                      onPressed: () {
                                        _deleteaddchannel(
                                            context, Channel[index].uid);
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

  _deleteaddchannel(context, String uidchannel) {
    FirebaseManager.shared.deletechannel(context, uidchannel: uidchannel);
  }
}
