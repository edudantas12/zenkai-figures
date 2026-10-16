
import 'package:flutter/foundation.dart';

import '../model/avaliacao.dart';
import '../model/figure.dart';

class AvaliacoesController extends ChangeNotifier {
  final List<Avaliacao> _avaliacoes = [];

  List<Avaliacao> get avaliacoes =>
      List.unmodifiable(_avaliacoes);

  void adicionar({
    required Figure figura,
    required int nota,
    required String comentario,
  }) {
    if (nota < 1 || nota > 5) return;

    final avaliacao = Avaliacao(
      figura: figura,
      nota: nota,
      comentario: comentario.trim(),
      data: DateTime.now(),
    );

    _avaliacoes.add(avaliacao);
    notifyListeners();
  }

  List<Avaliacao> buscarPorFigura(Figure figura) {
    return List.unmodifiable(
      _avaliacoes.where(
        (avaliacao) => avaliacao.figura.name == figura.name,
      ),
    );
  }
}
