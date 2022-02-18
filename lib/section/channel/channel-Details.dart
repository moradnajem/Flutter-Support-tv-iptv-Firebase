//import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';

import 'package:tv/manger/language.dart';
import 'package:tv/models/channelModel.dart';
import 'package:tv/models/favoriteModel.dart';
import 'package:tv/models/user_profile.dart';
import 'package:video_player/video_player.dart';


class cchannelDetails extends StatefulWidget {
  final ChannelModel Channel;
  bool isFavorite = false;
  cchannelDetails({
    required this.Channel,
  });

  @override
  cchannelDetailsState createState() => cchannelDetailsState();
}

class cchannelDetailsState extends State<cchannelDetails> {
  late VideoPlayerController _controller;
  Language lang = Language.ENGLISH;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.Channel.streamURL);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        lang = value!;
      });
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  addFavoriteChannel() {
    FirebaseManager.shared.addToFavorite(context,
        channelId: widget.Channel.uid, section: widget.Channel.section.index , channel: widget.Channel);
  }

  deleteFavoriteChannel(uid) {
    FirebaseManager.shared.deleteFavoriteChannel(context, uid: uid);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            StreamBuilder<List<FavoriteModel>>(
              stream: FirebaseManager.shared.getFavoriteByChannel(
                channelId: widget.Channel.uid,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<FavoriteModel>? section = snapshot.data;
                  return IconButton(
                      onPressed: () {
                        section!.isEmpty
                            ? addFavoriteChannel()
                            : deleteFavoriteChannel(section[0].uid);
                      },
                      icon: section!.isEmpty
                          ? const Icon(Icons.favorite_border_outlined)
                          : const Icon(Icons.favorite));
                } else {
                  return Container();
                }
              },
            )
          ],
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          centerTitle: true,
          title: Text(
              lang == Language.ENGLISH
                  ? widget.Channel.titleEN
                  : widget.Channel.titleAR,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500))),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(child: VideoPlayer(_controller),height:400,width: double.infinity,),
            _ControlsOverlay(controller: _controller),
            VideoProgressIndicator(_controller, allowScrubbing: true),


          ],
        ),
      ),

    );
  }

}
class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          color: Colors.black26,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 50),
              reverseDuration: Duration(milliseconds: 200),
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: () async {
                      var position = await controller.position;

                      controller.seekTo(
                          Duration(seconds: position!.inSeconds - 5));
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  SizedBox(width: 20,),
                  controller.value.isPlaying
                      ? MaterialButton(
                    child: Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      controller.value.isPlaying
                          ? controller.pause()
                          : controller.play();
                    },
                  )
                      : MaterialButton(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      controller.value.isPlaying
                          ? controller.pause()
                          : controller.play();
                    },
                  ),
                  SizedBox(width: 20,),
                  MaterialButton(
                    onPressed: () async {
                      var position = await controller.position;

                      controller.seekTo(
                          Duration(seconds: position!.inSeconds + 5));
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  SizedBox(width: 20,),
                  PopupMenuButton<double>(
                    initialValue: controller.value.playbackSpeed,
                    tooltip: 'Playback speed',
                    color: Colors.white,
                    onSelected: (speed) {
                      controller.setPlaybackSpeed(speed);
                    },
                    itemBuilder: (context) {
                      return [
                        for (final speed in _examplePlaybackRates)
                          PopupMenuItem(
                            value: speed,
                            child: Text('${speed}x',),
                          )
                      ];
                    },
                    child: Text('${controller.value.playbackSpeed}x',
                      style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
