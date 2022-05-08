import 'package:flutter/material.dart';

class Usurio {
  String idUsuario;
  String nome;
  String email;
  String urImagem;

  Usurio(
    this.idUsuario,
    this.nome,
    this.email, {
    this.urImagem = "",
  });
}
