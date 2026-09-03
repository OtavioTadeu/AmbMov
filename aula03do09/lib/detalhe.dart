import 'package:flutter/material.dart';

class DetalhePage extends StatefulWidget {
  final String? nome;

  const DetalhePage({super.key, this.nome});

  @override
  State<DetalhePage> createState() => _DetalhePageState();
}

class _DetalhePageState extends State<DetalhePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.nome ?? '')),
      body: ElevatedButton(
          onPressed: () => Navigator.pop(context), child: Text('Voltar')),
    );
  }
}
