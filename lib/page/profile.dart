import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tv/manger/M.S.dart';
import 'package:tv/manger/language.dart';
import 'package:tv/manger/user-type.dart';
import 'package:tv/models/assets.dart';
import 'package:tv/models/profile.dart';
import 'package:tv/models/user-model.dart';
import 'package:tv/models/user_profile.dart';

import '../main.dart';
import '../models/lang.dart';
import 'notification.dart';


class Profile extends StatefulWidget {
  final String screenTitle;

  @override
  _ProfileState createState() => _ProfileState();
  Profile( this.screenTitle);
}

class _ProfileState extends State<Profile> {
  List<ProfileList> items = [ ProfileList.CHANGE_LANGUAGE, ProfileList.EDIT_PROFILE, ProfileList.EDIT_PASSWORD, ProfileList.USERS, ProfileList.LOGOUT];

  Future<UserModel?> user = UserProfile.shared.getUser();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user.then((value) {
      if (value!.userType != UserType.ADMIN) {
        items.remove(ProfileList.USERS);
      }
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
        title: Text(
          AppLocalization.of(context)!.trans(widget.screenTitle),
          style: TextStyle(color: Theme
              .of(context)
              .primaryColor),),
        centerTitle: true,
        actions: const [
          NotificationsWidget(),
        ],
      ),
      body: FutureBuilder<UserModel?>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            UserModel? user = snapshot.data;

            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                     child: Icon(
                          Icons.person,
                          size: 52,
                          color: Theme.of(context).accentColor,
                        ),
                        radius: 50,
                        backgroundColor: Color(0xFFF0F4F8),
                      ),
                      SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user!.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor,),),
                          SizedBox(height: 5),
                          Text( user.userType == UserType.ADMIN ? AppLocalization.of(context)!.trans("admin") : AppLocalization.of(context)!.trans("user"), style: TextStyle(fontSize: 16),),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * (40 / 812)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return _item(context, item: items[index], isLast: index == (items.length - 1));
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox();
          }
        }
      ),
    );
  }

  Widget _item(context, { required ProfileList item, bool isLast = false }) {

    String? title;
    String? screen;

    switch (item) {
      case ProfileList.CHANGE_LANGUAGE:
        title = "Change Language";
        break;
      case ProfileList.EDIT_PROFILE:
        title = "Edit Profile";
        screen = "/EditProfile";
        break;
      case ProfileList.EDIT_PASSWORD:
        title = "Edit Password";
        screen = "/EditPassword";
        break;
        case ProfileList.USERS:
        title = "Users";
        screen = "/Users";
        break;
      case ProfileList.LOGOUT:
        title = "Logout";
        break;
    }


    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () async {
          if (item == ProfileList.CHANGE_LANGUAGE) {
            changeLanguage(context);
          } else if (item == ProfileList.LOGOUT) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title:  Text(AppLocalization.of(context)!.trans("Logout")),
                content:  Text(AppLocalization.of(context)!.trans("Are you sure to logout?")),
                actions: <Widget>[
                  TextButton(
                    onPressed: () =>               FirebaseManager.shared.signOut(context),

                    child: Text(AppLocalization.of(context)!.trans("Logout")),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child:Text(AppLocalization.of(context)!.trans("Close")),
                  ),
                ],
              ),
            );
          } else {
            await Navigator.of(context).pushNamed(screen!);
            setState(() {
              user = UserProfile.shared.getUser();
            });
          }
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalization.of(context)!.trans(title), style: TextStyle(color: isLast ? Colors.red : Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.w500),),
                Icon(Icons.arrow_forward_ios_rounded, color: Theme.of(context).primaryColor, size: 16,),
              ],
            ),
            SizedBox(height: 10,),
            Container(width: double.infinity, height: 1, color: Theme.of(context).primaryColor,),
          ],
        ),
      ),
    );
  }

  changeLanguage(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Container(
                      width: 35,
                      height: 35,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(Assets.shared.icEnglish),
                    ),
                    title: Text('English'),
                    onTap: () => _changeLanguage(context, lang: Language.ENGLISH),
                ),
                ListTile(
                  leading: Container(
                    width: 35,
                    height: 35,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(Assets.shared.icArabic),
                  ),
                  title: Text('عربي'),
                  onTap: () => _changeLanguage(context, lang: Language.ARABIC),
                ),
              ],
            ),
          );
        }
    );
  }

  _changeLanguage(context, { required Language lang }) async {
    MyApp.setLocale(context, Locale(lang == Language.ARABIC ? "ar" : "en"));
    await UserProfile.shared.setLanguage(language: lang);
    Navigator.of(context).pop();
  }

}
