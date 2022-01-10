//ClientsReport
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/core/models/CameraStream.dart';
import 'package:tv/core/viewmodels/CameraStreamsViewModel.dart';
import 'package:tv/manger/loader.dart';
import 'package:tv/ui/widgets/CameraVLCStreamCard.dart';


class ClientsReport extends StatefulWidget {
  @override
  ClientsReportState createState() => ClientsReportState();
}

class ClientsReportState extends State<ClientsReport> {
  late List<CameraStream> cameraStreams;

  Uint8List? image;
  GlobalKey? imageKey;



  @override
  void initState() {
    imageKey = new GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cameraStreamProvider = Provider.of<CameraStreamsViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Ms"),
        centerTitle: true,
        leading:  IconButton(
          icon: Icon(
              Icons.add,
              color: Theme.of(context).canvasColor
          ),
          onPressed: () => Navigator.pushNamed(context, '/AddCameraStreamCard'),
        ),
      ),      backgroundColor: Colors.blueAccent,
      body:  Container(
        child: StreamBuilder(
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
            }),
      ),
    );
  }
}

