import 'package:flutter/material.dart';

class Responsivo extends StatelessWidget {
  final Widget web;
  final Widget mobile;
  final Widget? tablet;

  const Responsivo({
    Key? key,
    required this.mobile,
    required this.web,
    this.tablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 1200) {
        return web;
      } else if (constraints.maxWidth >= 800) {
        Widget? resTablet = this.tablet;
        if (resTablet != null) {
          return resTablet;
        }
      } else {
        return mobile;
      }
    });
  }
}
