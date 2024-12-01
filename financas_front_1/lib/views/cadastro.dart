import 'package:financas_front_1/controllers/UserController.dart';
import 'package:financas_front_1/models/user.dart';
import 'package:financas_front_1/views/components/base.dart';
import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';

import 'package:financas_front_1/views/utils/utils.dart';
import 'package:financas_front_1/views/utils/form_utils.dart';

class Cadastro extends StatefulWidget {
  Cadastro({
    super.key,
  });

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  TextEditingController nome = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    senha.dispose();
    nome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StandardTheme.primary,
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.73),
            padding: const EdgeInsets.symmetric(horizontal: 38),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                    weight: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 0),
                  child: Text(
                    'Cadastro',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.80,
            width: MediaQuery.of(context).size.width,
            child: Card(
              margin: const EdgeInsets.all(0),
              child: Padding(
                  padding: const EdgeInsets.all(38.0),
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Seja bem vindo',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.075,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Cadastre-se e tenha acesso ao um amplo controle das suas finanças!',
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.05,
                                top: 24),
                            child: Input(
                              nome: 'Nome',
                              dark: false,
                              onChange: (value) {},
                              type: TextInputType.text,
                              onTap: () {},
                              password: false,
                              validate: (value) {},
                              icon: null,
                              action: TextInputAction.next,
                              controller: nome,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Input(
                              nome: 'E-mail',
                              onChange: (value) {},
                              onTap: () {},
                              dark: false,
                              type: TextInputType.text,
                              password: false,
                              validate: (value) {},
                              icon: null,
                              action: TextInputAction.next,
                              controller: email,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.width * 0.05,
                            ),
                            child: Input(
                              onTap: () {},
                              type: TextInputType.text,
                              dark: false,
                              validate: (value) {},
                              action: TextInputAction.done,
                              onChange: (value) {},
                              controller: senha,
                              icon: Icons.password,
                              nome: 'Senha',
                              password: true,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (email.text.isEmpty &&
                                  nome.text.isEmpty &&
                                  senha.text.isEmpty) {
                                messageToUser(
                                    context,
                                    'Todos os campos são obrigatórios',
                                    Colors.red,
                                    Icons.dangerous);
                              } else {
                                var a = await UserController.register(
                                    email.text, senha.text, nome.text);
                                if (a['data']['email'] != null) {
                                  var logged = await UserController.login(
                                      email.text, senha.text);
                                  User? user = logged['user'] as User;
                                  if (user.id != null) {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: BaseHome(),
                                            type: PageTransitionType.fade));
                                  } else {
                                    messageToUser(context, logged['message'],
                                        Colors.red, Icons.dangerous);
                                  }
                                }
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(top: 15),
                              decoration: BoxDecoration(
                                  color: email.text.isEmpty &&
                                          nome.text.isEmpty &&
                                          senha.text.isEmpty
                                      ? StandardTheme.disabledPrimary
                                      : StandardTheme.primary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 20),
                              child: const Text(
                                'Cadastrar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
