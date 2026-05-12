import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  final double height;
  const BrandLogo({super.key, this.height = 40});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/logo.png', height: height);
  }
}
