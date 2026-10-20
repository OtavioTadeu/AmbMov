import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aula_revisao_pratica/dados/loja.dart';
import 'package:aula_revisao_pratica/ui/tela_detalhe.dart';

class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loja = context.read<Loja>();
      loja.lerFavoritos();
      loja.carregar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loja = context.watch<Loja>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Receitas · ${loja.favoritos.length} favoritas'),
      ),
      body: _corpo(context, loja),
    );
  }

  Widget _corpo(BuildContext context, Loja loja) {
    if (loja.carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (loja.erro != null) {
      return Center(child: Text(loja.erro!));
    }
    return ListView.builder(
      itemCount: loja.itens.length,
      itemBuilder: (context, index) {
        final item = loja.itens[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(item.imagemUrl),
          ),
          title: Text(item.nome),
          subtitle: Text('${item.tempoMinutos} min'),
          trailing: Icon(
            loja.ehFavorito(item.id) ? Icons.star : Icons.star_border,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TelaDetalhe(item: item)),
            );
          },
        );
      },
    );
  }
}
