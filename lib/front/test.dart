//ClientsReport
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/core/models/CameraStream.dart';
import 'package:tv/core/models/model.dart';
import 'package:tv/core/viewmodels/CameraStreamsViewModel.dart';
import 'package:tv/front/test%201.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/manger/loader.dart';
import 'package:tv/manger/user_profile.dart';

class frontlive extends StatefulWidget {

  frontliveState createState() => frontliveState();
}
Language lang = Language.ENGLISH;

class frontliveState extends State<frontlive> {
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
            return ListView.builder(
              itemCount: section.length,
              itemBuilder: (buildContext, index) => GestureDetector(
                onTap: () {
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
                            padding: EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text (lang == Language.ENGLISH
                                    ? section[index].titleEN
                                    : section[index].titleAR,
                                  style: TextStyle(color: Theme
                                      .of(context)
                                      .primaryColor, fontSize: 18, fontWeight: FontWeight
                                      .w500,)
                                  ,)
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
}

