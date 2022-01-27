
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:tv/manger/user-type.dart';





class adminpage extends StatefulWidget {
  @override
  _adminpageState createState()
  {
    return _adminpageState();
  }
}

class _adminpageState extends State<adminpage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Ms"),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                  Icons.add,
                  color: Theme
                      .of(context)
                      .canvasColor
              ),
              onPressed: () {
                showActionsheet();
              }
          ),
          actions: [
      //      Visibility( child: IconButton(icon: Icon(Icons.add, color: Colors.white,), tooltip: AppLocalization.of(context)!.trans("Add Service"), onPressed: () => Navigator.of(context).pushNamed("/ServiceForm"))),
      //      NotificationsWidget(),
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              //ProfileScreen
              // ignore: deprecated_member_use
              child: FlatButton(
                onPressed: () => Navigator.pushNamed(context, '/addchannel'),
                child: Icon(
                    Icons.add,
                    color: Theme
                        .of(context)
                        .canvasColor
                ),),),
          ]),
      backgroundColor: Colors.blueAccent,
      body: Container(child: Center(child: Text("ClientsReport"),),),

    );
  }
  showActionsheet() {
    {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) =>
            CupertinoActionSheet(
                title: Text('Choose An Option'),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: const Text('addsection'),
                    onPressed: () => Navigator.pushNamed(context, '/addsection'),
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('addchannel'),
                    isDestructiveAction: false,
                    onPressed: () => Navigator.pushNamed(context, '/addchannel'),
                  )
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                  },
                )
            ),
      );
    }
  }}