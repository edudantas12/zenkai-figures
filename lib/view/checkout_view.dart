
import 'package:flutter/material.dart';

import '../main.dart';
import 'common_widgets.dart';

class CheckoutPage extends StatefulWidget {
  final double total;
  final VoidCallback onConfirmar;

  const CheckoutPage({
    super.key,
    required this.total,
    required this.onConfirmar,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String formaPagamento = 'Pix';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar compra'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            color: lime,
            size: 56,
          ),
          const SizedBox(height: 16),
          const Text(
            'Quase lá!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Confira seu pedido e escolha a forma de pagamento.',
            style: TextStyle(color: muted),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF393D3D),
              ),
            ),
            child: Column(
              children: [
                priceRow('Total do pedido', widget.total),
                const Divider(height: 28),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Total a pagar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ${widget.total.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: const TextStyle(
                        color: lime,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
          const Text(
            'Forma de pagamento',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          _opcaoPagamento(
            titulo: 'Pix',
            descricao: 'Pagamento instantâneo (demonstrativo)',
            icone: Icons.pix,
            valor: 'Pix',
          ),
          const SizedBox(height: 10),
          _opcaoPagamento(
            titulo: 'Cartão de crédito',
            descricao: 'Simulação de pagamento no cartão',
            icone: Icons.credit_card,
            valor: 'Cartão de crédito',
          ),

          const SizedBox(height: 28),

          PrimaryButton(
            'Confirmar pedido',
            icon: Icons.check_circle_outline,
            onPressed: _confirmar,
          ),

          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Demonstração: nenhum pagamento real será realizado.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: muted,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _opcaoPagamento({
    required String titulo,
    required String descricao,
    required IconData icone,
    required String valor,
  }) {
    final selecionado = formaPagamento == valor;

    return InkWell(
      onTap: () => setState(() => formaPagamento = valor),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: panel,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selecionado ? lime : const Color(0xFF393D3D),
            width: selecionado ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icone, color: lime, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descricao,
                    style: const TextStyle(
                      color: muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selecionado
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selecionado ? lime : muted,
            ),
          ],
        ),
      ),
    );
  }

  
  Future<void> _confirmar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar pedido?'),
        content: Text(
          'Forma de pagamento: $formaPagamento\n'
          'Total: R\$ ${widget.total.toStringAsFixed(2).replaceAll('.', ',')}\n\n'
          'Esta é uma compra demonstrativa. Nenhum pagamento real será feito.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Voltar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    widget.onConfirmar();

    if (!mounted) return;

    if (!mounted) return;

    final navigator = Navigator.of(context);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: lime,
          size: 48,
        ),
        title: const Text('Pedido confirmado!'),
        content: const Text(
          'Seu pedido demonstrativo foi concluído com sucesso.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              navigator.pop();
            }, 
            child: const Text('Concluir'),
          ),
        ],
      ),
    );
  }
}
