import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_web/rotas.dart';
import 'package:whats_app_web/telas/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_app_web/uteis/paleta_cores.dart';
import 'package:whats_app_web/provider/conversa_provider.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: PaletaCores.corPrimaria,
  accentColor: PaletaCores.corDestaque,
);

void main() {
  User? usuarioFirebase = FirebaseAuth.instance.currentUser;
  String urlInicial = "/";
  if (usuarioFirebase != null) {
    urlInicial = "/home";
  }

  //Atalhos
  final atalhos = WidgetsApp.defaultShortcuts;
  atalhos[LogicalKeySet(LogicalKeyboardKey.space)] = const ActivateIntent();

  runApp(
    MaterialApp(
      shortcuts: atalhos,
      title: "WhatsApp Web",
      debugShowCheckedModeBanner: false,
      // home: Login(),
      theme: temaPadrao,
      initialRoute: "/",
      onGenerateRoute: Rotas.gerarRota,
    ),
  );
}
