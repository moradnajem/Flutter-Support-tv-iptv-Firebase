import 'package:flutter/material.dart';
import 'package:tv/models/channelModel.dart';

class CameraStreamDetails extends StatelessWidget {
  final ChannelModel section;

  const CameraStreamDetails({required this.section});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('section'),
        actions: <Widget>[
          IconButton(
            iconSize: 35,
            icon: const Icon(Icons.delete_forever),
            onPressed: ()  {  },
          ),
          IconButton(
            iconSize: 35,
            icon: const Icon(Icons.edit),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: section.sectionuid,
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
            section.streamURL,
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
