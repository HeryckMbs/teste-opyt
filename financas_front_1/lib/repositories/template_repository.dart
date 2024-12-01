import 'package:financas_front_1/models/user.dart';
import 'package:financas_front_1/views/home/home.dart';
import 'package:financas_front_1/views/transacao/transacao.dart';
import 'package:financas_front_1/views/transacao/transacao_historico.dart';
import 'package:financas_front_1/views/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemplateRepository with ChangeNotifier, DiagnosticableTreeMixin {
  late String _currentIndex;
  late int idEventoSelecionado;
  String get currentIndex => _currentIndex;
  late String _authToken;
  String get authToken => _authToken;

  late User _currentUser;
  User get currentUser => _currentUser;

  bool _darkThemeSelected = false;
  bool get darkThemeSelected => _darkThemeSelected;

  ThemeData lighThemeData = ThemeData(
      useMaterial3: true,
      fontFamily: 'Montserrat',
      primaryColor: StandardTheme.primary,
      cardTheme: CardTheme(surfaceTintColor: StandardTheme.disabledPrimary));
  ThemeData darkThemeData = ThemeData(
      useMaterial3: true,
      fontFamily: 'Montserrat',
      primaryColor: StandardTheme.primary,
      buttonTheme: ButtonThemeData(
          buttonColor: StandardTheme.primary,
          disabledColor: StandardTheme.disabledPrimary),
      brightness: Brightness.dark,
      cardTheme: CardTheme(surfaceTintColor: StandardTheme.disabledPrimary),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStatePropertyAll(Colors.white),
        thumbColor: WidgetStatePropertyAll(StandardTheme.primary),
      ));
  ThemeData _themeSelected =
      ThemeData(useMaterial3: true, fontFamily: 'Montserrat');
  ThemeData get themeSelected => _themeSelected;

  setTheme() async {
    String theme =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark
            ? 'dark'
            : 'light';
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? themeStored = localStorage.getString('theme') ?? theme;

    if (themeStored != theme) {
      theme = themeStored;
      localStorage.setString('theme', theme);
    }
    _darkThemeSelected = theme == 'dark';

    _themeSelected = _darkThemeSelected ? darkThemeData : lighThemeData;
    notifyListeners();
  }

  changeTheme(bool darkTheme) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('theme', darkTheme ? 'dark' : 'light');
    _darkThemeSelected = darkTheme;
    _themeSelected = _darkThemeSelected ? darkThemeData : lighThemeData;
    notifyListeners();
  }

  final Map<String, Widget> _screens = {
    'home': Home(),
    'adicionar_transacao': AdicionarTransacao(),
    'historico_transacao': HistoricoTransacao()
  };

  final Map<String, String> _titles = {
    'home': 'Home',
    'adicionar_transacao': 'Adicionar Transação',
    'historico_transacao': 'Histórico de Transações'
  };

  Widget get screen => _screens[_currentIndex] ?? Home();
  String get title => _titles[_currentIndex] ?? 'Home';

  TemplateRepository(
    String index,
  ) {
    _currentIndex = index;
    idEventoSelecionado = 0;
    notifyListeners();
    // screens['evento'] = EventoIndex(
    //   idEvento: idEventoSelecionado,
    // );
  }

  setIndex(String index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setEvento(int idEventoo) {
    idEventoSelecionado = idEventoo;
    // screens['evento'] = EventoIndex(
    //   idEvento: idEventoSelecionado,
    // );
    _currentIndex = 'evento';
    notifyListeners();
  }
}
