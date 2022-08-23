import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quickagrocourier/provider/auth_provider.dart';
import 'package:quickagrocourier/provider/theme_provider.dart';
import 'package:quickagrocourier/provider/user_profile_provider.dart';
import 'package:quickagrocourier/screens/pages/profile_phone.dart';
import 'package:quickagrocourier/utils/colors.dart';
import 'package:quickagrocourier/utils/size.dart';
import 'package:quickagrocourier/widgets/profile_detail_tile.dart';
import 'package:provider/provider.dart';

bool _uploadingProfilePic = false;
bool _loading = false;

class WatchProfilePage extends StatefulWidget {
  @override
  _WatchProfilePageState createState() => _WatchProfilePageState();
}

class _WatchProfilePageState extends State<WatchProfilePage> {
  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var userProfileProvider = Provider.of<UserProfileProvider>(context);

    return Container(
      padding: EdgeInsets.all(width * 0.02),
      height: height,
      width: width,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    FeatherIcons.chevronLeft,
                    color: textColor,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: width * 0.02),
                Text(
                  "User Profile",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () async {
                        await getData();
                      },
                      child: ListView(
                        children: [
                          SizedBox(
                            height: height * 0.04,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    child: _uploadingProfilePic
                                        ? CircularProgressIndicator()
                                        : SizedBox.shrink(),
                                    backgroundColor:
                                        primaryColor.withOpacity(0.4),
                                    radius: width * 0.1,
                                    backgroundImage: userProfileProvider
                                                .profilePic ==
                                            ""
                                        ? null
                                        : Image.network(
                                                userProfileProvider.profilePic)
                                            .image,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Tooltip(
                                      message: "Change Profile Photo",
                                      child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            _uploadingProfilePic = true;
                                          });
                                          await userProfileProvider
                                              .uploadProfilePic();
                                          setState(() {
                                            _uploadingProfilePic = false;
                                          });
                                        },
                                        borderRadius:
                                            BorderRadius.circular(width),
                                        child: Container(
                                          width: width * 0.075,
                                          height: width * 0.075,
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            FeatherIcons.camera,
                                            color: white,
                                            size: width * 0.04,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Text(
                                userProfileProvider.name,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.025,
                          ),
                          SizedBox(
                            height: height * 0.04,
                          ),
                          Padding(
                            padding: EdgeInsets.all(width * 0.02),
                            child: Column(
                              children: [
                                ProfileDetailTile(
                                  title: "Email",
                                  value: userProfileProvider.email,
                                ),
                                ProfileDetailTile(
                                  title: "Phone number",
                                  value: userProfileProvider.phone,
                                  onTap: () {
                                    Get.to(() => ProfilePhone());
                                  },
                                ),
                                SizedBox(
                                  height: 50.sp,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: height * 0.0001),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.black,
                                        padding: EdgeInsets.symmetric(
                                          vertical: height * 0.01,
                                          horizontal: width * 0.01,
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                            barrierDismissible: true,
                                            context: context,
                                            builder: (context) {
                                              return SingleChildScrollView(
                                                child: Container(
                                                  width: double.infinity,
                                                  child: AlertDialog(
                                                    insetPadding:
                                                        EdgeInsets.all(15.sp),
                                                    contentPadding:
                                                        EdgeInsets.all(10.sp),
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    title: Text(
                                                      "Log Out",
                                                      style: TextStyle(
                                                          fontSize: 15.sp),
                                                    ),
                                                    content: Text(
                                                      "Are you sure, want to log out?",
                                                      style: TextStyle(
                                                        fontSize: 15.sp,
                                                      ),
                                                    ),
                                                    actions: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                              "CANCEL",
                                                              style: TextStyle(
                                                                fontSize: 14.sp,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Provider.of<AuthProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .logOut();
                                                            },
                                                            child: Text(
                                                              "LOG OUT",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.sp),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            FeatherIcons.logOut,
                                            color: primaryColor,
                                            size: 20.sp,
                                          ),
                                          SizedBox(
                                            width: width * 0.04,
                                          ),
                                          Text(
                                            "Log Out",
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                // ProfileDetailTile(
                                //   prefix: Padding(
                                //     padding: EdgeInsets.only(
                                //       right: width * 0.02,
                                //     ),
                                //     child: Icon(
                                //       FeatherIcons.creditCard,
                                //       color: textColor,
                                //     ),
                                //   ),
                                //   value: "Select Default Payment Card",
                                //   onTap: () {
                                //     Get.to(() => MyCards());
                                //   },
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  getData() async {
    setState(() {
      _loading = true;
    });
    await Provider.of<UserProfileProvider>(context, listen: false).getProfile();
    setState(() {
      _loading = false;
    });
  }
}
