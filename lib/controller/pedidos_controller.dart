
import 'package:flutter/foundation.dart';

import '../model/figure.dart';
import '../model/pedido.dart';

class PedidosController extends ChangeNotifier {
  final List<Pedido> _pedidos = [];

  List<Pedido> get pedidos => List.unmodifiable(_pedidos);

  void registrarPedido({
    required List<Figure> produtos,
    required Map<String, int> quantidades,
    required double total,
  }) {
    final itens = produtos
        .where((figura) => (quantidades[figura.name] ?? 0) > 0)
        .map(
          (figura) => ItemPedido(
            figura: figura,
            quantidade: quantidades[figura.name]!,
          ),
        )
        .toList();

    if (itens.isEmpty) return;

    _pedidos.insert(
      0,
      Pedido(
        itens: itens,
        total: total,
        data: DateTime.now(),
      ),
    );

    notifyListeners();
  }
  
  void marcarComoEntregue(int index) {
    if (index < 0 || index >= _pedidos.length) {
      return;
    }

    _pedidos[index] = _pedidos[index].copyWith(
      status: 'Entregue',
    );

    notifyListeners();
  }

}
