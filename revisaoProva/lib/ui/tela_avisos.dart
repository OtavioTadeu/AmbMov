import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dados/mural.dart';
import 'tela_detalhe.dart';
import 'tela_novo_aviso.dart';

class TelaAvisos extends StatefulWidget {
  const TelaAvisos({super.key});

  @override
  State<TelaAvisos> createState() => _TelaAvisosState();
}

class _TelaAvisosState extends State<TelaAvisos> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Mural>().iniciar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mural = context.watch<Mural>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avisos do campus'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TelaNovoAviso()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _corpo(mural),
    );
  }

  Widget _corpo(Mural mural) {
    if (mural.carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (mural.erro != null) {
      return Center(child: Text(mural.erro!));
    }
    if (mural.avisos.isEmpty) {
      return const Center(child: Text('Nenhum aviso'));
    }
    return ListView.builder(
      itemCount: mural.avisos.length,
      itemBuilder: (context, index) {
        final aviso = mural.avisos[index];
        return Card(
          child: ListTile(
            title: Text(aviso.titulo),
            trailing: Icon(
              mural.ehFavorito(aviso.id) ? Icons.star : Icons.star_border,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TelaDetalhe(aviso: aviso),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
