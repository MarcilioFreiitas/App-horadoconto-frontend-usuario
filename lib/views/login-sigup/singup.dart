import 'package:flutter/material.dart';
import 'package:hora_do_conto/service/auth_service_sigunp.dart';
import 'package:hora_do_conto/views/login-sigup/login.dart';
import 'package:hora_do_conto/widgets/my_input_field.dart';
import 'package:hora_do_conto/widgets/my_text_button.dart';

class SingUp extends StatefulWidget {
  @override
  _SingUpState createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  late TextEditingController nomeController;
  late TextEditingController sobreNomeController;
  late TextEditingController emailController;
  late TextEditingController cpfController;
  late TextEditingController passwordController;

  bool _isLoading = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    sobreNomeController = TextEditingController();
    nomeController = TextEditingController();
    emailController = TextEditingController();
    cpfController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 170,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/images/logo1.png"),
                    width: 200,
                  ),
                  SizedBox(height: 1.0),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 35,
                      ),
                      Column(
                        children: [
                          MyinputField(
                            label: 'Nome',
                            placeholder: "Nome",
                            onChange: (value) {
                              this.nomeController.text = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, insira seu nome';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          MyinputField(
                            label: 'Sobre nome',
                            placeholder: "Sobre nome",
                            onChange: (value) {
                              this.sobreNomeController.text = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, insira seu sobre nome';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          MyinputField(
                            label: 'Email',
                            placeholder: "Endereço de email",
                            onChange: (value) {
                              this.emailController.text = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Por favor, insira um e-mail válido';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          MyinputField(
                            label: 'CPF',
                            placeholder: "CPF",
                            onChange: (value) {
                              this.cpfController.text = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, insira seu CPF';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          MyinputField(
                            label: 'Senha',
                            placeholder: "Senha",
                            onChange: (value) {
                              this.passwordController.text = value;
                            },
                            isSenhaField: true,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 8) {
                                return 'A senha deve ter pelo menos 8 caracteres';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          MyTextButton(
                              label: "Cadastrar",
                              onTap: () async {
                                setState(() {
                                  _isLoading = true;
                                  _errorMessage = '';
                                });
                                try {
                                  signup(
                                      nomeController.text,
                                      sobreNomeController.text,
                                      emailController.text,
                                      passwordController.text,
                                      cpfController.text);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Usuário cadastrado com sucesso!')),
                                  );
                                  Navigator.pop(context);
                                } catch (e) {
                                  setState(() {
                                    _isLoading = false;
                                    _errorMessage = e.toString();
                                  });
                                }
                              }),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Text(
                                  "Já tem uma conta ?",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          const Color.fromARGB(255, 2, 10, 17)),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LogIn()),
                                  );
                                },
                              ),
                              SizedBox(width: 50),
                              Text(
                                "Entrar",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
