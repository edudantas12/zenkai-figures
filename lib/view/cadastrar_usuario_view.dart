
import 'package:flutter/material.dart';

import '../controller/cadastrar_usuario_controller.dart';
import '../core/erro_app.dart';
import '../core/mascaras.dart';
import '../main.dart';
import 'common_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final controller = getIt<CadastrarUsuarioController>();
  final formKey = GlobalKey<FormState>();

  final nome = TextEditingController();
  final email = TextEditingController();
  final celular = TextEditingController();
  final cep = TextEditingController();
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
    cep.dispose();
    senha.dispose();
    confirmar.dispose();
    super.dispose();
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _criarConta() async {
    if (controller.carregando) return;

    // Mostra o erro embaixo de cada campo inválido.
    final camposValidos = formKey.currentState?.validate() ?? false;

    final erro = controller.validar(
      nome: nome.text,
      email: email.text,
      celular: celular.text,
      cep: cep.text,
      senha: senha.text,
      confirmarSenha: confirmar.text,
      aceitouTermos: aceitou,
    );

    if (!camposValidos || erro != null) {
      _mensagem(erro ?? 'Verifique os campos destacados.');
      return;
    }

    try {
      await controller.cadastrar(
        nome: nome.text,
        email: email.text,
        celular: celular.text,
        cep: cep.text,
        senha: senha.text,
      );
    } on ErroApp catch (e) {
      if (mounted) _mensagem(e.mensagem);
      return;
    }

    if (!mounted) return;
    _mensagem('Cadastro realizado com sucesso!');
    // O usuário já fica autenticado: ao voltar, cai na tela principal.
    Navigator.pop(context);
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
            child: Form(
              key: formKey,
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

                  const Text('Nome'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: nome,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        CadastrarUsuarioController.validarNome(v ?? ''),
                    decoration: const InputDecoration(
                      hintText: 'Como podemos chamar você?',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text('Telefone (celular)'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: celular,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [MascaraTelefone()],
                    validator: (v) =>
                        CadastrarUsuarioController.validarTelefone(v ?? ''),
                    decoration: const InputDecoration(
                      hintText: '(11) 99999-9999',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text('CEP'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: cep,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [MascaraCep()],
                    validator: (v) =>
                        CadastrarUsuarioController.validarCep(v ?? ''),
                    decoration: const InputDecoration(
                      hintText: '00000-000',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text('E-mail'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    validator: (v) =>
                        CadastrarUsuarioController.validarEmail(v ?? ''),
                    decoration: const InputDecoration(
                      hintText: 'voce@exemplo.com',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text('Senha'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: senha,
                    obscureText: !mostrar,
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        CadastrarUsuarioController.validarSenha(v ?? ''),
                    decoration: InputDecoration(
                      hintText: 'Mínimo 8 caracteres e um número',
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
                  TextFormField(
                    controller: confirmar,
                    obscureText: !mostrar,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _criarConta(),
                    validator: (v) => (v ?? '').isEmpty
                        ? 'Repita sua senha.'
                        : v != senha.text
                            ? 'As senhas não coincidem.'
                            : null,
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

                  ListenableBuilder(
                    listenable: controller,
                    builder: (context, _) => controller.carregando
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: CircularProgressIndicator(color: lime),
                            ),
                          )
                        : PrimaryButton(
                            'Criar minha conta',
                            onPressed: _criarConta,
                          ),
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
      ),
    );
  }
}
