import 'package:flutter/foundation.dart';

import '../model/figure.dart';

/// Guarda os filtros aplicados ao catálogo.
class FiltroController extends ChangeNotifier {
  String universo = 'Todos';
  String marca = 'Todas';
  String tipo = 'Todos';
  double precoMaximo = 600;
  bool somenteEstoque = false;

  void atualizar({
    String? novoUniverso,
    String? novaMarca,
    String? novoTipo,
    double? novoPrecoMaximo,
    bool? novoSomenteEstoque,
  }) {
    universo = novoUniverso ?? universo;
    marca = novaMarca ?? marca;
    tipo = novoTipo ?? tipo;
    precoMaximo = novoPrecoMaximo ?? precoMaximo;
    somenteEstoque = novoSomenteEstoque ?? somenteEstoque;
    notifyListeners();
  }

  void limpar() {
    universo = 'Todos';
    marca = 'Todas';
    tipo = 'Todos';
    precoMaximo = 600;
    somenteEstoque = false;
    notifyListeners();
  }

  List<Figure> aplicar(List<Figure> figuras) {
    return figuras.where((figura) {
      return (universo == 'Todos' || figura.universe == universo) &&
          (marca == 'Todas' || figura.brand == marca) &&
          (tipo == 'Todos' || figura.type == tipo) &&
          figura.price <= precoMaximo;
    }).toList(growable: false);
  }
}
