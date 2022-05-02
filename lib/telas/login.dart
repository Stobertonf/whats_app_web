import '../uteis/paleta_cores.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerNome =
      TextEditingController(text: "Stoberton Francisco");
  TextEditingController _controllerEmail =
      TextEditingController(text: "stobertonf@gmail.com");
  TextEditingController _controllerSenha =
      TextEditingController(text: "12345678");

  bool _cadastroUsuario = false;

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
                          //Imagem de Perfil
                          Visibility(
                            visible: _cadastroUsuario,
                            child: ClipOval(
                              child: Image.asset(
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
                              onPressed: () {},
                              child: const Text("Selecionar Foto"),
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),
                          //Caixa de texto nome
                          Visibility(
                            //É um bool. True fica visível
                            visible: _cadastroUsuario, //Por padrão é falso
                            child: TextField(
                              controller: _controllerNome,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: "Nome",
                                labelText: "Nome",
                                suffixIcon: Icon(
                                  Icons.person_outline,
                                ),
                              ),
                            ),
                          ),
                          //Email
                          TextField(
                            controller: _controllerEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: "Email",
                              labelText: "Email",
                              suffixIcon: Icon(
                                Icons.email_outlined,
                              ),
                            ),
                          ),

                          //Senha
                          TextField(
                            obscureText: true,
                            controller: _controllerSenha,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: "Senha",
                              labelText: "Senha",
                              suffixIcon: Icon(
                                Icons.lock_outline,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          //botão Login
                          Container(
                            width: double.infinity, //Para ocupar o espaço total
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: PaletaCores.corPrimaria,
                              ),
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
                              Text("Login"),
                              Switch(
                                value: _cadastroUsuario,
                                onChanged: (bool valor) {
                                  setState(() {
                                    _cadastroUsuario = valor;
                                  });
                                },
                              ),
                              Text("Cadastro"),
                            ],
                          ),
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
