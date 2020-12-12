import 'package:firebase_cloud_messaging/firebase_cloud_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skischool/data/auth.dart';
import 'package:skischool/screens/lesson_detail_page.dart';
import 'package:skischool/screens/lessons_page.dart';
import 'screens/login_page.dart';

// Toggle this for testing Crashlytics in your app locally.
final _kTestingCrashlytics = true;

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Auth _auth = Auth();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();



  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize
    await Firebase.initializeApp();

    await _initializeCrashlytics();
    await _initializeMessaging();
  }

  @override
  void initState() {
    try {
      _auth.loadSettings();
    } catch (e) {
      print("Error Loading Settings: $e");
    }

    _initializeFlutterFire();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'SkiSchool',
//      theme: ,
//      home: new LoginPage(),
//    );
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>.value(value: _auth),
        ],
        child: RefreshConfiguration(
          enableScrollWhenRefreshCompleted: true,
          headerBuilder: () => MaterialClassicHeader(),
          child: MaterialApp(
            debugShowCheckedModeBanner: true,
            theme: new ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Consumer<Auth>(builder: (context, model, child) {
              if (model?.token != null) return LessonsPage();
              return LoginPage();
            }),
            routes: <String, WidgetBuilder>{
              "/login": (BuildContext context) => LoginPage(),
              "/lessons": (BuildContext context) => LessonsPage(),
              "/lesson": (BuildContext context) => LessonDetailPage(),
            },
          ),
        )
    );
  }

  Future<void> _initializeMessaging() async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      _auth.setFirebaseToken(token);
      _auth.postFirebaseToken(token);
      print("Push Messaging token: $token");
    });
  }


  Future<void> _initializeCrashlytics() async {
    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    // Pass all uncaught errors to Crashlytics.
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError(errorDetails);
    };
  }
}
