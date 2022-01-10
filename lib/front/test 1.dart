

//sectionDetails
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tv/core/models/model.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/manger/user_profile.dart';

class sectionDetails extends StatefulWidget {
  final ServiceModel section;

  sectionDetails({required this.section});

  @override
  sectionDetailsState createState() => sectionDetailsState();
}
Language lang = Language.ENGLISH;

class sectionDetailsState extends State<sectionDetails> {
  get index => null;

  get section => null;

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
                  Expanded(child:
                  Hero(
                    tag: widget.section.uid,
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
                        Text(lang == Language.ENGLISH
                            ? section[index].titleEN
                            : section[index].titleAR,
                          style: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight
                                .w500,)
                          ,)
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