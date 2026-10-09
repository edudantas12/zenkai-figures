# Zenkai Figures

Aplicativo de catálogo e loja virtual de action figures inspirado no universo dos animes, desenvolvido com Flutter e Dart.

## Sobre o projeto

A **Zenkai Figures** permite explorar figuras de personagens, visualizar detalhes dos produtos e montar um carrinho de compras em uma interface com identidade visual própria.

Este projeto foi desenvolvido como prática de desenvolvimento mobile, organização de código e construção de interfaces com Flutter.

## Funcionalidades

- Catálogo de action figures.
- Exibição de detalhes dos produtos.
- Busca e filtros de produtos.
- Favoritos.
- Carrinho de compras com controle de quantidade.
- Cálculo de subtotal, frete e total.
- Tela de perfil e gerenciamento de endereços.
- Telas de login e cadastro.
- Interface adaptável para visualização durante o desenvolvimento com Device Preview.

> Observação: funcionalidades que dependem de serviços externos ou persistência em banco de dados podem exigir configuração adicional. Consulte o código do projeto para verificar o estado atual de cada recurso.

## Tecnologias utilizadas

- **Flutter** — framework para desenvolvimento de interfaces multiplataforma.
- **Dart** — linguagem de programação.
- **Material Design** — componentes visuais.
- **Device Preview** — visualização e teste de diferentes formatos de tela.
- **Git e GitHub** — versionamento e hospedagem do código.

## Estrutura do projeto

```text
zenkai/
├── assets/
│   └── images/        # Logo e imagens dos produtos
├── lib/
│   ├── controller/    # Lógica e controle de estado
│   ├── model/         # Modelos de dados
│   └── view/          # Telas do aplicativo
├── test/              # Testes automatizados, se disponíveis
├── pubspec.yaml       # Dependências e configuração do Flutter
└── README.md
```

A estrutura exata pode variar conforme a evolução do projeto.

## Como executar

### Pré-requisitos

- Flutter SDK instalado.
- Dart SDK (incluído no Flutter).
- VS Code ou outra IDE compatível.
- Um navegador ou dispositivo/emulador configurado.

### Passos

1. Clone o repositório:

   ```bash
   git clone https://github.com/edudantas12/zenkai-figures.git
   ```

2. Entre na pasta:

   ```bash
   cd zenkai-figures
   ```

3. Instale as dependências:

   ```bash
   flutter pub get
   ```

4. Execute o aplicativo:

   ```bash
   flutter run
   ```

Para executar no Chrome:

```bash
flutter run -d chrome
```


## Imagens e assets

As imagens utilizadas pelo aplicativo ficam em `assets/images/`. A pasta é declarada na seção `flutter.assets` do arquivo `pubspec.yaml`.

## Próximas melhorias

- Aprimorar a persistência de dados.
- Integrar autenticação e banco de dados, caso necessário.
- Melhorar a documentação das telas e funcionalidades.
- Adicionar testes automatizados.
- Incluir capturas de tela do aplicativo.

## Autores

- Eduardo Augusto dos Santos Dantas
- Riquelme Auvídio do Carmo

## Licença

Este projeto ainda não possui uma licença definida. Entre em contato com os autores antes de reutilizar ou distribuir o código.
