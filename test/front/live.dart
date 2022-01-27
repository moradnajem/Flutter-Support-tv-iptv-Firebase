import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/channelModel.dart';

import 'sectionDetails.dart';

class live extends StatefulWidget {
  final String section;

  @override
  liveState createState() => liveState();
  live(this.section);
}

class liveState extends State<live> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChannelModel>>(
        stream:
        FirebaseManager.shared.getchannelByStatus(section: widget.section),
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
              itemBuilder: (buildContext, index) =>
                  sectionDetails(section: section[index]),
            );
          } else {
            return Center(child: loader(context));
          }
        });
  }
}
