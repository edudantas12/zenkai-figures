
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

  Pedido copyWith({
    List<ItemPedido>? itens,
    double? total,
    DateTime? data,
    String? status,
  }) {
    return Pedido(
      itens: itens ?? this.itens,
      total: total ?? this.total,
      data: data ?? this.data,
      status: status ?? this.status,
    );
  }
}
