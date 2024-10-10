import 'package:flutter/material.dart';
import 'package:flutter_application_sqlite2/lista.dart';
import 'package:flutter_application_sqlite2/cadastro.dart';
import 'package:path/path.dart';
import 'dart:io' show Platform;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit(); // Inicializa o FFI
    databaseFactory = databaseFactoryFfi; // Define o databaseFactory para FFI
  }
  WidgetsFlutterBinding.ensureInitialized();
  final database = await openDatabase(
    join(await getDatabasesPath(), 'petshop.db'),
    onCreate: (db, version) {
      // Executa a criação da tabela no banco de dados
      return db.execute(
        'CREATE TABLE caes(id INTEGER PRIMARY KEY, nome TEXT, raca TEXT, idade INTEGER)',
      );
    },
    version: 1,
  );

  runApp(MainApp(database: database));
}

class MainApp extends StatelessWidget {
  final Database database;

  const MainApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Cadastro DB',
                ),
                Tab(
                  text: 'Lista DB',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Cadastro(
                  database: database), // Passa o database para a aba Cadastro
              Lista(database: database), // Passa o database para a aba Lista
            ],
          ),
        ),
      ),
    );
  }
}
