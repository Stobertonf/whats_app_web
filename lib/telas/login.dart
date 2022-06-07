import 'dart:typed_data';
import '../modelos/usuario.dart';
import '../uteis/paleta_cores.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerNome =
      TextEditingController(text: "Stoberton Francisco");
  TextEditingController _controllerEmail =
      TextEditingController(text: "stobertonf@gmail.com");
  TextEditingController _controllerSenha =
      TextEditingController(text: "12345678");
  bool _cadastroUsuario = false;
  Uint8List? _arquivoImagemSelecionado;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  _verificarUsuarioLogado() async {
   User? usuarioLogado = await _auth.currentUser;

    if (usuarioLogado != null) {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  _selecionarImagem() async {
    //Selecionar arquivo
    FilePickerResult? resultado =
        await FilePicker.platform.pickFiles(type: FileType.image);

    //Recuperando o arquivo
    setState(() {
      _arquivoImagemSelecionado = resultado?.files.single.bytes;
    });
  }


  //Upload Imagem

  _uploadImagem(Usuario usuario) {
    Uint8List? arquivoSelecionado = _arquivoImagemSelecionado;
    if (arquivoSelecionado != null) {
      Reference imagemPerfilRef =
          _storage.ref("imagens/perfil/${usuario.idUsuario}.jpg");
      UploadTask uploadTask = imagemPerfilRef.putData(arquivoSelecionado);

      uploadTask.whenComplete(() async {
        String urImagem = await uploadTask.snapshot.ref.getDownloadURL();
        usuario.urlImagem = urImagem;

        //Atualiza url e nome nos dados do usuário
        await _auth.currentUser?.updateDisplayName(usuario.nome);
        await _auth.currentUser?.updatePhotoURL(usuario.urlImagem);

        final usuariosRef = _firestore.collection("usuarios");
        usuariosRef.doc(usuario.idUsuario).set(usuario.toMap()).then((value) {

          //Enviando rotas para a tela principal da app
          Navigator.pushReplacementNamed(context, "/home");
        });
      });
    }
  }

  _validarCampos() async {
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length > 6) {
        if (_cadastroUsuario) {
          if (_arquivoImagemSelecionado != null) {
            //Cadastro
            if (nome.isNotEmpty && nome.length >= 3) {
              await _auth
                  .createUserWithEmailAndPassword(email: email, password: senha)
                  .then((auth) {
                //Upload
                String? idUsuario = auth.user?.uid;
                if (idUsuario != null) {
                  Usuario usuario = Usuario(idUsuario, nome, email);
                  _uploadImagem(usuario);
                }


                //print("Usuário cadastrado: $idUsuario");
              });
            } else {
              print("Nome inválido, digite ao menos 3 caracteres");
            }
          } else {
            print("Selecione uma imagem");
          }
        } else {
          //Login
          await _auth
              .signInWithEmailAndPassword(email: email, password: senha)
              .then((auth) {
            //tela principal
            Navigator.pushReplacementNamed(context, "/home");
          });
        }
      } else {
        print("Senha inválida");
      }
    } else {
      print("Email inválido");
    }
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: PaletaCores.corFundo,
        height: alturaTela,
        width: larguraTela,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: larguraTela,
                height: alturaTela * 0.5, //Definindo o espaço da Altura.
                color: PaletaCores.corPrimaria,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      width: 500,
                      child: Column(
                        children: [
                          //Imagem perfil com botão
                          Visibility(
                            visible: _cadastroUsuario,
                            child: ClipOval(
                              child: _arquivoImagemSelecionado != null
                                  ? Image.memory(
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      _arquivoImagemSelecionado!,
                                    )
                                  : Image.asset(
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      "images/perfil.png",
                                    ),
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Visibility(
                            visible: _cadastroUsuario,
                            child: OutlinedButton(
                                onPressed: _selecionarImagem,
                                child: const Text("Selecionar Foto")),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          //Caixa de texto nome
                          Visibility(

                            visible: _cadastroUsuario,
                            child: TextField(
                              controller: _controllerNome,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  hintText: "Nome",
                                  labelText: "Nome",
                                  suffixIcon: Icon(Icons.person_outline)),
                            ),
                          ),

                          //Caixa de texto email
                          TextField(
                            controller: _controllerEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                hintText: "Email",
                                labelText: "Email",
                                suffixIcon: Icon(Icons.mail_outline)),
                          ),

                          //Senha
                          TextField(
                            obscureText: true,
                            controller: _controllerSenha,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(

                              hintText: "Senha",
                              labelText: "Senha",
                              suffixIcon: Icon(Icons.lock_outline),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          //botão Login
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _validarCampos();
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: PaletaCores.corPrimaria),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Text(
                                  _cadastroUsuario ? "Cadastro" : "Login",
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Login",
                              ),
                              Switch(
                                  value: _cadastroUsuario,
                                  onChanged: (bool valor) {
                                    setState(() {
                                      _cadastroUsuario = valor;
                                    });
                                  }),
                              const Text(
                                "Cadastro",
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
