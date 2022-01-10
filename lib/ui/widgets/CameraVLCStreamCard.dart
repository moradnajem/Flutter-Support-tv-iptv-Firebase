//CameraStreamVLCCard
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tv/core/models/CameraStream.dart';
import 'package:tv/ui/views/CameraStreamDetails.dart';

class CameraStreamVLCCard extends StatelessWidget {
  final CameraStream cameraStreamInfo;

  CameraStreamVLCCard({required this.cameraStreamInfo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    CameraStreamDetails(
                      cameraStream: cameraStreamInfo,
                    )));
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
                      Text(cameraStreamInfo.cameraStreamTitle ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}