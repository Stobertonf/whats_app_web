import '../uteis/paleta_cores.dart';
import 'package:flutter/material.dart';

class ListaMensagens extends StatefulWidget {
  const ListaMensagens({Key? key}) : super(key: key);

  @override
  _ListaMensagensState createState() => _ListaMensagensState();
}

class _ListaMensagensState extends State<ListaMensagens> {
  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;

    return Container(
      width: largura,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("imagens/bg.png"), fit: BoxFit.cover)),
      child: Column(
        children: [
          //Listagem de mensagens
          Expanded(
              child: Container(
            width: largura,
            color: Colors.orange,
            child: const Text("Lista mensagen"),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40)),
                  child: Row(
                    children: const [
                      Icon(Icons.insert_emoticon),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                          child: TextField(
                        decoration: InputDecoration(
                            hintText: "Digite uma mensagem",
                            border: InputBorder.none),
                      )),
                      Icon(Icons.attach_file),
                      Icon(Icons.camera_alt),
                    ],
                  ),
                )),

                //Botao Enviar
                FloatingActionButton(
                    backgroundColor: PaletaCores.corPrimaria,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    mini: true,
                    onPressed: () {})
              ],
            ),
          )
        ],
      ),
    );
  }
}
