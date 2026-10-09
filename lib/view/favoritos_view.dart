
import 'package:flutter/material.dart';

import '../model/figure.dart';
import 'common_widgets.dart';

class FavoritesPage extends StatelessWidget {
  final List<Figure> products;
  final ValueChanged<Figure> onOpen;
  final Set<String> produtosEmOferta;

  const FavoritesPage({
    super.key,
    required this.products,
    required this.onOpen,
    this.produtosEmOferta = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha lista de desejos'),
      ),
      body: products.isEmpty
          ? const Center(
              child: Text('Você ainda não tem favoritos.'),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .62,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length,
              itemBuilder: (_, i) {
                final figure = products[i];

                return ProductCard(
                  figure: figure,
                  favorite: true,
                  onFavorite: () {},
                  onAdd: () {},
                  onOpen: () => onOpen(figure),
                  mostrarDesconto: produtosEmOferta.contains(figure.name),
                );
              },
            ),
    );
  }
}
