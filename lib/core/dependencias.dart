import 'package:get_it/get_it.dart';

import '../controller/carrinho_controller.dart';
import '../controller/catalogo_controller.dart';
import '../controller/detalhes_figura_controller.dart';
import '../controller/filtro_controller.dart';
import '../controller/ofertas_controller.dart';

import '../controller/cadastrar_usuario_controller.dart';
import '../controller/login_controller.dart';
import '../controller/perfil_controller.dart';
import '../controller/recuperar_senha_controller.dart';
import '../controller/sobre_controller.dart';

final g = GetIt.instance;

void configurarDependencias() {
  g.registerSingleton<CadastrarUsuarioController>(CadastrarUsuarioController());
  g.registerSingleton<LoginController>(LoginController());
  g.registerSingleton<PerfilController>(PerfilController());
  g.registerSingleton<RecuperarSenhaController>(RecuperarSenhaController());
  g.registerSingleton<SobreController>(SobreController());
  g.registerLazySingleton<CarrinhoController>(CarrinhoController.new);
  g.registerLazySingleton<CatalogoController>(CatalogoController.new);
  g.registerLazySingleton<DetalhesFiguraController>(
    DetalhesFiguraController.new,
  );
  g.registerLazySingleton<FiltroController>(FiltroController.new);
  g.registerLazySingleton<OfertasController>(OfertasController.new);
}
