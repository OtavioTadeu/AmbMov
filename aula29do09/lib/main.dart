import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// =============================================================================
// AULA 17 - Provider (gerenciamento de estado)
// Data: 29/09/2026 (terça) | 19:00-22:40
// =============================================================================
//
// CONTEXTO: setState vive dentro de UM State. A outra tela não vê a mudança.
// Hoje: um objeto acima das telas (ChangeNotifier) e widgets que escutam.
//
// ANTES DE RODAR:
//   flutter pub add provider
//
//   1  o problema — setState não atravessa a outra tela
//   2  ChangeNotifier + ChangeNotifierProvider (uma tela)
//   3  context.watch × context.read
//   4  duas telas no mesmo Contador
//   5  Consumer (outra forma de escutar)
//   6  EXERCÍCIO — carrinho (TODOs)
//
// =============================================================================

/// Mude durante a aula (1 a 6).
const int exemplo = 6;

void main() {
  runApp(appDoExemplo(exemplo));
}

Widget appDoExemplo(int n) {
  switch (n) {
    case 1:
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aula 17 - Provider',
        home: Exemplo1Problema(),
      );
    case 2:
      return _appComContador(const Exemplo2UmaTela());
    case 3:
      return _appComContador(const Exemplo3WatchRead());
    case 4:
      return _appComContador(const Exemplo4DuasTelas());
    case 5:
      return _appComContador(const Exemplo5Consumer());
    case 6:
      return ChangeNotifierProvider(
        create: (_) => CarrinhoLab(),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Aula 17 - Provider',
          home: Exemplo6LabCarrinho(),
        ),
      );
    default:
      return const MaterialApp(debugShowCheckedModeBanner: false, home: Exemplo1Problema());
  }
}

Widget _appComContador(Widget home) {
  return ChangeNotifierProvider(
    create: (_) => Contador(),
    child: MaterialApp(debugShowCheckedModeBanner: false, title: 'Aula 17 - Provider', home: home),
  );
}

// =============================================================================
// O objeto compartilhado (exemplos 2 a 5)
// =============================================================================
class Contador extends ChangeNotifier {
  int valor = 0;

  void incrementar() {
    valor++;
    notifyListeners();
  }

  void zerar() {
    valor = 0;
    notifyListeners();
  }
}

// =============================================================================
// EXEMPLO 1 - O problema: setState não atravessa a outra tela
// =============================================================================
class Exemplo1Problema extends StatefulWidget {
  const Exemplo1Problema({super.key});

  @override
  State<Exemplo1Problema> createState() => _Exemplo1ProblemaState();
}

class _Exemplo1ProblemaState extends State<Exemplo1Problema> {
  int _valor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('1 · O problema')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'O número mora neste State. A outra tela recebe uma cópia na hora do push.\n'
            'Somar lá não muda aqui.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          Text(
            '$_valor',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
          ),
          FilledButton(onPressed: () => setState(() => _valor++), child: const Text('Somar aqui')),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => TelaCopia(valor: _valor)));
            },
            child: const Text('Abrir a outra tela (leva a cópia)'),
          ),
        ],
      ),
    );
  }
}

class TelaCopia extends StatefulWidget {
  const TelaCopia({super.key, required this.valor});

  final int valor;

  @override
  State<TelaCopia> createState() => _TelaCopiaState();
}

class _TelaCopiaState extends State<TelaCopia> {
  late int _copia = widget.valor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Outra tela (cópia)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Este número é outro. Volte: a primeira tela não acompanhou.'),
            const SizedBox(height: 24),
            Text(
              '$_copia',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            FilledButton(onPressed: () => setState(() => _copia++), child: const Text('Somar aqui')),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// EXEMPLO 2 - ChangeNotifierProvider + uma tela
// =============================================================================
class Exemplo2UmaTela extends StatelessWidget {
  const Exemplo2UmaTela({super.key});

  @override
  Widget build(BuildContext context) {
    final contador = context.watch<Contador>();

    return Scaffold(
      appBar: AppBar(title: const Text('2 · Provider, uma tela')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Contador está acima do MaterialApp.\n'
            'context.watch escuta. O botão chama incrementar(), que dá notifyListeners().',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          Text(
            '${contador.valor}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
          ),
          FilledButton(onPressed: contador.incrementar, child: const Text('Somar')),
        ],
      ),
    );
  }
}

// =============================================================================
// EXEMPLO 3 - watch reconstrói; read só chama o método
// =============================================================================
class Exemplo3WatchRead extends StatelessWidget {
  const Exemplo3WatchRead({super.key});

  @override
  Widget build(BuildContext context) {
    final contador = context.watch<Contador>();

    return Scaffold(
      appBar: AppBar(title: const Text('3 · watch × read')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'watch: no build, para mostrar o valor.\n'
            'read: no onPressed, para chamar o método.\n'
            'Não use watch dentro do onPressed.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          Text(
            '${contador.valor}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
          ),
          FilledButton(
            onPressed: () => context.read<Contador>().incrementar(),
            child: const Text('Somar (context.read)'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.read<Contador>().zerar(),
            child: const Text('Zerar (context.read)'),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// EXEMPLO 4 - Duas telas, o mesmo Contador
// =============================================================================
class Exemplo4DuasTelas extends StatelessWidget {
  const Exemplo4DuasTelas({super.key});

  @override
  Widget build(BuildContext context) {
    final contador = context.watch<Contador>();

    return Scaffold(
      appBar: AppBar(title: const Text('4 · Duas telas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'A rota nova continua embaixo do Provider (ele envolve o MaterialApp).\n'
            'Some aqui, abra o resumo, some lá: os dois mostram o mesmo número.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          Text(
            '${contador.valor}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
          ),
          FilledButton(
            onPressed: () => context.read<Contador>().incrementar(),
            child: const Text('Somar nesta tela'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TelaResumo()));
            },
            child: const Text('Abrir resumo'),
          ),
        ],
      ),
    );
  }
}

class TelaResumo extends StatelessWidget {
  const TelaResumo({super.key});

  @override
  Widget build(BuildContext context) {
    final contador = context.watch<Contador>();

    return Scaffold(
      appBar: AppBar(title: const Text('Resumo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Mesmo Contador. Sem copiar o int no push.'),
            const SizedBox(height: 24),
            Text(
              '${contador.valor}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            FilledButton(
              onPressed: () => context.read<Contador>().incrementar(),
              child: const Text('Somar nesta tela'),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// EXEMPLO 5 - Consumer
// =============================================================================
class Exemplo5Consumer extends StatelessWidget {
  const Exemplo5Consumer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('5 · Consumer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Consumer<Contador> escuta só o trecho do builder.\n'
            'O botão usa read, como no exemplo 3.\n'
            'Na disciplina, watch no build é o padrão. Consumer é a outra grafia.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          Consumer<Contador>(
            builder: (context, contador, child) {
              return Text(
                '${contador.valor}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              );
            },
          ),
          FilledButton(onPressed: () => context.read<Contador>().incrementar(), child: const Text('Somar')),
        ],
      ),
    );
  }
}

const List<String> _lanches = ['Pão de queijo', 'Suco', 'Misto'];

// =============================================================================
// EXEMPLO 6 - EXERCÍCIO: carrinho
// OBJETIVO:
//   1) adicionar o nome na lista
//   2) notifyListeners() para a tela redesenhar
//   3) limpar a lista e avisar de novo
// =============================================================================
class CarrinhoLab extends ChangeNotifier {
  final List<String> itens = [];

  void adicionar(String nome) {
    itens.add(nome);
    notifyListeners();
  }

  void limpar() {
    itens.clear();
    notifyListeners();
  }
}

class Exemplo6LabCarrinho extends StatelessWidget {
  const Exemplo6LabCarrinho({super.key});

  @override
  Widget build(BuildContext context) {
    final carrinho = context.watch<CarrinhoLab>();

    return Scaffold(
      appBar: AppBar(title: Text('6 · Lab — Carrinho (${carrinho.itens.length})')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Carrinho compartilhado com Provider.\n'
            'Adicione itens e veja a contagem no AppBar em tempo real.',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 16),
          for (final nome in _lanches) ...[
            FilledButton(
              onPressed: () => context.read<CarrinhoLab>().adicionar(nome),
              child: Text('Adicionar $nome'),
            ),
            const SizedBox(height: 8),
          ],
          OutlinedButton(
            onPressed: () => context.read<CarrinhoLab>().limpar(),
            child: const Text('Limpar Carrinho'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TelaResumoCarrinho()),
              );
            },
            child: const Text('Ver Carrinho em outra tela'),
          ),
          const SizedBox(height: 24),
          Text(
            carrinho.itens.isEmpty
                ? 'Carrinho vazio'
                : carrinho.itens.map((item) => '• $item').join('\n'),
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class TelaResumoCarrinho extends StatelessWidget {
  const TelaResumoCarrinho({super.key});

  @override
  Widget build(BuildContext context) {
    final carrinho = context.watch<CarrinhoLab>();

    return Scaffold(
      appBar: AppBar(title: Text('Resumo do Carrinho (${carrinho.itens.length})')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Esta tela acessa a mesma fonte de verdade (CarrinhoLab) via Provider.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: carrinho.itens.isEmpty
                  ? const Text('O carrinho está vazio.', style: TextStyle(fontSize: 18))
                  : ListView(
                      children: [
                        for (final item in carrinho.itens)
                          ListTile(
                            leading: const Icon(Icons.shopping_cart),
                            title: Text(item),
                          ),
                      ],
                    ),
            ),
            FilledButton(
              onPressed: () => context.read<CarrinhoLab>().adicionar('Pão de queijo'),
              child: const Text('Adicionar Pão de queijo nesta tela'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.read<CarrinhoLab>().limpar(),
              child: const Text('Limpar Carrinho'),
            ),
          ],
        ),
      ),
    );
  }
}
