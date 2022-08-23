import 'package:quickagrocourier/utils/size.dart';

bool isMobile = width.toInt() < 600 ? true : false;
bool isWatch = width.toInt() == height.toInt() ? true : false;
bool isTablet = width.toInt() > 600 && width.toInt() < 1000 ? true : false;
bool isDesktop = width.toInt() > 1000 ? true : false;
