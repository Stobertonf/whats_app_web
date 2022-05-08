import 'package:flutter/material.dart';
import 'package:whats_app_web/telas/login.dart';

void main() {
  runApp(
    const MaterialApp(
      title: "WhatsApp Web",
      debugShowCheckedModeBanner: false,
      // home: Login(),
      initialRoute: "/login",
      onGenerateRoute: Rotas.genarRota,
    ),
  );
}
