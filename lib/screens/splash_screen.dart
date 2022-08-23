import 'package:flutter/material.dart';
import 'package:quickagrocourier/screens/watch_home.dart';
import 'package:quickagrocourier/utils/get_responsive.dart';
import 'package:get/get.dart';
import 'package:quickagrocourier/provider/auth_provider.dart';
import 'package:quickagrocourier/provider/notice_provider.dart';
import 'package:quickagrocourier/provider/order_provider.dart';
import 'package:quickagrocourier/provider/user_profile_provider.dart';
import 'package:quickagrocourier/screens/home.dart';
import 'package:quickagrocourier/screens/login.dart';
import 'package:quickagrocourier/utils/size.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icon/icon.png",
                width: width * 0.25,
                filterQuality: FilterQuality.high,
              ),
              SizedBox(height: height * 0.02),
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          ),
        ),
      ),
    );
  }

  getData() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.getSharedPreferences();
    if (authProvider.token.length == 0) {
      Get.offAll(() => Login());
    } else {
      await Provider.of<UserProfileProvider>(context, listen: false)
          .getProfile();
      await Provider.of<OrderProvider>(context, listen: false)
          .getCourierOrders();
      await Provider.of<NoticeProvider>(context, listen: false).fetchNotices();
      Get.offAll(() => isWatch ? WatchHome() : Home());
    }
  }
}
