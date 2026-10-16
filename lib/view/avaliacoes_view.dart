
import 'package:flutter/material.dart';

import '../main.dart';
import '../model/figure.dart';
import '../controller/avaliacoes_controller.dart';

class ReviewsPage extends StatelessWidget {
  final Figure figure;
  final AvaliacoesController controller;

  const ReviewsPage({
    super.key,
    required this.figure,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final reviews = controller.buscarPorFigura(figure);

    final media = reviews.isEmpty
        ? 0.0
        : reviews.fold<int>(
              0,
              (total, review) => total + review.nota,
            ) /
            reviews.length;

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
            child: Row(
              children: [
                Text(
                  media.toStringAsFixed(1).replaceAll('.', ','),
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '★' * media.round() +
                            '☆' * (5 - media.round()),
                        style: const TextStyle(
                          color: lime,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '${reviews.length} avaliações',
                        style: const TextStyle(
                          color: muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (reviews.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Este produto ainda não possui avaliações.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted),
                ),
              ),
            ),
          for (final review in reviews)
            Card(
              color: panel,
              child: ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: lime,
                  size: 36,
                ),
                title: Text(
                  '${review.nota} de 5 estrelas',
                ),
                subtitle: Text(
                  '${review.comentario.isEmpty ? "Nenhum comentário escrito." : review.comentario}\n'
                  '${review.data.day.toString().padLeft(2, '0')}/'
                  '${review.data.month.toString().padLeft(2, '0')}/'
                  '${review.data.year}',
                  style: const TextStyle(
                    color: muted,
                    height: 1.6,
                  ),
                ),
                isThreeLine: true,
              ),
            ),
        ],
      ),
    );
  }
}
