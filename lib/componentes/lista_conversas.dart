import 'dart:async';
import '../uteis/responsivo.dart';
import '../modelos/usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/conversa_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListaConversas extends StatefulWidget {
  const ListaConversas({Key? key}) : super(key: key);

  @override
  _ListaConversasState createState() => _ListaConversasState();
}

class _ListaConversasState extends State<ListaConversas> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  late Usuario _usuarioRemetente;
  StreamController _streamController =
      StreamController<QuerySnapshot>.broadcast();
  late StreamSubscription _streamConversas;

  _adicionarListenerConversas() {
    final stream = _firestore
        .collection("conversas")
        .doc(_usuarioRemetente.idUsuario)
        .collection("ultimas_mensagens")
        .snapshots();

    _streamConversas = stream.listen((dados) {
      _streamController.add(dados);
    });
  }

  _recuperarDadosIniciais() {
    User? usuarioLogado = _auth.currentUser;
    if (usuarioLogado != null) {
      String idUsuario = usuarioLogado.uid;
      String? nome = usuarioLogado.displayName ?? "";
      String? email = usuarioLogado.email ?? "";
      String? urlImagem = usuarioLogado.photoURL ?? "";

      _usuarioRemetente = Usuario(idUsuario, nome, email, urlImagem: urlImagem);
    }

    _adicionarListenerConversas();
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosIniciais();
  }

  @override
  void dispose() {
    _streamConversas.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsivo.isMobile(context);

    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: const [
                  Text("Carregando conversas"),
                  CircularProgressIndicator(),
                ],
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Erro ao carregar os dados!",
                ),
              );
            } else {
              QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
              List<DocumentSnapshot> listaConversas =
                  querySnapshot.docs.toList();

              return ListView.separated(
                separatorBuilder: (context, indice) {
                  return const Divider(
                    color: Colors.grey,
                    thickness: 0.2,
                  );
                },
                itemCount: listaConversas.length,
                itemBuilder: (context, indice) {
                  DocumentSnapshot conversa = listaConversas[indice];
                  String urlImagemDestinatario =
                      conversa["urlImagemDestinatario"];
                  String nomeDestinatario = conversa["nomeDestinatario"];
                  String emailDestinatario = conversa["emailDestinatario"];
                  String ultimaMensagem = conversa["ultimaMensagem"];
                  String idDestinatario = conversa["idDestinatario"];

                  Usuario usuario = Usuario(
                      idDestinatario, nomeDestinatario, emailDestinatario,
                      urlImagem: urlImagemDestinatario);

                  return ListTile(
                    onTap: () {
                      if (isMobile) {
                        Navigator.pushNamed(context, "/mensagens",
                            arguments: usuario);
                      } else {
                        context.read<ConversaProvider>().usuarioDestinatario =
                            usuario;
                      }
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
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      ultimaMensagem,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    contentPadding: const EdgeInsets.all(
                      8,
                    ),
                  );
                },
              );
            }
        }
      },
    );
  }
}
