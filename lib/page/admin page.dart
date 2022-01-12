import 'package:flutter/material.dart';
import 'package:tv/manger/user-type.dart';

import '../main.dart';
import 'notification.dart';


class adminpage extends StatefulWidget {
  @override
  _adminpageState createState() => _adminpageState();
}

class _adminpageState extends State<adminpage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Ms"),
          centerTitle: true,
          leading:  IconButton(
            icon: Icon(
                Icons.add,
                color: Theme.of(context).canvasColor
            ),
            onPressed: () => Navigator.pushNamed(context, '/addsection'),
          ),
          actions: [
            NotificationsWidget(),
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              //ProfileScreen
              // ignore: deprecated_member_use
              child:  FlatButton(
                onPressed: () => Navigator.pushNamed(context, '/addchannel'),
                child: Icon(
                    Icons.add,
                    color: Theme.of(context).canvasColor
                ),),),]),
      backgroundColor: Colors.blueAccent,
      body: Container(child: Center(child: Text("ClientsReport"),),),

    );
  }
}