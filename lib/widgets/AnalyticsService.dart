import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService{
  final _instance = FirebaseAnalytics.instance;

  Future <void> logCreateRestaurant() async {
    await _instance.logEvent(name: "Create Restaurant");
  }
}