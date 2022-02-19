//import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:video_player/video_player.dart';

import 'package:tv/manger/language.dart';
import 'package:tv/models/channelModel.dart';
import 'package:tv/models/favoriteModel.dart';
import 'package:tv/models/user_profile.dart';
import 'package:flick_video_player/flick_video_player.dart';


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
  late FlickManager _controller;
  Language lang = Language.ENGLISH;
  late VideoPlayerController controller;

  @override
  void initState() {
    _controller = FlickManager(
      videoPlayerController: VideoPlayerController.network(
        widget.Channel.streamURL,
      ),
    );
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
        channelId: widget.Channel.uid,
        section: widget.Channel.section.index,
        channel: widget.Channel);
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
          backgroundColor: Theme
              .of(context)
              .canvasColor,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Theme
                .of(context)
                .primaryColor,
          ),
          centerTitle: true,
          title: Text(
              lang == Language.ENGLISH
                  ? widget.Channel.titleEN
                  : widget.Channel.titleAR,
              style: TextStyle(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500))),
      body: SingleChildScrollView(
      child: FlickVideoPlayer(
        flickManager: _controller,
      ),

    ));
  }
}
