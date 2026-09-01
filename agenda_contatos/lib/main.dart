import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Contact {
  final String name;
  final String email;
  final String phone;
  bool isFavorite;

  Contact({
    required this.name,
    required this.email,
    required this.phone,
    this.isFavorite = false,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda de Contatos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AgendaPage(),
    );
  }
}

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();

  final _emailRegEx = RegExp(r'^[\w.-]+@[\w.-]+\.\w+$');
  final _telefoneRegEx = RegExp(r'^\d{10,11}$');
  final _nomeRegEx = RegExp(r'^[a-zA-ZÀ-ÿ\s]{3,}$');

  final List<Contact> _contatos = [];

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _adicionarContato() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _contatos.add(
          Contact(
            name: _nomeController.text.trim(),
            email: _emailController.text.trim(),
            phone: _telefoneController.text.trim(),
          ),
        );
        _nomeController.clear();
        _emailController.clear();
        _telefoneController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Contato cadastrado com sucesso"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _toggleFavorito(int index) {
    setState(() {
      _contatos[index].isFavorite = !_contatos[index].isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritosCount = _contatos.where((c) => c.isFavorite).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Contatos (${_contatos.length})'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Cadastrar contato",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nomeController,
                          decoration: const InputDecoration(
                            labelText: "Nome completo",
                            hintText: "Ex.: Ana Silva",
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Nome vazio";
                            }
                            if (!_nomeRegEx.hasMatch(value.trim())) {
                              return "Nome inválido";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: "E-mail",
                            hintText: "Ex.: exemplo@dominio.com",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Email vazio";
                            }
                            if (!_emailRegEx.hasMatch(value.trim())) {
                              return "Email inválido";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _telefoneController,
                          decoration: const InputDecoration(
                            labelText: "Telefone",
                            hintText: "Ex.: 31999999999",
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Telefone vazio";
                            }
                            if (!_telefoneRegEx.hasMatch(value.trim())) {
                              return "Telefone inválido";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _adicionarContato,
                          child: const Text("Adicionar contato"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Lista",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "$favoritosCount favorito(s)",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _contatos.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, size: 50, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              "Nenhum contato ainda",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _contatos.length,
                        itemBuilder: (context, index) {
                          final contato = _contatos[index];
                          final initial = contato.name.isNotEmpty
                              ? contato.name[0].toUpperCase()
                              : "?";

                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(child: Text(initial)),
                              title: Text(contato.name),
                              subtitle:
                                  Text("${contato.email}\n${contato.phone}"),
                              trailing: IconButton(
                                icon: Icon(
                                  contato.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: contato.isFavorite ? Colors.red : null,
                                ),
                                onPressed: () => _toggleFavorito(index),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
