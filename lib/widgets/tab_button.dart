import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagrocourier/provider/theme_provider.dart';
import 'package:quickagrocourier/utils/colors.dart';
import 'package:quickagrocourier/utils/size.dart';
import 'package:provider/provider.dart';

class TabButton extends StatelessWidget {
  final bool enabled;
  final String title;
  final Function onTap;

  TabButton(this.enabled, this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    return TextButton(
      onPressed: () {
        onTap();
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: height * 0.01),
        backgroundColor: enabled ? primaryColor : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: enabled ? white : textColor.withOpacity(0.7),
          fontSize: 12.sp,
        ),
      ),
    );
  }
}
