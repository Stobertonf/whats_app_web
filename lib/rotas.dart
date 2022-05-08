import 'package:flutter/material.dart';
import 'package:whats_app_web/telas/login.dart';

class Rotas {
  static Route<dynamic> gerarRota(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MatererialPageRoute(
          builder: (_) => Login(),
        );

      case "/login":
        return MatererialPageRoute(
          builder: (_) => Login(),
        );

      case "/home":
        return MatererialPageRoute(
          builder: (_) => Login(),
        );
    }
  }
}
