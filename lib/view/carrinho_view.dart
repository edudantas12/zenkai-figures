
import 'package:flutter/material.dart';

import '../controller/carrinho_controller.dart';
import '../main.dart';
import '../model/figure.dart';
import 'common_widgets.dart';

class CartPage extends StatefulWidget {
  final List<Figure> products;
  final CarrinhoController controller;
  final VoidCallback onCheckout;

  const CartPage({
    super.key,
    required this.products,
    required this.controller,
    required this.onCheckout,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cep = TextEditingController();

  @override
  void dispose() {
    cep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;

    final items = widget.products
        .where((p) => c.quantidades.containsKey(p.name))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu carrinho'),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'Seu carrinho está vazio',
                style: TextStyle(color: muted),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  '${c.quantidadeTotal} figuras esperando por você',
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),

                ...items.map(
                  (p) => Card(
                    color: panel,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 72,
                              height: 82,
                              color: bg,
                              padding: const EdgeInsets.all(4),
                              child: p.imagePath.isNotEmpty
                                  ? Image.asset(
                                      p.imagePath,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                          child: Text(
                                            p.emoji,
                                            style: const TextStyle(
                                              fontSize: 30,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Text(
                                        p.emoji,
                                        style: const TextStyle(
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'R\$ ${p.price.toStringAsFixed(2).replaceAll('.', ',')}',
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Quantidade: ${c.quantidades[p.name]}',
                                  style: const TextStyle(color: muted),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    constraints: const BoxConstraints.tightFor(
                                      width: 32,
                                      height: 36,
                                    ),
                                    padding: EdgeInsets.zero,
                                    tooltip: 'Diminuir quantidade',
                                    onPressed: () {
                                      setState(() {
                                        c.definirQuantidade(
                                          p,
                                          c.quantidades[p.name]! - 1,
                                        );
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      size: 21,
                                    ),
                                  ),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    constraints: const BoxConstraints.tightFor(
                                      width: 32,
                                      height: 36,
                                    ),
                                    padding: EdgeInsets.zero,
                                    tooltip: 'Aumentar quantidade',
                                    onPressed: () {
                                      setState(() {
                                        c.definirQuantidade(
                                          p,
                                          c.quantidades[p.name]! + 1,
                                        );
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      size: 21,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                constraints: const BoxConstraints.tightFor(
                                  width: 36,
                                  height: 32,
                                ),
                                padding: EdgeInsets.zero,
                                tooltip: 'Remover produto',
                                onPressed: () {
                                  setState(() {
                                    c.definirQuantidade(p, 0);
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: muted,
                                  size: 21,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Calcular entrega',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: cep,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '00000-000',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          if (!c.calcularFrete(cep.text)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Informe um CEP válido.'),
                              ),
                            );
                          }
                        });
                      },
                      child: const Text(
                        'Calcular',
                        style: TextStyle(color: lime),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: panel,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      priceRow(
                        'Subtotal',
                        c.subtotal(widget.products),
                      ),
                      priceRow('Frete', c.frete),
                      const Divider(),
                      priceRow(
                        'Total',
                        c.total(widget.products),
                        bold: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                PrimaryButton(
                  'Finalizar compra',
                  icon: Icons.arrow_forward,
                  onPressed: widget.onCheckout,
                ),
              ],
            ),
    );
  }
}
