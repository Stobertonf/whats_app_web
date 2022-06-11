import 'dart:async';
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
    }
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

    _streamMensagens = stream.listen((dados) {
      _streamController.add(dados);
    });
  }

  _recuperarDadosInicias() {
    _usuarioRemetente = widget.usuarioRemetente;
    _usuarioDestinatario = widget.usuarioDestinatario;
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosInicias();
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;

    return Container(
      width: largura,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("imagens/bg.png"),
        ),
      ),
      child: Column(
        children: [
          //Listagem de mensagens
          Expanded(
              child: Container(
            width: largura,
            color: Colors.orange,
            child: const Text(
              "Lista mensagen",
            ),
          )),

          //Caixa de texto
          Container(
            padding: const EdgeInsets.all(8),
            color: PaletaCores.corFundoBarra,
            child: Row(
              children: [
                //Caixa de texto arredondada
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40)),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.insert_emoticon,
                      ),
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
                      const Icon(
                        Icons.attach_file,
                      ),
                      const Icon(
                        Icons.camera_alt,
                      ),
                    ],
                  ),
                )),

                //Botao Enviar
                FloatingActionButton(
                    backgroundColor: PaletaCores.corPrimaria,
                    child: const Icon(
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
