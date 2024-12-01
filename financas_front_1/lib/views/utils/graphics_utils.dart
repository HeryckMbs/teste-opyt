import 'package:financas_front_1/views/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LegendWidget extends StatelessWidget {
  const LegendWidget({
    super.key,
    required this.name,
    required this.color,
  });
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xff757391),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class LegendsListWidget extends StatelessWidget {
  const LegendsListWidget({
    super.key,
    required this.legends,
  });
  final List<Legend> legends;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: legends
          .map(
            (e) => LegendWidget(
              name: e.name,
              color: e.color,
            ),
          )
          .toList(),
    );
  }
}

class Legend {
  Legend(this.name, this.color);
  final String name;
  final Color color;
}

BarChartGroupData generateGroupData(
  int x,
  double receita,
  double despesa,
) {
  final pilateColor = Colors.purple;
  final quickWorkoutColor = Colors.green;
  final betweenSpace = 0.2;

  return BarChartGroupData(
    x: x,
    groupVertically: true,
    barRods: [
      BarChartRodData(
        fromY: 0,
        toY: receita,
        borderRadius: null,
        color: pilateColor,
        width: 10,
      ),
      BarChartRodData(
          fromY: receita + betweenSpace,
          toY: receita + betweenSpace + despesa,
          color: quickWorkoutColor,
          width: 10,
          borderRadius: null),
    ],
  );
}

Widget leftTitles(double value, TitleMeta meta) {
  const style = TextStyle(fontSize: 6);
  return SideTitleWidget(
    axisSide: meta.axisSide,
    
    child: Text(formatMoneyValue(value), style: style),
  );
}

Widget bottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(fontSize: 8);
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'JAN';
      break;
    case 1:
      text = 'FEV';
      break;
    case 2:
      text = 'MAR';
      break;
    case 3:
      text = 'ABR';
      break;
    case 4:
      text = 'MAI';
      break;
    case 5:
      text = 'JUN';
      break;
    case 6:
      text = 'JUL';
      break;
    case 7:
      text = 'AGO';
      break;
    case 8:
      text = 'SET';
      break;
    case 9:
      text = 'OUT';
      break;
    case 10:
      text = 'NOV';
      break;
    case 11:
      text = 'DEZ';
      break;
    default:
      text = '';
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(text, style: style),
  );
}
