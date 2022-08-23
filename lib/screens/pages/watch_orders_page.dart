import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagrocourier/widgets/watch_order_history_card.dart';
import 'package:get/get.dart';
import 'package:quickagrocourier/provider/notice_provider.dart';
import 'package:quickagrocourier/provider/order_provider.dart';
import 'package:quickagrocourier/provider/theme_provider.dart';
import 'package:quickagrocourier/screens/notices.dart';
import 'package:quickagrocourier/utils/colors.dart';
import 'package:quickagrocourier/utils/size.dart';
import 'package:quickagrocourier/widgets/tab_button.dart';
import 'package:provider/provider.dart';

bool _loading = false;
bool _activeOrders = true;

class WatchOrdersPage extends StatefulWidget {
  @override
  _WatchOrdersPageState createState() => _WatchOrdersPageState();
}

class _WatchOrdersPageState extends State<WatchOrdersPage> {
  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var orderProvider = Provider.of<OrderProvider>(context);
    var noticeProvider = Provider.of<NoticeProvider>(context);

    return Container(
      padding: EdgeInsets.all(width * 0.02),
      height: height,
      width: width,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 50.sp,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Orders",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: textColor,
                    ),
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: width * 0.02),
                        child: IconButton(
                          onPressed: () {
                            Get.to(() => Notices());
                          },
                          icon: Icon(
                            FeatherIcons.bell,
                            size: 20.sp,
                            color: textColor,
                          ),
                          tooltip: "Notices",
                        ),
                      ),
                      noticeProvider.notices["seen"]
                          ? SizedBox.shrink()
                          : Positioned(
                              top: width * 0.015,
                              right: width * 0.025,
                              child: Container(
                                width: width * 0.015,
                                height: width * 0.015,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius:
                                        BorderRadius.circular(borderRadius)),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
            orderProvider.orders.length == 0
                ? Expanded(
                    child: _loading
                        ? Center(child: CircularProgressIndicator())
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "No Orders",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Text(
                                  "Assigned orders will be displayed here",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                TextButton(
                                  onPressed: () {
                                    getData();
                                  },
                                  child: Text(
                                    "REFRESH",
                                  ),
                                ),
                              ],
                            ),
                          ),
                  )
                : Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 40.sp,
                          margin:
                              EdgeInsets.symmetric(horizontal: width * 0.002),
                          padding: EdgeInsets.all(width * 0.002),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TabButton(_activeOrders,
                                    "Active (${orderProvider.activeOrdersCount})",
                                    () {
                                  setState(() {
                                    _activeOrders = true;
                                  });
                                }),
                              ),
                              SizedBox(
                                width: width * 0.01,
                              ),
                              Expanded(
                                child: TabButton(!_activeOrders,
                                    "Past Orders (${orderProvider.pastOrdersCount})",
                                    () {
                                  setState(() {
                                    _activeOrders = false;
                                  });
                                }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Expanded(
                          child: _loading
                              ? Center(child: CircularProgressIndicator())
                              : orderProvider.activeOrdersCount == 0 &&
                                      _activeOrders
                                  ? Center(
                                      child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("No Active Orders"),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            getData();
                                          },
                                          child: Text(
                                            "REFRESH",
                                            style: TextStyle(fontSize: 20.sp),
                                          ),
                                        ),
                                      ],
                                    ))
                                  : orderProvider.pastOrdersCount == 0 &&
                                          !_activeOrders
                                      ? Center(
                                          child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "No Past Orders",
                                              style: TextStyle(fontSize: 20.sp),
                                            ),
                                            SizedBox(
                                              height: height * 0.02,
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                getData();
                                              },
                                              child: Text(
                                                "REFRESH",
                                                style:
                                                    TextStyle(fontSize: 20.sp),
                                              ),
                                            ),
                                          ],
                                        ))
                                      : RefreshIndicator(
                                          onRefresh: () async {
                                            await getData();
                                          },
                                          child: ListView.builder(
                                            padding:
                                                EdgeInsets.all(width * 0.02),
                                            itemCount:
                                                orderProvider.orders.length,
                                            itemBuilder: (context, index) {
                                              var order =
                                                  orderProvider.orders[index];
                                              return _activeOrders &&
                                                      (order["isCancelled"] ||
                                                          order["isDelivered"])
                                                  ? SizedBox.shrink()
                                                  : !_activeOrders &&
                                                          !order[
                                                              "isCancelled"] &&
                                                          !order["isDelivered"]
                                                      ? SizedBox.shrink()
                                                      : WatchOrderHistoryCard(
                                                          order: order);
                                            },
                                          ),
                                        ),
                        ),
                      ],
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
    await Provider.of<OrderProvider>(context, listen: false).getCourierOrders();
    await Provider.of<NoticeProvider>(context, listen: false).fetchNotices();
    setState(() {
      _loading = false;
    });
  }
}
