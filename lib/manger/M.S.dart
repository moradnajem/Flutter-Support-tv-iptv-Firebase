
import 'dart:js';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tv/core/models/model.dart';
import 'package:tv/manger/extensions.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/manger/status.dart';
import 'package:tv/manger/user-model.dart';
import 'package:tv/manger/user-type.dart';
import 'package:tv/manger/user_profile.dart';


import '../main.dart';
import 'loader.dart';
import 'notification-model.dart';




class FirebaseManager {

  static final FirebaseManager shared = FirebaseManager();
  final notificationRef = FirebaseFirestore.instance.collection('Notification');

  final FirebaseAuth auth = FirebaseAuth.instance;
  final userRef = FirebaseFirestore.instance.collection('User');
  final sectionRef = FirebaseFirestore.instance.collection('section');


  // TODO:- Start User

  Stream<List<UserModel>> getAllUsers() {
    return userRef.snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<UserModel>> getAllUser({required Status accountStatus}) {
    return userRef
        .where("status-account", isEqualTo: accountStatus.index)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();
    });
  }

  Future<UserModel> getUserByUid({ required String uid }) async {
    UserModel userTemp;

    var user = await userRef
        .doc(uid)
        .snapshots()
        .first;
    userTemp = UserModel.fromJson(user.data());

    return userTemp;
  }

  Future<UserModel> getCurrentUser() {
    return getUserByUid(uid: auth.currentUser!.uid);
  }


  createAccountUser({
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String imagePath,
    required String name,
    required String phone,
    required String email,
    required String city,
    required String password,
    required UserType userType,
  }) async {
    showLoaderDialog(scaffoldKey.currentContext);

    if (!email.isValidEmail()) {
      scaffoldKey.showTosta(
          message: AppLocalization.of(scaffoldKey.currentContext!)!.trans(
              "please enter a valid email"), isError: true);
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      return;
    }

    var userId = await _createAccountInFirebase(
        scaffoldKey: scaffoldKey, email: email, password: password);

    String imgUrl = "";


    if (userId != null) {
      userRef.doc(userId).set({
        "id": "${Random().nextInt(99999)}",
        "image": imgUrl,
        "name": name,
        "phone": phone,
        "email": email,
        "city": city,
        "balance": 0,
        "status-account": 1,
        "type-user": userType.index,
        "uid": userId,
      })
          .then((value) async {
        showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
        addNotifications(uidUser: userId,
            titleEN: "Welcome",
            titleAR: "مرحبا بك",
            detailsEN: "Welcome to our app\nWe wish you a happy experience",
            detailsAR: "مرحبا بك في تطبيقنا\nنتمنى لك تجربة رائعة");

        await getAllUsers().first.then((users) {
          for (var user in users) {
            if (user.userType == UserType.ADMIN) {
              addNotifications(uidUser: user.uid,
                  titleEN: "New User",
                  titleAR: "مستخدم جديد",
                  detailsEN: "$name new created a new account",
                  detailsAR: "$name أنشأ حساب جديد ");
            }
          }
        });

        Navigator.of(scaffoldKey.currentContext!).pushNamedAndRemoveUntil(
            "/SignIn", (route) => false,
            arguments: "Account created successfully, Your account in now under review");
      })
          .catchError((err) {
        showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!.trans(
                "Something went wrong"), isError: true);
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
    required String image,
    required String name,
    required String city,
    required String phoneNumber,
  }) async {
    showLoaderDialog(scaffoldKey.currentContext);

    String imageURL = "";

    if (image != "") {
      if (image.isURL()) {
        imageURL = image;
      } else {
        //     imageURL = await _uploadImage(folderName: "user", imagePath: image);
      }
    }


    userRef.doc(auth.currentUser!.uid).update({
      "image": imageURL,
      "name": name,
      "phone": phoneNumber,
      "city": city,
    })
        .then((value) async {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      UserModel? user = (await UserProfile.shared.getUser());
      user!.image = imageURL;
      user.name = name;
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

  // TODO:- End User
  login({ required GlobalKey<
      ScaffoldState> scaffoldKey, required String email, required String password }) async {
    try {
      try {
        //      await FirebaseFirestore.instance.terminate();
        await FirebaseFirestore.instance.clearPersistence();
      } catch (e) {}
      showLoaderDialog(scaffoldKey.currentContext);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

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
                message: AppLocalization.of(scaffoldKey.currentContext!)!.trans(
                    "Account under review"), isError: true);
            auth.signOut();
            break;
          case Status.Rejected:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!.trans(
                    "Your account has been denied"), isError: true);
            auth.signOut();
            break;
          case Status.Deleted:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!.trans(
                    "Your account has been deleted"), isError: true);
            auth.signOut();
            break;
          case Status.Disable:
            showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!.trans(
                    "Your account has been disabled"), isError: true);
            auth.signOut();
        }
      });

      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!.trans(
                "user not found"), isError: true);
      } else if (e.code == 'wrong-password') {
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!.trans(
                "wrong password"), isError: true);
      } else if (e.code == 'too-many-requests') {
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!.trans(
                "The account is temporarily locked"), isError: true);
      } else {
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!.trans(
                "Something went wrong"), isError: true);
      }
    }

    showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
    return;
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

  Stream<List<ServiceModel>> getServices({required Section section}) {
    return sectionRef
        .where("section", isEqualTo: section.index)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return ServiceModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<ServiceModel>> getMyServices() {
    return sectionRef
        .where("uid-owner", isEqualTo: auth.currentUser!.uid)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return ServiceModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<ServiceModel> getServiceById({required String id}) {
    return sectionRef.doc(id).snapshots().map((QueryDocumentSnapshot) {
      return ServiceModel.fromJson(QueryDocumentSnapshot.data());
    });
  }
}


  class FireStoreApiService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String path;
  late CollectionReference ref;

  FireStoreApiService(this.path) {
    ref = firestore.collection(path);
  }

  Future<QuerySnapshot> getAllCameraStreams() {
    return ref.get();
  }

  Stream<QuerySnapshot> getStreamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getCameraStreamById(String id) {
    return ref.doc(id).get();
  }

  Future<void> removeCameraStream(String? id) {
    return ref.doc(id).delete();
  }

  Future<DocumentReference> addCameraStream(Map data) {
    return ref.add(data);
  }

  Future<void> updateCameraStream(Map data, String? id) {
    return ref.doc(id).update(data as Map<String, Object?>);
  }
}
