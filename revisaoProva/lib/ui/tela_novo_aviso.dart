import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dados/mural.dart';

class TelaNovoAviso extends StatefulWidget {
  const TelaNovoAviso({super.key});

  @override
  State<TelaNovoAviso> createState() => _TelaNovoAvisoState();
}

class _TelaNovoAvisoState extends State<TelaNovoAviso> {
  final _formKey = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _corpo = TextEditingController();

  @override
  void dispose() {
    _titulo.dispose();
    _corpo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo aviso')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titulo,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              validator: _validarTitulo,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _corpo,
              decoration: const InputDecoration(
                labelText: 'Texto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                context.read<Mural>().adicionar(
                  _titulo.text.trim(),
                  _corpo.text.trim(),
                );
                Navigator.pop(context);
              },
              child: const Text('Publicar'),
            ),
          ],
        ),
      ),
    );
  }

  String? _validarTitulo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o título';
    }
    return null;
  }
}
