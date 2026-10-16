
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:device_preview_plus/device_preview_plus.dart';

import 'controller/avaliacoes_controller.dart';
import 'controller/carrinho_controller.dart';
import 'controller/catalogo_controller.dart';
import 'controller/enderecos_controller.dart';
import 'controller/filtro_controller.dart';
import 'controller/pedidos_controller.dart';
import 'controller/perfil_controller.dart';
import 'core/dependencias.dart';
import 'model/figure.dart';
import 'view/avaliacoes_view.dart';
import 'view/carrinho_view.dart';
import 'view/catalogo_view.dart';
import 'view/checkout_view.dart';
import 'view/detalhes_figura_view.dart';
import 'view/favoritos_view.dart';
import 'view/filtro_view.dart';
import 'view/login_view.dart';
import 'view/ofertas_view.dart';
import 'view/pedidos_view.dart';
import 'view/perfil_view.dart';
import 'view/sobre_view.dart';
import 'view/minhas_avaliacoes_view.dart';

const lime = Color(0xFFB8F35B);
const bg = Color(0xFF101112);
const panel = Color(0xFF1C1E1F);
const muted = Color(0xFF9CA3A3);

final getIt = GetIt.instance;


void main() {
  configurarDependencias();

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const ZenkaiApp(),
    ),
  );
}

class ZenkaiApp extends StatefulWidget {
  const ZenkaiApp({super.key});

  @override
  State<ZenkaiApp> createState() => _ZenkaiAppState();
}

class _ZenkaiAppState extends State<ZenkaiApp> {
  final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

  final List<Figure> products = const [

    Figure(
      'Goku Super Saiyajin',
      'Dragon Ball Z',
      'Banpresto',
      529.90,
      529.90,
      '26 cm',
      'PVC',
      'Estátua não articulada',
      'Uma peça indispensável para fãs de Dragon Ball, com acabamento detalhado e base de exposição.',
      '🔥',
    ),
    Figure(
      'Naruto Modo Sábio',
      'Naruto Shippuden',
      'Banpresto',
      399.90,
      399.90,
      '22 cm',
      'PVC',
      'Estátua',
      'Naruto em sua forma sábia, com detalhes inspirados no anime.',
      '🍥',
    ),
    Figure(
      'Luffy',
      'One Piece',
      'Bandai',
      479.90,
      479.90,
      '24 cm',
      'PVC',
      'Estátua',
      'Uma figura cheia de personalidade do capitão dos Chapéus de Palha.',
      '☠️',
    ),
    Figure(
      'Vegeta Super Saiyajin',
      'Dragon Ball Z',
      'Banpresto',
      499.90,
      499.90,
      '25 cm',
      'PVC',
      'Estátua',
      'Vegeta em uma pose clássica, ideal para completar sua coleção.',
      '⚡',
    ),
    Figure(
      'Tanjiro Kamado',
      'Demon Slayer',
      'Good Smile',
      329.90,
      329.90,
      '18 cm',
      'PVC',
      'Articulada',
      'Figura de Tanjiro com detalhes da roupa e acessórios.',
      '🌊',
    ),
    Figure(
      'Roronoa Zoro',
      'One Piece',
      'Bandai',
      419.90,
      419.90,
      '21 cm',
      'PVC',
      'Estátua',
      'O espadachim dos Chapéus de Palha em uma pose de batalha.',
      '⚔️',
    ),
  ];

  
  final List<Figure> produtosOfertas = const [
    Figure(
      'Sasuke Uchiha',
      'Naruto Shippuden',
      'Bandai',
      239.90,
      299.90,
      '21 cm',
      'PVC',
      'Estátua',
      'Figura de Sasuke com detalhes inspirados no anime.',
      '⚡',
    ),
    Figure(
      'Satoru Gojo',
      'Jujutsu Kaisen',
      'Good Smile',
      279.90,
      349.90,
      '23 cm',
      'PVC',
      'Articulada',
      'Figura de Gojo com acabamento detalhado.',
      '🔵',
    ),
    Figure(
      'Eren Yeager',
      'Attack on Titan',
      'Banpresto',
      249.90,
      319.90,
      '22 cm',
      'PVC',
      'Estátua',
      'Figura de Eren inspirada em Attack on Titan.',
      '⚔️',
    ),
    Figure(
      'Saitama',
      'One Punch Man',
      'Bandai',
      199.90,
      259.90,
      '20 cm',
      'PVC',
      'Estátua',
      'Figura do herói de One Punch Man.',
      '👊',
    ),
  ];

  List<Figure> get todosProdutos => [
    ...products,
    ...produtosOfertas,
  ];

  final carrinho = getIt<CarrinhoController>();
  final catalogo = getIt<CatalogoController>();
  final filtros = getIt<FiltroController>();
  final perfil = getIt<PerfilController>();
  final pedidos = PedidosController();
  final enderecos = EnderecosController();
  final avaliacoes = AvaliacoesController();

  int tab = 0;
  bool entrou = false;

  void abrirDetalhes(Figure figura) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPage(
          figure: figura,
          favorite: catalogo.ehFavorito(figura),
          onFavorite: () {
            catalogo.alternarFavorito(figura);
            setState(() {});
          },
          onAdd: () {
            carrinho.adicionar(figura);
            setState(() {});
          },
          onReviews: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => 
              ReviewsPage(
                figure: figura,
                controller: avaliacoes,
              ) 
            ),
          ),
        ),
      ),
    );
  }

  
  void abrirSobre() {
    debugPrint('Abrindo tela Sobre...');

    navigatorKey.currentState?.push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const AboutPage(),
      ),
    );
  }

  
  Future<void> abrirFiltro() async {
    final navigator = navigatorKey.currentState;

    if (navigator == null) {
      debugPrint('ERRO: navegador não encontrado ao abrir filtros.');
      return;
    }

    await navigator.push<void>(
      MaterialPageRoute<void>(
        builder: (_) => FilterPage(controller: filtros),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }


  
  
  void abrirPedidos() {
    navigatorKey.currentState?.push<void>(
      MaterialPageRoute<void>(
        builder: (_) => PedidosPage(
          pedidos: pedidos.pedidos,
          avaliacoesController: avaliacoes,
          onAtualizar: () {
            setState(() {});
          },
          onMarcarEntregue: (index) {
            pedidos.marcarComoEntregue(index);
            navigatorKey.currentState?.pop();
            abrirPedidos();
          },
        ),
      ),
    );
  }





  void abrirFavoritos() {
    debugPrint('CLIQUE EM MINHA LISTA DE DESEJOS');

    navigatorKey.currentState?.push<void>(
      MaterialPageRoute<void>(
        builder: (_) => FavoritesPage(
          products: todosProdutos.where(catalogo.ehFavorito).toList(),
          onOpen: abrirDetalhes,
          produtosEmOferta: produtosOfertas.map((p) => p.name).toSet(),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zenkai Figures',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      // Integração com o Device Preview

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.dark(
          primary: lime,
          surface: bg,
          secondary: lime,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: bg,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: panel,
          hintStyle: const TextStyle(color: muted),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF393D3D),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF393D3D),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: lime),
          ),
        ),
      ),
      home: entrou
          ? _shell()
          : LoginPage(
              onLogin: (u, e) {
                perfil.atualizarNome(u);
                perfil.atualizarEmail(e);
                setState(() => entrou = true);
              },
            ),
    );
  }

  Widget _shell() {
    return Scaffold(
      body: IndexedStack(
        index: tab,
        children: [
          CatalogPage(
            products: filtros.aplicar(
              catalogo.filtrar(products),
            ),
            favorites: catalogo.favoritos,
            onFavorite: (figura) {
              catalogo.alternarFavorito(figura);
              setState(() {});
            },
            onAdd: (figura) {
              carrinho.adicionar(figura);
              setState(() {});
            },
            onOpen: abrirDetalhes,
            onFilter: abrirFiltro,
          ),
          OffersPage(
            products: produtosOfertas,
            onAdd: (figura) {
              carrinho.adicionar(figura);
              setState(() {});
            },
            onOpen: abrirDetalhes,
            onFavorite: (figura) {
              catalogo.alternarFavorito(figura);
              setState(() {});
            },
            ehFavorito: catalogo.ehFavorito,
          ),
          CartPage(
            products: todosProdutos,
            controller: carrinho,
            onCheckout: () {
              navigatorKey.currentState?.push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => CheckoutPage(
                    total: carrinho.total(todosProdutos),
                    onConfirmar: () {
                      pedidos.registrarPedido(
                        produtos: todosProdutos,
                        quantidades: carrinho.quantidades,
                        total: carrinho.total(products),
                      );

                      setState(() {
                        carrinho.limpar();
                      });
                    },
                  ),
                ),
              );
            },
          ),
          ProfilePage(
            username: perfil.nomeUsuario,
            email: perfil.email,
            favorites: catalogo.favoritos.length,
            cartCount: pedidos.pedidos.length,
            enderecosController: enderecos,
            avaliacoesController: avaliacoes,
            onMyReviews: () {
              debugPrint('Abrindo Minhas avaliações');

              navigatorKey.currentState?.push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => MinhasAvaliacoesPage(
                    controller: avaliacoes,
                  ),
                ),
              );
            },
            onName: (nome) {
              perfil.atualizarNome(nome);
              setState(() {});
            },
            onLogout: () => setState(() => entrou = false),
            onAbout: abrirSobre,
            onOrders: abrirPedidos,
            onFavorites: abrirFavoritos,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF1B1D1E),
        indicatorColor: const Color(0xFF29351D),
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2, color: lime),
            label: 'Figuras',
          ),
          const NavigationDestination(
            icon: Icon(Icons.sell_outlined),
            selectedIcon: Icon(Icons.sell, color: lime),
            label: 'Ofertas',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: carrinho.quantidadeTotal > 0,
              label: Text('${carrinho.quantidadeTotal}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            selectedIcon: const Icon(
              Icons.shopping_bag,
              color: lime,
            ),
            label: 'Carrinho',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: lime),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

