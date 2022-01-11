import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tv/front/test%201.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/channelModel.dart';

class allSeries extends StatefulWidget {
  @override
  allSeriesState createState() => allSeriesState();
}

class allSeriesState extends State<allSeries> {


  Widget build(BuildContext context) {
    return StreamBuilder<List<ChannelModel>>(
        stream: FirebaseManager.shared.getAllOrders(),
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
              itemBuilder: (buildContext, index) => sectionDetails(
                  section: section[index]),
            );
          } else {
            return Center(child: loader(context));
          }
        }
    );
  }
}

