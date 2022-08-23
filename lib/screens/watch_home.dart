import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagrocourier/provider/auth_provider.dart';
import 'package:quickagrocourier/provider/theme_provider.dart';
import 'package:quickagrocourier/screens/pages/orders_page.dart';
import 'package:quickagrocourier/screens/pages/profile_page.dart';
import 'package:quickagrocourier/screens/pages/watch_orders_page.dart';
import 'package:quickagrocourier/screens/pages/watch_profile_page.dart';
import 'package:quickagrocourier/utils/colors.dart';
import 'package:provider/provider.dart';

class WatchHome extends StatefulWidget {
  @override
  _WatchHomeState createState() => _WatchHomeState();
}

class _WatchHomeState extends State<WatchHome> {
  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).updateFirebaseToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text("Exit App?"),
                      content: Text("Are you sure, want to exit?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text(
                              "CANCEL",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            )),
                        TextButton(
                          onPressed: () {
                            exit(0);
                          },
                          child: Text("EXIT"),
                        ),
                      ]);
                }) ??
            false;
      },
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: 50.sp,
          child: BottomNavigationBar(
            backgroundColor: Provider.of<ThemeProvider>(context).scaffoldColor,
            type: BottomNavigationBarType.shifting,
            selectedLabelStyle: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 10.sp,
            ),
            unselectedItemColor: textColor,
            currentIndex: _currentPageIndex,
            elevation: 0,
            selectedItemColor: primaryColor,
            onTap: (int index) {
              _pageController.jumpToPage(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  FeatherIcons.fileText,
                  size: 25.sp,
                ),
                label: "Orders",
              ),
              BottomNavigationBarItem(
                icon: Icon(FeatherIcons.user, size: 25.sp),
                label: "Profile",
              ),
            ],
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 4,
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return _pages[index];
          },
        ),
      ),
    );
  }

  int _currentPageIndex = 0;

  PageController _pageController = new PageController();

  List<Widget> _pages = [
    WatchOrdersPage(),
    WatchProfilePage(),
  ];
}
