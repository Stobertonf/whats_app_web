import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';

import '../modelos/usuario.dart';
import '../uteis/responsivo.dart';
import '../uteis/paleta_cores.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeWeb extends StatefulWidget {
  const HomeWeb({super.key});

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  late Usuario _usuarioLogado;
  FirebaseAuth _auth = FirebaseAuth.instance;

  _recuperarDadosUsuarioLogado() {
    User? usuarioLogado = _auth.currentUser;
    if (usuarioLogado != null) {
      String idUsuario = usuarioLogado.uid;
      String? nome = usuarioLogado.displayName ?? "";
      String? email = usuarioLogado.email ?? "";
      String? urlImagem = usuarioLogado.photoURL ?? "";

      _usuarioLogado = Usuario(idUsuario, nome, email, urlImagem: urlImagem);
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = Responsivo.isWeb(context);
    final largura = MediaQuery.of(context).size.width;
    final altura = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: PaletaCores.corFundo,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                width: largura,
                height: altura * 0.2, //Multiplicando por 20% da altura total
                color: PaletaCores.corPrimaria,
              ),
            ),
            Positioned(
              top: isWeb ? altura * 0.05 : 0,
              left: isWeb ? largura * 0.05 : 0,
              right: isWeb ? largura * 0.05 : 0,
              bottom: isWeb ? altura * 0.05 : 0,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: AreaLateralConversas(
                      usuarioLogado: _usuarioLogado,
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: AreaLateralConversas(
                      usuarioLogado: _usuarioLogado,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AreaLateralConversas extends StatelessWidget {
  final Usuario usuarioLogado;

  const AreaLateralConversas({
    Key? key,
    required this.usuarioLogado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: PaletaCores.corFundoBarraClaro,
        border: Border(
          right: BorderSide(
            color: PaletaCores.corFundo,
          ),
        ),
      ),
      child: Column(
        children: [
          //Barra Superiro
          Container(
            padding: const EdgeInsets.all(8),
            color: PaletaCores.corFundoBarraClaro,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(
                    usuarioLogado.urlImagem,
                  ),
                ),
                const Spacer(), //Empurra os itens para o final
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.message,
                  ),
                ),
                IconButton(
                  //Deslogar o Usuário
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                  icon: const Icon(
                    Icons.logout,
                  ),
                ),
              ],
            ),
          ),

          //Barra de pesquisa
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: "Pesquisar uma Conversa",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
