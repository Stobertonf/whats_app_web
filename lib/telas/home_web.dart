import 'package:flutter/material.dart';

class HomeWeb extends StatefulWidget {
  const HomeWeb({super.key});

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text(
        "Vai Liverpool",
      ),
    );
  }
}
