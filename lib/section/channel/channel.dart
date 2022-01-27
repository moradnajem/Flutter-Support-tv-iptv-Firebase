import 'package:flutter/material.dart';
import 'package:tv/front/sectionDetails.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/channelModel.dart';

import 'channel-Details.dart';



class channel extends StatefulWidget {
  final String section;

  @override
  channelState createState() => channelState();
  channel(this.section);
}

class channelState extends State<channel> {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChannelModel>>(
        stream: FirebaseManager.shared.getchannelByStatus(section: widget.section),
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
              itemBuilder: (buildContext, index) => channelDetails(
                  section: section[index]),
            );
          } else {
            return Center(child: loader(context));
          }
        }
    );
  }
}