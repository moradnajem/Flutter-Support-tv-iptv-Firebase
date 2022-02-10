import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
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
  late FlickManager flickManager;
  Language lang = Language.ENGLISH;
  late VlcPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VlcPlayerController.network(
      widget.Channel.streamURL,
      autoPlay: true,
    );
    flickManager = FlickManager(
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
  Widget build(BuildContext context) {
    return kIsWeb ? _buildWebView() : _buildView();
  }

  Widget _buildWebView() {
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
      body: FlickVideoPlayer(
        flickManager: flickManager,
      ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  Widget _buildView() {
    return Scaffold(
      appBar: AppBar(
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
      body: VlcPlayer(
        aspectRatio: 16 / 9,
        controller: controller,
        placeholder: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  addFavoriteChannel() {
    FirebaseManager.shared.addToFavorite(context,
        channelId: widget.Channel.uid, section: widget.Channel.section.index , channel: widget.Channel);
  }

  deleteFavoriteChannel(uid) {
    FirebaseManager.shared.deleteFavoriteChannel(context, uid: uid);
  }
}
