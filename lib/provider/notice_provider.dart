import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:quickagrocourier/provider/auth_provider.dart';
import 'package:quickagrocourier/utils/server.dart';
import 'package:provider/provider.dart';

class NoticeProvider extends ChangeNotifier {
  Map notices = {};

  fetchNotices() async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };
    var response =
        await http.get(Uri.parse("$serverUrl/notices"), headers: headers);

    if (response.statusCode == 200) {
      notices = jsonDecode(response.body);
    }
    notifyListeners();
  }

  updateNoticeSeen() async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };
    await http.post(Uri.parse("$serverUrl/notices/seen"),
        headers: headers, body: jsonEncode({}));
  }
}
