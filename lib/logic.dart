import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'model.dart';

class Logic {
  Exchange exchange = Exchange();
  Stopwatch stopwatch = Stopwatch();
  bool apiResult = false;

  showMessage() {
    return Fluttertoast.showToast(
        msg: "Took long enough to respond. Check your internet connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey.shade700,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  getFootballApi(page)async{
    String baseUrl = "http://10.0.2.2:5000/api/footballers?page=$page";
    Uri url = Uri.parse(baseUrl);
    var result;

    try {
      http.Response response;
      response = await http.get(url);

      print(response.statusCode);
      print(response.body);

      result = jsonDecode(response.body);
      print(result["footballers"]);
      print(result["total_pages"]);
      var football = new Football(footballers: result["footballers"], totalPages:
      result["total_pages"]);
      print(football);
      apiResult = true;

    } catch (e) {
      apiResult = false;
      print("Error");
    }
    Timer(Duration(seconds: 5), () {
      if (!apiResult) {
        print("Data could not be fetched after 5 seconds.");
        showMessage();
      }
    });
    return apiResult
        ? Football(
      footballers: result["footballers"],
      totalPages: result["total_pages"]
    )
        : Future.error("Data couldnt be fetched");
  }

  getApi(date) async {
    String baseUrl =
        "https://www.nrb.org.np/api/forex/v1/rates?from=$date&to=$date&per_page=100&page=1";
    Uri url = Uri.parse(baseUrl);
    var result;

    try {
      http.Response response;
      response = await http.get(url);

      print(response.statusCode);

      result = jsonDecode(response.body);
      apiResult = true;

    } catch (e) {
      apiResult = false;
      print("Error");
    }
    Timer(Duration(seconds: 5), () {
      if (!apiResult) {
        print("Data could not be fetched after 5 seconds.");
        showMessage();
      }
    });
    return apiResult
        ? Exchange.fromJson(result)
        : Future.error("Data couldnt be fetched");
  }

  getApiTotal() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String one_month_ago = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: 30)));
    String baseUrl =
        "https://www.nrb.org.np/api/forex/v1/rates?from=$one_month_ago&to=$today&per_page=100&page=1";
    Uri url = Uri.parse(baseUrl);
    var result;

    try {
      http.Response response;

      response = await http.get(url);

      print(response.statusCode);
      result = jsonDecode(response.body);
      apiResult = true;

      print(result);
    } catch (e) {
      apiResult = false;
      print("Error");
    }
    Timer(Duration(seconds: 5), () {
      if (!apiResult) {
        print("Data could not be fetched after 5 seconds.");
        showMessage();
      }
    });
    return apiResult
        ? Exchange.fromJson(result)
        : Future.error("Data couldnt be fetched");
  }
}


class Football {
  List footballers;
  int totalPages;

  Football({
    required this.footballers,
    required this.totalPages
  });

}