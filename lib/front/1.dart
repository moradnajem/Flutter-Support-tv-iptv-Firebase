import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tv/core/models/model.dart';
import 'package:tv/manger/M.S.dart';

import 'package:tv/manger/language.dart';
import 'package:tv/manger/loader.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/manger/user_profile.dart';



class alllive extends StatefulWidget {
  @override
  _allliveState createState() => _allliveState();
}
class _allliveState extends State<alllive> {
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
    return StreamBuilder<List<ServiceModel>>(
        stream: FirebaseManager.shared.getServices(section: Section.LIVE),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List? section = snapshot.data;
            if (section!.isEmpty) {
              return Center(child: Text(
                "No  added", style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor, fontSize: 18),));
            }
            return GridView.count(
              padding: const EdgeInsets.all(10),
              crossAxisCount: 4,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              children: List.generate(section.length, (index) {
                return InkWell(
                  onTap: () => Navigator.of(context).pushNamed("/section", arguments: section[index].uid),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(12))
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(lang == Language.ENGLISH
                          ? section[index].titleEN
                          : section[index].titleAR,
                        style: TextStyle(color: Theme
                            .of(context)
                            .primaryColor, fontSize: 18, fontWeight: FontWeight
                            .w500,)
                        ,)
                    ],
                  ),
                );
              }),
            );
          } else {
            return Center(child: loader(context));
          }
        }
    );
  }
}
