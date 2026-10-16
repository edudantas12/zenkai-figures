
import 'package:flutter/material.dart';

import '../controller/avaliacoes_controller.dart';
import '../model/figure.dart';
import '../main.dart';

class NovaAvaliacaoPage extends StatefulWidget {
  final Figure figura;
  final AvaliacoesController controller;
  final VoidCallback onSalvar;

  const NovaAvaliacaoPage({
    super.key,
    required this.figura,
    required this.controller,
    required this.onSalvar,
  });

  @override
  State<NovaAvaliacaoPage> createState() =>
      _NovaAvaliacaoPageState();
}

class _NovaAvaliacaoPageState
    extends State<NovaAvaliacaoPage> {
  int nota = 5;
  final comentarioController = TextEditingController();

  @override
  void dispose() {
    comentarioController.dispose();
    super.dispose();
  }

  void salvarAvaliacao() {
  widget.controller.adicionar(
    figura: widget.figura,
    nota: nota,
    comentario: comentarioController.text,
  );

  widget.onSalvar();

  Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliar figura'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            widget.figura.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Como você avalia este produto?',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => IconButton(
                onPressed: () {
                  setState(() => nota = index + 1);
                },
                icon: Icon(
                  index < nota
                      ? Icons.star
                      : Icons.star_border,
                  color: lime,
                  size: 36,
                ),
              ),
            ),
          ),
          Center(
            child: Text('$nota de 5 estrelas'),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: comentarioController,
            maxLines: 5,
            maxLength: 500,
            decoration: const InputDecoration(
              labelText: 'Seu comentário',
              hintText: 'Conte como foi sua experiência...',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: salvarAvaliacao,
              child: const Text('Enviar avaliação'),
            ),
          ),
        ],
      ),
    );
  }
}
