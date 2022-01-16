import 'package:flutter/material.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/models/SectionModel.dart';
import 'package:tv/models/user_profile.dart';

import 'live.dart';


class sectionDetail extends StatefulWidget {

  final SectionModel section;
  
  sectionDetail({required this.section});

  @override
  sectionDetailState createState() => sectionDetailState();
}

class sectionDetailState extends State<sectionDetail> {

  Language lang = Language.ENGLISH;



  void initState() {
    // TODO: implement initState
    super.initState();
    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        lang = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery
        .of(context)
        .size
        .height * 0.1;
    var _width = MediaQuery
        .of(context)
        .size
        .width * 0.1;

    return
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const live(
                  )));
        },             child: Padding(
        padding: const EdgeInsets.all(8),
        child: Card(
          elevation: 5,
          child: Container(
            height: _height,
            width: _width,
            child: Column(
              children: <Widget>[
                Expanded(child:
                Hero(
                  tag: widget.section.uid,
                  child: SizedBox(
                    height: 360,
                    width: _width,
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.section.titleEN,
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
