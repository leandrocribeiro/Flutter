import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Cartão de Visitas',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Meu Cartão',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Leandro Cesar Ribeiro',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('Professor de Engenharia, Física e Matemática'),
              Text('Unifafibe e Colégio PLUS'),
              Text('leandrocribeiro@gmail.com'),
            ],
          ),
        ),
      ),
    );
  }
}
