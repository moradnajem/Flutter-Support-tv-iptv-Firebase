import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/manger/user-type.dart';
import 'package:tv/models/channelModel.dart';
import 'package:tv/models/favoriteModel.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/models/user_profile.dart';

import 'package:tv/page/notification.dart';

import '../../main.dart';
import '../../page/add-channel.dart';
import 'channel-Details.dart';

class FavoriteChannel extends StatefulWidget {
  _FavoriteChannelState createState() => _FavoriteChannelState();
  final String Channel;
  final String screenTitle;
  bool searchMode = false;
  int? section;
  FavoriteChannel(this.Channel, this.screenTitle, {this.section});
}

class _FavoriteChannelState extends State<FavoriteChannel> {
  Language lang = Language.ENGLISH;
  Widget? appBarTitle;
  final TextEditingController? searchTextField = TextEditingController();

  void initState() {
    // TODO: implement initState
    super.initState();
    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        appBarTitle = Text(
          widget.screenTitle,
          style: TextStyle(color: Theme.of(context).primaryColor),
        );
        lang = value!;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchTextField!.dispose();
    super.dispose();
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
              ),
              body: user?.userType == UserType.ADMIN
                  ? _widgetTech(context, searchTextField)
                  : _widgetUser(context, searchTextField),
            );
          }

          return const SizedBox();
        });
  }

  Widget _widgetUser(context, searchController) {
    return StreamBuilder<List<FavoriteModel>>(
        stream: FirebaseManager.shared.getMyFavorites(section: widget.section!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<FavoriteModel>? Channel = snapshot.data;

            if (Channel!.isEmpty) {
              return Center(
                  child: Text(
                "No  added",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ));
            }
            return ListView.builder(
                itemCount: Channel.length,
                itemBuilder: (item,index) {
                  return MaterialButton(onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                cchannelDetails(
                                  Channel: ChannelModel(
                                      section:
                                      Section.values[Channel[index].section],
                                      uid: Channel[index].channelId,
                                      streamURL: Channel[index].streamURL,
                                      titleAR: Channel[index].titlear,
                                      titleEN: Channel[index].titleen,
                                      sectionuid: ""),
                                )));
                  },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    iconSize: 35,
                                    icon: const Icon(Icons.favorite),
                                    onPressed: () {
                                      FirebaseManager.shared
                                          .deleteFavoriteChannel(
                                          context,
                                          uid: Channel[index].uid);
                                    },
                                  ),
                                  Text(
                                      lang == Language.ENGLISH
                                          ? Channel[index].titleen
                                          : Channel[index].titlear,
                                      style: TextStyle(
                                          color: Theme
                                              .of(context)
                                              .primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                });
          } else {
            return Center(
              child: loader(context),
            );
          }
        });
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Widget _widgetTech(context, searchController) {
    return StreamBuilder<List<FavoriteModel>>(
        stream: FirebaseManager.shared.getMyFavorites(section: widget.section!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<FavoriteModel>? Channel = snapshot.data;

            if (Channel!.isEmpty) {
              return Center(
                  child: Text(
                "No  added",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ));
            }
            return ListView.builder(
                itemCount: Channel.length,
                itemBuilder: (item,index) {
                  return MaterialButton(onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                cchannelDetails(
                                  Channel: ChannelModel(
                                      section:
                                      Section.values[Channel[index].section],
                                      uid: Channel[index].channelId,
                                      streamURL: Channel[index].streamURL,
                                      titleAR: Channel[index].titlear,
                                      titleEN: Channel[index].titleen,
                                      sectionuid: ""),
                                )));
                  },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  iconSize: 35,
                                  icon: const Icon(Icons.favorite),
                                  onPressed: () {
                                    FirebaseManager.shared
                                        .deleteFavoriteChannel(
                                        context,
                                        uid: Channel[index].uid);
                                  },
                                ),
                                Text(
                                    lang == Language.ENGLISH
                                        ? Channel[index].titleen
                                        : Channel[index].titlear,
                                    style: TextStyle(
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                });
          } else {
            return Center(
              child: loader(context),
            );
          }
        });
  }



  //  Stream<List<ChannelModel>> getMyFavorite(){

  //  Stream<List<FavoriteModel>> x = FirebaseManager.shared.getMyFavorites();
  //    FirebaseManager.shared.getchannelById(id: x.c)

}
