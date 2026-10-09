
class Figure {
  final String name, universe, brand, height, material, type, description, emoji;
  final double price, oldPrice;

  const Figure(
    this.name,
    this.universe,
    this.brand,
    this.price,
    this.oldPrice,
    this.height,
    this.material,
    this.type,
    this.description,
    this.emoji,
  );

  int get discount => ((1 - price / oldPrice) * 100).round();

  
  String get imagePath {
    final nome = name.toLowerCase();

    if (nome.contains('goku')) {
      return 'assets/images/goku.png';
    } else if (nome.contains('naruto')) {
      return 'assets/images/naruto.png';
    } else if (nome.contains('luffy')) {
      return 'assets/images/luffy.png';
    } else if (nome.contains('vegeta')) {
      return 'assets/images/vegeta.png';
    } else if (nome.contains('tanjiro')) {
      return 'assets/images/tanjiro.png';
    } else if (nome.contains('zoro')) {
      return 'assets/images/zoro.png';
    } else if (nome.contains('sasuke')) {
      return 'assets/images/sasuke.png';
    } else if (nome.contains('gojo')) {
      return 'assets/images/gojo.png';
    } else if (nome.contains('eren')) {
      return 'assets/images/eren.png';
    } else if (nome.contains('saitama')) {
      return 'assets/images/saitama.png';
    }

    return '';
  }

}

class FilterSelection { final String universe, brand, type; final double maxPrice; final bool stockOnly; const FilterSelection({this.universe='Todos',this.brand='Todas',this.type='Todos',this.maxPrice=600,this.stockOnly=false}); }

