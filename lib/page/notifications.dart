import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/notification-model.dart';
import 'package:tv/models/user_profile.dart';

import '../main.dart';



class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {

  Language lang = Language.ENGLISH;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseManager.shared.setNotificationRead();
    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        lang = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: Text(AppLocalization.of(context)!.trans("Notifications"), style: TextStyle(color: Theme.of(context).primaryColor),),
        centerTitle: true,
      ),
      body: StreamBuilder<List<NotificationModel>>(
          stream: FirebaseManager.shared.getMyNotifications(),
          builder: (context, snapshot) {

            if (snapshot.hasData) {

              List<NotificationModel>? items = snapshot.data;

              items!.sort((a,b) {
                return DateTime.parse(b.createdDate).compareTo(DateTime.parse(a.createdDate));
              });

              return items.isEmpty ? Center(child: Text(AppLocalization.of(context)!.trans("You have no notifications"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),)) : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _item(item: items[index]);
                },
              );
            } else {
              return Center(child: loader(context));
            }

          }
      ),
    );
  }

  Widget _item({ required NotificationModel item }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(lang == Language.ARABIC ? item.titleAr : item.titleEn, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.w600),),
        const SizedBox(height: 5),
        Text(lang == Language.ARABIC ? item.detailsAr : item.detailsEn, style: const TextStyle(color: Colors.black54, fontSize: 16),),
        const SizedBox(height: 10),
        Container(height: 1, color: Theme.of(context).primaryColor,),
        const SizedBox(height: 10),
      ],
    );
  }

}
