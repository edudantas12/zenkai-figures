import 'package:flutter/material.dart';

import '../main.dart';
import '../model/figure.dart';

class ReviewsPage extends StatelessWidget {
  final Figure figure;

  const ReviewsPage({
    super.key,
    required this.figure,
  });

  @override
  Widget build(BuildContext context) {
    final reviews = <Map<String, String>>[
      {
        'nome': 'Mariana Costa',
        'comentario':
            'O destaque da minha coleção! A pintura é impecável e chegou bem protegido.',
      },
      {
        'nome': 'Rafael Lima',
        'comentario':
            'Original e cheio de detalhes. A base e o acabamento são ótimos.',
      },
      {
        'nome': 'Bruno Alves',
        'comentario': 'Figura linda, caixa em ótimo estado e entrega rápida.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            figure.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Row(
              children: [
                Text(
                  '4,9',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '★★★★★',
                        style: TextStyle(color: lime, fontSize: 20),
                      ),
                      Text(
                        '48 avaliações',
                        style: TextStyle(color: muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (final review in reviews)
            Card(
              color: panel,
              child: ListTile(
                title: Text(review['nome']!),
                subtitle: Text(
                  '${review['comentario']}\n★★★★★',
                  style: const TextStyle(color: muted, height: 1.6),
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}
