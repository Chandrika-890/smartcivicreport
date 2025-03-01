import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screen/auth/login_screen.dart';
import 'screen/auth/signup_screen.dart';
import 'screen/complaint_form_screen.dart';
import 'screen/my_complaints_screen.dart';
import 'screen/profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Complaint Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/complaint_form': (context) => ComplaintFormScreen(),
        '/my_complaints': (context) => MyComplaintsScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
