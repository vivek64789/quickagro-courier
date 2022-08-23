import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagrocourier/provider/order_provider.dart';
import 'package:quickagrocourier/provider/theme_provider.dart';
import 'package:quickagrocourier/utils/colors.dart';
import 'package:quickagrocourier/utils/masked_input_formatter.dart';
import 'package:quickagrocourier/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';

String _verificationCode = "";
bool _verifying = false;
bool _showScanner = false;

class VerifyOrder extends StatefulWidget {
  final Map order;

  VerifyOrder(this.order);

  @override
  _VerifyOrderState createState() => _VerifyOrderState();
}

class _VerifyOrderState extends State<VerifyOrder> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
    _verificationCode = "";
    _verifying = false;
    _showScanner = false;
  }

  @override
  void reassemble() {
    super.reassemble();
    if (GetPlatform.isAndroid) {
      controller!.pauseCamera();
    } else if (GetPlatform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(width * 0.02),
        height: height,
        width: width,
        child: SafeArea(
          child: _verifying
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
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
                          "Verify & Deliver",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      "Enter Verification Code",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: textColor,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (text) {
                              _verificationCode = text;
                            },
                            inputFormatters: [
                              MaskedTextInputFormatter(
                                mask: "xxxxxx",
                                separator: "",
                              )
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              fillColor: textColor.withOpacity(0.1),
                              filled: true,
                            ),
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      "Ask the client for verification code",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async {
                          if (_verificationCode == "") {
                            Fluttertoast.showToast(
                                msg: "Please enter verification code!",
                                backgroundColor: primaryColor);
                          } else {
                            setState(() {
                              _verifying = true;
                            });
                            await Provider.of<OrderProvider>(context,
                                    listen: false)
                                .verifyOrder(widget.order, _verificationCode);
                            setState(() {
                              _verifying = false;
                            });
                          }
                        },
                        style: TextButton.styleFrom(
                          primary: primaryColor,
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                        ),
                        child: Text(
                          "Verify",
                          style: TextStyle(
                            color: white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Text(
                          "OR",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _showScanner = !_showScanner;
                          });
                        },
                        style: TextButton.styleFrom(
                          primary: primaryColor,
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                        ),
                        child: Text(
                          _showScanner ? "Cancel" : "Scan QR Code",
                          style: TextStyle(
                            color: white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    _showScanner
                        ? Expanded(
                            child: QRView(
                              key: qrKey,
                              onQRViewCreated: _onQRViewCreated,
                              overlay: QrScannerOverlayShape(
                                borderColor: Colors.red,
                                borderRadius: 10,
                                borderLength: 30,
                                borderWidth: 10,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        _verifying = true;
      });
      await Provider.of<OrderProvider>(context, listen: false)
          .verifyOrder(widget.order, scanData.code.toString());
      setState(() {
        _verifying = false;
      });
    });
  }
}
