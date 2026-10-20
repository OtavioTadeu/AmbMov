import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:aula_revisao_pratica/dados/loja.dart';
import 'package:aula_revisao_pratica/model/item.dart';

class TelaDetalhe extends StatefulWidget {
  const TelaDetalhe({super.key, required this.item});

  final Item item;

  @override
  State<TelaDetalhe> createState() => _TelaDetalheState();
}

class _TelaDetalheState extends State<TelaDetalhe> {
  final _formKey = GlobalKey<FormState>();
  final _observacao = TextEditingController();

  @override
  void dispose() {
    _observacao.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loja = context.watch<Loja>();
    final item = widget.item;
    final salva = loja.observacaoDe(item.id);
    return Scaffold(
      appBar: AppBar(title: Text(item.nome)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.network(item.imagemUrl, height: 180, fit: BoxFit.cover),
          const SizedBox(height: 12),
          Text('${item.tempoMinutos} min de preparo'),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              context.read<Loja>().alternarFavorito(item.id);
            },
            icon: Icon(
              loja.ehFavorito(item.id) ? Icons.star : Icons.star_border,
            ),
            label: Text(loja.ehFavorito(item.id) ? 'Favorita' : 'Favoritar'),
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _observacao,
              decoration: const InputDecoration(
                labelText: 'Observação',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().length < 3) {
                  return 'Mínimo de 3 caracteres';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;
              context.read<Loja>().salvarObservacao(
                item.id,
                _observacao.text.trim(),
              );
            },
            child: const Text('Salvar observação'),
          ),
          if (salva != null) ...[
            const SizedBox(height: 12),
            Text('Salva: $salva'),
          ],
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }
}
