import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/channelModel.dart';
import 'package:tv/models/user_profile.dart';
import 'package:tv/page/notification.dart';

import '../../main.dart';
import 'channel-Details.dart';

class channel extends StatefulWidget {
  final String section;
  final String screenTitle;
  @override
  channelState createState() => channelState();
  channel(this.section, this.screenTitle);
}

class channelState extends State<channel> {
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
              NotificationsWidget(),
            ]),
        body: StreamBuilder<List<ChannelModel>>(
            stream: FirebaseManager.shared
                .getchannelByStatus(section: widget.section),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List? section = snapshot.data;
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
                              builder: (_) => channelDetails(
                                    section: section[index],
                                  )));
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
                                            color:
                                                Theme.of(context).primaryColor,
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
            }));
  }
}
