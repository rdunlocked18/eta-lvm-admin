import 'package:flutter/material.dart';
import 'package:locked_wallet/screens/admin_dashboard/tabs/dashbard_widraw_contract.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../adminAuth/login.dart';

class AdminDashBoard extends StatefulWidget {
  const AdminDashBoard({Key? key}) : super(key: key);

  @override
  State<AdminDashBoard> createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text("Admin Dashboard"),
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  Logout(context);
                },
                child: Icon(Icons.logout)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Admin DashBoard",
              //   style: TextStyle(
              //       fontSize: 60,
              //       color: Color(0xFF0C331F),
              //       fontWeight: FontWeight.bold),
              // ),
              SizedBox(
                height: 20,
              ),
              DashBoardWithDrawContract()
            ],
          ),
        ),
      ),
    );
  }

  void Logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Continue"),
              onPressed: () async {
                SharedPreferences mainPref =
                    await SharedPreferences.getInstance();
                mainPref.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLogin()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
