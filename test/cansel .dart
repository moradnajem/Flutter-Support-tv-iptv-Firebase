import 'package:flutter/material.dart';
import 'package:tv/models/SectionModel.dart';
import 'package:tv/models/channelModel.dart';

class CameraStreamDetail extends StatelessWidget {
  final SectionModel section;

   const CameraStreamDetail({required this.section});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('section'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: section.uid,
            child: Image.asset(
              'assets/camera.svg',
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            section.titleEN,
            style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                fontStyle: FontStyle.italic),
          ),
          Text(
            section.titleAR,
            style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                fontStyle: FontStyle.italic,
                color: Colors.orangeAccent),
          )
        ],
      ),
    );
  }
}