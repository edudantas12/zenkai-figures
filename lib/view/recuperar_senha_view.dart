
import 'package:flutter/material.dart';

import '../controller/recuperar_senha_controller.dart';
import '../main.dart';
import 'common_widgets.dart';

class RecoverPage extends StatefulWidget {
  const RecoverPage({super.key});

  @override
  State<RecoverPage> createState() => _RecoverPageState();
}

class _RecoverPageState extends State<RecoverPage> {
  final controller = RecuperarSenhaController();
  final email = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar senha'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.key_outlined,
              color: lime,
              size: 65,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Esqueceu a senha? A gente te ajuda.',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Informe o e-mail cadastrado. Em uma integração real, '
            'enviaremos um link para redefinir sua senha.',
            style: TextStyle(color: muted),
          ),
          const SizedBox(height: 22),
          const Text('E-mail cadastrado'),
          const SizedBox(height: 6),
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'voce@exemplo.com',
              prefixIcon: Icon(Icons.mail_outline),
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            'Enviar link de recuperação',
            onPressed: () {
              if (!controller.emailValido(email.text)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Informe um e-mail válido.'),
                  ),
                );
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Solicitação registrada para demonstração.',
                  ),
                ),
              );
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Voltar para o login',
              style: TextStyle(color: lime),
            ),
          ),
        ],
      ),
    );
  }
}
