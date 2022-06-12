import 'dart:math';

import '../uteis/paleta_cores.dart';
import 'package:flutter/material.dart';

class HomeWeb extends StatefulWidget {
  const HomeWeb({super.key});

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final altura = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: PaletaCores.corFundo,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: largura,
                height: altura * 0.2, //Multiplicando por 20% da altura total
                color: PaletaCores.corPrimaria,
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              bottom: 20,
              child: Row(
                children: const [
                  Expanded(
                    flex: 4,
                    child: AreaLateralConversas(),
                  ),
                  Expanded(
                    flex: 10,
                    child: AreaLateralConversas(),
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
  const AreaLateralConversas({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      color: Colors.orange,
    );
  }
}
