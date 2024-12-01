import 'package:financas_front_1/controllers/UserController.dart';
import 'package:financas_front_1/main.dart';
import 'package:financas_front_1/models/user.dart';
import 'package:financas_front_1/views/components/base.dart';
import 'package:flutter/material.dart';
import 'package:financas_front_1/views/utils/utils.dart';
import 'package:financas_front_1/views/utils/form_utils.dart';
import 'package:page_transition/page_transition.dart';

class Login extends StatefulWidget {
  Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  @override
  void dispose() {
    // Limpa os controladores quando o widget for descartado
    email.dispose();
    senha.dispose();
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
                    Navigator.push(
                        context,
                        PageTransition(
                            child: MyHomePage(),
                            type: PageTransitionType.fade));
                  },
                  child:  Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size:                               MediaQuery.of(context).size.aspectRatio * 40,
                    weight: 1,
                  ),
                ),
                 Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 0),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize:                               MediaQuery.of(context).size.aspectRatio * 40,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          // "email": "cc",
          //"password": "SenhaForte123"

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.80,
            width: MediaQuery.of(context).size.width,
            child: Card(
              margin: const EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.all(38.0),
                child: ListView(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seja bem vindo de volta!',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.aspectRatio * 25,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'É sempre bom ter você aqui! ',
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.aspectRatio * 20,
                        ),
                      ),
                      // InputElement(type: )
                      Padding(
                        padding: const EdgeInsets.only(bottom: 28.0, top: 24),
                        child: Input(
                          nome: 'E-mail',
                          type: TextInputType.text,
                          onChange: (value) {},
                          onTap: () {},
                          password: false,
                          validate: (value) {},
                          icon: null,
                          action: TextInputAction.next,
                          controller: email,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 38.0),
                        child: Input(
                          type: TextInputType.text,
                          onTap: () {},
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
                          if (email.text.isEmpty && senha.text.isEmpty) {
                            messageToUser(
                                context,
                                'Todos os campos são obrigatórios',
                                Colors.red,
                                Icons.dangerous);
                          } else {
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
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                              color: email.text.isEmpty && senha.text.isEmpty
                                  ? StandardTheme.disabledPrimary
                                  : StandardTheme.primary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.aspectRatio * 20,
                            ),
                          ),
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                      //   child: Text('Esqueceu sua senha?',style: TextStyle(color: StandardTheme.primary,fontWeight: FontWeight.bold,fontSize: 15),),
                      // )
                    ],
                  ),
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
