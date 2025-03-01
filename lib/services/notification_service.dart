import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void requestPermission() async {
    await _firebaseMessaging.requestPermission();
  }

  void sendNotification(String title, String body) {
    // Use Firebase Cloud Messaging API to send notifications to users
  }
}
