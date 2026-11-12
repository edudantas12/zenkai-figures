import 'package:flutter/services.dart';

/// Máscara de telefone: `(11) 99999-9999` (celular) ou `(11) 3333-4444`.
class MascaraTelefone extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var d = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (d.length > 11) d = d.substring(0, 11);

    final b = StringBuffer();
    for (var i = 0; i < d.length; i++) {
      if (i == 0) b.write('(');
      if (i == 2) b.write(') ');
      // Hífen depois do 5º dígito do número no celular, do 4º no fixo.
      if (i == (d.length == 11 ? 7 : 6)) b.write('-');
      b.write(d[i]);
    }

    final texto = b.toString();
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}

/// Máscara de CEP: `01001-000`.
class MascaraCep extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var d = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (d.length > 8) d = d.substring(0, 8);

    final texto = d.length > 5 ? '${d.substring(0, 5)}-${d.substring(5)}' : d;
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}
