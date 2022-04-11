import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
}

extension MediaQuerySize on BuildContext {
  double dynamicWidth(double value) => mediaQuery.size.width * value;
  double dynamicHeight(double value) => mediaQuery.size.height * value;
}

