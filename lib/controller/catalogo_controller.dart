import 'package:flutter/foundation.dart';

import '../model/figure.dart';

/// Gerencia pesquisa, catálogo e lista de favoritos.
class CatalogoController extends ChangeNotifier {
  String _consulta = '';
  final Set<String> _favoritos = <String>{};

  String get consulta => _consulta;
  Set<String> get favoritos => Set.unmodifiable(_favoritos);

  void pesquisar(String valor) {
    if (_consulta == valor) return;
    _consulta = valor;
    notifyListeners();
  }

  List<Figure> filtrar(List<Figure> figuras) {
    final termo = _consulta.trim().toLowerCase();
    if (termo.isEmpty) return List.unmodifiable(figuras);
    return figuras.where((figura) {
      return figura.name.toLowerCase().contains(termo) ||
          figura.universe.toLowerCase().contains(termo) ||
          figura.brand.toLowerCase().contains(termo);
    }).toList(growable: false);
  }

  bool ehFavorito(Figure figura) => _favoritos.contains(figura.name);

  void alternarFavorito(Figure figura) {
    if (!_favoritos.add(figura.name)) {
      _favoritos.remove(figura.name);
    }
    notifyListeners();
  }
}
