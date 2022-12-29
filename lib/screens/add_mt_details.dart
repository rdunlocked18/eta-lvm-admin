import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locked_wallet/screens/admin_dashboard/admin_all_users_model/admin_all_users_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common_widget/common_textfield.dart';
import '../common_widget/state_info.dart';
import '../../../constants.dart';
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
  @override
  void initState() {
    super.initState();
    if (widget.user.metatrader?.id != null) {
      loginIdController.text = '${widget.user.metatrader?.serverId}';
      passwordController.text = '${widget.user.metatrader?.serverPassword}';
      serverNameController.text = '${widget.user.metatrader?.serverName}';
      accountIdController.text = '${widget.user.accountId}';
    }
  }

  TextEditingController loginIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController serverNameController = TextEditingController();
  TextEditingController accountIdController = TextEditingController();

  bool showPass = false;
  final formKey = GlobalKey<FormState>();
  bool isLoad = false;
  bool isLoad2 = false;

  saveMtDetails(SingleUserData user) async {
    isLoad = true;
    setState(() {});

    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token') ??
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFkaXRpMTIzNEB0ZXN0LmNvbSIsImlhdCI6MTY3MDM0MTY4OH0.BjE1w14UkKa8fjkq7cf5rxd1P9lQUqEXi4qnmSuDj1w";
    if (token.isEmpty) {
      print(token);
    } else {
      print("no token");
    }

    var headers = {
      // 'Content-Type': 'application/json',
      'Authorization': token
    };
    var request = http.Request(
        'POST', Uri.parse('$BASE_URL/api/admin/user/mtdetail/create'));
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

  saveAccountId(SingleUserData user) async {
    isLoad2 = true;
    setState(() {});

    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token') ??
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFkaXRpMTIzNEB0ZXN0LmNvbSIsImlhdCI6MTY3MDM0MTY4OH0.BjE1w14UkKa8fjkq7cf5rxd1P9lQUqEXi4qnmSuDj1w";
    if (token.isEmpty) {
      print(token);
    } else {
      print("no token");
    }

    var headers = {
      // 'Content-Type': 'application/json',
      'Authorization': token
    };
    var request =
        http.Request('POST', Uri.parse('$BASE_URL/api/admin/meta/linkaccid'));
    request.body = json.encode({
      "userId": "${user.id}",
      "accountId": accountIdController.text,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //  print(await response.stream.bytesToString());
      var res = await response.stream.bytesToString();
      var body = jsonDecode(res);
      var message = body['msg'];
      StaticInfo.token = body['token'];

      isLoad2 = false;
      setState(() {});
      print("my msg == $message");

      Fluttertoast.showToast(
          msg: 'Added Account Id to Dashboard',
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
      isLoad2 = false;
      setState(() {});
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MT5 Account Details"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: formKey,
                child: widget.user.metatrader?.id != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          CommonTextFieldWithTitle('Login ID',
                              'Enter numeric Mt5 ID', loginIdController, (val) {
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
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          CommonTextFieldWithTitle('Login ID',
                              'Enter numeric Mt5 ID', loginIdController, (val) {
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
              const SizedBox(
                height: 44,
              ),
              CommonTextFieldWithTitle(
                'Account ID',
                'Ex: xxxx-xxxx-xxxx',
                accountIdController,
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
              isLoad2
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0C331F)),
                        onPressed: () {
                          if (accountIdController.text.isNotEmpty) {
                            saveAccountId(widget.user);
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Enter Account Id First',
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.black);
                          }
                        },
                        child: Text("Save Account ID"),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
