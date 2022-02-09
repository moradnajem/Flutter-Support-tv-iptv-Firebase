import 'package:flutter/material.dart';


alertSheet(context, {bool addChannel = false, String title = "", required List<dynamic> items, required onTap(value) }) {

  List<Widget> actions = [];

  for (var value in items) {
    {
      actions.add(
        Align(
          alignment: Alignment.center,
          child: FlatButton(
            child: Text(
              addChannel?
              value.titleEN :
              value
              ,
              style:
              TextStyle(color: Theme.of(context).accentColor, fontSize: 18),
            ),
            onPressed: () {
              onTap(value);
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    };
  }

  actions.add(Align(
    alignment: Alignment.center,
    child: FlatButton(
      minWidth: MediaQuery.of(context).size.width,
      child: Text('Cancel',
        style:
        TextStyle(color: Theme.of(context).accentColor, fontSize: 18),),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),
  ));

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title, style: TextStyle(color: Theme.of(context).primaryColor), textAlign: TextAlign.center,),
      actions: actions,
    ),
  );
}