import 'package:flutter/foundation.dart';

import '../model/figure.dart';

/// Controla a categoria selecionada na área de ofertas.
class OfertasController extends ChangeNotifier {
  String _universoSelecionado = 'Todas';

  String get universoSelecionado => _universoSelecionado;

  void selecionarUniverso(String universo) {
    if (_universoSelecionado == universo) return;
    _universoSelecionado = universo;
    notifyListeners();
  }

  List<Figure> ofertas(List<Figure> figuras) {
    final resultado = figuras.where((figura) => figura.price < figura.oldPrice);
    if (_universoSelecionado == 'Todas') {
      return resultado.toList(growable: false);
    }
    return resultado
        .where((figura) => figura.universe == _universoSelecionado)
        .toList(growable: false);
  }
}
