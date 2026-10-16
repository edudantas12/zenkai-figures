
import 'package:flutter/material.dart';

import '../main.dart';
import '../model/pedido.dart';
import '../controller/avaliacoes_controller.dart';
import 'nova_avaliacao_view.dart';

class PedidosPage extends StatelessWidget {
  final void Function(int index) onMarcarEntregue;
  final List<Pedido> pedidos;
  final AvaliacoesController avaliacoesController;
  final VoidCallback onAtualizar;

  const PedidosPage({
    required this.onMarcarEntregue,
    super.key,
    required this.pedidos,
    required this.avaliacoesController,
    required this.onAtualizar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus pedidos'),
      ),
      body: pedidos.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nenhum pedido ainda',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Seus pedidos aparecerão aqui após a confirmação da compra.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];

                return Card(
                  color: panel,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.receipt_long,
                              color: lime,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Pedido #${pedidos.length - index}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              pedido.status,
                              style: const TextStyle(color: lime),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Data: ${pedido.data.day.toString().padLeft(2, '0')}/'
                          '${pedido.data.month.toString().padLeft(2, '0')}/'
                          '${pedido.data.year}',
                          style: const TextStyle(color: muted),
                        ),
                        const Divider(height: 24),
                        ...pedido.itens.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    item.figura.imagePath,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return SizedBox(
                                        width: 64,
                                        height: 64,
                                        child: Center(
                                          child: Text(
                                            item.figura.emoji,
                                            style: const TextStyle(
                                              fontSize: 28,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.figura.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${item.quantidade} x R\$ '
                                        '${item.figura.price.toStringAsFixed(2).replaceAll('.', ',')}',
                                        style: const TextStyle(
                                          color: muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'R\$ ${item.subtotal.toStringAsFixed(2).replaceAll('.', ',')}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Total do pedido',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              'R\$ ${pedido.total.toStringAsFixed(2).replaceAll('.', ',')}',
                              style: const TextStyle(
                                color: lime,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        
                        if (pedido.status != 'Entregue') ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => onMarcarEntregue(index),
                              icon: const Icon(Icons.local_shipping_outlined),
                              label: const Text('Simular entrega'),
                            ),
                          ),
                        ],
                        
                        if (pedido.status == 'Entregue') ...[
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () async {
                                for (final item in pedido.itens) {
                                  await Navigator.push<void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (_) => NovaAvaliacaoPage(
                                        figura: item.figura,
                                        controller: avaliacoesController,
                                        onSalvar: onAtualizar,
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.star_outline),
                              label: const Text('Avaliar compra'),
                            ),
                          ),
                        ],


                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
