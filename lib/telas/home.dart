import 'home_mobile.dart';
import '../uteis/responsivo.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_web/telas/home_web.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsivo(
      web: HomeWeb(),
      tablet: HomeWeb(),
      mobile: HomeMobile(),
    );
  }
}
