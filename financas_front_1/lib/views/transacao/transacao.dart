import 'package:financas_front_1/controllers/TransacaoController.dart';
import 'package:financas_front_1/repositories/template_repository.dart';
import 'package:financas_front_1/repositories/transacao_repository.dart';
import 'package:financas_front_1/views/utils/utils.dart';
import 'package:financas_front_1/views/utils/form_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class AdicionarTransacao extends StatefulWidget {
  @override
  _AdicionarTransacaoState createState() => _AdicionarTransacaoState();
}

class _AdicionarTransacaoState extends State<AdicionarTransacao> {
  TextEditingController dtInicio = TextEditingController();
  TextEditingController descricao = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Valor selecionado
  String? _selectedKey;
  String? _selectedTransacaoKey;

  MoneyMaskedTextController moneyController = MoneyMaskedTextController(
    decimalSeparator: ',', // Padrão brasileiro
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.025),
            child: InputDate(
                controller: dtInicio,
                nome: 'Data',
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
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.025),
            child: Input(
                controller: moneyController,
                nome: 'Valor',
                type: TextInputType.number,
                icon: Icons.cases,
                validate: (value) {
                  if (value == null || value == '') {
                    return 'Obrigatório!';
                  }
                  return null;
                },
                onChange: (value) {},
                onTap: () {}),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.025),
            child: Input(
                controller: descricao,
                nome: 'Descrição',
                type: TextInputType.text,
                icon: Icons.cases,
                validate: (value) {
                  if (value == null || value == '') {
                    return 'Obrigatório!';
                  }
                  return null;
                },
                constLines: 3,
                onChange: (value) {},
                onTap: () {}),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.025),
            child: Dropdown(
              selectedKey: _selectedTransacaoKey,
              options: const [
                {'key': 'receita', 'value': 'Receita'},
                {'key': 'despesa', 'value': 'Despesa'},
              ],
              name: 'Tipo de Transação',
              onChange: (value) async {
                _selectedTransacaoKey = value;
                await Provider.of<TransacaoRepository>(context, listen: false)
                    .setCategorias(value!);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.025),
            child: Dropdown(
              selectedKey: _selectedKey,
              options: context.watch<TransacaoRepository>().categoriasMenuItem,
              name: 'Categoria',
              onChange: (value) {
                setState(() {
                  _selectedKey = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.025),
            child: ElevatedButtonCustom(
              onPressed: () async {
                if (_selectedKey != null &&
                    descricao.text.isNotEmpty &&
                    moneyController.text.isNotEmpty &&
                    dtInicio.text.isNotEmpty) {
                  await TransacaoController.createTransacao(
                      dtInicio.text,
                      realParaFloat(moneyController.text),
                      int.parse(_selectedKey!),
                      descricao.text,
                      _selectedTransacaoKey!);
                  Provider.of<TemplateRepository>(context, listen: false)
                      .setIndex('home');
                  messageToUser(context, 'Transação cadastrada com sucessos',
                      Colors.green, Icons.done);
                } else {
                  String message = 'Todos os campos são obrigatórios!';
                  if (realParaFloat(moneyController.text) <= 0.0) {
                    message += '\nValor não pode ser negativo nem zerado!';
                  }
                  messageToUser(context!, message, Colors.red, Icons.dangerous);
                }
              },
              color: StandardTheme.primary,
              name: 'Cadastrar',
              full: true,
              colorText: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
