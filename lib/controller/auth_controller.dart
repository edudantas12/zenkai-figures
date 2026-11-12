import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../core/erro_app.dart';

/// Operações de autenticação com o Firebase Authentication.
class AuthController {
  final FirebaseAuth _auth;

  AuthController({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  /// Usuário autenticado no momento (ou `null`).
  User? get usuarioAtual => _auth.currentUser;

  /// Emite sempre que o usuário entra ou sai da conta.
  Stream<User?> get mudancasDeAutenticacao => _auth.authStateChanges();

  /// Cria a conta com e-mail e senha. A senha fica apenas no Authentication.
  Future<User> criarConta({
    required String email,
    required String senha,
  }) async {
    try {
      final credencial = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );
      return credencial.user!;
    } on FirebaseAuthException catch (e) {
      throw ErroApp(mensagemDeErro(e));
    } catch (_) {
      throw const ErroApp(
        'Não foi possível criar a conta. Tente novamente.',
      );
    }
  }

  /// Faz login com e-mail e senha.
  ///
  /// No Flutter Web, [lembrar] define se a sessão continua após fechar o
  /// navegador (`LOCAL`) ou só enquanto a aba estiver aberta (`SESSION`).
  Future<User> entrar({
    required String email,
    required String senha,
    bool lembrar = true,
  }) async {
    try {
      if (kIsWeb) {
        await _auth.setPersistence(
          lembrar ? Persistence.LOCAL : Persistence.SESSION,
        );
      }
      final credencial = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );
      return credencial.user!;
    } on FirebaseAuthException catch (e) {
      throw ErroApp(mensagemDeErro(e));
    } catch (_) {
      throw const ErroApp('Não foi possível entrar. Tente novamente.');
    }
  }

  /// Envia o e-mail do Firebase com o link para redefinir a senha.
  ///
  /// Com a proteção contra enumeração de e-mail ativa, o Firebase não
  /// informa se o e-mail existe: a resposta é a mesma nos dois casos.
  Future<void> enviarRedefinicaoSenha(String email) async {
    try {
      await _auth.setLanguageCode('pt-BR');
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw ErroApp(mensagemDeErro(e));
    } catch (_) {
      throw const ErroApp(
        'Não foi possível enviar o e-mail. Tente novamente.',
      );
    }
  }

  Future<void> sair() async {
    try {
      await _auth.signOut();
    } catch (_) {
      throw const ErroApp('Não foi possível sair da conta.');
    }
  }

  /// Exclui a conta recém-criada. Usado para desfazer um cadastro
  /// quando os dados não puderam ser salvos no Firestore.
  Future<void> excluirContaAtual() async {
    final usuario = _auth.currentUser;
    if (usuario == null) return;
    await usuario.delete();
  }

  /// Traduz os códigos do Firebase Authentication para mensagens claras.
  String mensagemDeErro(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'O e-mail informado é inválido.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'user-not-found':
        return 'Não encontramos uma conta com este e-mail.';
      case 'wrong-password':
        return 'Senha incorreta.';
      // Com a proteção contra enumeração de e-mail ativa, o Firebase
      // não diferencia usuário inexistente de senha errada.
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'A senha é muito fraca.';
      case 'operation-not-allowed':
        return 'O login por e-mail e senha não está habilitado.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde alguns minutos e tente de novo.';
      case 'network-request-failed':
        return 'Sem conexão com a internet. Verifique sua rede.';
      default:
        return 'Erro de autenticação (${e.code}). Tente novamente.';
    }
  }
}
