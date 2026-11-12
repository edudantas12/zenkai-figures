import 'package:flutter/foundation.dart';

import '../core/erro_app.dart';
import '../model/usuario.dart';
import 'auth_controller.dart';
import 'usuario_controller.dart';

/// Regras de validação e fluxo do cadastro de usuário.
class CadastrarUsuarioController extends ChangeNotifier {
  final AuthController _auth;
  final UsuarioController _usuarios;

  CadastrarUsuarioController(this._auth, this._usuarios);

  bool _carregando = false;
  bool get carregando => _carregando;

  static final _regexEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String apenasDigitos(String valor) =>
      valor.replaceAll(RegExp(r'\D'), '');

  static String? validarNome(String nome) {
    final n = nome.trim();
    if (n.isEmpty) return 'Informe seu nome.';
    if (n.length < 2) return 'O nome deve ter pelo menos 2 letras.';
    return null;
  }

  static String? validarEmail(String email) {
    final e = email.trim();
    if (e.isEmpty) return 'Informe seu e-mail.';
    if (!_regexEmail.hasMatch(e)) return 'Informe um e-mail válido.';
    return null;
  }

  /// Aceita celular com 11 dígitos (DDD + 9 + 8 dígitos) ou fixo com 10.
  static String? validarTelefone(String telefone) {
    final d = apenasDigitos(telefone);
    if (d.isEmpty) return 'Informe seu telefone.';
    if (d.length != 10 && d.length != 11) {
      return 'Telefone deve ter DDD + número, ex.: (11) 99999-9999.';
    }
    final ddd = int.parse(d.substring(0, 2));
    if (ddd < 11 || ddd % 10 == 0) return 'Informe um DDD válido.';
    if (d.length == 11 && d[2] != '9') {
      return 'Celular deve começar com 9 após o DDD.';
    }
    return null;
  }

  /// CEP brasileiro: exatamente 8 números.
  static String? validarCep(String cep) {
    final d = apenasDigitos(cep);
    if (d.isEmpty) return 'Informe seu CEP.';
    if (d.length != 8) return 'O CEP deve ter 8 números.';
    if (RegExp(r'^(\d)\1{7}$').hasMatch(d)) return 'Informe um CEP válido.';
    return null;
  }

  static String? validarSenha(String senha) {
    if (senha.isEmpty) return 'Informe uma senha.';
    if (senha.length < 8 || !RegExp(r'\d').hasMatch(senha)) {
      return 'A senha deve ter pelo menos 8 caracteres e um número.';
    }
    return null;
  }

  /// Valida o formulário e devolve a primeira mensagem de erro (ou `null`).
  String? validar({
    required String nome,
    required String email,
    required String celular,
    required String cep,
    required String senha,
    required String confirmarSenha,
    required bool aceitouTermos,
  }) {
    return validarNome(nome) ??
        validarTelefone(celular) ??
        validarCep(cep) ??
        validarEmail(email) ??
        validarSenha(senha) ??
        (senha != confirmarSenha ? 'As senhas não coincidem.' : null) ??
        (!aceitouTermos ? 'Você precisa aceitar os termos de uso.' : null);
  }

  /// Cria a conta no Authentication e salva os dados em `usuarios/{uid}`.
  ///
  /// Se a gravação no Firestore falhar, a conta recém-criada é excluída
  /// para não deixar um cadastro pela metade, e um [ErroApp] é lançado.
  Future<void> cadastrar({
    required String nome,
    required String email,
    required String celular,
    required String cep,
    required String senha,
  }) async {
    final auth = _auth;
    final usuarios = _usuarios;

    _carregando = true;
    notifyListeners();

    try {
      final user = await auth.criarConta(email: email, senha: senha);

      try {
        await usuarios.salvar(
          Usuario(
            uid: user.uid,
            nome: nome.trim(),
            telefone: apenasDigitos(celular),
            cep: apenasDigitos(cep),
            // Mesmo e-mail registrado no Authentication (as regras de
            // segurança conferem com o token).
            email: user.email ?? email.trim(),
          ),
        );
      } on ErroApp catch (erroFirestore) {
        try {
          await auth.excluirContaAtual();
        } catch (_) {
          await auth.sair();
          throw ErroApp(
            'Sua conta foi criada, mas não conseguimos salvar seus dados '
            '(${erroFirestore.mensagem}). Entre em contato com o suporte '
            'antes de tentar novamente.',
          );
        }
        throw ErroApp(
          'Não foi possível concluir o cadastro: ${erroFirestore.mensagem} '
          'Nenhuma conta foi criada, tente novamente.',
        );
      }
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }
}
