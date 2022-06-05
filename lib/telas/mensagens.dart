import '../modelos/usuario.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Mensagens extends StatefulWidget {
  final Usuario usuarioDestinatario;

  const Mensagens(this.usuarioDestinatario, {Key? key}) : super(key: key);

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  late Usuario _usuarioDestinario;
  _recuperarDadosIniciais() {
    _usuarioDestinario = widget.usuarioDestinatario;
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosIniciais();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              backgroundImage: CachedNetworkImageProvider(
                _usuarioDestinario.urlImagem,
              ),
            ),
            const SizedBox(
              width: 8,
            )
          ],
        ),
      ),
    );
  }
}
