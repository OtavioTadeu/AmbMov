import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// =============================================================================
// AULA 16 - SharedPreferences (persistência local)
// Data: 24/09/2026 (quinta)
// =============================================================================
//
// CONTEXTO: setState some ao fechar o app. Capstone pede favoritos / último login.
// Hoje: gravar e ler no disco com SharedPreferences.
//
// ANTES DE RODAR:
//   flutter pub add shared_preferences
//   flutter pub add http
//
//   1  conceito: memória × disco
//   2  setString / getString
//   3  setBool — favorito
//   4  último login (initState + salvar)
//   5  setStringList — vários favoritos
//   6  remove / clear
//   7  Map<> via JSON (jsonEncode / jsonDecode)
//   8  EXERCÍCIO — login Cotemig + salvar token (pular login se já tiver)
//   9  gabarito do exercício — NÃO projetar cedo
//
// =============================================================================

/// Mude durante a aula (1 a 9).
const int exemplo = 8;

const String urlAutenticacao = 'https://api.cotemig.com.br/v1/autenticacao';
const String chaveToken = 'aula16_cotemig_token';

String _tokenResumo(String token) {
  if (token.length <= 24) return token;
  return '${token.substring(0, 12)}…${token.substring(token.length - 8)}';
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aula 16 - SharedPreferences',
      home: _telaDoExemplo(exemplo),
    );
  }
}

Widget _telaDoExemplo(int n) {
  switch (n) {
    case 1:
      return const Exemplo1MemoriaVsDisco();
    case 2:
      return const Exemplo2SetGetString();
    case 3:
      return const Exemplo3FavoritoBool();
    case 4:
      return const Exemplo4UltimoLogin();
    case 5:
      return const Exemplo5StringList();
    case 6:
      return const Exemplo6RemoveClear();
    case 7:
      return const Exemplo7MapJson();
    case 8:
      return const Exemplo8LabLoginToken();
    default:
      return const Exemplo1MemoriaVsDisco();
  }
}

// =============================================================================
// EXEMPLO 1 - Memória × disco
// =============================================================================
class Exemplo1MemoriaVsDisco extends StatelessWidget {
  const Exemplo1MemoriaVsDisco({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('1 · Memória × disco')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.memory),
              title: Text('Memória (setState)'),
              subtitle: Text('Rápido. Some ao fechar / hot restart.'),
            ),
          ),
          SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.save),
              title: Text('Disco (SharedPreferences)'),
              subtitle: Text('Key → valor. Continua depois do restart.'),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Tipos no prefs: String, int, double, bool, List<String>.\n'
            'Não é banco SQL. Poucas chaves (favorito, login, tema…).',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// EXEMPLO 2 - setString / getString
// =============================================================================
class Exemplo2SetGetString extends StatefulWidget {
  const Exemplo2SetGetString({super.key});

  @override
  State<Exemplo2SetGetString> createState() => _Exemplo2SetGetStringState();
}

class _Exemplo2SetGetStringState extends State<Exemplo2SetGetString> {
  static const _chave = 'aula16_nome';
  final _controller = TextEditingController();
  String _lido = '(ainda não leu)';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chave, _controller.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Salvo no disco')));
  }

  Future<void> _ler() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lido = prefs.getString(_chave) ?? '(vazio / null)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('2 · setString / getString')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Nome', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _salvar, child: const Text('Salvar')),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: _ler, child: const Text('Ler do disco')),
            const SizedBox(height: 24),
            Text('Valor lido: $_lido', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text(
              'Dica: Salve → Hot Restart → aperte Ler. O nome volta.',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// EXEMPLO 3 - Favorito (bool)
// =============================================================================
class Exemplo3FavoritoBool extends StatefulWidget {
  const Exemplo3FavoritoBool({super.key});

  @override
  State<Exemplo3FavoritoBool> createState() => _Exemplo3FavoritoBoolState();
}

class _Exemplo3FavoritoBoolState extends State<Exemplo3FavoritoBool> {
  static const _chave = 'aula16_favorito_rick';
  bool _favorito = false;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _favorito = prefs.getBool(_chave) ?? false;
      _carregando = false;
    });
  }

  Future<void> _alternar() async {
    final prefs = await SharedPreferences.getInstance();
    final novo = !_favorito;
    await prefs.setBool(_chave, novo);
    setState(() => _favorito = novo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3 · Favorito (bool)')),
      body: Center(
        child: _carregando
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _favorito ? Icons.star : Icons.star_border,
                    size: 72,
                    color: _favorito ? Colors.amber : Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _favorito ? 'Rick está nos favoritos' : 'Não favorito',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _alternar,
                    child: Text(_favorito ? 'Remover favorito' : 'Favoritar'),
                  ),
                ],
              ),
      ),
    );
  }
}

// =============================================================================
// EXEMPLO 4 - Último login
// =============================================================================
class Exemplo4UltimoLogin extends StatefulWidget {
  const Exemplo4UltimoLogin({super.key});

  @override
  State<Exemplo4UltimoLogin> createState() => _Exemplo4UltimoLoginState();
}

class _Exemplo4UltimoLoginState extends State<Exemplo4UltimoLogin> {
  static const _chave = 'aula16_ultimo_usuario';
  final _controller = TextEditingController();
  bool _pronto = false;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final salvo = prefs.getString(_chave) ?? '';
    if (!mounted) return;
    setState(() {
      _controller.text = salvo;
      _pronto = true;
    });
  }

  Future<void> _salvar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chave, _controller.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Último usuário lembrado')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('4 · Último login')),
      body: !_pronto
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Usuário / e-mail',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: _salvar, child: const Text('Entrar (e lembrar)')),
                  const SizedBox(height: 16),
                  const Text(
                    'Faça Hot Restart: o campo deve voltar preenchido.',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
    );
  }
}

// =============================================================================
// EXEMPLO 5 - setStringList (vários ids)
// =============================================================================
class Exemplo5StringList extends StatefulWidget {
  const Exemplo5StringList({super.key});

  @override
  State<Exemplo5StringList> createState() => _Exemplo5StringListState();
}

class _Exemplo5StringListState extends State<Exemplo5StringList> {
  static const _chave = 'aula16_favoritos_ids';
  List<String> _ids = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ids = prefs.getStringList(_chave) ?? [];
    });
  }

  Future<void> _adicionar(String id) async {
    if (_ids.contains(id)) return;
    final prefs = await SharedPreferences.getInstance();
    final nova = [..._ids, id];
    await prefs.setStringList(_chave, nova);
    setState(() => _ids = nova);
  }

  Future<void> _remover(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final nova = _ids.where((e) => e != id).toList();
    await prefs.setStringList(_chave, nova);
    setState(() => _ids = nova);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('5 · StringList')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              children: [
                for (final id in ['1', '2', '3', '4'])
                  ActionChip(label: Text('Id $id'), onPressed: () => _adicionar(id)),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _ids.isEmpty
                ? const Center(child: Text('Nenhum favorito ainda'))
                : ListView.builder(
                    itemCount: _ids.length,
                    itemBuilder: (context, i) {
                      final id = _ids[i];
                      return ListTile(
                        title: Text('Personagem #$id'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _remover(id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// EXEMPLO 6 - remove / clear
// =============================================================================
class Exemplo6RemoveClear extends StatefulWidget {
  const Exemplo6RemoveClear({super.key});

  @override
  State<Exemplo6RemoveClear> createState() => _Exemplo6RemoveClearState();
}

class _Exemplo6RemoveClearState extends State<Exemplo6RemoveClear> {
  static const _chave = 'aula16_demo_clear';
  String _status = '…';

  @override
  void initState() {
    super.initState();
    _atualizarStatus();
  }

  Future<void> _atualizarStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _status = prefs.getString(_chave) ?? '(sem valor)';
    });
  }

  Future<void> _gravar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chave, 'dado temporário');
    await _atualizarStatus();
  }

  Future<void> _remover() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chave);
    await _atualizarStatus();
  }

  Future<void> _limparTudo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _atualizarStatus();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('clear() apagou as chaves deste app')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('6 · remove / clear')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Valor atual: $_status', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            FilledButton(onPressed: _gravar, child: const Text('Gravar demo')),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: _remover, child: const Text('remove(chave)')),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: _limparTudo, child: const Text('clear() — cuidado')),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// EXEMPLO 7 - Map<> via JSON
// Prefs NÃO grava Map direto. Transforme em String com jsonEncode e volte
// com jsonDecode (Map<String, dynamic>).
// =============================================================================
class Exemplo7MapJson extends StatefulWidget {
  const Exemplo7MapJson({super.key});

  @override
  State<Exemplo7MapJson> createState() => _Exemplo7MapJsonState();
}

class _Exemplo7MapJsonState extends State<Exemplo7MapJson> {
  static const _chave = 'aula16_perfil_map';

  final _nomeCtrl = TextEditingController();
  final _idadeCtrl = TextEditingController();
  bool _ativo = true;

  Map<String, dynamic>? _lido;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _idadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_chave);

    Map<String, dynamic>? mapa;
    if (json != null && json.isNotEmpty) {
      mapa = jsonDecode(json) as Map<String, dynamic>;
    }

    if (!mounted) return;
    setState(() {
      _lido = mapa;
      if (mapa != null) {
        _nomeCtrl.text = mapa['nome']?.toString() ?? '';
        _idadeCtrl.text = mapa['idade']?.toString() ?? '';
        _ativo = mapa['ativo'] as bool? ?? true;
      }
      _carregando = false;
    });
  }

  Future<void> _salvar() async {
    final prefs = await SharedPreferences.getInstance();

    final mapa = <String, dynamic>{
      'nome': _nomeCtrl.text.trim(),
      'idade': int.tryParse(_idadeCtrl.text.trim()) ?? 0,
      'ativo': _ativo,
    };

    // Map → String JSON → disco
    await prefs.setString(_chave, jsonEncode(mapa));

    if (!mounted) return;
    setState(() => _lido = mapa);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Map salvo (JSON no prefs)')));
  }

  Future<void> _ler() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_chave);

    if (json == null) {
      setState(() => _lido = null);
      return;
    }

    // String JSON → Map
    final mapa = jsonDecode(json) as Map<String, dynamic>;
    setState(() => _lido = mapa);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('7 · Map<> (JSON)')),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'SharedPreferences não tem setMap.\n'
                  'Salve: jsonEncode(mapa) → setString\n'
                  'Leia: getString → jsonDecode → Map<String, dynamic>',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nomeCtrl,
                  decoration: const InputDecoration(labelText: 'nome', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _idadeCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'idade', border: OutlineInputBorder()),
                ),
                SwitchListTile(
                  title: const Text('ativo'),
                  value: _ativo,
                  onChanged: (v) => setState(() => _ativo = v),
                ),
                FilledButton(onPressed: _salvar, child: const Text('Salvar Map')),
                const SizedBox(height: 8),
                OutlinedButton(onPressed: _ler, child: const Text('Ler Map do disco')),
                const SizedBox(height: 24),
                Text(
                  _lido == null
                      ? 'Map lido: (vazio)'
                      : 'Map lido:\n'
                            '  nome: ${_lido!['nome']}\n'
                            '  idade: ${_lido!['idade']}\n'
                            '  ativo: ${_lido!['ativo']}\n\n'
                            'JSON: ${jsonEncode(_lido)}',
                  style: const TextStyle(fontSize: 16, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Teste: Salvar → Hot Restart → Ler. O Map volta.',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
    );
  }
}

// =============================================================================
// EXEMPLO 8 - EXERCÍCIO: login Cotemig + token no prefs
// OBJETIVO:
//   1) Login na API Cotemig (Aula 14)
//   2) Se der certo → salvar o token no SharedPreferences
//   3) Ao abrir o app de novo → se já tiver token, PULAR o login (ir pra Home)
//   4) Sair → apagar o token e voltar ao login
// =============================================================================
class Exemplo8LabLoginToken extends StatefulWidget {
  const Exemplo8LabLoginToken({super.key});

  @override
  State<Exemplo8LabLoginToken> createState() => _Exemplo8LabLoginTokenState();
}

class _Exemplo8LabLoginTokenState extends State<Exemplo8LabLoginToken> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();

  /// Enquanto lê o prefs no início.
  bool _verificando = true;

  /// true = Home; false = tela de Login.
  bool _logado = false;

  String? _token;
  bool _carregandoLogin = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _verificarSessao();
  }

  @override
  void dispose() {
    _usuarioCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  /// Lê o token do disco. Se existir → Home. Senão → Login.
  Future<void> _verificarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(chaveToken);

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      setState(() {
        _token = token;
        _logado = true;
        _verificando = false;
      });
    } else {
      setState(() {
        _logado = false;
        _verificando = false;
      });
    }
  }

  Future<void> _entrar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _carregandoLogin = true;
      _erro = null;
    });

    try {
      final usuario = _usuarioCtrl.text.trim();
      final senha = _senhaCtrl.text;
      final basic = base64Encode(utf8.encode('$usuario:$senha'));

      final response = await http.post(
        Uri.parse(urlAutenticacao),
        headers: {'Authorization': 'Basic $basic', 'Accept': 'application/json'},
      );

      if (!mounted) return;

      if (response.statusCode == 401) {
        throw Exception('Usuário ou senha inválidos');
      }
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final map = jsonDecode(response.body) as Map<String, dynamic>;
      final token = map['token'] as String?;
      if (token == null || token.isEmpty) {
        throw Exception('Resposta sem token');
      }

      // Salvar o token no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(chaveToken, token);

      setState(() {
        _token = token;
        _logado = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _erro = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _carregandoLogin = false);
    }
  }

  /// Apaga o token e volta para a tela de login.
  Future<void> _sair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(chaveToken);

    setState(() {
      _token = null;
      _logado = false;
      _usuarioCtrl.clear();
      _senhaCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_verificando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_logado) {
      return _buildHome();
    }
    return _buildLogin();
  }

  Widget _buildLogin() {
    return Scaffold(
      appBar: AppBar(title: const Text('8 · Lab — Login + token'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.school, size: 64, color: Colors.blue),
              const SizedBox(height: 8),
              const Text(
                'Portal COTEMIG',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'TODOs:\n'
                '1–3  Ao abrir: ler token → se tiver, _logado = true\n'
                '4    Depois do login 200: setString(token)\n'
                '5    No Sair: remove(token)\n'
                'Teste: login → Hot Restart → deve pular o login.',
                style: TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _usuarioCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Usuário (Portal)',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Digite o usuário' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _senhaCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Digite a senha' : null,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _carregandoLogin ? null : _entrar,
                child: _carregandoLogin
                    ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Entrar'),
              ),
              if (_erro != null) ...[
                const SizedBox(height: 16),
                Text(_erro!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHome() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home (logado)'),
        actions: [TextButton(onPressed: _sair, child: const Text('Sair'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Sessão ativa',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Token:\n${_token == null ? "(null)" : _tokenResumo(_token!)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Se o TODO 4 estiver certo: Hot Restart deve abrir direto nesta Home.\n'
              'Sair (TODO 5) deve voltar ao login e exigir autenticar de novo.',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
