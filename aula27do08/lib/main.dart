import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AulaFormulario(),
    );
  }
}

class AulaFormulario extends StatefulWidget {
  const AulaFormulario({super.key});

  @override
  State<AulaFormulario> createState() => _AulaFormularioState();
}

class _AulaFormularioState extends State<AulaFormulario> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool get _isFormValid {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    return email.isNotEmpty &&
        _emailRegEx.hasMatch(email) &&
        password.isNotEmpty &&
        password.length >= 8;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void entrar() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login efetuado com sucesso"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aula Formulario")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Digite seu email',
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email vazio";
                  }
                  if (!_emailRegEx.hasMatch(value)) {
                    return "Email inválido";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Digite sua senha',
                  labelText: "Senha",
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Senha vazia";
                  }
                  if (value.length < 8) {
                    return "Senha inválida";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _isFormValid ? entrar : null,
                child: const Text("Entrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
