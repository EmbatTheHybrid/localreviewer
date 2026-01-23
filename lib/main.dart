import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:local_reviewer/firebase_options.dart';
import 'package:local_reviewer/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // makes sure plugins are initialized
  AwesomeNotifications().initialize(null, [    
    NotificationChannel(     
    ledColor: Colors.pink,       
    enableVibration: true,        
    channelKey: "restaurant_change",        
    channelName: "Restaurant Change",        
    channelDescription: 'Notifications for when restaurant is changed')  ]);

  try {
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  } catch(e) {
    print("Failed to initialize Firebase: $e");
  }

  final prefs =
      await SharedPreferences.getInstance(); // however you create your service
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Reviewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: Home(title: 'Local Reviews', prefs: prefs),
    );
  }
}

