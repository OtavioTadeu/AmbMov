import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PedidoLab(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aula 18 - Exercício',
        home: CardapioLab(),
      ),
    ),
  );
}

class ItemCardapio {
  const ItemCardapio({
    required this.id,
    required this.nome,
    required this.preco,
    required this.descricao,
  });

  final String id;
  final String nome;
  final double preco;
  final String descricao;
}

const List<ItemCardapio> cardapioInicial = [
  ItemCardapio(
    id: '1',
    nome: 'Pão de queijo',
    preco: 6,
    descricao: 'Quentinho, porção de 4.',
  ),
  ItemCardapio(
    id: '2',
    nome: 'Misto quente',
    preco: 9,
    descricao: 'Presunto e queijo na chapa.',
  ),
  ItemCardapio(id: '3', nome: 'Suco', preco: 5, descricao: 'Laranja, natural.'),
  ItemCardapio(
    id: '4',
    nome: 'Água',
    preco: 3,
    descricao: 'Garrafa de 500 ml.',
  ),
  ItemCardapio(id: '5', nome: 'Brownie', preco: 8, descricao: 'Com cobertura.'),
];

String _preco(double valor) => 'R\$ ${valor.toStringAsFixed(2)}';

class FormularioCadastro extends StatefulWidget {
  const FormularioCadastro({
    super.key,
    required this.aoSalvar,
    this.nomeInicial = '',
    this.precoInicial = '',
  });

  final void Function(String nome, double preco) aoSalvar;
  final String nomeInicial;
  final String precoInicial;

  @override
  State<FormularioCadastro> createState() => _FormularioCadastroState();
}

class _FormularioCadastroState extends State<FormularioCadastro> {
  late final TextEditingController _nomeCtrl = TextEditingController(
    text: widget.nomeInicial,
  );
  late final TextEditingController _precoCtrl = TextEditingController(
    text: widget.precoInicial,
  );
  String? _erro;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _precoCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    final nome = _nomeCtrl.text.trim();
    final preco = double.tryParse(_precoCtrl.text.trim().replaceAll(',', '.'));
    if (nome.isEmpty || preco == null || preco < 0) {
      setState(() => _erro = 'Informe o nome e um preço válido.');
      return;
    }
    widget.aoSalvar(nome, preco);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        TextField(
          controller: _nomeCtrl,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Nome',
            hintText: 'Leite com café',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _precoCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Preço',
            hintText: '7,50',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(onPressed: _salvar, child: const Text('Cadastrar')),
        if (_erro != null) ...[
          const SizedBox(height: 12),
          Text(_erro!, style: const TextStyle(color: Colors.red)),
        ],
      ],
    );
  }
}

class PedidoLab extends ChangeNotifier {
  final List<ItemCardapio> _itens = [...cardapioInicial];
  final Map<String, int> _qtd = {};

  List<ItemCardapio> get itens => List.unmodifiable(_itens);

  int quantidadeDe(String id) => _qtd[id] ?? 0;

  int get totalItens => _qtd.values.fold(0, (soma, qtd) => soma + qtd);

  double get totalReais {
    var soma = 0.0;
    for (final item in _itens) {
      soma += item.preco * quantidadeDe(item.id);
    }
    return soma;
  }

  void adicionar(String id) {
    _qtd[id] = quantidadeDe(id) + 1;
    notifyListeners();
  }

  void remover(String id) {
    if (quantidadeDe(id) <= 1) {
      _qtd.remove(id);
    } else {
      _qtd[id] = quantidadeDe(id) - 1;
    }
    notifyListeners();
  }

  void cadastrar(String nome, double preco) {
    _itens.add(
      ItemCardapio(
        id: '${_itens.length + 1}',
        nome: nome,
        preco: preco,
        descricao: 'Cadastrado na aula.',
      ),
    );
    notifyListeners();
  }
}

class CardapioLab extends StatelessWidget {
  const CardapioLab({super.key});

  void _abrirDetalhe(BuildContext context, ItemCardapio item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalheLab(item: item)),
    );
  }

  void _abrirPedido(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaPedidoLab()),
    );
  }

  void _abrirCadastro(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaCadastroLab()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pedido = context.watch<PedidoLab>();

    return Scaffold(
      appBar: AppBar(
        title: Text('2 · Cardápio (${pedido.totalItens})'),
        actions: [
          IconButton(
            onPressed: () => _abrirCadastro(context),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => _abrirPedido(context),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: pedido.itens.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = pedido.itens[index];
          return ListTile(
            title: Text(item.nome),
            subtitle: Text(_preco(item.preco)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${pedido.quantidadeDe(item.id)}',
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  onPressed: () => context.read<PedidoLab>().adicionar(item.id),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            onTap: () => _abrirDetalhe(context, item),
          );
        },
      ),
    );
  }
}

class DetalheLab extends StatelessWidget {
  const DetalheLab({super.key, required this.item});

  final ItemCardapio item;

  @override
  Widget build(BuildContext context) {
    final qtd = context.watch<PedidoLab>().quantidadeDe(item.id);

    return Scaffold(
      appBar: AppBar(title: Text(item.nome)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.nome,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _preco(item.preco),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              item.descricao,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: () => context.read<PedidoLab>().remover(item.id),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  '$qtd',
                  style: const TextStyle(fontSize: 20),
                ),
                IconButton(
                  onPressed: () => context.read<PedidoLab>().adicionar(item.id),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TelaCadastroLab extends StatelessWidget {
  const TelaCadastroLab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo item')),
      body: FormularioCadastro(
        aoSalvar: (nome, preco) {
          context.read<PedidoLab>().cadastrar(nome, preco);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class TelaPedidoLab extends StatelessWidget {
  const TelaPedidoLab({super.key});

  @override
  Widget build(BuildContext context) {
    final pedido = context.watch<PedidoLab>();
    final escolhidos = pedido.itens
        .where((item) => pedido.quantidadeDe(item.id) > 0)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Pedido')),
      body: escolhidos.isEmpty
          ? const Center(child: Text('Nenhum item ainda'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: escolhidos.length,
                    itemBuilder: (context, index) {
                      final item = escolhidos[index];
                      final qtd = pedido.quantidadeDe(item.id);
                      return ListTile(
                        title: Text(item.nome),
                        subtitle: Text(_preco(item.preco * qtd)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  context.read<PedidoLab>().remover(item.id),
                              icon: const Icon(Icons.remove),
                            ),
                            Text('$qtd'),
                            IconButton(
                              onPressed: () =>
                                  context.read<PedidoLab>().adicionar(item.id),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Total'),
                  trailing: Text(
                    _preco(pedido.totalReais),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
