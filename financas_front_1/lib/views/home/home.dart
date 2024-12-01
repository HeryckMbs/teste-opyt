import 'package:financas_front_1/repositories/transacao_repository.dart';
import 'package:financas_front_1/views/utils/graphics_utils.dart';
import 'package:financas_front_1/views/utils/utils.dart';
import 'package:financas_front_1/views/utils/form_utils.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void updatePage(index) {}
  final controller = PageController(keepPage: true);
  final controllerMain = PageController(keepPage: true);

  String? ano;

  @override
  void initState() {
    super.initState();

    Provider.of<TransacaoRepository>(context, listen: false)
        .getTransacoesAno('2024');
    Provider.of<TransacaoRepository>(context, listen: false)
        .getTransacoesCategory('2024');
    Provider.of<TransacaoRepository>(context, listen: false).getSaldo('2024');
    Provider.of<TransacaoRepository>(context, listen: false)
        .getSaldoReceita('2024');
    Provider.of<TransacaoRepository>(context, listen: false)
        .getSaldoDespesa('2024');
  }

  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  Widget build(BuildContext context) {
    double fontCards = MediaQuery.of(context).size.aspectRatio * 20;

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Dropdown(
                selectedKey: ano,
                options: const [
                  {'key': '2024', 'value': '2024'},
                  {'key': '2023', 'value': '2023'},
                  {'key': '2022', 'value': '2022'},
                  {'key': '2021', 'value': '2021'},
                  {'key': '2020', 'value': '2020'},
                  {'key': '2019', 'value': '2019'},
                  {'key': '2018', 'value': '2018'},
                  {'key': '2017', 'value': '2017'},
                ],
                name: 'Ano',
                onChange: (value) {
                  setState(() {
                    ano = value;
                  });
                  Provider.of<TransacaoRepository>(context, listen: false)
                      .getTransacoesAno(ano!);
                  Provider.of<TransacaoRepository>(context, listen: false)
                      .getTransacoesCategory(ano!);
                  Provider.of<TransacaoRepository>(context, listen: false)
                      .getSaldo(ano!);
                  Provider.of<TransacaoRepository>(context, listen: false)
                      .getSaldoReceita(ano!);
                  Provider.of<TransacaoRepository>(context, listen: false)
                      .getSaldoDespesa(ano!);
                },
              ),
            )),
          ],
        ),
        Row(
          children: [
            SaldoWidget(
              title: 'Saldo Total',
              fontCards:                              MediaQuery.of(context).size.aspectRatio * 24,
              value: formatDoubleToMoney(
                  Provider.of<TransacaoRepository>(context).saldo),
            ),
          ],
        ),
        Row(
          children: [
            SaldoWidget(
              title: 'Receitas',
              fontCards: fontCards,
              value: formatDoubleToMoney(
                  Provider.of<TransacaoRepository>(context).receita),
            ),
            SaldoWidget(
              title: 'Despesas',
              fontCards: fontCards,
              value: formatDoubleToMoney(
                  Provider.of<TransacaoRepository>(context, listen: false)
                      .despesa),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(children: [
                    TransacaoCategoriaChart(),
                    Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 1,
                            child: const TransacoesAno()),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TransacoesAno extends StatelessWidget {
  const TransacoesAno({super.key});

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = [];
    const pilateColor = Colors.purple;
    const quickWorkoutColor = Colors.green;

    final data = context.watch<TransacaoRepository>().transacoesAno;

    for (int mes = 0; mes < 12; mes++) {
      double receita = double.parse(data['receitas'].firstWhere(
          (r) => r['mes'] == mes + 1,
          orElse: () => {'valor': '0.0'})['valor']);
      double despesa = double.parse(data['despesas'].firstWhere(
          (d) => d['mes'] == mes + 1,
          orElse: () => {'valor': '0.0'})['valor']);

      barGroups.add(generateGroupData(mes, receita, despesa));
    }
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Receita e despesa (anual)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          LegendsListWidget(
            legends: [
              Legend('Receita', pilateColor),
              Legend('Despesa', quickWorkoutColor),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: context.watch<TransacaoRepository>().transacoesAno.isEmpty
                ? const Text('Nenhum dado encontrado!',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceBetween,
                      titlesData: const FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: leftTitles,
                            reservedSize: 20,
                          ),
                        ),
                        rightTitles: AxisTitles(),
                        topTitles: AxisTitles(),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: bottomTitles,
                            reservedSize: 20,
                          ),
                        ),
                      ),
                      barTouchData: BarTouchData(enabled: false),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      barGroups: barGroups,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class TransacaoCategoriaChart extends StatelessWidget {
  TransacaoCategoriaChart({
    super.key,
  });
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Transações por Categoria Total',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: LegendsListWidget(
            legends: context
                .watch<TransacaoRepository>()
                .transacoesCategory
                .map<Legend>((transacao) => Legend(
                      '${transacao['categoria']} : ${transacao['percentual'].toStringAsFixed(2)}%',
                      cores[context
                          .watch<TransacaoRepository>()
                          .transacoesCategory
                          .indexOf(transacao)],
                    ))
                .toList(),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.7,
          child: context.watch<TransacaoRepository>().transacoesCategory.isEmpty
              ? const Text('Nenhum dado encontrado!',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ))
              : PieChart(
                  PieChartData(
                    sections: context
                        .watch<TransacaoRepository>()
                        .transacoesCategory
                        .asMap()
                        .map((index, categoria) {
                          // Aqui, 'index' é o índice da lista, 'categoria' é o valor
                          return MapEntry(
                              index,
                              PieChartSectionData(
                                color: cores[index],
                                value: categoria['percentual'],
                                title: formatMoneyValue(categoria['valor']),
                                radius: 70,
                              ));
                        })
                        .values
                        .toList(),
                    pieTouchData: PieTouchData(
                      touchCallback:
                          (FlTouchEvent event, PieTouchResponse? response) {
                        if (!event.isInterestedForInteractions ||
                            response == null ||
                            response.touchedSection == null) {
                          return;
                        }
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class SaldoWidget extends StatelessWidget {
  const SaldoWidget({
    super.key,
    required this.fontCards,
    required this.title,
    required this.value,
  });
  final String title;
  final String value;
  final double fontCards;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
      color: StandardTheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: fontCards,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
