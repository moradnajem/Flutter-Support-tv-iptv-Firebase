import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/manger/status.dart';
import 'package:tv/manger/user-type.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/models/input_style.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/models/user_profile.dart';
import 'package:tv/page/chat.dart';

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
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
              FlatButton(
              child: Text(AppLocalization.of(context)!.trans("My Order"),
              style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              ),
              ),
              onPressed: () => Navigator.pushNamed(context, '/orderuser'),
              ),
                  SizedBox(height: 30,),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * (60 / 812),),
                  Form(
                    child: Column(
                      children: [
                        DropdownButtonFormField(
                          items: _dropdownMenuItem,
                          onChanged: (newValue) {
                            setState(() =>
                            _activeDropDownItem = newValue as String?);
                          },
                          value: _activeDropDownItem,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: customInputForm.copyWith(prefixIcon: Icon(
                            Icons.person_outline,
                            color: Theme
                                .of(context)
                                .primaryColor,
                          ),
                          ).copyWith(hintText: AppLocalization.of(context)!
                              .trans("Service"),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(AppLocalization.of(context)!.trans("Details"), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                            SizedBox(width: 10),
                         //   Text(order.details, style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * (80 / 812),),
                  RaisedButton(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      child: Text("ADD",
                          style: TextStyle(color: Theme
                              .of(context)
                              .canvasColor,)),
                      onPressed: _submitData
                  ),
                ],
              ),
            ),
          )
        ]);
  }

  _getServiceData() async {
    List<SubscriptionsModel> services = await FirebaseManager.shared
        .getAllSubscription()
        .first;

    setState(() {
      _dropdownMenuItem = services.map((item) =>
          DropdownMenuItem(child: Text(
              lang == Language.ARABIC ? item.SubscriptionAR : item
                  .SubscriptionEN), value: item.uid.toString())).toList();

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
      _scaffoldKey.showTosta(message: AppLocalization.of(context)!.trans(
          "Please fill in all fields"), isError: true);
      return;
    }

    SubscriptionsModel item = await FirebaseManager.shared
        .getSubscriptionById(id: _activeDropDownItem!)
        .first;

    FirebaseManager.shared.SubscriptionOrder(
        context, ownerId: item.uidOwner, SubscriptionId: _activeDropDownItem!);
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
                    */
                    },
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
                                      onPressed: () =>
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      add(
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
    FirebaseManager.shared.deleteSubscription(
        context, uidSubscription: uidSubscription);
  }

}