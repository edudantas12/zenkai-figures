
import 'package:flutter/material.dart';

import '../main.dart';
import 'common_widgets.dart';
import '../controller/enderecos_controller.dart';
import 'enderecos_view.dart';
import '../controller/avaliacoes_controller.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final String email;
  final int favorites;
  final int cartCount;
  final EnderecosController enderecosController;
  final ValueChanged<String> onName;
  final VoidCallback onLogout;
  final VoidCallback onAbout;
  final VoidCallback onOrders;
  final VoidCallback onFavorites;
  final AvaliacoesController avaliacoesController;
  final VoidCallback onMyReviews;
  

  const ProfilePage({
    super.key,
    required this.username,
    required this.email,
    required this.favorites,
    required this.cartCount,
    required this.enderecosController,
    required this.onName,
    required this.onLogout,
    required this.onAbout,
    required this.onOrders,
    required this.onFavorites,
    required this.avaliacoesController,
    required this.onMyReviews,
   
  });

  
 
  
Future<void> _editName(BuildContext context) async {
  final novoNome = await showDialog<String>(
    context: context,
    builder: (_) => _EditarNomeDialog(nomeAtual: username),
  );

  if (!context.mounted || novoNome == null) return;

  onName(novoNome);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Nome atualizado com sucesso!'),
    ),
  );
}



  Widget _tile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback action,
  ) {
    return ListTile(
      leading: Icon(icon, color: muted),
      title: Text(title),
      trailing: const Icon(
        Icons.chevron_right,
        color: muted,
      ),
      onTap: action,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu perfil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: const Color(0xFF26351D),
                  child: Text(
                    username.isEmpty
                        ? 'U'
                        : username[0].toUpperCase(),
                    style: const TextStyle(
                      color: lime,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => _editName(context),
                  child: const Text('Alterar nome de usuário'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Card(
            color: panel,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stat('$cartCount', 'Pedidos'),
                  _stat(
                    favorites.toString().padLeft(2, '0'),
                    'Favoritos',
                  ),
                  _stat(
                    avaliacoesController.avaliacoes.length.toString(),
                    'Avaliações',
                  ),
                ],  
              ),
            ),
          ),
          const SizedBox(height: 12),
          _tile(
            context,
            Icons.inventory_2_outlined,
            'Meus pedidos',
            onOrders,
          ),
                    
          _tile(
            context,
            Icons.star_outline,
            'Minhas avaliações',
            onMyReviews,
          ),

          _tile(
            context,
            Icons.favorite_border,
            'Minha lista de desejos',
            onFavorites,
          ),
          
          _tile(
            context,
            Icons.person_outline,
            'Dados pessoais',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InfoPage(
                  title: 'Dados pessoais',
                  message:
                      'Nome de usuário: $username\nE-mail: $email',
                ),
              ),
            ),
          ),

          _tile(
            context,
            Icons.location_on_outlined,
            'Endereços de entrega',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EnderecosPage(
                  controller: enderecosController,
                ),
              ),
            ),
          ),
          _tile(
            context,
            Icons.credit_card_outlined,
            'Formas de pagamento',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const InfoPage(
                  title: 'Formas de pagamento',
                  message:
                      'As opções de pagamento estarão disponíveis na finalização da compra.',
                ),
              ),
            ),
          ),
          _tile(
            context,
            Icons.info_outline,
            'Sobre a Zenkai Figures',
            onAbout,
          ),
          _tile(
            context,
            Icons.logout,
            'Sair da conta',
            onLogout,
          ),
        ],
      ),
    );
  }
}

Widget _stat(String n, String label) {
  return Column(
    children: [
      Text(
        n,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        label,
        style: const TextStyle(
          color: muted,
          fontSize: 10,
        ),
      ),
    ],
  );
}


class _EditarNomeDialog extends StatefulWidget {
  final String nomeAtual;

  const _EditarNomeDialog({
    required this.nomeAtual,
  });

  @override
  State<_EditarNomeDialog> createState() =>
      _EditarNomeDialogState();
}

class _EditarNomeDialogState extends State<_EditarNomeDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.nomeAtual,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: panel,
      title: const Text('Alterar nome de usuário'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Nome de usuário',
          hintText: 'Digite o novo nome',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            final nome = _controller.text.trim();

            if (nome.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Digite um nome de usuário.'),
                ),
              );
              return;
            }

            Navigator.of(context).pop(nome);
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
