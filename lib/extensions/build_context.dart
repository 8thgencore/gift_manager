import 'package:flutter/cupertino.dart';

extension BuildContextColors on BuildContext {

  Color dynamicPlainColor({
    required final Color lightThemeColor,
    required final Color darkThemeColor,
  }) {
    final Brightness brightness = MediaQuery.of(this).platformBrightness;
    switch (brightness) {
      case Brightness.dark:
        return darkThemeColor;
      case Brightness.light:
        return  lightThemeColor;
    }
  }
}