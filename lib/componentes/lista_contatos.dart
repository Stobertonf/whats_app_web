import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:whats_app_web/modelos/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListaContatos extends StatefulWidget {
  const ListaContatos({super.key});

  @override
  State<ListaContatos> createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  late String _idUsuarioLogado;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Usuario>> _recuperContatos() async {
    final usarioRef = _firestore.collection("usuario");
    QuerySnapshot querySnapshot = await usarioRef.get();
    List<Usuario> listaUsuarios = [];

    for (DocumentSnapshot item in querySnapshot.docs) {
      String idUsuario = item["idUsuario"];
      if (idUsuario == _idUsuarioLogado) continue;
      String email = item["email"];
      String nome = item["nome"];
      String urlImagem = item["urlImagem"];

      Usuario usario = Usuario(
        idUsuario,
        nome,
        email,
        urlImagem: urlImagem,
      );

      listaUsuarios.add(usario);
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
    _recuperarDadosUsuarioLogado;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
      future: _recuperContatos(),
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
                  separatorBuilder: (context, indexe) {
                    return const Divider(
                      color: Colors.grey,
                      thickness: 0.2,
                    );
                  },
                  itemCount: listaUsuarios.length,
                  itemBuilder: (context, indice) {
                    Usuario usuario = listaUsuarios[indice];

                    return ListTile(
                      onTap: () {},
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
                child: Text("Nenhum contato encontrado!"),
              );
            }
        }
      },
    );
  }
}
