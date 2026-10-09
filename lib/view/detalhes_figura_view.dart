
import 'package:flutter/material.dart';

import '../main.dart';
import '../model/figure.dart';
import 'common_widgets.dart';

class DetailPage extends StatelessWidget {
  final Figure figure;
  final bool favorite;
  final VoidCallback onFavorite;
  final VoidCallback onAdd;
  final VoidCallback onReviews;

  const DetailPage({
    super.key,
    required this.figure,
    required this.favorite,
    required this.onFavorite,
    required this.onAdd,
    required this.onReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da figura'),
        actions: [
          IconButton(
            onPressed: onFavorite,
            icon: Icon(
              favorite ? Icons.favorite : Icons.favorite_border,
              color: favorite ? lime : null,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            height: 280,
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                figure.emoji,
                style: const TextStyle(fontSize: 130),
              ),
            ),
          ),
          const SizedBox(height: 18),

          Text(
            figure.universe.toUpperCase(),
            style: const TextStyle(
              color: lime,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            figure.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            '★★★★★  4,9  •  48 avaliações',
            style: TextStyle(color: lime),
          ),
          const SizedBox(height: 10),

          Text(
            'R\$ ${figure.price.toStringAsFixed(2).replaceAll('.', ',')}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'De R\$ ${figure.oldPrice.toStringAsFixed(2).replaceAll('.', ',')}',
            style: const TextStyle(
              color: muted,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(height: 14),

          PrimaryButton(
            'Adicionar ao carrinho',
            icon: Icons.shopping_bag_outlined,
            onPressed: onAdd,
          ),

          const SizedBox(height: 20),
          const Text(
            'Energia lendária. Detalhes reais.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            figure.description,
            style: const TextStyle(
              color: muted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),

          Card(
            color: panel,
            child: Column(
              children: [
                ListTile(
                  title: const Text('Linha / fabricante'),
                  trailing: Text(figure.brand),
                ),
                ListTile(
                  title: const Text('Altura / material'),
                  trailing: Text(
                    '${figure.height} / ${figure.material}',
                  ),
                ),
                ListTile(
                  title: const Text('Tipo'),
                  trailing: Text(figure.type),
                ),
              ],
            ),
          ),

          TextButton(
            onPressed: onReviews,
            child: const Text(
              'Ver avaliações',
              style: TextStyle(color: lime),
            ),
          ),
        ],
      ),
    );
  }
}
