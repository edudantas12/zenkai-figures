# Zenkai Figures — projeto completo

Este pacote contém o projeto Flutter completo, não apenas a pasta `lib/view`.

## Estrutura principal

- `lib/view/`: telas da aplicação e widgets reutilizáveis.
- `lib/controller/`: os 10 controllers do projeto.
- `lib/model/`: modelo `Figure` usado pelo catálogo e carrinho.
- `lib/core/`: registro de dependências e rotas.
- `lib/main.dart`: tema, navegação principal e composição da aplicação.
- `assets/images/`: logomarca utilizada na interface.

## Correções feitas nesta versão

- Reescrita de `lib/view/avaliacoes_view.dart` para corrigir a estrutura da tela de avaliações.
- Reescrita de `lib/view/filtro_view.dart` para corrigir parênteses/chaves e organizar a aplicação/limpeza dos filtros.
- Inclusão do import de `view/common_widgets.dart` em `main.dart`, onde `InfoPage` é definido.

## Como executar no Windows

Abra o terminal na pasta que contém `pubspec.yaml` e rode:

```powershell
flutter pub get
flutter run -d chrome
```

Para conferir os problemas estáticos:

```powershell
flutter analyze
```

Observação: o ambiente onde este ZIP foi preparado não possui o Flutter SDK instalado; por isso, não foi possível executar `flutter analyze` nem confirmar uma compilação real. Se aparecer outro erro no seu computador, envie o log completo para corrigirmos com base nele.

