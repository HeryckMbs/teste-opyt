import 'package:financas_front_1/repositories/template_repository.dart';
import 'package:financas_front_1/views/login.dart';
import 'package:financas_front_1/views/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class BaseHome extends StatefulWidget {
  @override
  _BaseHomeState createState() => _BaseHomeState();
}

class _BaseHomeState extends State<BaseHome> {
  void updatePage(index) {}

  @override
  void initState() {
    super.initState();
  }

  bool light1 = true;
  final WidgetStateProperty<Icon?> thumbIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(
          Icons.dark_mode,
          color: Colors.black,
        );
      }
      return const Icon(
        Icons.light_mode,
        color: Colors.amber,
      );
    },
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(context.watch<TemplateRepository>().title,style: 
          TextStyle(
            fontSize:                               MediaQuery.of(context).size.aspectRatio * 37,

          ),),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Switch(
                thumbIcon: thumbIcon,
                value: context.watch<TemplateRepository>().darkThemeSelected,
                onChanged: (bool value) {
                  setState(() {
                    Provider.of<TemplateRepository>(context, listen: false)
                        .changeTheme(value);
                  });
                },
              ),
            ),
          ],
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          )),
      body: SingleChildScrollView(
        child: SizedBox(
            child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 25,
              vertical: MediaQuery.of(context).size.height / 50),
          child: context.watch<TemplateRepository>().screen,
        )),
      ),
      drawer: Drawer(
        elevation: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/logo.png'),
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    MenuItem(
                      icon: Icons.home,
                      title: 'Home',
                      color: Provider.of<TemplateRepository>(context,
                                      listen: false)
                                  .currentIndex ==
                              'home'
                          ? StandardTheme.primary
                          : null,
                      onTap: () {
                        Navigator.pop(context);

                        Provider.of<TemplateRepository>(context, listen: false)
                            .setIndex('home');
                      },
                    ),
                    MenuItem(
                      icon: Icons.addchart_sharp,
                      title: 'Adicionar Transação',
                      color: Provider.of<TemplateRepository>(context,
                                      listen: false)
                                  .currentIndex ==
                              'adicionar_transacao'
                          ? StandardTheme.primary
                          : null,
                      onTap: () {
                        Navigator.pop(context);

                        Provider.of<TemplateRepository>(context, listen: false)
                            .setIndex('adicionar_transacao');
                      },
                    ),
                    MenuItem(
                      icon: Icons.history,
                      title: 'Histórico de Transações',
                      color: Provider.of<TemplateRepository>(context,
                                      listen: false)
                                  .currentIndex ==
                              'historico_transacao'
                          ? StandardTheme.primary
                          : null,
                      onTap: () {
                        Navigator.pop(context);

                        Provider.of<TemplateRepository>(context, listen: false)
                            .setIndex('historico_transacao');
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              child: ActionButton(
                  onTap: () async {
                    Navigator.pop(context);

                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        PageTransition(
                            child: Login(), type: PageTransitionType.fade));
                    SharedPreferences localStorage =
                        await SharedPreferences.getInstance();
                    localStorage.clear();
                  },
                  icon: Icons.logout,
                  iconColor: StandardTheme.primary),
            )
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem(
      {super.key,
      required this.onTap,
      this.color,
      required this.title,
      required this.icon});

  final Function onTap;
  final String title;
  final Color? color;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: const BoxDecoration(
          // color: StandardTheme.badge,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Card(
        color: color,
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
             color: color != null? Colors.white:null,
            ),
          ),
          leading: Icon(
            icon,
            color: color != null ? Colors.white : Colors.black,
          ),
          onTap: () {
            onTap();
          },
        ),
      ),
    );
  }
}
