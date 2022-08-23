import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quickagrocourier/provider/auth_provider.dart';
import 'package:quickagrocourier/screens/home.dart';
import 'package:quickagrocourier/utils/colors.dart';
import 'package:quickagrocourier/utils/server.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart';

class OrderProvider extends ChangeNotifier {
  List<dynamic> orders = [];
  int activeOrdersCount = 0;
  int pastOrdersCount = 0;
  Map orderDetails = {};

  getCourierOrders() async {
    activeOrdersCount = 0;
    pastOrdersCount = 0;
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;

    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };

    var response = await http.get(
      Uri.parse("$serverUrl/orders/"),
      headers: headers,
    );

    orders = jsonDecode(response.body);

    for (Map order in orders) {
      if (order["status"] == "Delivered" ||
          order["status"].toString().contains("Cancelled")) {
        pastOrdersCount++;
      } else {
        activeOrdersCount++;
      }
    }

    notifyListeners();
  }

  verifyOrder(Map order, String verificationCode) async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;

    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };

    Map<String, dynamic> body = {
      "orderId": order["_id"],
      "verificationCode": int.parse(verificationCode)
    };

    if (verificationCode == order["verificationCode"].toString()) {
      var response = await http.post(
        Uri.parse("$serverUrl/orders/verify-and-deliver"),
        headers: headers,
        body: jsonEncode(body),
      );

      Fluttertoast.showToast(
        msg: response.body,
        backgroundColor: primaryColor,
      );

      if (response.statusCode == 200) {
        Socket? socket;
        try {
          socket = io(serverUrl, <String, dynamic>{
            'transports': ['websocket'],
            'autoConnect': false,
          });

          socket.connect();

          socket.emit("deliver", verificationCode);
        } catch (e) {
          print(e.toString());
        }

        await getCourierOrders();
        Get.offAll(() => Home());
      }
    } else {
      Fluttertoast.showToast(
        msg: "Invalid Verification Code",
        backgroundColor: primaryColor,
      );
    }
  }

  getOrderDetails(String orderId) async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;

    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };

    Map<String, dynamic> body = {
      "orderObjId": orderId,
    };

    var response = await http.post(
      Uri.parse("$serverUrl/orders/get-order-by-id"),
      headers: headers,
      body: jsonEncode(body),
    );

    orderDetails = jsonDecode(response.body);
    notifyListeners();
  }
}
