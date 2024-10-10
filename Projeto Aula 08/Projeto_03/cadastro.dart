import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_application_sqlite2/classecao.dart';

class Cadastro extends StatefulWidget {
  final Database database;
  const Cadastro({super.key, required this.database});
  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController racaController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> insereCao(Cao cao) async {
      final db = widget.database; // Correção aqui
      await db.insert(
        'caes',
        cao.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

//    Future<List<Cao>> caes() async {
//      final db = widget.database;
//      final List<Map<String, Object?>> mapasCaes = await db.query('caes');
//      return [
//        for (final {
//              'id': id as int,
//              'nome': nome as String,
//             'raca': raca as String,
//              'idade': idade as int,
//            } in mapasCaes)
//          Cao(id: id, nome: nome, raca: raca, idade: idade),
//      ];
//    }

    Future<void> atualizaCao(Cao cao) async {
      final db = widget.database;

      await db.update(
        'caes',
        cao.toMap(),
        where: 'id = ?',
        whereArgs: [cao.id],
      );
    }

    Future<void> apagaCao(int id) async {
      final db = widget.database;

      await db.delete(
        'caes',
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Cadastro em Banco de Dados SQLite',
              style: TextStyle(fontSize: 24), // Define o tamanho da fonte
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
              ),
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: racaController,
                decoration: const InputDecoration(
                  labelText: 'Raça',
                ),
              ),
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: idadeController,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () async {
                      var novoCadastro = Cao(
                        nome: nomeController.text,
                        raca: racaController.text,
                        idade: int.parse(idadeController.text),
                      );

                      await insereCao(novoCadastro);
                      nomeController.clear();
                      racaController.clear();
                      idadeController.clear();
                      idController.clear();
                    },
                    child: const Text('Cadastrar'),
                  ),
                ),
                const Text('   '),
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () async {
                      var atualizaCadastro = Cao(
                        id: int.parse(idController.text),
                        nome: nomeController.text,
                        raca: racaController.text,
                        idade: int.parse(idadeController.text),
                      );
                      await atualizaCao(atualizaCadastro);
                    },
                    child: const Text('Atualizar'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () {
                      if (idController.text.isNotEmpty) {
                        var dataid = int.parse(idController.text);
                        apagaCao(dataid);
                      }
                    },
                    child: const Text('Deletar'),
                  ),
                ),
                const Text('   '),
                SizedBox(
                  width: 140,
                  child: TextField(
                    controller: idController,
                    decoration: const InputDecoration(
                      labelText: 'ID',
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
