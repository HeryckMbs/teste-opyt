import 'dart:convert';

import 'package:financas_front_1/repositories/template_repository.dart';
import 'package:financas_front_1/repositories/transacao_repository.dart';
import 'package:financas_front_1/views/cadastro.dart';
import 'package:financas_front_1/views/components/base.dart';
import 'package:financas_front_1/views/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:financas_front_1/views/utils/utils.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  await dotenv.load(fileName: "assets/.env");
  bool logged = false;

  if (localStorage.containsKey('access_token')) {
    String accessToken = localStorage.getString('access_token') ?? '';
    DateTime? validUntil = localStorage.getString('valid_until') != null
        ? DateTime.parse(localStorage.getString('valid_until')!)
        : null;

    if (accessToken != '' && validUntil != null) {
      logged = !validUntil.isBefore(DateTime.now());
    }
  }
  if (!logged) {
    localStorage.clear();
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TemplateRepository('home')),
      ChangeNotifierProvider(create: (_) => TransacaoRepository()),
    ],
    child: MyApp(logged: logged),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({super.key, required this.logged});
  bool logged;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  bool settedTheme = false;

  void setTheme(BuildContext context) {
    if (!context.mounted) {
      settedTheme = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TemplateRepository>(context, listen: true).setTheme();

    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('pt', 'BR')
        ],
        title: 'Finanças',
        theme: context.watch<TemplateRepository>().themeSelected,
        debugShowCheckedModeBanner: false,
        home: widget.logged ? BaseHome() : MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.1,
            left: 30,
            right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Center(child: SvgPicture.asset('assets/login.svg', fit: BoxFit.contain,height: MediaQuery.of(context).size.height * 0.33,)),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(
                    image: const AssetImage('assets/logo.png'),
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Bem vindo!',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.aspectRatio * 45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.5),
                    child: Text(
                      'Controle suas finanças de maneira eficiente',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.aspectRatio * 25,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: Cadastro(),
                              type: PageTransitionType.fade));
                    },
                    child:  Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Cadastre-se',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,                           fontSize: MediaQuery.of(context).size.aspectRatio * 20,),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: Login(), type: PageTransitionType.fade));
                    },
                    child: Card(
                      color: StandardTheme.primary,
                      child:  Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Entrar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                             fontSize: MediaQuery.of(context).size.aspectRatio * 20,),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
