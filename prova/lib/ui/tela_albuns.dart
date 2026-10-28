import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dados/discoteca.dart';
// A navegação abre a tela do álbum.
import 'tela_album.dart';

class TelaAlbuns extends StatefulWidget {
  const TelaAlbuns({super.key});

  @override
  State<TelaAlbuns> createState() => _TelaAlbunsState();
}

class _TelaAlbunsState extends State<TelaAlbuns> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Discoteca>().iniciar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final discoteca = context.watch<Discoteca>();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Álbuns · ${discoteca.favoritos.length}'),
            // TODO 10: Mostrar o nome completo e a matrícula.
            const Text(
              'Otávio Tadeu Magalhães Ferreira - 72500964',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: _corpo(discoteca),
    );
  }

  Widget _corpo(Discoteca discoteca) {
    if (discoteca.carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (discoteca.erro != null) {
      return Center(child: Text(discoteca.erro!));
    }
    return ListView.builder(
      itemCount: discoteca.itens.length,
      itemBuilder: (context, index) {
        final album = discoteca.itens[index];
        return ListTile(
          leading: album.imagemUrl.isEmpty
              ? const CircleAvatar(child: Icon(Icons.album))
              : CircleAvatar(backgroundImage: NetworkImage(album.imagemUrl)),
          title: Text(album.nome),
          subtitle: Text(album.artista),
          trailing: IconButton(
            icon: Icon(
              discoteca.ehFavorito(album.id) ? Icons.star : Icons.star_border,
            ),
            onPressed: () {
              context.read<Discoteca>().alternarFavorito(album.id);
            },
          ),
          // TODO 4: A estrela mostra se este álbum é favorito.
          onTap: () {
            // TODO 2: Navegar para a tela do álbum.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TelaAlbum(album: album),
              ),
            );
          },
        );
      },
    );
  }
}
