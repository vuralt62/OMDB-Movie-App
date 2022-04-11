import 'package:flutter/material.dart';
import 'package:movie_app/extensions/size_extension.dart';

extension PaddingExtensionAll on BuildContext {
  EdgeInsets get paddingLow => EdgeInsets.all(dynamicHeight(0.01));
  EdgeInsets get paddingNormal => EdgeInsets.all(dynamicHeight(0.03));
  EdgeInsets get paddingMedium => EdgeInsets.all(dynamicHeight(0.05));
  EdgeInsets get paddingHigh => EdgeInsets.all(dynamicHeight(0.1));
}
