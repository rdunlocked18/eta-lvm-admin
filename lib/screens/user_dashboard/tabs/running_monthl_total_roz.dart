import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';

class RunningMonthlyTotalRoz extends StatefulWidget {
  const RunningMonthlyTotalRoz({Key? key}) : super(key: key);

  @override
  State<RunningMonthlyTotalRoz> createState() => _RunningMonthlyTotalRozState();
}

class _RunningMonthlyTotalRozState extends State<RunningMonthlyTotalRoz> {
  String token = getToken();
  void initState() {
    super.initState();
    firstMonth();
    secondMonth();
    thirdMonth();
    forthMonth();
  }

  firstMonth() async {
    var headers = {
      'Authorization': token,
      'Cookie':
          'connect.sid=s%3AQ7p33kSwg8IVzTr3fbEo-oaKr52cVMu8.zQsNAcM6ufJoqrk8a3cWzDH4CEohj9gEtiB9NVG0lqw'
    };
    var request =
        http.Request('GET', Uri.parse('$BASE_URL/api/user/month1/profit'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      var res = await response.stream.bytesToString();
      var body = jsonDecode(res);
      print("body is == $body");
      monthOne = body['totalProfit'];
      print(" wee body is == $monthOne");
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }

  secondMonth() async {
    var headers = {
      'Authorization': token,
      'Cookie':
          'connect.sid=s%3AQ7p33kSwg8IVzTr3fbEo-oaKr52cVMu8.zQsNAcM6ufJoqrk8a3cWzDH4CEohj9gEtiB9NVG0lqw'
    };
    var request =
        http.Request('GET', Uri.parse('$BASE_URL/api/user/month2/profit'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var res = await response.stream.bytesToString();
      var body = jsonDecode(res);
      print("body is == $body");
      monthTwo = body['totalProfit'];
      print(" wee body is == $monthOne");
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }

  thirdMonth() async {
    var headers = {
      'Authorization': token,
      'Cookie':
          'connect.sid=s%3AtKcv23ZHCe6Nk8izfMWwJNAWbQYvnrz5.rdTp%2BbXg3ZFiMsku7QzzOwDkb2z0dNcaLfWM4O1H5Kk'
    };
    var request =
        http.Request('GET', Uri.parse('$BASE_URL/api/user/month3/profit'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var res = await response.stream.bytesToString();
      var body = jsonDecode(res);
      print("body is == $body");
      monthThree = body['totalProfit'];
      print(" wee body is == $monthOne");
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }

  forthMonth() async {
    var headers = {
      'Authorization': token,
      'Cookie':
          'connect.sid=s%3ANlzlMBHmFOANCC5NVC4JOyQeSWDSG4AR.oUIup2SRTKHvZ1ZfH7ti%2BdWPWnpRRbVkVjwXDBBOgH0'
    };
    var request =
        http.Request('GET', Uri.parse('$BASE_URL/api/user/month4/profit'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var res = await response.stream.bytesToString();
      var body = jsonDecode(res);
      print("body is == $body");
      monthFour = body['totalProfit'];
      print(" wee body is == $monthOne");
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }

  // var  message;
  var monthOne;
  var monthTwo;
  var monthThree;
  var monthFour;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        monthOne == null &&
                monthTwo == null &&
                monthThree == null &&
                monthFour == null
            ? Center(
                child: Text("Loading....."),
              )
            : Container(
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Weeks')),
                    primaryYAxis:
                        NumericAxis(title: AxisTitle(text: 'Percentage')),
                    // Enable legend
                    legend: Legend(isVisible: true),
                    palette: [Color(0xFF0C331F)],
                    // Enable tooltip
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <LineSeries<GraphModel, String>>[
                      LineSeries<GraphModel, String>(
                          dataSource: <GraphModel>[
                            GraphModel(
                                '12/5/2022',
                                int.parse(monthOne == null
                                    ? "0"
                                    : monthOne.toString())),
                            GraphModel(
                                '2/6/2022',
                                int.parse(monthTwo == null
                                    ? "0"
                                    : monthTwo.toString())),
                            GraphModel(
                                '1/7/2022',
                                int.parse(monthThree == null
                                    ? "0"
                                    : monthThree.toString())),
                            GraphModel(
                                '12/8/2022',
                                int.parse(monthFour == null
                                    ? "0"
                                    : monthFour.toString())),
                          ],
                          xValueMapper: (GraphModel year, _) => year.year,
                          yValueMapper: (GraphModel sales, _) => sales.sales,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true))
                    ]),
              ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text(
              "Month December % Roz =",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 30,
            ),
            Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFF0C331F))),
              child: Text(
                "30%",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ],
    );
  }

  static getToken() async {
    SharedPreferences mainPref = await SharedPreferences.getInstance();
    var token = mainPref.getString("token");
    return token;
  }
}

class GraphModel {
  final int? sales;
  final String? year;
  const GraphModel(
    this.year,
    this.sales,
  );
}
