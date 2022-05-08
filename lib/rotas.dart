import 'package:flutter/material.dart';
import 'package:whats_app_web/telas/home.dart';
import 'package:whats_app_web/telas/login.dart';

class Rotas {
  static Route<dynamic> gerarRota(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => Login(),
        );

      case "/login":
        return MaterialPageRoute(
          builder: (_) => Login(),
        );

      case "/home":
        return MaterialPageRoute(
          builder: (_) => Home(),
        );
    }
  }
}
