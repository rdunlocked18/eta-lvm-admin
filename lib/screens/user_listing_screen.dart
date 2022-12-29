import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_mt_details.dart';
import 'admin_dashboard/admin_all_users_model/admin_all_users_model.dart';
import '../../../constants.dart';

class UserListingScreen extends StatefulWidget {
  const UserListingScreen({super.key});

  @override
  State<UserListingScreen> createState() => _UserListingScreenState();
}

class _UserListingScreenState extends State<UserListingScreen> {
  var message;
  List<SingleUserData> list = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    apiData();
  }

  apiData() async {
    isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "NULL";
    var headers = {'Authorization': token};
    var request =
        http.Request('GET', Uri.parse('$BASE_URL/api/admin/getallusers'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var res = await response.stream.bytesToString();
      var body = jsonDecode(res);
      message = body['data'];
      for (int i = 0; i < message.length; i++) {
        SingleUserData getList = SingleUserData.fromJson(message[i]);
        print(message[i]);
        list.add(getList);
      }

      setState(() {
        isLoading = false;
      });
    } else {
      print(response.reasonPhrase);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All users"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      SingleUserData singleUser = list[index];
                      var f = DateFormat('dd - MMM - yyyy');
                      var date = f.format(
                        DateTime.parse(singleUser.createdAt!),
                      );
                      print(date);

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 2,
                                blurRadius: 1,
                              )
                            ],
                            border: Border.all(
                              style: BorderStyle.solid,
                              color: Color(0xFF0C331F),
                              width: 0.7,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    5.0) //                 <--- border radius here
                                ),
                          ),
                          child: ListTile(
                            leading: singleUser.metatrader?.id == null
                                ? Icon(
                                    Icons.close,
                                  )
                                : Icon(
                                    Icons.verified,
                                  ),
                            title: Text("${singleUser.username}"),
                            subtitle: Text("Created At : ${date}"),
                            horizontalTitleGap: 2,
                            enableFeedback: true,
                            trailing: Icon(Icons.chevron_right),
                            contentPadding: EdgeInsets.all(10),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return AddUserMtDetails(
                                      user: list[index],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    })
          ],
        ),
      ),
    );
  }
}
