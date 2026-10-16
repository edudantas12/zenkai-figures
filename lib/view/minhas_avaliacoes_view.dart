
import 'package:flutter/material.dart';

import '../controller/avaliacoes_controller.dart';
import '../main.dart';

class MinhasAvaliacoesPage extends StatelessWidget {
  final AvaliacoesController controller;

  const MinhasAvaliacoesPage({
    super.key,
    required this.controller,
  });

 
@override
Widget build(BuildContext context) {
  return AnimatedBuilder(
    animation: controller,
    builder: (context, child) {
      final avaliacoes = controller.avaliacoes;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Minhas avaliações'),
        ),
        body: avaliacoes.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_border,
                        size: 64,
                        color: muted,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Você ainda não fez nenhuma avaliação.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: muted,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: avaliacoes.length,
                itemBuilder: (context, index) {
                  final avaliacao = avaliacoes[index];

                  return Card(
                    color: panel,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      leading: const Icon(
                        Icons.star,
                        color: lime,
                        size: 32,
                      ),
                      title: Text(
                        avaliacao.figura.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${'★' * avaliacao.nota}'
                              '${'☆' * (5 - avaliacao.nota)}',
                              style: const TextStyle(
                                color: lime,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              avaliacao.comentario.isEmpty
                                  ? 'Nenhum comentário escrito.'
                                  : avaliacao.comentario,
                              style: const TextStyle(color: muted),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${avaliacao.data.day.toString().padLeft(2, '0')}/'
                              '${avaliacao.data.month.toString().padLeft(2, '0')}/'
                              '${avaliacao.data.year}',
                              style: const TextStyle(
                                color: muted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      );
    },
  );
}

}
