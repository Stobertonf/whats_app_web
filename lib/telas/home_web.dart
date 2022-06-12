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
    return Scaffold(
      body: Container(
        color: PaletaCores.corFundo,
        child: Stack(children: [
          Positioned(
            child: Container(
              color: PaletaCores.corPrimaria,
            ),
          ),
        ]),
      ),
    );
  }
}
