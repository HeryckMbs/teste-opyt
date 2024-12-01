import 'package:financas_front_1/repositories/transacao_repository.dart';
import 'package:financas_front_1/views/utils/utils.dart';
import 'package:financas_front_1/views/utils/form_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HistoricoTransacao extends StatefulWidget {
  @override
  _HistoricoTransacaoState createState() => _HistoricoTransacaoState();
}

class _HistoricoTransacaoState extends State<HistoricoTransacao> {
  TextEditingController dtInicio = TextEditingController();
  TextEditingController dtFim = TextEditingController();
  String? categoria;
  String? ordenacao;

  @override
  void initState() {
    super.initState();
    Provider.of<TransacaoRepository>(context, listen: false).setCategorias('');
  }

  @override
  void dispose() {
    dtFim.dispose();
    dtInicio.dispose();
    categoria == null;
    super.dispose();
  }

  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: 10, top: MediaQuery.of(context).size.height * 0.025),
                child: InputDate(
                    controller: dtInicio,
                    nome: 'Data Início',
                    icon: Icons.date_range,
                    onTap: () async {
                      DateTime dataHora =
                          await showDatePickerOnly(context: context) ??
                              DateTime.now();

                      String formattedDate =
                          DateFormat('dd/MM/yyyy', 'pt_BR').format(dataHora);
                      dtInicio.text = formattedDate;
                    }),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.025),
                child: InputDate(
                    controller: dtFim,
                    nome: 'Data Fim',
                    icon: Icons.date_range,
                    onTap: () async {
                      DateTime dataHora =
                          await showDatePickerOnly(context: context) ??
                              DateTime.now();

                      String formattedDate =
                          DateFormat('dd/MM/yyyy', 'pt_BR').format(dataHora);
                      dtFim.text = formattedDate;
                    }),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                  padding: EdgeInsets.only(
                      right: 10,
                      top: MediaQuery.of(context).size.height * 0.025),
                  child: Dropdown(
                    selectedKey: categoria,
                    options:
                        context.watch<TransacaoRepository>().categoriasMenuItem,
                    name: 'Categoria',
                    onChange: (value) {
                      setState(() {
                        categoria = value;
                      });
                    },
                  )),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.025),
                child: Dropdown(
                  selectedKey: ordenacao,
                  options: const [
                    {'key': 'valor_desc', 'value': 'Valor (Decrescente)'},
                    {'key': 'data_desc', 'value': 'Data (Decrescente)'},
                    {'key': 'valor_asc', 'value': 'Valor (Crescente)'},
                    {'key': 'data_asc', 'value': 'Data (Crescente)'},
                  ],
                  name: 'Ordenar Por',
                  onChange: (value) {
                    setState(() {
                      ordenacao = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(
                  right: 10, top: MediaQuery.of(context).size.height * 0.025),
              child: ActionButton(
                  onTap: () {
                    setState(() {
                      dtInicio.text = '';
                      dtFim.text = '';
                      categoria = null;
                    });
                    Provider.of<TransacaoRepository>(context, listen: false)
                        .clearTransacoes();
                  },
                  icon: Icons.delete,
                  iconColor: StandardTheme.primary),
            )),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.025),
              child: ActionButton(
                  onTap: () {
                    if (dtInicio.text != '' && dtFim.text != '') {
                      Provider.of<TransacaoRepository>(context, listen: false)
                          .getTransacoes(
                              dtInicio.text, dtFim.text, categoria ?? '0',ordenacao ?? 'data_desc');
                    } else {
                      messageToUser(
                          context,
                          'Data de início e Fim são obrigatórios!',
                          Colors.amber,
                          Icons.dangerous);
                    }
                  },
                  icon: Icons.search,
                  iconColor: StandardTheme.primary),
            ))
          ],
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: context.watch<TransacaoRepository>().transacoes.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(
                        context
                                    .watch<TransacaoRepository>()
                                    .transacoes[index]
                                    .tipo ==
                                'receita'
                            ? Icons.savings
                            : Icons.request_quote,
                        size: MediaQuery.of(context).size.height * 0.05,
                        color: context
                                    .watch<TransacaoRepository>()
                                    .transacoes[index]
                                    .tipo ==
                                'receita'
                            ? Colors.green
                            : Colors.red,
                      ),
                      Container(
                        width: 2,
                        height: MediaQuery.of(context).size.height * 0.1,
                        color: Colors.blueGrey,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context
                                  .watch<TransacaoRepository>()
                                  .transacoes[index]
                                  .descricao!,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Valor: ${formatador.format(context.watch<TransacaoRepository>().transacoes[index].valor)}',
                              
                            ),
                            Text(
                              'Categoria: ${context.watch<TransacaoRepository>().transacoes[index].categoria!.nome}',
                            ),
                            Text(
                              'Data: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(context.watch<TransacaoRepository>().transacoes[index].competencia!))}',
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            })
      ],
    );
  }
}
