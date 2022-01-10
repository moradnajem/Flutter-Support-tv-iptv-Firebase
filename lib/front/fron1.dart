//ClientsReport
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/core/models/CameraStream.dart';
import 'package:tv/core/viewmodels/CameraStreamsViewModel.dart';
import 'package:tv/manger/loader.dart';
import 'package:tv/ui/widgets/CameraVLCStreamCard.dart';

class uservendor extends StatefulWidget {
  @override
  uservendorState createState() => uservendorState();
}

class uservendorState extends State<uservendor> {
  late List<CameraStream> cameraStreams;

  Uint8List? image;
  GlobalKey? imageKey;


  @override
  void initState() {
    imageKey = GlobalKey();
    super.initState();
  }


  Widget build(BuildContext context) {
    final cameraStreamProvider = Provider.of<CameraStreamsViewModel>(context);
    return StreamBuilder(
        stream: cameraStreamProvider.fetchCameraDataStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            cameraStreams = snapshot.data!.docs
                .map(
                    (doc) => CameraStream.fromMap(doc.data() as Map<dynamic, dynamic>, doc.id))
                .toList();

            return ListView.builder(
              itemCount: cameraStreams.length,
              itemBuilder: (buildContext, index) => CameraStreamVLCCard(
                  cameraStreamInfo: cameraStreams[index]),
            );
          } else {
            return Center(child: loader(context));
          }
        }
    );
  }
}

