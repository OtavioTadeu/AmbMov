import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detalhe.dart';

void main() {
  runApp(const MyApp());
}

class Usuario {
  final String nome;
  final String email;
  final String telefone;

  Usuario({
    required this.nome,
    required this.email,
    required this.telefone,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nome: json['name'] ?? '',
      email: json['email'] ?? '',
      telefone: json['phone'] ?? '',
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aula 12 - API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EsqueletoURL(),
    );
  }
}

class EsqueletoURL extends StatefulWidget {
  const EsqueletoURL({super.key});

  @override
  State<EsqueletoURL> createState() => _EsqueletoURLState();
}

class _EsqueletoURLState extends State<EsqueletoURL> {
  bool _carregando = false;
  String? _erro;
  List<Usuario> _usuarios = [];

  // TODO 1: Mapear Usuario
  // TODO 2: http.get(urlUsuarios)
  // TODO 3: se statusCode != 200, throw
  // TODO 4: jsonDecode + map Usuario.fromJson
  Future<List<Usuario>> _buscarUsuarios() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar usuários (Status ${response.statusCode})');
    }

    final List<dynamic> dados = jsonDecode(response.body);
    return dados.map((item) => Usuario.fromJson(item)).toList();
  }

  // TODO 5: loading -> await -> lista ou _erro (try/catch/finally)
  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
      _usuarios = [];
    });

    try {
      final itens = await _buscarUsuarios();
      setState(() {
        _usuarios = itens;
      });
    } catch (e) {
      setState(() {
        _erro = 'Falha ao carregar usuários: $e';
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

  void _abrirDetalhe(Usuario usuario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalheUsuarioPage(
          nome: usuario.nome,
          email: usuario.email,
          telefone: usuario.telefone,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab - Users da API'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Complete _buscarUsuarios e _carregar.\n'
              'URL: jsonplaceholder.typicode.com/users\n'
              'Bônus: onTap abre detalhe (Aula 10).',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ),
          Expanded(child: _corpo()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _carregando ? null : _carregar,
        icon: const Icon(Icons.cloud_download),
        label: const Text('Buscar'),
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
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      );
    }
    if (_usuarios.isEmpty) {
      return const Center(
        child: Text(
          'Lista vazia. Toque em Buscar.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _usuarios.length,
      itemBuilder: (context, index) {
        final u = _usuarios[index];
        final initial = u.nome.isNotEmpty ? u.nome[0].toUpperCase() : '?';
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(child: Text(initial)),
            title: Text(u.nome),
            subtitle: Text(u.email),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _abrirDetalhe(u),
          ),
        );
      },
    );
  }
}
