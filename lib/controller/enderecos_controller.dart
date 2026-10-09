
import 'package:flutter/foundation.dart';

import '../model/enderecos.dart';

class EnderecosController extends ChangeNotifier {
  final List<Endereco> _enderecos = [];

  List<Endereco> get enderecos =>
      List.unmodifiable(_enderecos);

  void adicionar(Endereco endereco) {
    if (endereco.principal || _enderecos.isEmpty) {
      for (final item in _enderecos) {
        item.principal = false;
      }
      endereco.principal = true;
    }

    _enderecos.add(endereco);
    notifyListeners();
  }

  void definirPrincipal(Endereco endereco) {
    for (final item in _enderecos) {
      item.principal = identical(item, endereco);
    }

    notifyListeners();
  }

  void excluir(Endereco endereco) {
    _enderecos.remove(endereco);

    if (_enderecos.isNotEmpty &&
        !_enderecos.any((item) => item.principal)) {
      _enderecos.first.principal = true;
    }

    notifyListeners();
  }

  void editar(
    Endereco antigo,
    Endereco atualizado,
  ) {
    final indice = _enderecos.indexOf(antigo);

    if (indice == -1) return;

    if (atualizado.principal) {
      for (final item in _enderecos) {
        item.principal = false;
      }
    }

    _enderecos[indice] = atualizado;

    if (!_enderecos.any((item) => item.principal)) {
      _enderecos[indice].principal = true;
    }

    notifyListeners();
  }
}
  