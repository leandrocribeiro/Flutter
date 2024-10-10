import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Calculadora(),
      ),
    ),
  );
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final TextEditingController _controlaX = TextEditingController();
  final TextEditingController _controlaY = TextEditingController();
  int resultado = 0;

  @override
  void initState() {
    super.initState();
    carrega();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 100,
              child: TextField(
                controller: _controlaX,
              ),
            ),
            SizedBox(
              width: 100,
              child: TextField(
                controller: _controlaY,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: soma,
          child: const Text('Soma'),
        ),
        const SizedBox(
          height: 50,
        ),
        Text(
          'Resultado: $resultado',
          style: const TextStyle(
            fontSize: 32,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: salva, child: const Text('Salva')),
            ElevatedButton(onPressed: limpa, child: const Text('Limpa')),
          ],
        ),
      ],
    );
  }

  void soma() {
    if (_controlaX.text.isNotEmpty && _controlaY.text.isNotEmpty) {
      int _x = int.parse(_controlaX.text);
      int _y = int.parse(_controlaY.text);
      setState(() {
        resultado = _x + _y;
      });
    }
  }

  void salva() async {
// Load and obtain the shared preferences for this app.
    final prefs = await SharedPreferences.getInstance();
// Save the counter value to persistent storage under the 'counter' key.
    await prefs.setString('valorX', _controlaX.text);
    await prefs.setString('valorY', _controlaY.text);
  }

  void limpa() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('valorX', '');
    await prefs.setString('valorY', '');
    _controlaX.text = '';
    _controlaY.text = '';
  }

  void carrega() async {
    final prefs = await SharedPreferences.getInstance();
    _controlaX.text = prefs.getString('valorX')!;
    _controlaY.text = prefs.getString('valorY')!;
  }
}
