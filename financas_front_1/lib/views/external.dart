// import 'dart:convert';
//
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:financas_app_1/main.dart';
// import 'package:financas_app_1/models/User.dart';
// import 'package:financas_app_1/models/igreja.dart';
// import 'package:financas_app_1/views/login.dart';
// import 'package:financas_app_1/views/utils/utils.dart';
// import 'package:page_transition/page_transition.dart';
//
// import 'package:flutter/material.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:http/http.dart' as http;
//
// import '../controllers/ChurchController.dart';
// import 'church/ListChurch.dart';
// import 'homePage/home.dart';
//
// class HomePublic extends StatefulWidget {
//   HomePublic({super.key});
//   @override
//   _HomePublicState createState() => _HomePublicState();
// }
//
// class _HomePublicState extends State<HomePublic> {
//   bool isLoading = false;
//   final controller = PageController(keepPage: true);
//
//   String selecionado = "home";
//   List<String> mesesDoAno = [
//     'Janeiro',
//     'Fevereiro',
//     'Março',
//     'Abril',
//     'Maio',
//     'Junho',
//     'Julho',
//     'Agosto',
//     'Setembro',
//     'Outubro',
//     'Novembro',
//     'Dezembro'
//   ];
//   List<String> diasDaSemana = [
//     'Segunda-feira',
//     'Terça-feira',
//     'Quarta-feira',
//     'Quinta-feira',
//     'Sexta-feira',
//     'Sábado',
//     'Domingo',
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // bottomNavigationBar: ExternalBottomBar(
//       //   selecionado: selecionado,
//       // ),
//       backgroundColor: const Color(0xFF131112),
//       body: Stack(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height * 0.25,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color.fromRGBO(245, 224, 12, 1),
//                   Color.fromRGBO(255, 184, 0, 1),
//                 ],
//               ),
//             ),
//             child: Container(
//               height: MediaQuery.of(context).size.height,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     // widget.title,
//                     width: MediaQuery.of(context).size.width * 0.25,
//                     height: MediaQuery.of(context).size.height * 0.25,
//                     child: Image.asset('assets/logo.png'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Container(
//           //   height: MediaQuery.of(context).size.height * 0.32,
//           //   decoration: BoxDecoration(
//           //     image: DecorationImage(
//           //       fit: BoxFit.fill,
//           //       opacity: 0.4,
//           //       image: NetworkImage(
//           //           'https://cdn3.vectorstock.com/i/1000x1000/14/12/musicians-and-singers-set-rock-band-vector-6511412.jpg'),
//           //     ),
//           //     borderRadius: const BorderRadius.all(Radius.circular(30)),
//           //   ),
//           // ),
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   // height: MediaQuery.of(context).size.height * 0.7,
//                   margin: EdgeInsets.only(
//                       top: MediaQuery.of(context).size.height * 0.2),
//                   padding: EdgeInsets.symmetric(
//                       vertical: MediaQuery.of(context).size.height * 0.025),
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         topRight: Radius.circular(30)),
//                     color: Color(0xFF131112),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.only(bottom: 20),
//                         child: const Row(
//                           // mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 'Primeira Igreja Batista do Finsocial',
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 18,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 5),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Eventos da Semana',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 25,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       GridView.count(
//                         padding: const EdgeInsets.all(10),
//                         physics: const ScrollPhysics(),
//                         scrollDirection: Axis.vertical,
//                         shrinkWrap: true,
//                         crossAxisCount: 2,
//                         childAspectRatio: 4 / 3,
//                         children: [
//                           InkWell(
//                               onTap: () async {
//
//
//                                 showDialogue(context);
//                                 SharedPreferences prefs =
//                                     await SharedPreferences.getInstance();
//                                 String? accessToken =
//                                     prefs.getString('access_token');
//                                 bool login = false;
//                                 if (getIt.isRegistered<UserCustom>()) {
//                                   List<Igreja> churchs =
//                                       await ChurchController.getChurchs();
//                                   await Navigator.push(
//                                     context,
//                                     PageTransition(
//                                         child: ChurchList(
//                                           churchs: churchs,
//                                         ),
//                                         type: PageTransitionType.fade,
//                                         duration: Duration(milliseconds: 300)),
//                                   );
//                                 } else {
//                                   await Navigator.push(
//                                       context,
//                                       PageTransition(
//                                           child: Login(),
//                                           type: PageTransitionType.fade));
//                                 }
//                                 hideProgressDialogue(context);
//                               },
//                               child: const CardAcoes(
//                                   title: 'Área do membro',
//                                   icone: Icons.emoji_people_outlined,
//                                   iconColor: Color(0xFF263238))),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
