import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ST2(),
    );
  }
}

class ST2 extends StatefulWidget {
  const ST2({super.key});

  @override
  State<ST2> createState() => _ST2State();
}

class _ST2State extends State<ST2> {
  int _counter = 0;

  void _increment() {
    if (_counter < 10) {
      setState(() {
        _counter++;
      });
    }
  }

  void _decrement() {
    if (_counter > 0) {
      setState(() {
        _counter--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Valor: $_counter',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _counter > 0 ? _decrement : null,
                  icon: const Icon(Icons.remove),
                  label: const Text('Decrementar'),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _counter < 10 ? _increment : null,
                  icon: const Icon(Icons.add),
                  label: const Text('Incrementar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
