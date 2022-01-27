import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/SectionModel.dart';
import 'package:tv/models/user_profile.dart';
import 'package:tv/page/notification.dart';

import '../lib/main.dart';
import '../lib/section/channel/channel.dart';



class Live extends StatefulWidget {
  LiveState createState() => LiveState();
}

class LiveState extends State<Live> {
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

  Widget appBarTitle = const Text(
    "Live",
    style: TextStyle(color: Colors.black),
  );
  Icon actionIcon = const Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SectionModel>>(
        stream: FirebaseManager.shared.getSection(section: Section.LIVE),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List? section = snapshot.data;
            if (section!.isEmpty) {
              return Center(child: Text(
                "No  added", style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor, fontSize: 18),));
            }
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).canvasColor,
                  elevation: 0,
                  iconTheme: IconThemeData(
                    color: Theme.of(context).primaryColor,
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.language, color: Theme.of(context).primaryColor),
                    onPressed: () => Navigator.pushNamed(context, '/SelectLanguage'),
                  ),
                  title: appBarTitle,
                    centerTitle: true,
                    actions: <Widget>[
                      IconButton(icon: actionIcon,onPressed:(){
                        setState(() {
                          if ( actionIcon.icon == Icons.search){
                            actionIcon = const Icon(Icons.close);
                            appBarTitle = const TextField(
                              style: TextStyle(
                                color: Colors.blue,

                              ),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search,color: Colors.blue),
                                  hintText: "Search...",
                                  hintStyle: TextStyle(color: Colors.blue)
                              ),
                            );}
                          else {
                            actionIcon = const Icon(Icons.search);
                            appBarTitle =  Text(AppLocalization.of(context)!.trans('Live'), style: TextStyle(color: Theme.of(context).primaryColor),);
                          }
                        });
                      } ,),
                      NotificationsWidget(),
                    ]
                ),
             body: ListView.builder(
              itemCount: section.length,
              itemBuilder: (buildContext, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => channel(section[index].uid)));
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
                                Text (lang == Language.ENGLISH
                                    ? section[index].titleEN
                                    : section[index].titleAR,
                                    style: TextStyle(color: Theme
                                        .of(context)
                                        .primaryColor, fontSize: 18, fontWeight: FontWeight
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
          ));
          } else {
            return Center(child: loader(context));
          }
        }
    );
  }
}

