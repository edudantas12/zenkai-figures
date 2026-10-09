
import 'figure.dart';

class ItemPedido {
  final Figure figura;
  final int quantidade;

  const ItemPedido({
    required this.figura,
    required this.quantidade,
  });

  double get subtotal => figura.price * quantidade;
}

class Pedido {
  final List<ItemPedido> itens;
  final double total;
  final DateTime data;
  final String status;

  Pedido({
    required List<ItemPedido> itens,
    required this.total,
    required this.data,
    this.status = 'Confirmado',
  }) : itens = List.unmodifiable(itens);
}
