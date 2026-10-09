
import 'package:flutter/material.dart';

import '../controller/cadastrar_usuario_controller.dart';
import '../main.dart';
import 'common_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final controller = CadastrarUsuarioController();

  final nome = TextEditingController();
  final email = TextEditingController();
  final celular = TextEditingController();
  final senha = TextEditingController();
  final confirmar = TextEditingController();

  bool aceitou = false;
  bool mostrar = false;

  @override
  void dispose() {
    controller.dispose();
    nome.dispose();
    email.dispose();
    celular.dispose();
    senha.dispose();
    confirmar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta'),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.all(22),
              children: [
                const Text(
                  'SUA COLEÇÃO EM OUTRO NÍVEL',
                  style: TextStyle(
                    color: lime,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Toda coleção começa com uma conexão.',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Faça parte da Zenkai. Novidades, ofertas e figuras '
                  'que contam a sua história.',
                  style: TextStyle(color: muted),
                ),
                const SizedBox(height: 22),

                const Text('Nome de usuário'),
                const SizedBox(height: 6),
                TextField(
                  controller: nome,
                  decoration: const InputDecoration(
                    hintText: 'Como podemos chamar você?',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 14),

                const Text('E-mail'),
                const SizedBox(height: 6),
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'voce@exemplo.com',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                ),
                const SizedBox(height: 14),

                const Text('Celular'),
                const SizedBox(height: 6),
                TextField(
                  controller: celular,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: '(11) 99999-9999',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 14),

                const Text('Senha'),
                const SizedBox(height: 6),
                TextField(
                  controller: senha,
                  obscureText: !mostrar,
                  decoration: InputDecoration(
                    hintText: 'Crie uma senha segura',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          mostrar = !mostrar;
                        });
                      },
                      icon: Icon(
                        mostrar
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                const Text('Confirmar senha'),
                const SizedBox(height: 6),
                TextField(
                  controller: confirmar,
                  obscureText: !mostrar,
                  decoration: const InputDecoration(
                    hintText: 'Repita sua senha',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),

                CheckboxListTile(
                  value: aceitou,
                  onChanged: (v) {
                    setState(() {
                      aceitou = v ?? false;
                    });
                  },
                  activeColor: lime,
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Li e aceito os Termos de uso e a Política de '
                    'privacidade.',
                    style: TextStyle(
                      color: muted,
                      fontSize: 12,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                PrimaryButton(
                  'Criar minha conta',
                  onPressed: () {
                    final erro = controller.validar(
                      nome: nome.text,
                      email: email.text,
                      celular: celular.text,
                      senha: senha.text,
                      confirmarSenha: confirmar.text,
                      aceitouTermos: aceitou,
                    );

                    if (erro != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(erro)),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Conta criada para demonstração.',
                        ),
                      ),
                    );

                    Navigator.pop(context);
                  },
                ),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Já faz parte da coleção? Entrar',
                      style: TextStyle(color: lime),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
