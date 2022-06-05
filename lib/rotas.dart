import 'modelos/usuario.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_web/telas/home.dart';
import 'package:whats_app_web/telas/login.dart';
import 'package:whats_app_web/telas/mensagens.dart';

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

      case "/mensagens":
        return MaterialPageRoute(
          builder: (_) => Mensagens(args as Usuario),
        );
    }

    return _erroRota(); //para exibir a mensagem de erro das rotas
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Tela não encontrada",
            ),
          ),
          body: const Center(
            child: Text("Tela não encontrada"),
          ),
        );
      },
    );
  }
}
