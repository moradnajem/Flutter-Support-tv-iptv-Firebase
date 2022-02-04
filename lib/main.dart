import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tv/page/User.dart';
import 'package:tv/page/add%20channel.dart';
import 'package:tv/page/add section.dart';
import 'package:tv/page/edit-password.dart';
import 'package:tv/page/edit-profile.dart';
import 'package:tv/page/forgot_password.dart';
import 'package:tv/page/notifications.dart';
import 'package:tv/page/signin.dart';
import 'package:tv/page/signup.dart';
import 'package:tv/page/splash.dart';
import 'package:tv/page/tabbar.dart';

import 'Subscriptions/Subscriptions.dart';
import 'Subscriptions/addSubscriptions.dart';
import 'Subscriptions/Subscriptionsorders.dart';
import 'manger/init.dart'
if (dart.library.html) 'manger/web_init.dart'
if (dart.library.io) 'manger/io_init.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const MyApp());
}


class AppLocalization {
  AppLocalization(this.locale);

  Locale? locale;

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  late Map<String, String> _sentences;

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString("assets/languages/languages-${locale!.languageCode}.json");
    Map<String, dynamic> _result = json.decode(jsonString);

    _sentences = {};
    _result.forEach((String key, dynamic value) {
      _sentences[key] = value.toString();
    });

    return true;
  }

  trans(String key) {
    return _sentences[key];
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localizations = AppLocalization(locale);
    await localizations.load();


    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);


  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(locale);
    if (kDebugMode) {
      print("Load ${locale.languageCode}");
    }
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  @override


    Widget build(BuildContext context) {
    return Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        },
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
      locale:_locale,

      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US')
      ],
      localizationsDelegates: const [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode || supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      },
      title: 'MS',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
        primaryColor:  Colors.blue,
        backgroundColor: Colors.white,
        platform: TargetPlatform.android,
        fontFamily: 'NeoSansArabic', colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black,),
        ),
      initialRoute: "/Splash",
      onGenerateRoute: (settings) {
        final arguments = settings.arguments;
        switch (settings.name) {
            case '/Splash':
            return MaterialPageRoute(builder: (_) =>   Splash());
            case '/SignIn':
            return MaterialPageRoute(builder: (_) =>  SignIn(message: arguments,));
            case '/SignUp':
            return MaterialPageRoute(builder: (_) =>  Signup());
            case '/ForgotPassword':
            return MaterialPageRoute(builder: (_) => ForgotPassword());
            case '/TabBarPage':
            return MaterialPageRoute(builder: (_) => TabBarPage(userType: arguments,));
            case '/addsection':
            return MaterialPageRoute(builder: (_) =>   addsection());
            case '/addchannel':
            return MaterialPageRoute(builder: (_) =>   addchannel());
            case '/add':
            return MaterialPageRoute(builder: (_) =>   add());
            case '/Notification':
            return MaterialPageRoute(builder: (_) =>  const Notifications());
            case '/Subscriptions':
            return MaterialPageRoute(builder: (_) =>   Subscriptions());
            case '/Orders':
            return MaterialPageRoute(builder: (_) =>   Orders());
            case '/Users':
            return MaterialPageRoute(builder: (_) =>   const Users());
            case '/EditPassword':
            return MaterialPageRoute(builder: (_) =>   EditPassword());
            case '/EditProfile':
            return MaterialPageRoute(builder: (_) =>   EditProfile());
          default:
            return MaterialPageRoute(
                builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                )
            );
        }
      },
    ));
  }
}