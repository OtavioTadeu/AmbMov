import 'package:flutter/material.dart';

class DetalheContatoPage extends StatelessWidget {
  final String nome;
  final String email;
  final String telefone;

  const DetalheContatoPage({
    super.key,
    required this.nome,
    required this.email,
    required this.telefone,
  });

  @override
  Widget build(BuildContext context) {
    final initial = nome.isNotEmpty ? nome[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(
        title: Text(nome),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                initial,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              nome,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text('E-mail'),
                subtitle: Text(email),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Telefone'),
                subtitle: Text(telefone),
              ),
            ),
            const Spacer(),
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
