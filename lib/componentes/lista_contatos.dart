import 'package:flutter/material.dart';
import 'package:whats_app_web/modelos/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListaContatos extends StatefulWidget {
  const ListaContatos({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListaContatosState createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  late String _idUsuarioLogado;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Usuario>> _recuperarContatos() async {
    final usuarioRef = _firestore.collection("usuarios");
    QuerySnapshot querySnapshot = await usuarioRef.get();
    List<Usuario> listaUsuarios = [];

    for (DocumentSnapshot item in querySnapshot.docs) {
      String idUsuario = item["idUsuario"];
      if (idUsuario == _idUsuarioLogado) continue;
      String email = item["email"];
      String nome = item["nome"];
      String urlImagem = item["urlImagem"];

      Usuario usuario = Usuario(
        idUsuario,
        nome,
        email,
        urlImagem: urlImagem,
      );

      listaUsuarios.add(usuario);
    }

    return listaUsuarios;
  }

  _recuperarDadosUsuarioLogado() async {
    User? usuarioAtual = await _auth.currentUser;
    if (usuarioAtual != null) {
      _idUsuarioLogado = usuarioAtual.uid;
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
      future: _recuperarContatos(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: const [
                  Text("Carregando contatos"),
                  CircularProgressIndicator(),
                ],
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return const Center(
                child: Text("Erro ao carregar os dados!"),
              );
            } else {
              List<Usuario>? listaUsuarios = snapshot.data;
              if (listaUsuarios != null) {
                return ListView.separated(
                  separatorBuilder: (context, indice) {
                    return const Divider(
                      color: Colors.grey,
                      thickness: 0.2,
                    );
                  },
                  itemCount: listaUsuarios.length,
                  itemBuilder: (context, indice) {
                    Usuario usuario = listaUsuarios[indice];
                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, "/mensagens",
                            arguments: usuario);
                      },
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            CachedNetworkImageProvider(usuario.urlImagem),
                      ),
                      title: Text(
                        usuario.nome,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(8),
                    );
                  },
                );
              }

              return const Center(
                child: Text(
                  "Nenhum contato encontrado!",
                ),
              );
            }
        }
      },
    );
  }
}
