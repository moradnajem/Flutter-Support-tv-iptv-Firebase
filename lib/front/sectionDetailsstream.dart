
//CameraStreamDetails
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tv/models/channelModel.dart';
import 'package:video_player/video_player.dart';

class sectionDetailsstream extends StatefulWidget {
  final ChannelModel cameraStream;

  sectionDetailsstream({required this.cameraStream});

  @override
  sectionDetailsstreamState createState() => sectionDetailsstreamState();
}

class sectionDetailsstreamState extends State<sectionDetailsstream> {
  late VideoPlayerController _controller;

  late ChewieController _chewieController;


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.cameraStream.streamURL,)
      ..initialize().then((_) {
        setState(() {});
      });
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: 3 / 2,
      autoPlay: false,
      looping: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }
  @override
  void dispose() {
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery
        .of(context)
        .size
        .height * 1.33;
    var _width = MediaQuery
        .of(context)
        .size
        .width * 1.9;

    return
      GestureDetector(
        onTap:
            () {},
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            elevation: 5,
            child: SizedBox(
              height: _height,
              width: _width,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Chewie(
                        controller: _chewieController,
                      ),
                    ),
                  ),
                  Expanded(child:
                  Hero(
                    tag: widget.cameraStream.uid,
                    child: SizedBox(
                      height: 360,
                      width: _width,
                      //   child: VideoPlayer(_controller),
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(widget.cameraStream.title ?? '',
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

  Widget buildIndicator() => VideoProgressIndicator(
    _controller,
    allowScrubbing: true,
  );
}

