import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tv/Subscriptions/SubscriptionOrdermodel.dart';
import 'package:tv/Subscriptions/SubscriptionsModel.dart';
import 'package:tv/models/chat-model.dart';
import 'package:tv/models/extensions.dart';
import 'package:tv/manger/Section.dart';
import 'package:tv/manger/status.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/manger/user-type.dart';
import 'package:tv/models/user_profile.dart';
import 'package:tv/models/channelModel.dart';
import 'package:tv/models/SectionModel.dart';
import 'package:uuid/uuid.dart';
import '../main.dart';
import '../models/loader.dart';
import '../models/notification-model.dart';

class FirebaseManager {
  static final FirebaseManager shared = FirebaseManager();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final userRef = FirebaseFirestore.instance.collection('User');
  final sectionRef = FirebaseFirestore.instance.collection('section');
  final channelRef = FirebaseFirestore.instance.collection('channel');
  final SubscriptionRef = FirebaseFirestore.instance.collection('Subscription');
  final SubscriptionOrderRef =
      FirebaseFirestore.instance.collection('SubscriptionOrder');
  final notificationRef = FirebaseFirestore.instance.collection('Notification');
  final chatRef = FirebaseFirestore.instance.collection('Chat');
  final storageRef = FirebaseStorage.instance.ref();

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

  createAccountAUTH({
    required GlobalKey<ScaffoldState> scaffoldKey,
    required UserType userType,
    required UserCredential user,
  }) async {
    showLoaderDialog(scaffoldKey.currentContext);

    var userId = user.user!.uid;

    if (userId != null) {
      userRef.doc(userId).set({
        "id": "${Random().nextInt(99999)}",
        "image": user.user!.photoURL == null ? "" : user.user!.photoURL,
        "name": user.user!.displayName == null ? "" : user.user!.displayName,
        "phone": user.user!.phoneNumber == null ? "" : user.user!.phoneNumber,
        "city": "",
        "createdDate": DateTime.now().toString(),
        "email": user.user!.email,
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
                  detailsEN: " new created a new account",
                  detailsAR: " أنشأ حساب جديد ");
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
            message: AppLocalization.of(scaffoldKey.currentContext!)!
                .trans("Something went wrong"),
            isError: true);
      });
    } else {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
    }
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
          message: AppLocalization.of(scaffoldKey.currentContext!)!
              .trans("please enter a valid email"),
          isError: true);
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
        "createdDate": DateTime.now().toString(),
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
            message: AppLocalization.of(scaffoldKey.currentContext!)!
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
    }).then((value) async {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      scaffoldKey.showTosta(
          message: AppLocalization.of(scaffoldKey.currentContext!)!
              .trans("done successfully"));
    }).catchError((err) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      scaffoldKey.showTosta(
          message: AppLocalization.of(scaffoldKey.currentContext!)!
              .trans("Something went wrong"),
          isError: true);
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
        imageURL = await _uploadImage(folderName: "user", imagePath: image);
      }
    }

    userRef.doc(auth.currentUser!.uid).update({
      "image": imageURL,
      "name": name,
      "phone": phoneNumber,
      "city": city,
    }).then((value) async {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      UserModel? user = (await UserProfile.shared.getUser());
      user!.image = imageURL;
      user.name = name;
      user.city = city;
      user.phone = phoneNumber;
      UserProfile.shared.setUser(user: user);
      Navigator.of(scaffoldKey.currentContext!).pop();
    }).catchError((err) {
      showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
      scaffoldKey.showTosta(
          message: AppLocalization.of(scaffoldKey.currentContext!)!
              .trans("Something went wrong"),
          isError: true);
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
          message: AppLocalization.of(scaffoldKey.currentContext!)!
              .trans("Something went wrong"),
          isError: true);
    });
  }

  // TODO:- End User
  // TODO:- Start Auth

  signInWithGoogle(
      {required GlobalKey<ScaffoldState> scaffoldKey,
      required UserType userType}) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    DocumentSnapshot doc = await userRef.doc(userCredential.user!.uid).get();

    if (!doc.exists) {
      if (userType != UserType.USER) {
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!
                .trans("This feature is allowed for admin only"),
            isError: true);
        return;
      } else {
        createAccountAUTH(
            scaffoldKey: scaffoldKey, userType: userType, user: userCredential);
      }
    } else {
      await getUserByUid(uid: userCredential.user!.uid).then((UserModel user) {
        if (user.userType != userType) {
          scaffoldKey.showTosta(
              message: AppLocalization.of(scaffoldKey.currentContext!)!
                  .trans("User not found"),
              isError: true);
          auth.signOut();
          return;
        }

        switch (user.accountStatus) {
          case Status.ACTIVE:
            UserProfile.shared.setUser(user: user);
            Navigator.of(scaffoldKey.currentContext!).pushNamedAndRemoveUntil(
                '/TabBarPage', (Route<dynamic> route) => false,
                arguments: user.userType);
            break;
          case Status.PENDING:
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!
                    .trans("Account under review"),
                isError: true);
            auth.signOut();
            break;
          case Status.Rejected:
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!
                    .trans("Your account has been denied"),
                isError: true);
            auth.signOut();
            break;
          case Status.Deleted:
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!
                    .trans("Your account has been deleted"),
                isError: true);
            auth.signOut();
            break;
        }
      });
    }
  }

  /*  signInWithTwitter({ required GlobalKey<ScaffoldState> scaffoldKey, required UserType userType }) async {
     final TwitterLogin twitterLogin = TwitterLogin(
       consumerKey: 'yxIMMy6eUgPF7B4oLxhyU9zBF',
       consumerSecret:'Ec2HGWOTpjJTX9wx8QYx8XefPCNSFLcCRD4oep0c19eTOZTqOe',
       redirectURI: '',
     );

     final TwitterLoginResult loginResult = await twitterLogin.authorize();

     final TwitterSession twitterSession = loginResult.session;

     final twitterAuthCredential = TwitterAuthProvider.credential(
       accessToken: twitterSession.token,
       secret: twitterSession.secret,
     );

     UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);

     DocumentSnapshot doc = await userRef.doc(userCredential.user!.uid).get();

     if (!doc.exists) {

       if (userType == UserType.ADMIN) {
         scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext!)!.trans("This feature is allowed for admin only"), isError: true);
         return;
       } else {
         createAccountAUTH(scaffoldKey: scaffoldKey, userType: userType, user: userCredential);
       }

     } else {
       await getUserByUid(uid: userCredential.user!.uid).then((UserModel user) {

         if (user.userType != userType) {
           scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext!)!.trans("User not found"), isError: true);
           auth.signOut();
           return;
         }

         switch (user.accountStatus) {
           case Status.ACTIVE:
             UserProfile.shared.setUser(user: user);
             Navigator.of(scaffoldKey.currentContext!).pushNamedAndRemoveUntil('/Tabbar', (Route<dynamic> route) => false, arguments: user.userType);
             break;
           case Status.PENDING:
             scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext!)!.trans("Account under review"), isError: true);
             auth.signOut();
             break;
           case Status.Rejected:
             scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext!)!.trans("Your account has been denied"), isError: true);
             auth.signOut();
             break;
           case Status.Deleted:
             scaffoldKey.showTosta(message: AppLocalization.of(scaffoldKey.currentContext!)!.trans("Your account has been deleted"), isError: true);
             auth.signOut();
             break;
         }

       });
     }
//   final twitterLogin = TwitterLogin(
//       /// Consumer API keys
//       apiKey: API_KEY,
//
//       /// Consumer API Secret keys
//       apiSecretKey: API_SECRET_KEY,
//
//       /// Registered Callback URLs in TwitterApp
//       /// Android is a deeplink
//       /// iOS is a URLScheme
//       redirectURI: 'example://',
//     );
//
//     /// Forces the user to enter their credentials
//     /// to ensure the correct users account is authorized.
//     /// If you want to implement Twitter account switching, set [force_login] to true
//     /// login(forceLogin: true);
//     final authResult = await twitterLogin.login();
//     switch (authResult.status) {
//       case TwitterLoginStatus.loggedIn:
//         // success
//         print('====== Login success ======');
//         break;
//       case TwitterLoginStatus.cancelledByUser:
//         // cancel
//         print('====== Login cancel ======');
//         break;
//       case TwitterLoginStatus.error:
//       case null:
//         // error
//         print('====== Login error ======');
//         break;
   }*/

  signInWithApple(
      {required GlobalKey<ScaffoldState> scaffoldKey,
      required UserType userType}) async {
    String generateNonce([int length = 32]) {
      const charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(
          length, (_) => charset[random.nextInt(charset.length)]).join();
    }

    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    DocumentSnapshot doc = await userRef.doc(userCredential.user!.uid).get();

    if (!doc.exists) {
      if (userType == UserType.USER) {
        scaffoldKey.showTosta(
            message: AppLocalization.of(scaffoldKey.currentContext!)!
                .trans("This feature is allowed for admin only"),
            isError: true);
        return;
      } else {
        createAccountAUTH(
            scaffoldKey: scaffoldKey, userType: userType, user: userCredential);
      }
    } else {
      await getUserByUid(uid: userCredential.user!.uid).then((UserModel user) {
        if (user.userType == userType) {
          scaffoldKey.showTosta(
              message: AppLocalization.of(scaffoldKey.currentContext!)!
                  .trans("User not found"),
              isError: true);
          auth.signOut();
          return;
        }

        switch (user.accountStatus) {
          case Status.ACTIVE:
            Navigator.of(scaffoldKey.currentContext!).pushNamedAndRemoveUntil(
                '/TabBarPage', (Route<dynamic> route) => false,
                arguments: user.userType);
            break;
          case Status.PENDING:
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!
                    .trans("Account under review"),
                isError: true);
            auth.signOut();
            break;
          case Status.Rejected:
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!
                    .trans("Your account has been denied"),
                isError: true);
            auth.signOut();
            break;
          case Status.Deleted:
            scaffoldKey.showTosta(
                message: AppLocalization.of(scaffoldKey.currentContext!)!
                    .trans("Your account has been deleted"),
                isError: true);
            auth.signOut();
            break;
        }
      });
    }
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

  forgotPassword(
      {required GlobalKey<ScaffoldState> scaffoldKey,
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

  deleteAccount(context, {required String iduser}) async {
    showLoaderDialog(context);

    await userRef.doc(iduser).delete().then((_) => {}).catchError((e) {});

    showLoaderDialog(context, isShowLoader: false);
  }

// TODO:- END auth
// TODO:- Start Notifications

  addNotifications({
    required String uidUser,
    required String titleEN,
    required String titleAR,
    required String detailsEN,
    required String detailsAR,
  }) async {
    String uid = notificationRef.doc().id;
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

  section(
    context, {
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
    }).then((value) {
      showLoaderDialog(context, isShowLoader: false);
      Navigator.of(context).pop();
    }).catchError((err) {
      showLoaderDialog(context, isShowLoader: false);
    });
  }

  deleteSection(context, {required String uidSection}) async {
    showLoaderDialog(context);

    await sectionRef
        .doc(uidSection)
        .delete()
        .then((_) => {})
        .catchError((e) {});

    showLoaderDialog(context, isShowLoader: false);
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

  Stream<List<SectionModel>> getMySection() {
    return sectionRef
        .where("uid-owner", isEqualTo: auth.currentUser!.uid)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return SectionModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<SectionModel>> getAllSection() {
    return sectionRef.snapshots().map((QueryDocumentSnapshot) {
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

    await channelRef
        .doc(uidchannel)
        .delete()
        .then((_) => {})
        .catchError((e) {});

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

  Stream<List<ChannelModel>> getAllchannel() {
    return channelRef.snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return ChannelModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<ChannelModel>> getMychannelTech() {
    return channelRef
        .where("owner-id", isEqualTo: auth.currentUser!.uid)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return ChannelModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<ChannelModel>> getMychannel() {
    return channelRef
        .where("user-id", isEqualTo: auth.currentUser!.uid)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return ChannelModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<ChannelModel> getchannelById({required String id}) {
    return channelRef.doc(id).snapshots().map((QueryDocumentSnapshot) {
      return ChannelModel.fromJson(QueryDocumentSnapshot.data());
    });
  }

  // TODO:- ENd channel
  // TODO:- Start Subscription/

  Subscription(
    context, {
    String uid = "",
    required GlobalKey<ScaffoldState> scaffoldKey,
    required String SubscriptionEN,
    required String SubscriptionAR,
  }) async {
    showLoaderDialog(context);
    String tempUid =
        (uid == null || uid == "") ? SubscriptionRef.doc().id : uid;
    SubscriptionRef.doc(tempUid).set({
      "Subscription-en": SubscriptionEN,
      "Subscription-ar": SubscriptionAR,
      "uid-owner": auth.currentUser!.uid,
      "uid": tempUid,
    }).then((value) {
      showLoaderDialog(context, isShowLoader: false);
      Navigator.of(context).pop();
    }).catchError((err) {
      showLoaderDialog(context, isShowLoader: false);
    });
  }

  deleteSubscription(context, {required String uidSubscription}) async {
    showLoaderDialog(context);

    await SubscriptionRef.doc(uidSubscription)
        .delete()
        .then((_) => {})
        .catchError((e) {});

    showLoaderDialog(context, isShowLoader: false);
  }

  Stream<List<SubscriptionsModel>> getSubscription({required Section section}) {
    return SubscriptionRef.where("Subscription", isEqualTo: section.index)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return SubscriptionsModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<SubscriptionsModel>> getMySubscription() {
    return SubscriptionRef.where("uid-owner", isEqualTo: auth.currentUser!.uid)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return SubscriptionsModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<SubscriptionsModel>> getAllSubscription() {
    return SubscriptionRef.snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return SubscriptionsModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<SubscriptionsModel> getSubscriptionById({required String id}) {
    return SubscriptionRef.doc(id).snapshots().map((QueryDocumentSnapshot) {
      return SubscriptionsModel.fromJson(QueryDocumentSnapshot.data());
    });
  }

  // TODO:- ENd Subscription

  // TODO:- Start SubscriptionOrder
  SubscriptionOrder(
    context, {
    String uid = "",
    required String ownerId,
    required String SubscriptionId,
  }) async {
    showLoaderDialog(context);

    String tempUid =
        (uid == null || uid == "") ? SubscriptionOrderRef.doc().id : uid;

    addNotifications(
        uidUser: ownerId,
        titleEN: "Subscriptio Request",
        titleAR: "طلب اشتراك",
        detailsEN: "A new Subscriptio has been requested",
        detailsAR: "تم طلب اشتراك جديد");

    SubscriptionOrderRef.doc(tempUid).set({
      "user-id": auth.currentUser!.uid,
      "Subscription-id": ownerId,
      "Subscription-id": SubscriptionId,
      "createdDate": DateTime.now().toString(),
      "status": Status.PENDING.index,
      "message-en": "",
      "message-ar": "",
      "uid": tempUid,
    }).then((value) {
      showLoaderDialog(context, isShowLoader: false);
      Navigator.of(context).pop();
    }).catchError((err) {
      showLoaderDialog(context, isShowLoader: false);
    });
  }

  changeOrderStatus(
    context, {
    required String uid,
    required Status status,
    String messageEN = "",
    String messageAR = "",
  }) async {
    showLoaderDialog(context);

    SubscriptionOrderRef.doc(uid).update({
      "status": status.index,
      "message-en": messageEN,
      "message-ar": messageAR,
    }).then((value) {
      showLoaderDialog(context, isShowLoader: false);
    }).catchError((err) {
      showLoaderDialog(context, isShowLoader: false);
    });
  }

  Stream<List<SubscriptionOrderModel>> getOrdersByStatus(
      {required Status status}) {
    return SubscriptionOrderRef.where("status", isEqualTo: status.index)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return SubscriptionOrderModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<SubscriptionOrderModel>> getAllSubscriptionOrder() {
    return SubscriptionOrderRef.snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return SubscriptionOrderModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<SubscriptionOrderModel>> getMySubscriptionOrderTech() {
    return SubscriptionOrderRef.where("owner-id",
            isEqualTo: auth.currentUser!.uid)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return SubscriptionOrderModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<List<SubscriptionOrderModel>> getMySubscriptionOrder() {
    return SubscriptionOrderRef.where("user-id",
            isEqualTo: auth.currentUser!.uid)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return SubscriptionOrderModel.fromJson(doc.data());
      }).toList();
    });
  }

  Stream<SubscriptionOrderModel> getOrderById({required String id}) {
    return SubscriptionOrderRef.doc(id)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return SubscriptionOrderModel.fromJson(QueryDocumentSnapshot.data());
    });
  }

  // TODO:- Start Chat

  sendMessage(
    context, {
    required String uidOrder,
    required String uidService,
    required String uidReceiver,
    required String uidUser,
    String message = "",
    String image = "",
  }) async {
    String uid = chatRef.doc().id;
    String imageUrl = "";

    if (image != "") {
      showLoaderDialog(context);
      imageUrl = await _uploadImage(folderName: "chat", imagePath: image);
      showLoaderDialog(context, isShowLoader: false);
    }

    chatRef.doc(uid).set({
      "uid-order": uidOrder,
      "uid-user": uidUser,
      "uid-sender": auth.currentUser!.uid,
      "uid-receiver": uidReceiver,
      "uid-service": uidService,
      "message": message,
      "image": imageUrl,
      "createdDate": DateTime.now().toString(),
      "uid": uid,
    }).catchError((_) {});
  }

  Stream<List<ChatModel>> getChatByUidOrder({required String uidOrder}) {
    return chatRef
        .where("uid-order", isEqualTo: uidOrder)
        .snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return ChatModel.fromJson(doc.data());
      }).toList();
    });
  }

  // TODO:- End Chat

  Future<String> _uploadImage(
      {required String folderName, required String imagePath}) async {
    UploadTask uploadTask = storageRef
        .child('$folderName/${const Uuid().v4()}')
        .putFile(File(imagePath));
    String url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }
  // payment

// _payment() async {
//   var request = BraintreeDropInRequest(
//     tokenizationKey: "",
//     collectDeviceData: true,
//     paypalRequest: BraintreePayPalRequest(
//       amount: "10.00",
//       displayName: "name",
//     ),
//     cardEnabled: true,
//   );
//
//   BraintreeDropInResult result = await BraintreeDropIn.start(request);
//
//   if (result != null) {
//     print("===================");
//     print(result.paymentMethodNonce.description);
//     print(result.paymentMethodNonce.nonce);
//     print("===================");
//   }
//
// }
}
