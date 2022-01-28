import 'package:flutter/material.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/status.dart';
import 'package:tv/manger/user-type.dart';
import 'package:tv/models/loader.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/models/user_profile.dart';

import '../../main.dart';
import 'notification.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  Status status = Status.PENDING;
  UserType userType = UserType.USER;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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

        title: Text(
          AppLocalization.of(context)!.trans('Users'),
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
        actions: const [
          NotificationsWidget(),
        ],
      ),
      body: FutureBuilder<UserModel?>(
          future: UserProfile.shared.getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserModel? currentUser = snapshot.data;
              return StreamBuilder<List<UserModel>>(
                  stream: FirebaseManager.shared.getAllUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<UserModel> items = [];
                      for (var user in snapshot.data!) {
                        if (user.uid != currentUser!.uid &&
                            user.accountStatus == status &&
                            user.userType == userType) {
                          items.add(user);
                        }
                      }
                      items.sort((a, b) {
                        return DateTime.parse(b.dateCreated!)
                            .compareTo(DateTime.parse(a.dateCreated!));
                      });
                      return ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount:
                        items.isEmpty ? items.length + 2 : items.length + 1,
                        itemBuilder: (context, index) {
                          return index == 0
                              ? _header()
                              : (items.isEmpty
                              ? Center(
                            child: Text(
                              AppLocalization.of(context)!
                                  .trans("There are no members"),
                              style: TextStyle(
                                  fontSize: 18,
                                  color:
                                  Theme.of(context).primaryColor),
                            ),
                          )
                              : _item(user: items[index - 1]));
                        },
                      );
                    } else {
                      return Center(child: loader(context));
                    }
                  });
            } else {
              return const SizedBox();
            }
          }),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalization.of(context)!.trans("Status Account:-"),
          style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Row(
              children: [
                Radio(
                  activeColor: Theme.of(context).primaryColor,
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
                  activeColor: Theme.of(context).primaryColor,
                  value: Status.PENDING,
                  groupValue: status,
                  onChanged: (Status? value) {
                    setState(() {
                      status = value!;
                    });
                  },
                ),
                Text(AppLocalization.of(context)!.trans("pending")),
              ],
            ),
            Row(
              children: [
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: UserType.USER,
                  groupValue: userType,
                  onChanged: (UserType? value) {
                    setState(() {
                      userType = value!;
                    });
                  },
                ),
                Text(AppLocalization.of(context)!.trans("users")),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        const SizedBox(height: 20),
        Container(
          height: 1,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _item({required UserModel user}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                AppLocalization.of(context)!.trans("User ID: "),
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 10),
              Flexible(
                  child: Text(user.id!,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                AppLocalization.of(context)!.trans("User name: "),
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 10),
              Flexible(
                  child: Text(user.name,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                AppLocalization.of(context)!.trans("Email: "),
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 10),
              Flexible(
                  child: Text(user.email!,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                AppLocalization.of(context)!.trans("Phone: "),
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 10),
              Flexible(
                  child: Text(user.phone!,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                AppLocalization.of(context)!.trans("Date created: "),
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 10),
              //  Flexible(child: Text(user.dateCreated.changeDateFormat(), style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary))),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: status == Status.PENDING,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        FirebaseManager.shared.changeStatusAccount(
                            scaffoldKey: _scaffoldKey,
                            userId: user.uid!,
                            status: Status.ACTIVE);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * (50 / 812),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                            child: Text(
                              AppLocalization.of(context)!.trans("accept"),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: status == Status.PENDING,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        FirebaseManager.shared.changeStatusAccount(
                            scaffoldKey: _scaffoldKey,
                            userId: user.uid!,
                            status: Status.Rejected);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * (50 / 812),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                            child: Text(
                              AppLocalization.of(context)!.trans("Rejected"),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: status == Status.Disable,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        FirebaseManager.shared.changeStatusAccount(
                            scaffoldKey: _scaffoldKey,
                            userId: user.uid!,
                            status: Status.ACTIVE);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * (50 / 812),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                            child: Text(
                              AppLocalization.of(context)!.trans("activation"),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: status == Status.ACTIVE,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        /*
                        showAlertDialog(context, title: AppLocalization.of(context)!.trans("Disable Account"), message: AppLocalization.of(context)!.trans("Are you sure disable account?"), titleBtnOne: "disabled", titleBtnTwo: "Close", actionBtnOne: () {
                          Navigator.of(context).pop();
                          FirebaseManager.shared.changeStatusAccount(scaffoldKey: _scaffoldKey, userId: user.uid, status: Status.Disable);
                        }, actionBtnTwo: () {
                          Navigator.of(context).pop();
                        });*/
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * (50 / 812),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                            child: Text(
                              AppLocalization.of(context)!.trans("disabled"),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: status == Status.Disable,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        /*
                        showAlertDialog(context, title: AppLocalization.of(context)!.trans("Delete Account"), message: AppLocalization.of(context)!.trans("Are you sure delete account?"), titleBtnOne: "Delete", titleBtnTwo: "Close", actionBtnOne: () {
                          Navigator.of(context).pop();
                          FirebaseManager.shared.changeStatusAccount(scaffoldKey: _scaffoldKey, userId: user.uid, status: Status.Deleted);
                        }, actionBtnTwo: () {
                          Navigator.of(context).pop();
                        });*/
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * (50 / 812),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                            child: Text(
                              AppLocalization.of(context)!.trans("Delete"),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
