
import 'package:flutter/material.dart';

import '../controller/sobre_controller.dart';
import '../main.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre a Zenkai'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(18),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                'assets/images/zenkai_logo.png',
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.bolt,
                  color: lime,
                  size: 80,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Mais que figures. Histórias na estante.',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            SobreController.objetivo,
            style: TextStyle(
              color: muted,
              height: 1.5,
            ),
          ),
          const Divider(height: 30),
          const Text(
            'Desenvolvido por',
            style: TextStyle(
              color: lime,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          for (final nome in SobreController.integrantes)
            ListTile(
              leading: const Icon(
                Icons.person_outline,
                color: lime,
              ),
              title: Text(nome),
            ),
          const SizedBox(height: 12),
          const Text(
            'Projeto acadêmico • Zenkai Figures',
            style: TextStyle(
              color: muted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
