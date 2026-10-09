import 'package:flutter/material.dart';

import '../controller/filtro_controller.dart';
import '../main.dart';

class FilterPage extends StatefulWidget {
  final FiltroController controller;

  const FilterPage({
    super.key,
    required this.controller,
  });

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late String universe;
  late String brand;
  late String type;
  late double price;
  late bool stock;

  @override
  void initState() {
    super.initState();
    final controller = widget.controller;
    universe = controller.universo;
    brand = controller.marca;
    type = controller.tipo;
    price = controller.precoMaximo;
    stock = controller.somenteEstoque;
  }

  Widget _chips(
    String title,
    List<String> values,
    String selected,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values.map((value) {
            return ChoiceChip(
              label: Text(value),
              selected: selected == value,
              selectedColor: lime,
              onSelected: (_) {
                setState(() => onChanged(value));
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void _limpar() {
    widget.controller.limpar();
    setState(() {
      universe = 'Todos';
      brand = 'Todas';
      type = 'Todos';
      price = 600;
      stock = false;
    });
  }

  void _aplicar() {
    widget.controller.atualizar(
      novoUniverso: universe,
      novaMarca: brand,
      novoTipo: type,
      novoPrecoMaximo: price,
      novoSomenteEstoque: stock,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtrar figuras'),
        actions: [
          TextButton(
            onPressed: _limpar,
            child: const Text('Limpar', style: TextStyle(color: lime)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _chips(
            'Universo',
            [
              'Todos',
              'Dragon Ball Z',
              'Naruto Shippuden',
              'One Piece',
              'Demon Slayer',
            ],
            universe,
            (value) => universe = value,
          ),
          const SizedBox(height: 20),
          Text('Preço máximo: R\$ ${price.toStringAsFixed(0)}'),
          Slider(
            value: price,
            min: 100,
            max: 600,
            divisions: 10,
            activeColor: lime,
            onChanged: (value) => setState(() => price = value),
          ),
          const SizedBox(height: 12),
          _chips(
            'Marca',
            ['Todas', 'Banpresto', 'Bandai', 'Good Smile'],
            brand,
            (value) => brand = value,
          ),
          const SizedBox(height: 20),
          _chips(
            'Tipo de figura',
            ['Todos', 'Estátua', 'Estátua não articulada', 'Articulada'],
            type,
            (value) => type = value,
          ),
          SwitchListTile(
            title: const Text('Somente em estoque'),
            value: stock,
            activeThumbColor: lime,
            onChanged: (value) => setState(() => stock = value),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _aplicar,
            child: const Text('Aplicar filtros'),
          ),
        ],
      ),
    );
  }
}
