import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aula 20/08',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Aula01(),
    );
  }
}

class Aula01 extends StatefulWidget {
  const Aula01({super.key});

  @override
  State<Aula01> createState() => _Aula01State();
}

class _Aula01State extends State<Aula01> {
  final TextEditingController _controller = TextEditingController();
  final List<String> names = [];

  void _addText([String? value]) {
    final text = (value ?? _controller.text).trim();
    if (text.isNotEmpty) {
      setState(() {
        names.add(text);
        _controller.clear();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      names.removeAt(index);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                onSubmitted: (value) => _addText(value),
                decoration: InputDecoration(
                  hintText: "Digite algo...",
                  labelText: "Nome",
                  prefixIcon: const Icon(Icons.remove_red_eye),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _addText(),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text("$index")),
                        title: Text(names[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeItem(index),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
