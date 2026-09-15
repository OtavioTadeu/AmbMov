import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// =============================================================================
// AULA 13 - Lab: API Rick and Morty
// Data: 15/09/2026 (terça) | 19:00-22:40
// =============================================================================

const String urlPersonagens = 'https://rickandmortyapi.com/api/character';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aula 13 - Rick and Morty',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TelaListaPersonagens(),
    );
  }
}

// =============================================================================
// MODEL — Mapear o Model conforme a API
// =============================================================================
class Personagem {
  final int id;
  final String nome;
  final String status;
  final String especie;
  final String genero;
  final String imagemUrl;
  final String origem;

  Personagem({
    required this.id,
    required this.nome,
    required this.status,
    required this.especie,
    required this.genero,
    required this.imagemUrl,
    required this.origem,
  });

  factory Personagem.fromJson(Map<String, dynamic> json) {
    return Personagem(
      id: json['id'] ?? 0,
      nome: json['name'] ?? '',
      status: json['status'] ?? 'Desconhecido',
      especie: json['species'] ?? 'Desconhecido',
      genero: json['gender'] ?? 'Desconhecido',
      imagemUrl: json['image'] ?? '',
      origem: json['origin'] != null ? (json['origin']['name'] ?? 'Desconhecido') : 'Desconhecido',
    );
  }
}

// =============================================================================
// TELA LISTA — complete os TODOs
// =============================================================================
class TelaListaPersonagens extends StatefulWidget {
  const TelaListaPersonagens({super.key});

  @override
  State<TelaListaPersonagens> createState() => _TelaListaPersonagensState();
}

class _TelaListaPersonagensState extends State<TelaListaPersonagens> {
  bool _carregando = false;
  String? _erro;
  List<Personagem> _personagens = [];

  // TODO 1: http.get(Uri.parse(urlPersonagens))
  // TODO 2: se statusCode != 200, throw Exception(...)
  // TODO 3: jsonDecode → Map → body['results'] como List
  // TODO 4: map Personagem.fromJson em cada item
  Future<List<Personagem>> _buscarPersonagens() async {
    final url = Uri.parse(urlPersonagens);
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar personagens (Status: ${response.statusCode})');
    }

    final Map<String, dynamic> body = jsonDecode(response.body);
    final List<dynamic> results = body['results'] ?? [];
    return results.map((e) => Personagem.fromJson(e as Map<String, dynamic>)).toList();
  }

  // TODO 5: loading true → await _buscarPersonagens → lista ou _erro
  //         (try / catch / finally + if (!mounted) return)
  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final itens = await _buscarPersonagens();
      if (!mounted) return;
      setState(() {
        _personagens = itens;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = 'Erro ao carregar os dados: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_erro!),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  // TODO 6: Navigator.push + MaterialPageRoute → TelaDetalhePersonagem
  //         Passe o Personagem pelo construtor (Aula 10).
  void _abrirDetalhe(Personagem p) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaDetalhePersonagem(personagem: p),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab - Rick and Morty'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Rick & Morty API - Personagens Encontrados',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando personagens...'),
          ],
        ),
      );
    }
    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _erro!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _carregar,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }
    if (_personagens.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 60, color: Colors.grey),
            SizedBox(height: 12),
            Text('Lista vazia. Toque em Buscar.', style: TextStyle(fontSize: 18, color: Colors.black54)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _personagens.length,
      itemBuilder: (context, index) {
        final p = _personagens[index];
        Color statusColor = Colors.grey;
        if (p.status.toLowerCase() == 'alive') statusColor = Colors.green;
        if (p.status.toLowerCase() == 'dead') statusColor = Colors.red;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: p.imagemUrl.isNotEmpty
                  ? Image.network(
                      p.imagemUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => CircleAvatar(
                        radius: 28,
                        child: Text(p.nome.isNotEmpty ? p.nome[0] : '?'),
                      ),
                    )
                  : CircleAvatar(
                      radius: 28,
                      child: Text(p.nome.isNotEmpty ? p.nome[0] : '?'),
                    ),
            ),
            title: Text(
              p.nome,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${p.status} - ${p.especie}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _abrirDetalhe(p),
          ),
        );
      },
    );
  }
}

// =============================================================================
// TELA DETALHE — complete o layout (e conecte no TODO 6)
// =============================================================================
class TelaDetalhePersonagem extends StatelessWidget {
  const TelaDetalhePersonagem({super.key, required this.personagem});

  final Personagem personagem;

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    if (personagem.status.toLowerCase() == 'alive') statusColor = Colors.green;
    if (personagem.status.toLowerCase() == 'dead') statusColor = Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text(personagem.nome),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: personagem.imagemUrl.isNotEmpty
                    ? Image.network(
                        personagem.imagemUrl,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const CircleAvatar(
                          radius: 60,
                          child: Icon(Icons.person, size: 60),
                        ),
                      )
                    : const CircleAvatar(
                        radius: 60,
                        child: Icon(Icons.person, size: 60),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              personagem.nome,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: statusColor, size: 14),
                const SizedBox(width: 6),
                Text(
                  personagem.status,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Espécie'),
                subtitle: Text(personagem.especie),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Gênero'),
                subtitle: Text(personagem.genero),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.public),
                title: const Text('Origem'),
                subtitle: Text(personagem.origem),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
