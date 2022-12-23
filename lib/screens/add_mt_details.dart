import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locked_wallet/screens/admin_dashboard/admin_all_users_model/admin_all_users_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common_widget/common_textfield.dart';
import '../common_widget/state_info.dart';
import 'package:http/http.dart' as http;

class AddUserMtDetails extends StatefulWidget {
  final SingleUserData user;
  const AddUserMtDetails({
    super.key,
    required this.user,
  });

  @override
  State<AddUserMtDetails> createState() => _AddUserMtDetailsState();
}

class _AddUserMtDetailsState extends State<AddUserMtDetails> {
  TextEditingController loginIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController serverNameController = TextEditingController();

  bool showPass = false;
  final formKey = GlobalKey<FormState>();
  bool isLoad = false;

  saveMtDetails(SingleUserData user) async {
    isLoad = true;
    setState(() {});

    final prefs = await SharedPreferences.getInstance();
    print('${prefs.getString('token')}');

    var headers = {
      // 'Content-Type': 'application/json',
      'Authorization':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFkaXRpMTIzNEB0ZXN0LmNvbSIsImlhdCI6MTY3MDM0MTY4OH0.BjE1w14UkKa8fjkq7cf5rxd1P9lQUqEXi4qnmSuDj1w'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://api.lockedvaultenterprises.com/api/admin/user/mtdetail/create'));
    request.body = json.encode({
      "userId": "${user.id}",
      "serverId": loginIdController.text,
      "serverPassword": passwordController.text,
      "serverName": serverNameController.text,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //  print(await response.stream.bytesToString());
      var res = await response.stream.bytesToString();
      var body = jsonDecode(res);
      var message = body['msg'];
      StaticInfo.token = body['token'];

      isLoad = false;
      setState(() {});
      print("my msg == $message");

      Fluttertoast.showToast(
          msg: 'Mt5 Details Saved',
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) {
      //       return UserDashboard();
      //     },
      //   ),
      // );
    } else {
      Fluttertoast.showToast(
          msg: 'Failed',
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black);
      isLoad = false;
      setState(() {});
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add MT5 Account Details"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                CommonTextFieldWithTitle(
                    'Login ID', 'Enter numeric Mt5 ID', loginIdController,
                    (val) {
                  if (val!.isEmpty) {
                    return 'This is required field';
                  }
                  return null;
                }),
                const SizedBox(
                  height: 14,
                ),
                CommonTextFieldWithTitle(
                    'Password', 'Enter Password', passwordController,
                    suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                        child: const Icon(Icons.remove_red_eye)),
                    obscure: showPass, (val) {
                  if (val!.isEmpty) {
                    return 'This is required field';
                  }
                  return null;
                }),
                const SizedBox(
                  height: 14,
                ),
                CommonTextFieldWithTitle(
                  'Server Name',
                  'Ex: MetaQuotes-Demo-123',
                  serverNameController,
                  (val) {
                    if (val!.isEmpty) {
                      return 'This is required field';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 34,
                ),

                //Sign Up
                isLoad
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0C331F)),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              saveMtDetails(widget.user);
                            }
                          },
                          child: Text("Save User"),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
