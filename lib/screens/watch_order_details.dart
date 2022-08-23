import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:quickagrocourier/screens/watch_verify_order.dart';
import 'package:get/get.dart';
import 'package:quickagrocourier/provider/order_provider.dart';
import 'package:quickagrocourier/provider/theme_provider.dart';
import 'package:quickagrocourier/screens/verify_order.dart';
import 'package:quickagrocourier/utils/colors.dart';
import 'package:quickagrocourier/utils/currency.dart';
import 'package:quickagrocourier/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

bool _loading = false;

class WatchOrderDetails extends StatefulWidget {
  final String orderId;
  WatchOrderDetails(this.orderId);

  @override
  _WatchOrderDetailsState createState() => _WatchOrderDetailsState();
}

class _WatchOrderDetailsState extends State<WatchOrderDetails> {
  @override
  void initState() {
    getOrderDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(width * 0.02),
        height: height * 1.4,
        width: width,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.sp,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 20.sp,
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        FeatherIcons.chevronLeft,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Text(
                      "Order Details",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(width * 0.02),
                            child: Table(
                              children: [
                                TableRow(children: [
                                  Text(
                                    "Order Id",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  Text(
                                    orderProvider.orderDetails["orderId"]
                                        .toString(),
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ]),
                                TableRow(children: [
                                  SizedBox(height: height * 0.01),
                                  SizedBox(height: height * 0.01)
                                ]),
                                TableRow(children: [
                                  Text(
                                    "Ordered On",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  Text(
                                    orderProvider.orderDetails["date"]
                                        .toString()
                                        .split("T")[0],
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ]),
                                TableRow(children: [
                                  SizedBox(height: height * 0.01),
                                  SizedBox(height: height * 0.01)
                                ]),
                                TableRow(children: [
                                  Text(
                                    "Client Name",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  Text(
                                    orderProvider.orderDetails["clientName"]
                                        .toString(),
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ]),
                                TableRow(children: [
                                  SizedBox(height: height * 0.01),
                                  SizedBox(height: height * 0.01)
                                ]),
                                TableRow(children: [
                                  Text(
                                    "Items",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  Text(
                                    orderProvider.orderDetails["items"].length
                                        .toString(),
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ]),
                                TableRow(children: [
                                  SizedBox(height: height * 0.01),
                                  SizedBox(height: height * 0.01)
                                ]),
                                TableRow(children: [
                                  Text(
                                    "Status",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  Text(
                                    orderProvider.orderDetails["status"]
                                        .toString(),
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ]),
                                TableRow(children: [
                                  SizedBox(height: height * 0.01),
                                  SizedBox(height: height * 0.01)
                                ]),
                                TableRow(children: [
                                  Text(
                                    "Delivery Address",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  Text(
                                    orderProvider.orderDetails["address"]
                                        .toString(),
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ]),
                                TableRow(children: [
                                  SizedBox(height: height * 0.01),
                                  SizedBox(height: height * 0.01)
                                ]),
                                TableRow(children: [
                                  Text(
                                    "Preferred Delivery Time",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  Text(
                                    "${orderProvider.orderDetails["preferredDeliveryDate"]} ${orderProvider.orderDetails["preferredDeliveryTime"]}",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ]),
                                TableRow(children: [
                                  SizedBox(height: height * 0.01),
                                  SizedBox(height: height * 0.01)
                                ]),
                                TableRow(children: [
                                  Text(
                                    "Phone Number",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      launch(
                                          "tel:${orderProvider.orderDetails["phone"]}");
                                    },
                                    child: Text(
                                      orderProvider.orderDetails["phone"]
                                          .toString(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.all(width * 0.02),
                            child: Text(
                              "Ordered Items",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: textColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(width * 0.02),
                            child: Table(
                                border: TableBorder.all(
                                    color: primaryColor,
                                    style: BorderStyle.solid,
                                    width: 1),
                                children: getOrderedItemsList()),
                          ),
                        ],
                      ),
              ),
              _loading
                  ? SizedBox.shrink()
                  : Column(children: [
                      SizedBox(height: height * 0.02),
                      Container(
                        height: 60.sp,
                        width: double.infinity,
                        padding: EdgeInsets.all(width * 0.02),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Amount: $currencySymbol${orderProvider.orderDetails["totalPrice"]}",
                              style: TextStyle(
                                color: white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            Text(
                              "Payment Method: ${orderProvider.orderDetails["paymentMethod"]}",
                              style: TextStyle(
                                color: white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      SizedBox(
                        height: 50.sp,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            launch(
                                "tel:${orderProvider.orderDetails["phone"]}");
                          },
                          style: TextButton.styleFrom(
                              primary: Colors.blue,
                              backgroundColor: Colors.blue.withOpacity(0.2),
                              padding: EdgeInsets.all(width * 0.04)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FeatherIcons.phoneCall,
                                size: 20.sp,
                              ),
                              SizedBox(width: width * 0.02),
                              Text(
                                "Call Client",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      SizedBox(
                        height: 50.sp,
                        width: double.infinity,
                        child: orderProvider.orderDetails["isDelivered"]
                            ? Text(
                                orderProvider.orderDetails["status"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : orderProvider.orderDetails["isCancelled"]
                                ? Text(
                                    orderProvider.orderDetails["status"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : TextButton(
                                    onPressed: () {
                                      Get.to(() => WatchVerifyOrder(
                                          orderProvider.orderDetails));
                                    },
                                    style: TextButton.styleFrom(
                                        primary: Colors.green,
                                        backgroundColor:
                                            Colors.green.withOpacity(0.2),
                                        padding: EdgeInsets.all(width * 0.04)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FeatherIcons.check,
                                          size: 20.sp,
                                        ),
                                        SizedBox(width: width * 0.02),
                                        Text(
                                          "Verify & Deliver",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                      ),
                      SizedBox(height: height * 0.01),
                      Divider(),
                    ]),
            ],
          ),
        ),
      ),
    ));
  }

  getOrderDetails() async {
    setState(() {
      _loading = true;
    });
    await Provider.of<OrderProvider>(context, listen: false)
        .getOrderDetails(widget.orderId);
    setState(() {
      _loading = false;
    });
  }

  getOrderedItemsList() {
    var orderProvider = Provider.of<OrderProvider>(context, listen: false);
    List<TableRow> rows = [];
    rows.add(TableRow(children: [
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "No.",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "Name",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "Type",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "Quantity",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "Total Price",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ]));

    for (var item in orderProvider.orderDetails["items"]) {
      rows.add(TableRow(children: [
        Padding(
          padding: EdgeInsets.all(width * 0.01),
          child: Text(
            (orderProvider.orderDetails["items"].indexOf(item) + 1).toString(),
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(width * 0.01),
          child: Text(
            item["title"],
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(width * 0.01),
          child: Text(
            item["isBundle"] ? "Bundle" : "Product",
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(width * 0.01),
          child: Text(
            item["quantity"].toString(),
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(width * 0.01),
          child: Text(
            currencySymbol +
                (int.parse(item["quantity"].toString()) *
                        int.parse(item["price"].toString()))
                    .toString(),
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
      ]));
    }

    rows.add(TableRow(children: [
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "",
          style: TextStyle(fontSize: 12.sp),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "",
          style: TextStyle(fontSize: 12.sp),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "",
          style: TextStyle(fontSize: 12.sp),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "Total Amount",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          currencySymbol +
              (orderProvider.orderDetails["totalPrice"] +
                      orderProvider.orderDetails["discountAmount"])
                  .toString(),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ]));

    rows.add(TableRow(children: [
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "",
          style: TextStyle(fontSize: 12.sp),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "",
          style: TextStyle(fontSize: 12.sp),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "",
          style: TextStyle(fontSize: 12.sp),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "Discount Applied",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "-" +
              currencySymbol +
              orderProvider.orderDetails["discountAmount"].toString(),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ]));

    rows.add(TableRow(children: [
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "",
          style: TextStyle(fontSize: 12.sp),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "",
          style: TextStyle(fontSize: 12.sp),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "",
          style: TextStyle(fontSize: 12.sp),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          "Grand Total",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(width * 0.01),
        child: Text(
          currencySymbol + orderProvider.orderDetails["totalPrice"].toString(),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ]));

    return rows;
  }
}
