import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickagrocourier/screens/login.dart';
import 'package:quickagrocourier/screens/notices.dart';
import 'package:quickagrocourier/screens/order_details.dart';
import 'package:quickagrocourier/utils/server.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  String email = "";
  String name = "";
  String token = "";
  String type = "";
  String profilePic = "";
  // bool isFingerprintEnabled = false;

  changeEmail(String newEmail) {
    email = newEmail;
    notifyListeners();
  }

  changeName(String newName) {
    name = newName;
    notifyListeners();
  }

  changeToken(String newToken) {
    token = newToken;
    notifyListeners();
  }

  changeType(String newType) {
    type = newType;
    notifyListeners();
  }

  changeProfilePic(String newProfilePic) {
    profilePic = newProfilePic;
    notifyListeners();
  }

  setAllValues(String newEmail, String newName, String newToken, String newType,
      String newProfilePic) {
    email = newEmail;
    name = newName;
    token = newToken;
    type = newType;
    profilePic = newProfilePic;
    notifyListeners();
  }

  clearAllValues() {
    email = "";
    name = "";
    token = "";
    type = "";
    profilePic = "";
    notifyListeners();
  }

  setSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setString("name", name);
    prefs.setString("token", token);
    prefs.setString("type", type);
  }

  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email") == null ? "" : prefs.getString("email")!;
    name = prefs.getString("name") == null ? "" : prefs.getString("name")!;
    token = prefs.getString("token") == null ? "" : prefs.getString("token")!;
    type = prefs.getString("type") == null ? "" : prefs.getString("type")!;
  }

  logOut() async {
    clearAllValues();
    await setSharedPreferences();
    Get.offAll(() => Login());
  }

  updateFirebaseToken() async {
    await Firebase.initializeApp();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message!.data["type"] == "order") {
        Get.to(() => OrderDetails(message.data["orderId"]));
      } else if (message.data["type"] == "notice") {
        Get.to(() => Notices());
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data["type"] == "order") {
        Get.to(() => OrderDetails(message.data["orderId"]));
      } else if (message.data["type"] == "notice") {
        Get.to(() => Notices());
      }
    });
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getToken().then((firebaseToken) async {
      String token =
          Provider.of<AuthProvider>(Get.context!, listen: false).token;
      Map<String, String> headers = {
        "Authorization": "JWT $token",
        "Content-Type": "application/json"
      };
      Map<String, dynamic> body = {"token": firebaseToken};
      await http.post(Uri.parse("$serverUrl/users/update-firebase-token"),
          headers: headers, body: jsonEncode(body));
    });
  }
}
