import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/controller/cadastrar_usuario_controller.dart';
import 'package:flutter_application_1/controller/login_controller.dart';
import 'package:flutter_application_1/core/mascaras.dart';
import 'package:flutter_application_1/model/usuario.dart';
import 'package:flutter_test/flutter_test.dart';

String? validarTudo({
  String nome = 'Eduardo',
  String email = 'edu@exemplo.com',
  String celular = '(11) 98765-4321',
  String cep = '01001-000',
  String senha = 'senha1234',
  String? confirmar,
  bool termos = true,
}) {
  // validar() só usa regras locais, não acessa o Firebase.
  return CadastrarUsuarioController.validarNome(nome) ??
      CadastrarUsuarioController.validarTelefone(celular) ??
      CadastrarUsuarioController.validarCep(cep) ??
      CadastrarUsuarioController.validarEmail(email) ??
      CadastrarUsuarioController.validarSenha(senha) ??
      ((confirmar ?? senha) != senha ? 'As senhas não coincidem.' : null) ??
      (!termos ? 'Você precisa aceitar os termos de uso.' : null);
}

String aplicar(TextInputFormatter f, String texto) => f
    .formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(text: texto),
    )
    .text;

void main() {
  group('Cadastro - validação', () {
    test('aceita todos os campos preenchidos corretamente', () {
      expect(validarTudo(), isNull);
    });

    test('bloqueia campos vazios', () {
      expect(validarTudo(nome: ''), 'Informe seu nome.');
      expect(validarTudo(celular: ''), 'Informe seu telefone.');
      expect(validarTudo(cep: ''), 'Informe seu CEP.');
      expect(validarTudo(email: ''), 'Informe seu e-mail.');
      expect(validarTudo(senha: ''), 'Informe uma senha.');
    });

    test('rejeita e-mail inválido', () {
      for (final e in ['edu', 'edu@', 'edu@exemplo', '@exemplo.com', 'a b@c.com']) {
        expect(validarTudo(email: e), 'Informe um e-mail válido.', reason: e);
      }
    });

    test('telefone: celular com 11 dígitos e fixo com 10', () {
      expect(CadastrarUsuarioController.validarTelefone('(11) 98765-4321'), isNull);
      expect(CadastrarUsuarioController.validarTelefone('11987654321'), isNull);
      expect(CadastrarUsuarioController.validarTelefone('(11) 3333-4444'), isNull);
      expect(CadastrarUsuarioController.validarTelefone('98765-4321'), isNotNull);
      expect(CadastrarUsuarioController.validarTelefone('(11) 88765-4321'), isNotNull);
      expect(CadastrarUsuarioController.validarTelefone('(01) 98765-4321'), isNotNull);
      expect(CadastrarUsuarioController.validarTelefone('(20) 98765-4321'), isNotNull);
    });

    test('CEP: exatamente 8 números', () {
      expect(CadastrarUsuarioController.validarCep('01001-000'), isNull);
      expect(CadastrarUsuarioController.validarCep('01001000'), isNull);
      expect(CadastrarUsuarioController.validarCep('0100100'), 'O CEP deve ter 8 números.');
      expect(CadastrarUsuarioController.validarCep('010010001'), 'O CEP deve ter 8 números.');
      expect(CadastrarUsuarioController.validarCep('00000000'), 'Informe um CEP válido.');
    });

    test('senha: mínimo 8 caracteres e um número', () {
      expect(CadastrarUsuarioController.validarSenha('curta1'), isNotNull);
      expect(CadastrarUsuarioController.validarSenha('semnumeros'), isNotNull);
      expect(CadastrarUsuarioController.validarSenha('senha1234'), isNull);
    });

    test('senhas diferentes e termos não aceitos', () {
      expect(validarTudo(confirmar: 'outra1234'), 'As senhas não coincidem.');
      expect(validarTudo(termos: false), 'Você precisa aceitar os termos de uso.');
    });
  });

  group('Login - validação', () {
    final login = LoginController();

    test('bloqueia campos vazios e e-mail inválido', () {
      expect(login.validar('', ''), 'Informe o e-mail e a senha.');
      expect(login.validar('edu@exemplo.com', ''), 'Informe o e-mail e a senha.');
      expect(login.validar('edu', 'senha1234'), 'Informe um e-mail válido.');
      expect(login.validar('edu@exemplo.com', 'senha1234'), isNull);
    });
  });

  group('Máscaras', () {
    test('telefone', () {
      expect(aplicar(MascaraTelefone(), '11987654321'), '(11) 98765-4321');
      expect(aplicar(MascaraTelefone(), '1133334444'), '(11) 3333-4444');
      expect(aplicar(MascaraTelefone(), '119876543219999'), '(11) 98765-4321');
    });

    test('CEP', () {
      expect(aplicar(MascaraCep(), '01001000'), '01001-000');
      expect(aplicar(MascaraCep(), '01001'), '01001');
      expect(aplicar(MascaraCep(), 'ab01001000999'), '01001-000');
    });
  });

  group('Model Usuario', () {
    final data = DateTime.utc(2026, 11, 11, 12);
    final usuario = Usuario(
      uid: 'abc123',
      nome: 'Eduardo',
      telefone: '11987654321',
      cep: '01001000',
      email: 'edu@exemplo.com',
      dataCadastro: data,
    );

    test('toMap tem os campos esperados e nenhuma senha', () {
      final mapa = usuario.toMap();
      expect(
        mapa.keys.toSet(),
        {'uid', 'nome', 'telefone', 'cep', 'email', 'dataCadastro'},
      );
      expect(mapa['dataCadastro'], isA<Timestamp>());
      expect(mapa.keys.any((k) => k.toLowerCase().contains('senha')), isFalse);
    });

    test('fromMap reconstrói o objeto (ida e volta)', () {
      final copia = Usuario.fromMap('abc123', usuario.toMap());
      expect(copia.uid, 'abc123');
      expect(copia.nome, 'Eduardo');
      expect(copia.telefone, '11987654321');
      expect(copia.cep, '01001000');
      expect(copia.email, 'edu@exemplo.com');
      // toDate() devolve horário local: compara o instante, não o fuso.
      expect(copia.dataCadastro!.isAtSameMomentAs(data), isTrue);
    });

    test('fromMap tolera campos ausentes e usa o ID como uid', () {
      final u = Usuario.fromMap('xyz', const {});
      expect(u.uid, 'xyz');
      expect(u.nome, '');
      expect(u.dataCadastro, isNull);
    });

    test('formatação de telefone e CEP', () {
      expect(usuario.telefoneFormatado, '(11) 98765-4321');
      expect(usuario.cepFormatado, '01001-000');
    });
  });
}
