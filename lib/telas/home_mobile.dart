import '../modelos/usuario.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../componentes/lista_contatos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeMobileState createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  // ignore: prefer_final_fields
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("WhatsApp"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
              ),
            ),
            const SizedBox(
              width: 3.0,
            ),
            IconButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, "/login");
              },
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            labelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                text: "Conversas",
              ),
              Tab(
                text: "Contatos",
              ),
            ],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              Center(
                child: Text("Conversas"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: ListaContatos(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
