import 'package:flutter/foundation.dart';

import '../model/figure.dart';

/// Mantém a figura selecionada e as ações da tela de detalhes.
class DetalhesFiguraController extends ChangeNotifier {
  Figure? _figuraSelecionada;
  bool _favorito = false;

  Figure? get figuraSelecionada => _figuraSelecionada;
  bool get favorito => _favorito;

  void selecionar(Figure figura, {bool favorito = false}) {
    _figuraSelecionada = figura;
    _favorito = favorito;
    notifyListeners();
  }

  void definirFavorito(bool valor) {
    if (_favorito == valor) return;
    _favorito = valor;
    notifyListeners();
  }

  void limparSelecao() {
    _figuraSelecionada = null;
    _favorito = false;
    notifyListeners();
  }
}
