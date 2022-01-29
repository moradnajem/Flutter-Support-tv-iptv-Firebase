/*
import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/manger/status.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/models/user_profile.dart';
import 'package:tv/page/notification.dart';


import '../main.dart';
import '../lib/Subscriptions/SubscriptionOrdermodel.dart';
import '../lib/Subscriptions/SubscriptionsModel.dart';


class MyOrder extends StatefulWidget {
  const MyOrder({Key? key}) : super(key: key);

  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Language lang = Language.ENGLISH;

  @override
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: Text(AppLocalization.of(context)!.trans("my ticket"), style: TextStyle(color: Theme.of(context).primaryColor),),
        centerTitle: true,
        actions: const [
          NotificationsWidget(),
        ],
      ),
      body: StreamBuilder<List<SubscriptionOrderModel>>(
          stream: FirebaseManager.shared.getMySubscriptionOrder(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              List<SubscriptionOrderModel>? orders = snapshot.data;

              return orders!.isEmpty ? Center(child: Text(AppLocalization.of(context)!.trans("You have no requests"), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor)),) : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return _item(context, order: orders[index]);
                },
              );
            } else {
              return Center(child: loader(context));
            }
          }
      ),
    );
  }

  Widget _item(context, { required SubscriptionOrderModel order }) {

    String statusTitle = "";
    Widget statusIcon = const Icon(Icons.check, size: 22, color: Colors.green,);

    switch (order.status) {
      case Status.ACTIVE:
        statusTitle = AppLocalization.of(context)!.trans("Activity");
        statusIcon = const Icon(Icons.timer, size: 22, color: Colors.blue,);
        break;
      case Status.PENDING:
        statusTitle = AppLocalization.of(context)!.trans("In Review");
        statusIcon = const Icon(Icons.update, size: 22, color: Colors.yellow,);
        break;
      case Status.Rejected:
        statusTitle = AppLocalization.of(context)!.trans("Rejected");
        statusIcon = const Icon(Icons.report, size: 22, color: Colors.red,);
        break;
      case Status.Finished:
        statusTitle = AppLocalization.of(context)!.trans("Finished");
        statusIcon = const Icon(Icons.check, size: 22, color: Colors.green,);
        break;
      case Status.canceled:
        statusTitle = AppLocalization.of(context)!.trans("canceled");
        statusIcon = const Icon(Icons.cancel, size: 22, color: Colors.orangeAccent,);
        break;
    }

    return Column(
        children: [
          const SizedBox(height: 10),
          InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed("/OrderDetails", arguments: order),
              child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  AppLocalization.of(context)!.trans("Service: "),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).primaryColor),
                                ),
                                const SizedBox(width: 10),
                                StreamBuilder<SubscriptionsModel>(
                                    stream: FirebaseManager.shared
                                        .getSubscriptionById(id: order.ownerId),
                                    builder: (context, snapshot) {
                                      String serviceName = snapshot.hasData
                                          ? lang == Language.ARABIC
                                          ? snapshot.data!.SubscriptionAR
                                          : snapshot.data!.SubscriptionEN
                                          : "";
                                      return Text(serviceName,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Theme.of(context).colorScheme.secondary));
                                    }),
                              ],
                            ),
                            Visibility(
                              visible: order.status == Status.ACTIVE,
                              child: Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {/*
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Chat(
                              order: order,
                            ),
                          ),
                        );
                      */},
                                      icon: Icon(
                                        Icons.chat,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ]
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        FutureBuilder<UserModel>(
                            future:
                            FirebaseManager.shared.getUserByUid(uid: order.ownerId),
                            builder: (context, snapshot) {
                              return Column(
                                children: [

                                  /*   Visibility(
                  visible: order.status == Status.Rejected,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            AppLocalization.of(context)
                                .trans("Reason of refuse: "),
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(width: 10),z
                          Text(
                              lang == Language.ARABIC
                                  ? order.messageAR
                                  : order.messageEN,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.secondary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                          Visibility(
                  visible: order.status == Status.canceled,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            AppLocalization.of(context)
                                .trans("Reason of refuse: "),
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(width: 10),
                          Text(
                              lang == Language.ARABIC
                                  ? order.messageAR
                                  : order.messageEN,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.secondary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),*/
                                  Row(
                                    children: [
                                      Text(
                                        AppLocalization.of(context)!.trans("Date: "),
                                        style: TextStyle(
                                            fontSize: 18, color: Theme.of(context).primaryColor),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        order.createdDate.changeDateFormat(),
                                        style: TextStyle(
                                            fontSize: 16, color: Theme.of(context).colorScheme.secondary),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(color: Theme.of(context).primaryColor),
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          statusIcon,
                                          const SizedBox(width: 10),
                                          Text(
                                            statusTitle,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context).colorScheme.secondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            })])))]);
  }
}
*/