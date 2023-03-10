// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locked_wallet/screens/admin_dashboard/admin_all_users_model/admin_all_users_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../common_widget/reusable_tableRow.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';

import '../../user_dashboard/user_dashboard.dart';
import '../../user_listing_screen.dart';

class DashBoardWithDrawContract extends StatefulWidget {
  const DashBoardWithDrawContract({Key? key}) : super(key: key);

  @override
  State<DashBoardWithDrawContract> createState() =>
      _DashBoardWithDrawContractState();
}

class _DashBoardWithDrawContractState extends State<DashBoardWithDrawContract> {
  List<String> items = ["All User", "Ramazan", "Latif Ullah", "Asad"];
  String _initialValue = "All User";
  bool allUsers = true;
  //String token = getToken();

  var message = [];
  var sync = [];
  int? netProfit = 0;
  List<SingleUserData> list = [];
  UserModel? select;
  void initState() {
    super.initState();
    GetAllUsers();
    getData();
  }

  Future<void> GetAllUsers() async {
    netProfit = 0;
    SharedPreferences mainPref = await SharedPreferences.getInstance();
    var token = mainPref.getString("token");
    isLoading = true;
    setState(() {});
    print(token);
    var headers = {
      'Authorization': token ?? '',
    };
    var request =
        http.Request('GET', Uri.parse('$BASE_URL/api/admin/getallusers'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      var body = jsonDecode(res);
      message = body['data'];
      print("MESSAGE IS $message");
      for (int i = 0; i < message.length; i++) {
        SingleUserData getList = SingleUserData.fromJson(message[i]);
        list.add(getList);
        netProfit = netProfit ?? 0 + getList.totalProfit!;
        setState(() {});
      }
      print(netProfit);
      getChartData();
    } else {
      print(response.reasonPhrase);
    }
  }

  String getvalidDate(String dd) {
    var f = DateFormat('dd - MMM - yyyy');
    var date = f.format(
      DateTime.parse(dd),
    );
    print(date);

    return date;
  }

  syncDash() async {
    SharedPreferences mainPref = await SharedPreferences.getInstance();
    var token = mainPref.getString("token");
    var headers = {
      'Authorization': token ?? '',
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.lockedvaultenterprises.com/api/user/getdashboard'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      var body = jsonDecode(res);
      sync = body['data'];
      setState(() {});
      print('Sync is =$sync');
    } else {
      print(response.reasonPhrase);
    }
  }

  var data = [];
  bool isLoading = false;
  getData() async {
    SharedPreferences mainPref = await SharedPreferences.getInstance();
    var token = mainPref.getString("token");
    isLoading = true;
    setState(() {});
    print(token);
    var headers = {
      'Authorization': token ?? '',
    };
    var request =
        http.Request('GET', Uri.parse('$BASE_URL/api/admin/getallusers'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      var body = jsonDecode(res);
      data = body['data'];
      isLoading = false;
      setState(() {});
      print(data);
    } else {
      isLoading = false;
      print(response.reasonPhrase);
    }
  }

  void mainBB() async {
    SharedPreferences mainPref = await SharedPreferences.getInstance();
    var token = mainPref.getString("token");
    isLoading = true;
    setState(() {});
    print(token);
    var headers = {
      'Authorization': token ?? '',
    };
    var request =
        http.Request('GET', Uri.parse('$BASE_URL/api/admin/getallusers'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      var body = jsonDecode(res);
      data = body['data'];
      List<Map<String, dynamic>> users =
          body['data'] as List<Map<String, dynamic>>;
      for (int i = 0; i <= users.length; i++) {
        print('${users[i]['dashboard']['balance']}');
      }
      //List<String> sd = [];
      isLoading = false;
      setState(() {});
      print(data);
    } else {
      isLoading = false;
      print(response.reasonPhrase);
    }
  }

  List<ProfitLoss> psList = [];
  void getChartData() async {
    psList = [];
    print(list);

    list.forEach((element) {
      psList.add(ProfitLoss(
          '${element.username}', element.totalProfit?.toDouble() ?? 0));
    });

    print("LIST $psList");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //mainBB();
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Image.asset(
                  "assets/hersheybar381.png",
                  fit: BoxFit.contain,
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () async {
                  await showDialog(
                      context: context,
                      builder: (_) {
                        return StatefulBuilder(
                          builder: (BuildContext context,
                              void Function(void Function()) setState) {
                            return Dialog(
                              backgroundColor: Colors.grey.shade200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        itemCount: list.length,
                                        itemBuilder: (context, index) {
                                          print(
                                              list[index].username.toString());
                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(list[index]
                                                        .username
                                                        .toString()),
                                                  ),
                                                  Checkbox(
                                                    focusColor:
                                                        const Color(0xFFFFC000),
                                                    checkColor: Colors.black,
                                                    activeColor:
                                                        const Color(0xFFFFC000),
                                                    value:
                                                        list[index].isSelected,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        list[index].isSelected =
                                                            !list[index]
                                                                .isSelected;
                                                        if (value == true)
                                                          allUsers = false;

                                                        setState(() {});
                                                      });
                                                    },
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        }),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        width: 120,
                                        height: 60,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Color(0xFF0C331F),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          "Submit",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      });
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xFF0C331F),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Text(
                        _initialValue,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return UserListingScreen();
                      },
                    ),
                  );
                },
                child: Icon(
                  Icons.person,
                ),
              ),
              Spacer(),
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return UserDashboard();
                        },
                      ),
                    );
                  },
                  child: Icon(Icons.menu)),
              SizedBox(
                width: 10,
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          //graph
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .5,
            child: SfCartesianChart(
                palette: [Color(0xFF0C331F)],
                primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Investors')),
                primaryYAxis:
                    NumericAxis(title: AxisTitle(text: 'Profit / Loss')),
                series: <ChartSeries>[
                  ColumnSeries<ProfitLoss, String>(
                      dataSource: psList,
                      xValueMapper: (ProfitLoss sales, _) => sales.day,
                      yValueMapper: (ProfitLoss sales, _) => sales.profit,
                      dataLabelSettings: DataLabelSettings(isVisible: true))
                ]),
          ),
          SizedBox(
            height: 30,
          ),
          //Buttons

          Column(
            children: [
              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         width: double.infinity,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             border: Border.all(color: Colors.black)),
              //         padding: EdgeInsets.symmetric(vertical: 20),
              //         child: Column(
              //           children: [
              //             Text(
              //               "Balance",
              //               style: TextStyle(
              //                   fontSize: 17,
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.black),
              //             ),
              //             SizedBox(
              //               height: 10,
              //             ),
              //             Text(
              //               "1",
              //               style: TextStyle(
              //                   fontSize: 17,
              //                   fontWeight: FontWeight.w500,
              //                   color: Colors.black),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       width: 20,
              //     ),
              //     Expanded(
              //       child: Container(
              //         width: double.infinity,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             border: Border.all(color: Colors.black)),
              //         padding: EdgeInsets.symmetric(vertical: 20),
              //         child: Column(
              //           children: [
              //             Text(
              //               "Equity",
              //               style: TextStyle(
              //                   fontSize: 17,
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.black),
              //             ),
              //             SizedBox(
              //               height: 10,
              //             ),
              //             Text(
              //               "1",
              //               style: TextStyle(
              //                   fontSize: 17,
              //                   fontWeight: FontWeight.w500,
              //                   color: Colors.black),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 10,
              ),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black)),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Text(
                            "Net Profit",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${netProfit}",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black)),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Text(
                            "Investors",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${list.length}",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )

          // FutureBuilder(
          //     future: syncDash(),
          //     builder: (context, AsyncSnapshot snapshot) {
          //       if (snapshot.data != null || sync != null) {
          //         return ListView.builder(
          //             shrinkWrap: true,
          //             physics: ScrollPhysics(),
          //             itemCount: sync.length,
          //             itemBuilder: (context, index) {
          //               // sync[index]['positions'][index]['openPrice'];
          //               return GestureDetector(
          //                 onTap: () {
          //                   getData();
          //                 },
          //                 child: ,
          //               );
          //             });
          //       } else {
          //         return Center(child: CircularProgressIndicator());
          //       }
          //     }),
          ,
          SizedBox(
            height: 20,
          ),

          CustomTable(
              firstList: ['Account Name', 'P/Ps', 'Time'],
              heading: [],
              isHeader: true),

          ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (contex, index) {
                // var date=DateTime(int.parse(list[index].createDate.toString()));
                // print(date);

                // var f = DateFormat('E, d MMM yyyy HH:mm:ss');
                // var date = f.format(DateFormat(TimeOfDay.fromDateTime()).toUtc()) + " GMT";
                //  print(date);
                if (allUsers == true || list[index].isSelected) {
                  return GestureDetector(
                    onTap: () {
                      print(list[index].createdAt.toString());
                    },
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            children: [
                              CustomTable(
                                heading: ['Account Name', 'P/Ps', 'Time'],
                                firstList: [
                                  list[index].username ?? "NO USERNAME",
                                  list[index].totalProfit.toString(),

                                  // data[index]['totalProfit'].toString(),
                                  getvalidDate(list[index].createdAt.toString())
                                ],
                                // secondList: ['Jpy/USD', '40', '74'],
                                // thirdList: ['BTC/USD', '71', '17'],
                                // fourthList: ['XUA/USD', '67', '11']
                              ),
                            ],
                          ),
                  );
                }
                return Container();
                //   Column(children: [
                //   Row(
                //     children: [
                //      Column(children: [
                //        Text(list[index].username ?? "null"),
                //        SizedBox(height: 2,),
                //        Divider(color: Colors.grey,)
                //      ],)
                //     ],
                //   ),
                // ],);
              }),

          // CustomTable(
          //     heading: ['Trades', 'P/Ps', 'Time'],
          //     firstList: [list[1].username ?? "null", '20', '55'],
          //     secondList: ['Jpy/USD', '40', '74'],
          //     thirdList: ['BTC/USD', '71', '17'],
          //     fourthList: ['XUA/USD', '67', '11'])
        ],
      ),
    );
  }

  Table CustomTable({
    required List<String> heading,
    required List<String> firstList,
    bool isHeader = false,
    // required List<String> secondList,
    // required List<String> thirdList,
    // required List<String> fourthList,
  }) {
    return Table(
      border: TableBorder.all(),
      columnWidths: {
        0: FractionColumnWidth(0.5),
        1: FractionColumnWidth(0.15),
        2: FractionColumnWidth(0.35),
      },
      children: [
        ReusableTableRow(firstList, isHeader: isHeader),
        // ReusableTableRow(secondList),
        // ReusableTableRow(thirdList),
        // ReusableTableRow(fourthList),
      ],
    );
  }
}

class ProfitLoss {
  ProfitLoss(this.day, this.profit);

  final String day;
  final double profit;
}
