import 'package:flutter/material.dart';
import 'package:locked_wallet/screens/adminAuth/login.dart';
import 'package:locked_wallet/screens/admin_dashboard/admin_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences mainPref = await SharedPreferences.getInstance();
  var token = mainPref.getString("token");
  print("TOKEN:$token");
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: token == null ? AdminLogin() : AdminDashBoard(),
    ),
  );
}
