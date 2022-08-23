import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagrocourier/provider/theme_provider.dart';
import 'package:quickagrocourier/utils/size.dart';
import 'package:provider/provider.dart';

class ProfileDetailTile extends StatelessWidget {
  final String title;
  final String value;
  final Widget prefix;
  final Function? onTap;

  ProfileDetailTile({
    this.title = "",
    this.value = "",
    this.prefix = const SizedBox.shrink(),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    return GestureDetector(
      onTap: onTap == null
          ? () {}
          : () {
              onTap!();
            },
      child: Padding(
        padding: EdgeInsets.only(bottom: height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title == ""
                ? SizedBox.shrink()
                : Text(
                    title,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: textColor.withOpacity(0.5),
                    ),
                  ),
            SizedBox(
              height: height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    prefix,
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                onTap == null
                    ? SizedBox.shrink()
                    : Icon(
                        FeatherIcons.chevronRight,
                        color: textColor,
                      )
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
