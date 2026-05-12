// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'dart:convert';
import 'package:flutter/material.dart';

Widget getPlatformProductImage({
  required String url,
  double? width,
  double? height,
  required BoxFit fit,
}) {
  // Use a unique viewType based on the URL to avoid collisions
  final String viewType =
      'img-${base64.encode(utf8.encode(url)).replaceAll('=', '')}';

  // Register the view factory using the correct dart:ui_web registry
  ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final html.ImageElement img = html.ImageElement()
      ..src = url
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = fit == BoxFit.contain ? 'contain' : 'cover'
      ..style.pointerEvents = 'none'
      ..setAttribute('loading', 'lazy');

    img.onError.listen((_) {
      debugPrint('WEB IMAGE ERROR: Failed to load $url');
    });

    return img;
  });

  return SizedBox(
    width: width,
    height: height,
    child: HtmlElementView(viewType: viewType),
  );
}

void openExternalUrl(String url) {
  html.window.open(url, "_blank");
}
