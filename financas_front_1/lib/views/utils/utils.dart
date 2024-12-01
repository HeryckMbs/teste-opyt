import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StandardTheme {
  static Color primary = const Color(0xFF533495);
  static Color disabledPrimary = const Color(0xFF7952C0);

  static Color fontColor = const Color.fromRGBO(0, 0, 0, 10);
}

String formatMoneyValue(double value) {
  if (value >= 1e9) {
    return '${(value / 1e9).toStringAsFixed(2)}B';
  } else if (value >= 1e6) {
    return '${(value / 1e6).toStringAsFixed(2)}M';
  } else if (value >= 1e3) {
    return '${(value / 1e3).toStringAsFixed(2)}K';
  }
  return value.toStringAsFixed(2);
}

formatDoubleToMoney(double value) {
  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  if (value < 0) {
    return 'R\$ ${formatador.format(value).replaceFirst('R\$', '').trim()}';
  }
  return formatador.format(value);
}

double realParaFloat(String valor) {
  String somenteNumeros = valor.replaceAll(RegExp(r'[^\d,]'), '');

  somenteNumeros = somenteNumeros.replaceAll(',', '.');
  return double.parse(somenteNumeros);
}

Color getRandomColor() {
  Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256), // Red: 0-255
    random.nextInt(256), // Green: 0-255
    random.nextInt(256), // Blue: 0-255
    1.0,
  );
}

class Traducao {
  static List<String> meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  static List<String> diasSemana = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo'
  ];
}

// ignore: must_be_immutable

class ElevatedButtonCustom extends StatelessWidget {
  const ElevatedButtonCustom(
      {super.key,
      required this.onPressed,
      required this.name,
      this.colorText,
      this.full,
      this.icon,
      required this.color});

  final Function onPressed;
  final bool? full;
  final String name;
  final IconData? icon;
  final Color color;
  final Color? colorText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // ignore: prefer_if_null_operators
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: () async {
        onPressed();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: full != null ? MainAxisSize.max : MainAxisSize.min,
          children: [
            icon != null
                ? Icon(
                    icon,
                    color: colorText ?? Colors.black,
                  )
                : Container(),
            Text(
              name,
              style: TextStyle(
                color: colorText ?? Colors.black,
                fontSize: MediaQuery.of(context).size.aspectRatio * 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Color> cores = [
  Colors.green,
  Colors.blue,
  Colors.purple,
  Colors.orange,
  Colors.teal,
  Colors.cyan,
  Colors.amber,
  Colors.red,
  Colors.deepOrange,
  Colors.indigo,
  Colors.blueGrey,
  Colors.greenAccent,
  Colors.yellow,
  Colors.brown,
  Colors.pink,
  Colors.deepPurple,
  Colors.lightBlue,
  Colors.grey,
  Colors.black,
  Colors.green[900]!
];

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.iconColor,
  });

  final Function onTap;
  final Color iconColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        onTap();
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Icon(icon, color: iconColor),
        ),
      ),
    );
  }
}

void messageToUser(
    BuildContext context, String message, Color color, IconData icon) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 2000,
      content: Row(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Text(message),
        )
      ]),
      backgroundColor: color,
    ),
  );
}
