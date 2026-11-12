import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../controller/cadastrar_usuario_controller.dart';
import '../controller/usuario_controller.dart';
import '../core/erro_app.dart';
import '../core/mascaras.dart';
import '../main.dart';
import '../model/usuario.dart';
import 'common_widgets.dart';

/// Exibe, em tempo real, os dados do documento `usuarios/{uid}` do
/// usuário autenticado. Qualquer alteração no Firestore aparece na hora.
class InformacoesUsuarioPage extends StatefulWidget {
  const InformacoesUsuarioPage({super.key});

  @override
  State<InformacoesUsuarioPage> createState() =>
      _InformacoesUsuarioPageState();
}

class _InformacoesUsuarioPageState extends State<InformacoesUsuarioPage> {
  final auth = getIt<AuthController>();
  final usuarios = getIt<UsuarioController>();

  /// Criado uma única vez: o StreamBuilder mantém a mesma assinatura.
  Stream<Usuario?>? _stream;

  @override
  void initState() {
    super.initState();
    final uid = auth.usuarioAtual?.uid;
    if (uid != null) _stream = usuarios.stream(uid);
  }

  Future<void> _editar(Usuario usuario) async {
    final alterado = await showDialog<Usuario>(
      context: context,
      builder: (_) => _EditarInformacoesDialog(usuario: usuario),
    );
    if (alterado == null || !mounted) return;

    try {
      await usuarios.atualizar(
        usuario.uid,
        nome: alterado.nome,
        telefone: alterado.telefone,
        cep: alterado.cep,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informações atualizadas com sucesso!')),
      );
    } on ErroApp catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.mensagem)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações do usuário'),
        centerTitle: true,
      ),
      body: _stream == null
          ? const _Aviso(
              icone: Icons.lock_outline,
              titulo: 'Você não está conectado',
              mensagem: 'Entre na sua conta para ver suas informações.',
            )
          : StreamBuilder<Usuario?>(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  final erro = snapshot.error;
                  return _Aviso(
                    icone: Icons.cloud_off_outlined,
                    titulo: 'Não foi possível carregar',
                    mensagem: erro is FirebaseException
                        ? usuarios.mensagemDeErro(erro)
                        : 'Erro inesperado ao carregar seus dados.',
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: lime),
                  );
                }

                final usuario = snapshot.data;
                if (usuario == null) {
                  return const _Aviso(
                    icone: Icons.person_off_outlined,
                    titulo: 'Nenhum dado encontrado',
                    mensagem:
                        'Não encontramos suas informações de cadastro.',
                  );
                }

                return _conteudo(usuario);
              },
            ),
    );
  }

  Widget _conteudo(Usuario usuario) {
    final itens = <_ItemInfo>[
      _ItemInfo(Icons.person_outline, 'Nome', usuario.nome),
      _ItemInfo(
        Icons.phone_outlined,
        'Telefone',
        usuario.telefoneFormatado,
      ),
      _ItemInfo(Icons.location_on_outlined, 'CEP', usuario.cepFormatado),
      _ItemInfo(Icons.mail_outline, 'E-mail', usuario.email),
      _ItemInfo(
        Icons.calendar_today_outlined,
        'Membro desde',
        usuario.dataCadastro == null
            ? 'Registrando...'
            : _formatarData(usuario.dataCadastro!),
      ),
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF29351D),
                  shape: BoxShape.circle,
                  border: Border.all(color: lime, width: 2),
                ),
                child: Center(
                  child: Text(
                    usuario.nome.isEmpty
                        ? 'U'
                        : usuario.nome[0].toUpperCase(),
                    style: const TextStyle(
                      color: lime,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              usuario.nome.isEmpty ? 'Usuário' : usuario.nome,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: lime, size: 9),
                SizedBox(width: 6),
                Text(
                  'Sincronizado em tempo real',
                  style: TextStyle(color: muted, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 32),
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
            for (final item in itens) ...[
              _CartaoInfo(item: item),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 14),
            PrimaryButton(
              'Editar informações',
              icon: Icons.edit_outlined,
              onPressed: () => _editar(usuario),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatarData(DateTime data) {
    String dois(int n) => n.toString().padLeft(2, '0');
    final d = data.toLocal();
    return '${dois(d.day)}/${dois(d.month)}/${d.year}';
  }
}

class _ItemInfo {
  final IconData icone;
  final String rotulo;
  final String valor;

  const _ItemInfo(this.icone, this.rotulo, this.valor);
}

class _CartaoInfo extends StatelessWidget {
  final _ItemInfo item;

  const _CartaoInfo({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF393D3D)),
      ),
      child: Row(
        children: [
          Icon(item.icone, color: lime, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.rotulo,
                  style: const TextStyle(color: muted, fontSize: 13),
                ),
                const SizedBox(height: 5),
                Text(
                  item.valor.isEmpty ? 'Não informado' : item.valor,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Aviso extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String mensagem;

  const _Aviso({
    required this.icone,
    required this.titulo,
    required this.mensagem,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, color: lime, size: 52),
            const SizedBox(height: 14),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: const TextStyle(color: muted),
            ),
          ],
        ),
      ),
    );
  }
}

/// Diálogo para editar nome, telefone e CEP. Devolve o [Usuario] alterado
/// (com telefone e CEP só com dígitos) ou `null` se cancelado.
class _EditarInformacoesDialog extends StatefulWidget {
  final Usuario usuario;

  const _EditarInformacoesDialog({required this.usuario});

  @override
  State<_EditarInformacoesDialog> createState() =>
      _EditarInformacoesDialogState();
}

class _EditarInformacoesDialogState extends State<_EditarInformacoesDialog> {
  final formKey = GlobalKey<FormState>();
  late final nome = TextEditingController(text: widget.usuario.nome);
  late final telefone =
      TextEditingController(text: widget.usuario.telefoneFormatado);
  late final cep = TextEditingController(text: widget.usuario.cepFormatado);

  @override
  void dispose() {
    nome.dispose();
    telefone.dispose();
    cep.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!(formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      widget.usuario.copyWith(
        nome: nome.text.trim(),
        telefone: CadastrarUsuarioController.apenasDigitos(telefone.text),
        cep: CadastrarUsuarioController.apenasDigitos(cep.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: panel,
      title: const Text('Editar informações'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nome,
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    CadastrarUsuarioController.validarNome(v ?? ''),
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: telefone,
                keyboardType: TextInputType.phone,
                inputFormatters: [MascaraTelefone()],
                validator: (v) =>
                    CadastrarUsuarioController.validarTelefone(v ?? ''),
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: cep,
                keyboardType: TextInputType.number,
                inputFormatters: [MascaraCep()],
                validator: (v) =>
                    CadastrarUsuarioController.validarCep(v ?? ''),
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _salvar,
          style: FilledButton.styleFrom(
            backgroundColor: lime,
            foregroundColor: Colors.black,
          ),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
