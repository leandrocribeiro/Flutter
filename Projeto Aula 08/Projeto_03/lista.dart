import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_sqlite2/classecao.dart';

class Lista extends StatefulWidget {
  final Database database;
  const Lista({super.key, required this.database});

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  late Future<List<Cao>> listaCaes;

  @override
  void initState() {
    super.initState();
    // Inicialmente carrega a lista de cães ao iniciar a aba
    listaCaes = _carregarCaes();
  }

  Future<List<Cao>> _carregarCaes() async {
    final db = widget.database;
    final List<Map<String, dynamic>> maps = await db.query('caes');

    return List.generate(maps.length, (i) {
      return Cao(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        raca: maps[i]['raca'],
        idade: maps[i]['idade'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              // Recarrega a lista de cães quando o botão é pressionado
              setState(() {
                listaCaes = _carregarCaes();
              });
            },
            child: const Text('Atualizar Lista'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Cao>>(
              future: listaCaes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text('Erro ao carregar dados');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Nenhum registro encontrado');
                } else {
                  // Exibe a lista de cães, incluindo o ID
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final cao = snapshot.data![index];
                      return Card(
                        child: ListTile(
                          title: Text('ID: ${cao.id} - Nome: ${cao.nome}'),
                          subtitle: Text(
                            'Raça: ${cao.raca}, Idade: ${cao.idade} anos',
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
