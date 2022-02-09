import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/manger/status.dart';
import 'package:tv/manger/user-type.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/models/user_profile.dart';
import 'package:tv/page/chat.dart';
import 'package:tv/page/notification.dart';

//paid
//Unpaid
//canceled
//rejected
//process

import '../main.dart';
import 'SubscriptionOrdermodel.dart';
import 'SubscriptionsModel.dart';


class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Language lang = Language.ENGLISH;

  Status status = Status.PENDING;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
        backgroundColor: Theme
            .of(context)
            .canvasColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme
              .of(context)
              .primaryColor,
        ),
        title: Text(AppLocalization.of(context)!.trans('Orders'),
          style: TextStyle(color: Theme
              .of(context)
              .primaryColor),),
        centerTitle: true,
        actions: const [
          NotificationsWidget(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _header(),
            Expanded(
              child: FutureBuilder<UserModel?>(
                  future: UserProfile.shared.getUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder<List<SubscriptionOrderModel>>(
                          stream: snapshot.data!.userType == UserType.ADMIN
                              ? FirebaseManager.shared.getAllSubscriptionOrder()
                              : snapshot.data!.userType == UserType.USER
                              ? FirebaseManager.shared
                              .getMySubscriptionOrderTech()
                              : FirebaseManager.shared.getMySubscriptionOrder(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<SubscriptionOrderModel> orders = [];

                              for (var order in snapshot.data!) {
                                if (order.status == status) {
                                  orders.add(order);
                                }
                              }

                              return orders.isEmpty
                                  ? Center(
                                child: Text(
                                    AppLocalization.of(context)!
                                        .trans("no orders"),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme
                                            .of(context)
                                            .primaryColor)),
                              )
                                  : ListView.builder(
                                itemCount: orders.length,
                                itemBuilder: (context, index) {
                                  return _item(context,
                                      order: orders[index]);
                                },
                              );
                            } else {
                              return Center(child: loader(context));
                            }
                          });
                    } else {
                      return Center(
                        child: loader(context),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            AppLocalization.of(context)!.trans("Status Order:-"),
            style: TextStyle(fontSize: 18, color: Theme
                .of(context)
                .primaryColor),
          ),
          const SizedBox(height: 10),

          Column(
            children: [
              Row(
                children: [
                  Row(
                    children: [

                      Radio(
                        activeColor: Theme
                            .of(context)
                            .primaryColor,
                        value: Status.ACTIVE,
                        groupValue: status,
                        onChanged: (Status? value) {
                          setState(() {
                            status = value!;
                          });
                        },
                      ),
                      Text(AppLocalization.of(context)!.trans("active")),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        activeColor: Theme
                            .of(context)
                            .primaryColor,
                        value: Status.PENDING,
                        groupValue: status,
                        onChanged: (Status? value) {
                          setState(() {
                            status = value!;
                          });
                        },
                      ),
                      Text(AppLocalization.of(context)!.trans("in review")),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 1,
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
              const SizedBox(height: 20),
            ],
          )
        ]);
  }

  Widget _item(context, {required SubscriptionOrderModel order}) {
    return Column(
        children: [
              Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme
                        .of(context)
                        .primaryColor),
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
                                  AppLocalization.of(context)!.trans(
                                      "Service: "),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme
                                          .of(context)
                                          .primaryColor),
                                ),
                                StreamBuilder<SubscriptionsModel>(
                                    stream: FirebaseManager.shared
                                        .getSubscriptionById(
                                        id: order.ownerId),
                                    builder: (context, snapshot) {
                                      String serviceName = snapshot.hasData
                                          ? lang == Language.ARABIC
                                          ? snapshot.data!.SubscriptionAR
                                          : snapshot.data!.SubscriptionEN
                                          : "";
                                      return Text(serviceName,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Theme
                                                  .of(context)
                                                  .colorScheme
                                                  .secondary));
                                    }),
                              ],
                            ),
                            Visibility(
                              visible: order.status == Status.ACTIVE,
                              child: Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Chat(
                                                  order: order,
                                                ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.chat,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ],
                        ),
                          Visibility(
                          visible: order.status == Status.Rejected,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    AppLocalization.of(context)!
                                        .trans("Reason of refuse: "),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme
                                            .of(context)
                                            .primaryColor),
                                  ),
                                  Text(
                                      lang == Language.ARABIC
                                          ? order.messageAR
                                          : order.messageEN,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme
                                              .of(context)
                                              .colorScheme
                                              .secondary)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: order.status == Status.canceled,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    AppLocalization.of(context)!
                                        .trans("canceled"),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme
                                            .of(context)
                                            .primaryColor),
                                  ),
                                  Text(
                                      lang == Language.ARABIC
                                          ? order.messageAR
                                          : order.messageEN,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme
                                              .of(context)
                                              .colorScheme
                                              .secondary)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              AppLocalization.of(context)!.trans(
                                  "Customer name: "),
                              style: TextStyle(
                                  fontSize: 18, color: Theme
                                  .of(context)
                                  .primaryColor),
                            ),
                            FutureBuilder<UserModel>(
                                future: FirebaseManager.shared
                                    .getUserByUid(uid: order.userId),
                                builder: (context, snapshot) {
                                  return Text(
                                    snapshot.hasData ? snapshot.data!.name : "",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .secondary),
                                  );
                                }),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Text(
                              AppLocalization.of(context)!.trans("Date: "),
                              style: TextStyle(
                                  fontSize: 18, color: Theme
                                  .of(context)
                                  .primaryColor),
                            ),
                            Text(
                              order.createdDate.changeDateFormat(),
                              style: TextStyle(
                                  fontSize: 16, color: Theme
                                  .of(context)
                                  .colorScheme
                                  .secondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              AppLocalization.of(context)!.trans(
                                  "Service: "),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme
                                      .of(context)
                                      .primaryColor),
                            ),
                            StreamBuilder<SubscriptionsModel>(
                                stream: FirebaseManager.shared
                                    .getSubscriptionById(
                                    id: order.ownerId),
                                builder: (context, snapshot) {
                                  String serviceName = snapshot.hasData
                                      ? snapshot.data!.details
                                      : "";
                                  return Text(serviceName,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme
                                              .of(context)
                                              .colorScheme
                                              .secondary));
                                }),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: status == Status.PENDING,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      FirebaseManager.shared.changeOrderStatus(
                                          _scaffoldKey.currentContext,
                                          uid: order.uid,
                                          status: Status.ACTIVE);
                                    },
                                    child: Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.3,
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * (50 / 812),
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      child: Center(
                                          child: Text(
                                            AppLocalization.of(context)!.trans(
                                                "accept"),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          )),
                                    ),
                                  ),
                                  const SizedBox(width: 20,),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: status == Status.PENDING,
                              child: Row(
                                children: [
                                  InkWell(
                                   // onTap: () => _btnReject(uid: order.uid),
                                    child: Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.3,
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * (50 / 812),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      child: Center(
                                          child: Text(
                                            AppLocalization.of(context)!.trans(
                                                "Reject"),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: status == Status.ACTIVE,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        FirebaseManager.shared
                                            .changeOrderStatus(
                                            _scaffoldKey.currentContext,
                                            uid: order.uid,
                                            status: Status.Finished);
                                      },
                                      child: Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.3,
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .height * (50 / 812),
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Center(
                                            child: Text(
                                              AppLocalization.of(context)!
                                                  .trans(
                                                  "End the service"),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            )),
                                      ),
                                    ),
                                    const SizedBox(width: 20,),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: order.status == Status.Finished,
                                    child: Column(
                                        children: [
                                          IconButton(icon: const Icon(
                                            Icons.delete_forever,
                                            size: 36, color: Colors.red,),
                                              tooltip: AppLocalization.of(
                                                  context)!
                                                  .trans("delete service"),
                                              onPressed: () {})

                                        ]
                                    ),
                                  ),
                                  Visibility(
                                    visible: order.status == Status.Rejected,
                                    child: Column(
                                        children: [
                                          IconButton(icon: const Icon(
                                            Icons.delete_forever,
                                            size: 36, color: Colors.red,),
                                              tooltip: AppLocalization.of(
                                                  context)!
                                                  .trans("delete service"),
                                              onPressed: () {})

                                        ]
                                    ),
                                  ),
                                  Visibility(
                                    visible: order.status == Status.canceled,
                                    child: Column(
                                        children: [
                                          IconButton(icon: const Icon(
                                            Icons.delete_forever,
                                            size: 36, color: Colors.red,),
                                              tooltip: AppLocalization.of(
                                                  context)!
                                                  .trans("delete service"),
                                              onPressed: () {})
                                        ]
                                    ),
                                  ),
                                  Visibility(
                                    visible: status == Status.ACTIVE,
                                    child: Row(
                                      children: [
                                        InkWell(
                                          //onTap: () =>
                                          //    _btncancelle(uid: order.uid),
                                          child: Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.3,
                                            height: MediaQuery
                                                .of(context)
                                                .size
                                                .height * (50 / 812),
                                            decoration: const BoxDecoration(
                                              color: Colors.orangeAccent,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            child: Center(
                                                child: Text(
                                                  AppLocalization.of(context)!
                                                      .trans("cancelle"),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),

                                  )
                                ],

                              ),
                            ]
                        )
                      ]
                  )
              )
        ]
    );
  }
}