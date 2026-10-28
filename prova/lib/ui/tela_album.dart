import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dados/discoteca.dart';
import '../model/album.dart';

class TelaAlbum extends StatefulWidget {
  const TelaAlbum({super.key, required this.album});

  final Album album;

  @override
  State<TelaAlbum> createState() => _TelaAlbumState();
}

class _TelaAlbumState extends State<TelaAlbum> {
  final _formKey = GlobalKey<FormState>();
  final _observacao = TextEditingController();

  @override
  void dispose() {
    _observacao.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final discoteca = context.watch<Discoteca>();
    final album = widget.album;
    final salva = discoteca.observacaoDe(album.id);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(album.nome),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (album.imagemUrl.isNotEmpty)
            Image.network(album.imagemUrl, height: 180, fit: BoxFit.cover),
          const SizedBox(height: 12),
          Text(album.genero),
          const SizedBox(height: 12),
          // TODO 9: Mostrar o nome do álbum em negrito, tamanho 22,
          // depois 8 pixels, e o artista no tamanho 16.
          Text(
            album.nome,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            album.artista,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _observacao,
              decoration: const InputDecoration(
                labelText: 'Observação',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                // TODO 1: Não aceitar observação com menos de 3 caracteres.
                if (value == null || value.trim().length < 3) {
                  return 'Mínimo de 3 caracteres';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;
              context.read<Discoteca>().salvarObservacao(
                album.id,
                _observacao.text.trim(),
              );
            },
            child: const Text('Salvar observação'),
          ),
          if (salva != null) ...[
            const SizedBox(height: 12),
            Text('Salva: $salva'),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              // TODO 4: Este botão favorita ou tira o favorito deste álbum.
              context.read<Discoteca>().alternarFavorito(album.id);
            },
            icon: Icon(
              discoteca.ehFavorito(album.id) ? Icons.star : Icons.star_border,
            ),
            // TODO 4: A estrela mostra se este álbum é favorito.
            label: Text(
              discoteca.ehFavorito(album.id) ? 'Favorito' : 'Favoritar',
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              // TODO 3: Voltar para a lista.
              Navigator.pop(context);
            },
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }
}
