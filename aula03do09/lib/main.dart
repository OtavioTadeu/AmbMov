import 'package:flutter/material.dart';
import 'detalhe.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const EsqueletoLab(),
    );
  }
}

class EsqueletoLab extends StatefulWidget {
  const EsqueletoLab({super.key});

  @override
  State<EsqueletoLab> createState() => _EsqueletoLabState();
}

class _EsqueletoLabState extends State<EsqueletoLab> {
  final List<Map<String, dynamic>> _contatos = [
    {
      'nome': 'Ana Silva',
      'email': 'ana@email.com',
      'telefone': '(31) 98888-7777',
      'favorito': true
    },
    {
      'nome': 'Bruno Costa',
      'email': 'bruno@email.com',
      'telefone': '(31) 97777-6666',
      'favorito': false
    },
  ];

  void _abrirDetalhe(Map<String, dynamic> contato) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhePage(nome: contato['nome']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Lab — Contatos (${_contatos.length})'),
          centerTitle: true),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Tela 1: lista pronta.\n'
              'Complete o onTap → Navigator.push → TelaDetalheContato.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _contatos.length,
              itemBuilder: (context, index) {
                final c = _contatos[index];
                final favorito = c['favorito'] as bool;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading:
                        CircleAvatar(child: Text((c['nome'] as String)[0])),
                    title: Text(c['nome'] as String),
                    subtitle: Text(c['email'] as String),
                    trailing: Icon(
                      favorito ? Icons.favorite : Icons.chevron_right,
                      color: favorito ? Colors.red : null,
                    ),
                    onTap: () => _abrirDetalhe(c),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
