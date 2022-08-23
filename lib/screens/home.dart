import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagrocourier/provider/auth_provider.dart';
import 'package:quickagrocourier/provider/theme_provider.dart';
import 'package:quickagrocourier/screens/pages/orders_page.dart';
import 'package:quickagrocourier/screens/pages/profile_page.dart';
import 'package:quickagrocourier/utils/colors.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Provider.of<ThemeProvider>(context).scaffoldColor,
          type: BottomNavigationBarType.fixed,
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
              icon: Icon(FeatherIcons.fileText),
              label: "Orders",
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.user),
              label: "Profile",
            ),
          ],
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
    OrdersPage(),
    ProfilePage(),
  ];
}
