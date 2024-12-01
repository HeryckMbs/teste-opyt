import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  Input(
      {super.key,
      this.controller,
      required this.nome,
      required this.icon,
      required this.type,
      this.password,
      this.height,
      this.constLines,
      this.dica,
      this.dark,
      this.action,
      required this.validate,
      required this.onChange,
      this.enabled,
      required this.onTap});

  final TextEditingController? controller;
  final nome;
  final icon;
  bool? enabled;
  bool? dark;
  final Function validate;
  final TextInputType type;

  final String? dica;
  final double? height;
  final TextInputAction? action;
  final int? constLines;
  final Function onTap; // nullable and optional
  final Function onChange; // nullable and optional
  final bool? password;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        textInputAction: action ?? TextInputAction.done,
        onChanged: (value) async {
          onChange(value) ?? print('ruim');
        },
        obscureText: password ?? false,
        controller: controller,
        cursorHeight: 30,
        keyboardType: type,
        enabled: enabled,
        maxLines: constLines ?? 1,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 30, left: 30, right: 30),
          hintStyle: TextStyle(
            height: height ?? 1,
          ),
          alignLabelWithHint: true,
          errorStyle: const TextStyle(fontWeight: FontWeight.bold),
          focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.red)),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.red)),
          labelText: nome,
          floatingLabelStyle:  TextStyle(
            fontSize:                               MediaQuery.of(context).size.aspectRatio * 25,

          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                width: 3,
              )),
          filled: true,
        ),
        validator: (value) {
          return validate(value);
        },
      ),
    );
  }
}

Future<DateTime?> showDatePickerOnly({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
  lastDate ??= firstDate.add(const Duration(days: 365 * 200));

  // Exibe apenas o DatePicker
  final DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  return selectedDate; // Retorna apenas a data
}

// ignore: must_be_immutable
class InputDate extends StatelessWidget {
  InputDate(
      {super.key,
      required this.controller,
      required this.nome,
      required this.icon,
      this.dark,
      required this.onTap});

  final TextEditingController controller;
  final nome;
  final icon;
  final Function onTap; // nullable and optional
  bool? dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: TextFormField(
        onTap: () {
          onTap();
        },
        controller: controller,
        showCursor: false,
        readOnly: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 30, left: 30, right: 30),
          alignLabelWithHint: true,
          errorStyle: const TextStyle(fontWeight: FontWeight.bold),
          focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.red)),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.red)),
          labelText: nome,
          floatingLabelStyle: const TextStyle(
            fontSize: 18,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                width: 3,
              )),
          filled: true,
        ),
      ),
    );
  }
}

class Dropdown extends StatelessWidget {
  const Dropdown({
    super.key,
    required String? selectedKey,
    required String name,
    required Function(String?) onChange,
    required List<Map<String, String>> options,
  })  : _selectedKey = selectedKey,
        _options = options,
        name = name,
        _onChange = onChange;

  final String? _selectedKey;
  final String name;
  final List<Map<String, String>> _options;
  final Function(String?) _onChange;

  @override
  Widget build(BuildContext context) {
    final validSelectedKey =
        _options.any((option) => option['key'] == _selectedKey)
            ? _selectedKey
            : null;

    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: validSelectedKey,
      hint: const Text(
        "Selecione uma opção",
      ),
      items: _options.map((option) {
        return DropdownMenuItem<String>(
          value: option['key'],
          child: Text(option['value'] ?? ''),
        );
      }).toList(),
      onChanged: (String? newValue) {
        _onChange(newValue);
      },
      decoration: InputDecoration(
        labelText: name,
        contentPadding: const EdgeInsets.only(top: 30, left: 30, right: 30),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        filled: true,
      ),
      validator: (value) {
        if (value == null) return "Por favor, selecione uma opção";
        return null;
      },
    );
  }
}
