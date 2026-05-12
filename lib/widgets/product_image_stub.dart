import 'package:flutter/material.dart';

Widget getPlatformProductImage({
  required String url,
  double? width,
  double? height,
  required BoxFit fit,
}) {
  throw UnsupportedError(
    'Cannot create a ProductImage without platform implementation',
  );
}

void openExternalUrl(String url) {
  throw UnsupportedError('Cannot open URL without platform implementation');
}
