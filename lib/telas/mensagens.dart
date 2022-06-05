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
  late Usuario _usuarioDestinatario;
  _recuperarDadosIniciais() {
    _usuarioDestinatario = widget.usuarioDestinatario;
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
                _usuarioDestinatario.urlImagem,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              _usuarioDestinatario.nome,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
