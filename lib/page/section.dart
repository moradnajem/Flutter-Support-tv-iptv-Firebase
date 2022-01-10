


//allticket
import 'package:flutter/material.dart';
import 'package:tv/manger/language.dart';


class section extends StatefulWidget {
  @override
  _sectionState createState() => _sectionState();
}

class _sectionState extends State<section> {
  Language lang = Language.ENGLISH;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("section"),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      backgroundColor: Colors.blueAccent,

      body: Container(child: Center(child: Text("section"),),),

    );
  }
}