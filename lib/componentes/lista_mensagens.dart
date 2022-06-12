import 'dart:async';
import 'package:provider/provider.dart';
import 'package:whats_app_web/provider/conversa_provider.dart';

import '../modelos/conversa.dart';
import '../modelos/mensagem.dart';
import '../modelos/usuario.dart';
import '../uteis/paleta_cores.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListaMensagens extends StatefulWidget {
  final Usuario usuarioRemetente;
  final Usuario usuarioDestinatario;

  const ListaMensagens({
    Key? key,
    required this.usuarioRemetente,
    required this.usuarioDestinatario,
  }) : super(key: key);

  @override
  _ListaMensagensState createState() => _ListaMensagensState();
}

class _ListaMensagensState extends State<ListaMensagens> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _controllerMensagem = TextEditingController();
  ScrollController _scrollController = ScrollController();
  late Usuario _usuarioRemetente;
  late Usuario _usuarioDestinatario;

  StreamController _streamController =
      StreamController<QuerySnapshot>.broadcast();
  late StreamSubscription _streamMensagens;

  _enviarMensagem() {
    String textoMensagem = _controllerMensagem.text;
    if (textoMensagem.isNotEmpty) {
      String idUsuarioRemetente = _usuarioRemetente.idUsuario;
      Mensagem mensagem = Mensagem(
          idUsuarioRemetente, textoMensagem, Timestamp.now().toString());

      //Salvar mensagem para remetente
      String idUsuarioDestinatario = _usuarioDestinatario.idUsuario;
      _salvarMensagem(idUsuarioRemetente, idUsuarioDestinatario, mensagem);
      Conversa conversaRementente = Conversa(
          idUsuarioRemetente, //jamilton
          idUsuarioDestinatario, // joao
          mensagem.texto,
          _usuarioDestinatario.nome,
          _usuarioDestinatario.email,
          _usuarioDestinatario.urlImagem);
      _salvarConversa(conversaRementente);

      //Salvar mensagem para destinatário
      _salvarMensagem(idUsuarioDestinatario, idUsuarioRemetente, mensagem);
      Conversa conversaDestinatario = Conversa(
          idUsuarioDestinatario, //joão
          idUsuarioRemetente, //jamilton
          mensagem.texto,
          _usuarioRemetente.nome,
          _usuarioRemetente.email,
          _usuarioRemetente.urlImagem);
      _salvarConversa(conversaDestinatario);
    }
  }

  _salvarConversa(Conversa conversa) {
    _firestore
        .collection("conversas")
        .doc(conversa.idRemetente)
        .collection("ultimas_mensagens")
        .doc(conversa.idDestinatario)
        .set(conversa.toMap());
  }

  _salvarMensagem(
      String idRemetente, String idDestinatario, Mensagem mensagem) {
    _firestore
        .collection("mensagens")
        .doc(idRemetente)
        .collection(idDestinatario)
        .add(mensagem.toMap());

    _controllerMensagem.clear();
  }

  _adicionarListenerMensagens() {
    final stream = _firestore
        .collection("mensagens")
        .doc(_usuarioRemetente.idUsuario)
        .collection(_usuarioDestinatario.idUsuario)
        .orderBy("data", descending: false)
        .snapshots();

    _streamMensagens = stream.listen(
      (dados) {
        _streamController.add(dados);
        Timer(
          Duration(seconds: 1),
          () {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          },
        );
      },
    );
  }

  _recuperarDadosInicias() {
    _usuarioRemetente = widget.usuarioRemetente;
    _usuarioDestinatario = widget.usuarioDestinatario;

    _adicionarListenerMensagens();
  }

  _atualizarListenerMensagens() {
    Usuario? usuarioDestinatario =
        context.watch<ConversaProvider>().usuarioDestinatario;

    if (usuarioDestinatario != null) {
      _usuarioDestinatario = usuarioDestinatario;
      _recuperarDadosInicias();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _streamMensagens.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosInicias();
    print("");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies(); //Ciclo de vida de um StatefulWidget
    _atualizarListenerMensagens();
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;

    return Container(
      width: largura,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("imagens/bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          //Listagem de mensagens
          StreamBuilder(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Expanded(
                    child: Center(
                      child: Column(
                        children: const [
                          Text(
                            "Carregando dados",
                          ),
                          CircularProgressIndicator(),
                        ],
                      ),
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
                    QuerySnapshot querySnapshot =
                        snapshot.data as QuerySnapshot;
                    List<DocumentSnapshot> listaMensagens =
                        querySnapshot.docs.toList();

                    return Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (context, indice) {
                          DocumentSnapshot mensagem = listaMensagens[indice];

                          Alignment alinhamento = Alignment.bottomLeft;
                          Color cor = Colors.white;

                          if (_usuarioRemetente.idUsuario ==
                              mensagem["idUsuario"]) {
                            alinhamento = Alignment.bottomRight;
                            cor = const Color(
                              0xffd2ffa5,
                            );
                          }

                          Size largura = MediaQuery.of(context).size * 0.8;

                          return Align(
                            alignment: alinhamento,
                            child: Container(
                              constraints: BoxConstraints.loose(largura),
                              decoration: BoxDecoration(
                                  color: cor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.all(6),
                              child: Text(mensagem["texto"]),
                            ),
                          );
                        },
                      ),
                    );
                  }
              }
            },
          ),

          //Caixa de texto
          Container(
            padding: const EdgeInsets.all(8),
            color: PaletaCores.corFundoBarra,
            child: Row(
              children: [
                //Caixa de texto arredondada
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40)),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_emoticon),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                            child: TextField(
                          controller: _controllerMensagem,
                          decoration: const InputDecoration(
                              hintText: "Digite uma mensagem",
                              border: InputBorder.none),
                        )),
                        const Icon(Icons.attach_file),
                        const Icon(Icons.camera_alt),
                      ],
                    ),
                  ),
                ),

                //Botao Enviar
                FloatingActionButton(
                    backgroundColor: PaletaCores.corPrimaria,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    mini: true,
                    onPressed: () {
                      _enviarMensagem();
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
