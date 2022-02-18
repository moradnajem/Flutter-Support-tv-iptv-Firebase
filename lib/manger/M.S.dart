import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/manger/status.dart';
import 'package:tv/models/favoriteModel.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/manger/user-type.dart';
import 'package:tv/models/user_profile.dart';
import 'package:tv/models/channelModel.dart';
import 'package:tv/models/SectionModel.dart';
import '../models/lang.dart';
import '../models/loader.dart';
import '../models/notification-model.dart';




class FirebaseManager {
  static final FirebaseManager shared = FirebaseManager();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final userRef = FirebaseFirestore.instance.collection('User');
  final sectionRef = FirebaseFirestore.instance.collection('section');
  final channelRef = FirebaseFirestore.instance.collection('channel');
  final notificationRef = FirebaseFirestore.instance.collection('Notification');
  final favoriteRef = FirebaseFirestore.instance.collection('Favorite');

  // TODO:- Start User

  Stream<List<UserModel>> getAllUsers() {
    return userRef.snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();
    });
  }

  Future<UserModel> getUserByUid({required String uid}) async {
    UserModel userTemp;

    var user = await userRef.doc(uid).snapshots().first;
    userTemp = UserModel.fromJson(user.data());

    return userTemp;
  }

  Future<UserModel> getCurrentUser() {
    return getUserByUid(uid: auth.currentUser!.uid);
  }

  createAccountUser({
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String name,
    required String phone,
    required String email,
    required String city,
    required String password,
  }) async {
    showLoaderDialog(scaffoldKey.currentContext);

    if (!email.isValidEmail()) {
      scaffoldKey.showTosta(
          message: AppLocalization.of(scaffoldKey.currentContext)!
              .trans("please enter a valid email"),
          isError: true);
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      return;
    }

    var userId = await _createAccountInFirebase(
        scaffoldKey: scaffoldKey, email: email, password: password);

    if (userId != null) {
      userRef.doc(userId).set({
        "id": "${Random().nextInt(999)}",
        "name": name,
        "phone": phone,
        "email": email,
        "city": city,
        "status-account": 1,
        "type-user": 1,
        "uid": userId,
      }).then((value) async {
        showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
        addNotifications(
            uidUser: userId,
            titleEN: "Welcome",
            titleAR: "مرحبا بك",
            detailsEN: "Welcome to our app\nWe wish you a happy experience",
            detailsAR: "مرحبا بك في تطبيقنا\nنتمنى لك تجربة رائعة");

        await getAllUsers().first.then((users) {
          for (var user in users) {
            if (user.userType == UserType.ADMIN) {
              addNotifications(
                  uidUser: user.uid!,
                  titleEN: "New User",
                  titleAR: "مستخدم جديد",
                  detailsEN: "$name new created a new account",
                  detailsAR: "$name أنشأ حساب جديد ");
            }
          }
        });

        Navigator.of(scaffoldKey.currentContext!).pushNamedAndRemoveUntil(
            "/SignIn", (route) => false,
            arguments:
            "Account created successfully, Your account in now under review");
      }).catchError((err) {
        showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext)!
                .trans("Something went wrong"),
            isError: true);
      });
    } else {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
    }
  }


  changeStatusAccount({
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String userId,
    required Status status,
  }) {
    showLoaderDialog(scaffoldKey.currentContext);
    userRef.doc(userId).update({
      "status-account": status.index,
    })
        .then((value) async {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      scaffoldKey.showTosta(
          message: AppLocalization.of(scaffoldKey.currentContext!)!.trans(
              "done successfully"));
    })
        .catchError((err) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      scaffoldKey.showTosta(
          message: AppLocalization.of(scaffoldKey.currentContext!)!.trans(
              "Something went wrong"), isError: true);
    });
  }

  updateAccount({
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String name,
    required String city,
    required String phoneNumber,
  }) async {
    showLoaderDialog(scaffoldKey.currentContext);
    userRef.doc(auth.currentUser!.uid).update({
      "name": name,
      "phone": phoneNumber,
      "city": city,
    })
        .then((value) async {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      UserModel? user = (await UserProfile.shared.getUser());
      user!.name = name;
      user.city = city;
      user.phone = phoneNumber;
      UserProfile.shared.setUser(user: user);
      Navigator.of(scaffoldKey.currentContext!).pop();
    })
        .catchError((err) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      scaffoldKey.showTosta(
          message: AppLocalization.of(scaffoldKey.currentContext!)!.trans(
              "Something went wrong"), isError: true);
    });
  }

  changePassword({
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String newPassword,
    required String confirmPassword,
  }) async {
    showLoaderDialog(scaffoldKey.currentContext);
    auth.currentUser!.updatePassword(newPassword).then((value) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      Navigator.of(scaffoldKey.currentContext!).pop();
    }).catchError((err) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      scaffoldKey.showTosta(
          message: AppLocalization.of(scaffoldKey.currentContext!)!.trans(
              "Something went wrong"), isError: true);
    });
  }

  login(
      {required GlobalKey<ScaffoldState> scaffoldKey,
        required String email,
        required String password}) async {
    showLoaderDialog(scaffoldKey.currentContext);

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await getUserByUid(uid: auth.currentUser!.uid).then((UserModel user) {
        switch (user.accountStatus) {
          case Status.ACTIVE:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            UserProfile.shared.setUser(user: user);
            Navigator.of(scaffoldKey.currentContext!).pushNamedAndRemoveUntil(
                '/TabBarPage', (Route<dynamic> route) => false,
                arguments: user.userType);
            break;
          case Status.PENDING:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!
                    .trans("Account under review"),
                isError: true);
            auth.signOut();
            break;
          case Status.Rejected:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!
                    .trans("Your account has been denied"),
                isError: true);
            auth.signOut();
            break;
          case Status.Deleted:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!
                    .trans("Your account has been deleted"),
                isError: true);
            auth.signOut();
            break;
          case Status.Disable:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!
                    .trans("Your account has been disabled"),
                isError: true);
            auth.signOut();
        }
      });

      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!
                .trans("user not found"),
            isError: true);
      } else if (e.code == 'wrong-password') {
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!
                .trans("wrong password"),
            isError: true);
      } else if (e.code == 'too-many-requests') {
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!
                .trans("The account is temporarily locked"),
            isError: true);
      }
    }

    showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
    return;
  }

  Future<String?> _createAccountInFirebase(
      {required GlobalKey<ScaffoldState> scaffoldKey,
        required String email,
        required String password}) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!
                .trans("the email is already used"),
            isError: true);
      }
      return null;
    } catch (e) {
      scaffoldKey.showTosta(
          message: AppLocalization.of(scaffoldKey.currentContext!)!
              .trans("something went wrong"),
          isError: true);
      print(e);
      return null;
    }
  }


  signOut(context) async {
    try {
      showLoaderDialog(context);
      await FirebaseAuth.instance.signOut();
      await UserProfile.shared.setUser(user: null);
      showLoaderDialog(context, isShowLoader: false);
      Navigator.pushNamedAndRemoveUntil(context, "/SignIn", (route) => false);
    } catch (_) {
      showLoaderDialog(context, isShowLoader: false);
    }
  }

  forgotPassword({required GlobalKey<ScaffoldState> scaffoldKey,
    required String email}) async {
    showLoaderDialog(scaffoldKey.currentContext);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      return true;
    } on FirebaseAuthException catch (e) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      if (e.code == 'user-not-found') {
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!
                .trans("user not found"),
            isError: true);
        return false;
      }
    }
  }

  deleteAccount(context, { required String iduser }) async {

    showLoaderDialog(context);

    await userRef.doc(iduser).delete().then((_) => {

    }).catchError((e) {

    });

    showLoaderDialog(context, isShowLoader: false);

  }

  // TODO:- End User
// TODO:- Start Notifications

  addNotifications({
    required String uidUser,
    required String titleEN,
    required String titleAR,
    required String detailsEN,
    required String detailsAR,
  }) async {
    String uid = notificationRef
        .doc()
        .id;
    notificationRef
        .doc(uid)
        .set({
      "user-id": uidUser,
      "title-en": titleEN,
      "title-ar": titleAR,
      "details-en": detailsEN,
      "details-ar": detailsAR,
      "createdDate": DateTime.now().toString(),
      "is-read": false,
      "uid": uid,
    })
        .then((value) {})
        .catchError((err) {});
  }

  setNotificationRead() async {
    List<NotificationModel> items = await getMyNotifications().first;
    for (var item in items) {
      if (item.userId == auth.currentUser!.uid && !item.isRead) {
        notificationRef.doc(item.uid).update({
          "is-read": true,
        });
      }
    }
  }

  Stream<List<NotificationModel>> getMyNotifications() {
    return notificationRef
        .where("user-id", isEqualTo: auth.currentUser!.uid)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return NotificationModel.fromJson(doc.data());
      }).toList();
    });
  }

// TODO:- End Notifications
// TODO:- Start section

  section(context,
      {
        String uid = "",
        required GlobalKey<ScaffoldState> scaffoldKey,
        required String titleEN,
        required String titleAR,
        required Section section,
      }) async {
    showLoaderDialog(context);
    String tempUid = (uid == null || uid == "") ? sectionRef.doc().id : uid;
    sectionRef.doc(tempUid).set({
      "title-en": titleEN,
      "title-ar": titleAR,
      "section": section.index,
      "uid": tempUid,
    })
        .then((value) {
      showLoaderDialog(context, isShowLoader: false);
      Navigator.of(context).pop();
    })
        .catchError((err) {
      showLoaderDialog(context, isShowLoader: false);
    });
  }
  deleteSection(context, {required String uidSection}) async {
    showLoaderDialog(context);

    await sectionRef.doc(uidSection).delete().then((_) => {}).catchError((e) {});

    showLoaderDialog(context, isShowLoader: false);
  }
  Stream<List<SectionModel>> getSectionsByName(
      {required String sectionName, required String fieldType}) {
    return sectionRef
        .where(fieldType,
        isGreaterThanOrEqualTo: sectionName, isLessThan: sectionName + 'z')
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return SectionModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<SectionModel>> getSection({required Section section}) {
    return sectionRef
        .where("section", isEqualTo: section.index)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return SectionModel.fromJson(doc.data());
      }).toList();
    });
  }



  Stream<SectionModel> getSectionById({required String id}) {
    return sectionRef.doc(id).snapshots().map((QueryDocumentSnapshot) {
      return SectionModel.fromJson(QueryDocumentSnapshot.data());
    });
  }


  //  TODO:- End Section

  // TODO:- Start favorite

  addToFavorite(context,
      {
        required String channelId,
        required int section,
        required ChannelModel channel,
      }) async {
    showLoaderDialog(context);
    String tempUid =  favoriteRef.doc().id;
    favoriteRef.doc(tempUid).set({
      "uid": tempUid,
      "userId": auth.currentUser!.uid,
      "channelId": channelId,
      "section": section,
      "streamURL": channel.streamURL,
      "titlear": channel.titleAR,
      "titleen": channel.titleEN,
    })
        .then((value) {
      showLoaderDialog(context, isShowLoader: false);
    })
        .catchError((err) {
      showLoaderDialog(context, isShowLoader: false);
    });
  }

  deleteFavoriteChannel(context, {required String uid}) async {
    showLoaderDialog(context);

    await favoriteRef.doc(uid).delete().then((_) => {}).catchError((e) {});

    showLoaderDialog(context, isShowLoader: false);
  }

  Stream<List<FavoriteModel>> getMyFavorites({required int section}) {
    return favoriteRef
        .where("userId",isEqualTo: auth.currentUser!.uid)
        .where("section",isEqualTo: section)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return FavoriteModel.fromJson(doc.data());
      }).toList();
    });
  }

Stream<List<FavoriteModel>> getFavoriteByChannel({required String channelId}) {
    return favoriteRef
        .where("userId", isEqualTo: auth.currentUser!.uid)
        .where("channelId", isEqualTo: channelId)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return FavoriteModel.fromJson(doc.data());
      }).toList();
    });
  }

  // TODO:- Start channel

  addOrEditChanne(
      context, {
        String uid = "",
        required GlobalKey<ScaffoldState> scaffoldKey,
        required String sectionuid,
        required String streamURL,
        required String titleEN,
        required String titleAR,
        required Section section,
      }) async {
    showLoaderDialog(context);

    String tempUid = (uid == null || uid == "") ? channelRef.doc().id : uid;

    channelRef.doc(tempUid).set({
      "section-uid": sectionuid,
      "title-en": titleEN,
      "title-ar": titleAR,
      "streamURL": streamURL,
      "section": section.index,
      "uid": tempUid,
    }).then((value) {
      showLoaderDialog(context, isShowLoader: false);
      Navigator.of(context).pop();
    }).catchError((err) {
      showLoaderDialog(context, isShowLoader: false);
    });
  }
  deletechannel(context, {required String uidchannel}) async {
    showLoaderDialog(context);

    await channelRef.doc(uidchannel).delete().then((_) => {}).catchError((e) {});

    showLoaderDialog(context, isShowLoader: false);
  }
  Stream<List<ChannelModel>> getchannelByStatus({required String channel}) {
    return channelRef
        .where("section-uid", isEqualTo: channel)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return ChannelModel.fromJson(doc.data());
      }).toList();
    });
  }
  Stream<List<ChannelModel>> getchannelByName(
      {required String channelName, required String fieldType}) {
    return channelRef
        .where(fieldType,
        isGreaterThanOrEqualTo: channelName, isLessThan: channelName + 'z')
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return ChannelModel.fromJson(doc.data());
      }).toList();
    });
  }


  // TODO:- ENd channel

}


