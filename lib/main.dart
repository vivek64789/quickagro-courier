import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagrocourier/provider/fingerprint_provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickagrocourier/provider/auth_provider.dart';
import 'package:quickagrocourier/provider/notice_provider.dart';
import 'package:quickagrocourier/provider/order_provider.dart';
import 'package:quickagrocourier/provider/theme_provider.dart';
import 'package:quickagrocourier/provider/user_profile_provider.dart';
import 'package:quickagrocourier/screens/splash_screen.dart';
import 'package:quickagrocourier/utils/colors.dart';
import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (context, builder) => MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
          ChangeNotifierProvider<FingerprintProvider>(
              create: (_) => FingerprintProvider()),
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
          ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()),
          ChangeNotifierProvider<UserProfileProvider>(
              create: (_) => UserProfileProvider()),
          ChangeNotifierProvider<NoticeProvider>(
              create: (_) => NoticeProvider()),
        ],
        child: Builder(
          builder: (context) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            color: primaryColor,
            theme: ThemeData(primarySwatch: Colors.green).copyWith(
              scaffoldBackgroundColor:
                  Provider.of<ThemeProvider>(context).scaffoldColor,
              textTheme: GoogleFonts.lexendDecaTextTheme(),
              primaryColor: primaryColor,
            ),
            home: SplashScreen(),
          ),
        ),
      ),
    );
  }
}
