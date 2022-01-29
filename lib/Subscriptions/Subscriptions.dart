import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/manger/status.dart';
import 'package:tv/manger/user-type.dart';
import 'package:tv/models/SectionModel.dart';
import 'package:tv/models/assets.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/input_style.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/models/user_profile.dart';
import 'package:tv/page/notification.dart';

import '../main.dart';
import 'SubscriptionOrdermodel.dart';
import 'SubscriptionsModel.dart';
import 'addSubscriptions.dart';


class Subscriptions extends StatefulWidget {
  String? uidActiveService;

  _SubscriptionsState createState() => _SubscriptionsState();

}

class _SubscriptionsState extends State<Subscriptions> {
  Language lang = Language.ENGLISH;
  List<DropdownMenuItem<String>>? _dropdownMenuItem = [];
  String? _activeDropDownItem;

  void initState() {
    // TODO: implement initState
    super.initState();
    _getServiceData();
    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        lang = value!;
      });
    });
  }

  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
        key: _scaffoldKey,
        future: UserProfile.shared.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel? user = snapshot.data;

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme
                    .of(context)
                    .canvasColor,
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
                title: Text(AppLocalization.of(context)!.trans('Subscriptions'),
                  style: TextStyle(color: Theme
                      .of(context)
                      .primaryColor),),
                centerTitle: true,
                actions: [
                  Visibility(visible: user!.userType == UserType.ADMIN,
                    child: IconButton(
                        icon: Icon(
                            Icons.add,
                            color: Theme
                                .of(context)
                                .primaryColor
                        ),
                        onPressed: () {
                            Navigator.pushNamed(context, '/add');
                        }
                    ),),
                ],
              ),
              body: user.userType == UserType.ADMIN
                  ? _widgetTech(context)
                  : _widgetUser(context),
            );
          }

          return SizedBox();
        }
    );
  }

  Widget _widgetUser(context) {
    return Column(
        children: [
    _MyOrder(),
   SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 30,),
         //   SvgPicture.asset(Assets.shared.icOrderService, width: MediaQuery.of(context).size.width * 0.6,),
            SizedBox(height: MediaQuery.of(context).size.height * (60 / 812),),
            Form(
              child: Column(
                children: [
                  DropdownButtonFormField(
                    items: _dropdownMenuItem,
                    onChanged: (newValue) {
                      setState(() => _activeDropDownItem = newValue as String?);
                    },
                    value: _activeDropDownItem,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: customInputForm.copyWith(prefixIcon: Icon(
                      Icons.person_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    ).copyWith(hintText: AppLocalization.of(context)!.trans("Service"),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * (80 / 812),),
            RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text("ADD",
                    style: TextStyle(color: Theme.of(context).canvasColor,)),
                onPressed:   _submitData
            ),
          ],
        ),
      ),
    )]);
  }

  _getServiceData() async {

    List<SubscriptionsModel> services = await FirebaseManager.shared.getAllSubscription().first;

    setState(() {
      _dropdownMenuItem = services.map((item) => DropdownMenuItem(child: Text( lang == Language.ARABIC ? item.SubscriptionAR : item.SubscriptionEN ), value: item.uid.toString())).toList();

      if (widget.uidActiveService != null) {
        _activeDropDownItem = widget.uidActiveService;
      }

    });

  }

  bool _validation() {
    return !(_activeDropDownItem == null);
  }

  _submitData() async {

    if (!_validation()) {
      _scaffoldKey.showTosta(message: AppLocalization.of(context)!.trans("Please fill in all fields"), isError: true);
      return;
    }

    SubscriptionsModel item = await  FirebaseManager.shared.getSubscriptionById(id: _activeDropDownItem!).first;

    FirebaseManager.shared.SubscriptionOrder(context,  ownerId: item.uid );

  }




final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Widget _widgetTech(context) {
    return StreamBuilder<List<SubscriptionsModel>>(
        stream: FirebaseManager.shared.getAllSubscription(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List? Subscription = snapshot.data;
            if (Subscription!.isEmpty) {
              return Center(child: Text(
                "No  added", style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor, fontSize: 18),));
            }
            return ListView.builder(
              itemCount: Subscription.length,
              itemBuilder: (buildContext, index) =>
                  GestureDetector(
                    onTap: () {
                      /*
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => channel(Subscription[index].uid)));
                    */},
                    child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      elevation: 5,
                      child: SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.1,
                        width: MediaQuery
                            .of(context)
                            .size
                            .height * 0.1,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(lang == Language.ENGLISH
                                      ? Subscription[index].SubscriptionEN
                                      : Subscription[index].SubscriptionAR,
                                      style: TextStyle(color: Theme
                                          .of(context)
                                          .primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight
                                              .w500)
                                  ),
                                  IconButton(
                                    iconSize: 35,
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => add(
                                                updateSubscription: Subscription[index]))),
                                    //  onPressed: ()  { },
                                  ),
                                  IconButton(
                                    iconSize: 35,
                                    icon: const Icon(Icons.delete_forever),
                                    onPressed: () {
                                      _deleteSection(
                                          context, Subscription[index].uid);
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  ),
            );
          } else {
            return Center(
              child: loader(context),
            );
          }

        }
    );
  }

  _deleteSection(context, String uidSubscription) {
    FirebaseManager.shared.deleteSubscription(context, uidSubscription: uidSubscription);
  }

  Widget  _MyOrder() {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
    return
      Expanded(
          key: _scaffoldKey,
          child: StreamBuilder<List<SubscriptionOrderModel>>(
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
