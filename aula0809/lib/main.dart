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
      debugShowCheckedModeBanner: false,
      title: 'Aula 11 - Async',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExercicioLab(),
    );
  }
}

class ExercicioLab extends StatefulWidget {
  const ExercicioLab({super.key});

  @override
  State<ExercicioLab> createState() => _ExercicioLabState();
}

class _ExercicioLabState extends State<ExercicioLab> {
  bool _carregando = false;
  String? _erro;
  List<Map<String, String>> _contatos = [];

  // TODO 1: criar Future<List<Map<String, String>>> _buscarContatos() async
  //         com await Future.delayed(...) e return da lista fake
  Future<List<Map<String, String>>> _buscarContatos() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      {
        'nome': 'Ana Silva',
        'email': 'ana.silva@email.com',
        'telefone': '(31) 98888-7777',
      },
      {
        'nome': 'Bruno Costa',
        'email': 'bruno.costa@email.com',
        'telefone': '(31) 97777-6666',
      },
      {
        'nome': 'Carlos Souza',
        'email': 'carlos.souza@email.com',
        'telefone': '(31) 96666-5555',
      },
      {
        'nome': 'Daniela Rocha',
        'email': 'daniela.rocha@email.com',
        'telefone': '(31) 95555-4444',
      },
    ];
  }

  Future<void> _carregar() async {
    // TODO 2: setState → _carregando = true, limpar _erro e _contatos
    // TODO 3: try { lista = await _buscarContatos(); setState com lista }
    //         catch { setState com _erro + SnackBar }
    //         finally { _carregando = false }
    setState(() {
      _carregando = true;
      _erro = null;
      _contatos = [];
    });

    try {
      final itens = await _buscarContatos();
      setState(() {
        _contatos = itens;
      });
    } catch (e) {
      setState(() {
        _erro = 'Falha ao carregar contatos: $e';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_erro!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  void _abrirDetalhe(Map<String, String> contato) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalheContatoPage(
          nome: contato['nome'] ?? '',
          email: contato['email'] ?? '',
          telefone: contato['telefone'] ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex. 7 — Lab Contatos'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _corpo(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _carregando ? null : _carregar,
        icon: const Icon(Icons.download),
        label: const Text('Buscar contatos'),
      ),
    );
  }

  Widget _corpo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _erro!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.orange),
          ),
        ),
      );
    }
    if (_contatos.isEmpty) {
      return const Center(
        child: Text(
          'Lab: buscar lista com delay\n+ loading + erro',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    return ListView.builder(
      itemCount: _contatos.length,
      itemBuilder: (context, index) {
        final c = _contatos[index];
        final initial = (c['nome'] ?? '?')[0].toUpperCase();
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(child: Text(initial)),
            title: Text(c['nome'] ?? ''),
            subtitle: Text(c['email'] ?? ''),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _abrirDetalhe(c),
          ),
        );
      },
    );
  }
}

