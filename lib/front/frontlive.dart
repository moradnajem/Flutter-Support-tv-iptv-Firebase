//ClientsReport

import 'package:flutter/material.dart';
import 'package:tv/front/sectionDetail.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/SectionModel.dart';


class frontlive extends StatefulWidget {

  frontliveState createState() => frontliveState();
}

class frontliveState extends State<frontlive> {

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
            return ListView.builder(
              itemCount: section.length,
              itemBuilder: (buildContext, index) => sectionDetail(
                  section: section[index],),
            );
          } else {
            return Center(child: loader(context));
          }
        }
    );
  }
}