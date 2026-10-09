
import 'package:flutter/material.dart';

import '../model/figure.dart';
import 'common_widgets.dart';

class OffersPage extends StatelessWidget {
  final List<Figure> products;
  final ValueChanged<Figure> onAdd;
  final ValueChanged<Figure> onOpen;
  final ValueChanged<Figure> onFavorite;
  final bool Function(Figure) ehFavorito;

  const OffersPage({
    super.key,
    required this.products,
    required this.onAdd,
    required this.onOpen,
    required this.onFavorite,
    required this.ehFavorito,
  }); 

  @override
  Widget build(BuildContext context) {
    final ofertas = products
        .where((p) => p.price < p.oldPrice)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ofertas Zenkai'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .62,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: ofertas.length,
        itemBuilder: (_, i) => ProductCard(
          figure: ofertas[i],
          favorite: ehFavorito(ofertas[i]),
          onFavorite: () => onFavorite(ofertas[i]),
          onAdd: () => onAdd(ofertas[i]),
          onOpen: () => onOpen(ofertas[i]),
          mostrarDesconto: true,
        ),
      ),
    );
  }
}
