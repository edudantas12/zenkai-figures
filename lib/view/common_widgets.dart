
import 'package:flutter/material.dart';

import '../main.dart';
import '../model/figure.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;

  const PrimaryButton(
    this.label, {
    super.key,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.arrow_forward),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: lime,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Figure figure;
  final bool favorite;
  final VoidCallback onFavorite;
  final VoidCallback onAdd;
  final VoidCallback onOpen;
  final bool mostrarDesconto;

  const ProductCard({
    super.key,
    required this.figure,
    required this.favorite,
    required this.onFavorite,
    required this.onAdd,
    required this.onOpen,
    this.mostrarDesconto = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: panel,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: figure.imagePath.isNotEmpty
                            ? Image.asset(
                                figure.imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Text('Erro ao carregar: $error');
                                },
                              )
                            : Text(
                                figure.emoji,
                                style: const TextStyle(fontSize: 58),
                              ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        onPressed: onFavorite,
                        icon: Icon(
                          favorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: favorite ? lime : Colors.white,
                        ),
                      ),
                    ),
                    if (mostrarDesconto && figure.discount > 0)
                      Positioned(
                        left: 5,
                        top: 5,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: lime,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '-${figure.discount}%',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                figure.universe.toUpperCase(),
                style: const TextStyle(
                  color: muted,
                  fontSize: 9,
                ),
              ),
              Text(
                figure.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (mostrarDesconto) ...[
                Text(
                  'R\$ ${figure.oldPrice.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                  'R\$ ${figure.price.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(
                    color: lime,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ] else
                Text(
                  'R\$ ${figure.oldPrice.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: onAdd,
                  icon: const Icon(
                    Icons.add_circle,
                    color: lime,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class InfoPage extends StatelessWidget {
  final String title;
  final String message;

  const InfoPage({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDadosPessoais = title == 'Dados pessoais';

    final partes = message.split('\n');
    String nome = '';
    String email = '';

    for (final parte in partes) {
      if (parte.startsWith('Nome de usuário:')) {
        nome = parte.replaceFirst('Nome de usuário:', '').trim();
      } else if (parte.startsWith('E-mail:')) {
        email = parte.replaceFirst('E-mail:', '').trim();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: isDadosPessoais
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),

                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF29351D),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: lime,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: lime,
                            size: 52,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          nome.isEmpty ? 'Usuário' : nome,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Suas informações pessoais',
                          style: TextStyle(
                            color: muted,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  const Text(
                    'INFORMAÇÕES DA CONTA',
                    style: TextStyle(
                      color: lime,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.3,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: panel,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFF393D3D),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              color: lime,
                              size: 26,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Nome de usuário',
                                    style: TextStyle(
                                      color: muted,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    nome.isEmpty ? 'Não informado' : nome,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          child: Divider(
                            color: Color(0xFF393D3D),
                            height: 1,
                          ),
                        ),

                        Row(
                          children: [
                            const Icon(
                              Icons.mail_outline,
                              color: lime,
                              size: 26,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'E-mail',
                                    style: TextStyle(
                                      color: muted,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    email.isEmpty
                                        ? 'Não informado'
                                        : email,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Voltar ao perfil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lime,
                        foregroundColor: bg,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: muted),
                ),
              ),
            ),
    );
  }
}


Widget priceRow(
  String label,
  double value, {
  bool bold = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: bold
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ),
        Text(
          'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}',
          style: TextStyle(
            fontWeight: bold
                ? FontWeight.bold
                : FontWeight.normal,
            fontSize: bold ? 20 : 14,
          ),
        ),
      ],
    ),
  );
}
