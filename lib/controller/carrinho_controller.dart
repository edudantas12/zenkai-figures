import 'package:flutter/foundation.dart';

import '../model/figure.dart';

/// Gerencia quantidades, subtotal e frete estimado do carrinho.
class CarrinhoController extends ChangeNotifier {
  final Map<String, int> _quantidades = <String, int>{};
  double _frete = 0;
  String _cep = '';

  Map<String, int> get quantidades => Map.unmodifiable(_quantidades);
  String get cep => _cep;
  double get frete => _frete;
  int get quantidadeTotal =>
      _quantidades.values.fold(0, (total, quantidade) => total + quantidade);

  double subtotal(List<Figure> figuras) {
    return figuras
        .where((figura) => _quantidades.containsKey(figura.name))
        .fold(0, (total, figura) =>
            total + figura.price * _quantidades[figura.name]!);
  }

  double total(List<Figure> figuras) => subtotal(figuras) + _frete;

  void adicionar(Figure figura) {
    _quantidades.update(figura.name, (quantidade) => quantidade + 1,
        ifAbsent: () => 1);
    notifyListeners();
  }

  void definirQuantidade(Figure figura, int quantidade) {
    if (quantidade <= 0) {
      _quantidades.remove(figura.name);
    } else {
      _quantidades[figura.name] = quantidade;
    }
    notifyListeners();
  }

  bool calcularFrete(String cepInformado) {
    final somenteNumeros = cepInformado.replaceAll(RegExp(r'\D'), '');
    if (somenteNumeros.length != 8) return false;
    _cep = somenteNumeros;
    _frete = _quantidades.isEmpty ? 0 : 19.90;
    notifyListeners();
    return true;
  }

  void limpar() {
    _quantidades.clear();
    _frete = 0;
    _cep = '';
    notifyListeners();
  }
}
