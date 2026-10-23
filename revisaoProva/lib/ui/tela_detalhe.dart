import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dados/mural.dart';
import '../model/aviso.dart';

class TelaDetalhe extends StatelessWidget {
  const TelaDetalhe({super.key, required this.aviso});

  final Aviso aviso;

  @override
  Widget build(BuildContext context) {
    final mural = context.watch<Mural>();
    final favorito = mural.ehFavorito(aviso.id);
    return Scaffold(
      appBar: AppBar(title: Text(aviso.titulo)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            aviso.titulo,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(aviso.corpo),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              context.read<Mural>().alternarFavorito(aviso.id);
            },
            icon: Icon(favorito ? Icons.star : Icons.star_border),
            label: Text(favorito ? 'Favorito' : 'Favoritar'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }
}
