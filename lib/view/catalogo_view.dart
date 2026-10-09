import 'package:flutter/material.dart';

import '../main.dart';
import '../model/figure.dart';
import 'common_widgets.dart';

class CatalogPage extends StatefulWidget {
  final List<Figure> products;
  final Set<String> favorites;
  final ValueChanged<Figure> onFavorite;
  final ValueChanged<Figure> onAdd;
  final ValueChanged<Figure> onOpen;
  final VoidCallback onFilter;

  const CatalogPage({
    super.key,
    required this.products,
    required this.favorites,
    required this.onFavorite,
    required this.onAdd,
    required this.onOpen,
    required this.onFilter,
  });

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.products.where((figure) {
      final term = query.trim().toLowerCase();
      return figure.name.toLowerCase().contains(term) ||
          figure.universe.toLowerCase().contains(term) ||
          figure.brand.toLowerCase().contains(term);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.bolt, color: lime),
            SizedBox(width: 6),
            Text('ZENKAI', style: TextStyle(fontWeight: FontWeight.w900)),
            Text(' FIGURES', style: TextStyle(color: muted, fontSize: 10)),
          ],
        ),
        actions: [IconButton(onPressed: widget.onFilter, icon: const Icon(Icons.tune))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar figuras, animes...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => query = value),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Nenhuma figura encontrada.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .62,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, index) {
                      final figure = filtered[index];
                      return ProductCard(
                        figure: figure,
                        favorite: widget.favorites.contains(figure.name),
                        onFavorite: () => widget.onFavorite(figure),
                        onAdd: () => widget.onAdd(figure),
                        onOpen: () => widget.onOpen(figure),
                        mostrarDesconto: false,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
