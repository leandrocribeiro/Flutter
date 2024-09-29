import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_application_geolocator_win/current.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  var textUmidade = '';
  var textTemperatura = '';
  late Position posicao;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              const Text(
                'Sistema Busca Geolocalização',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 300, // Defina a largura
                height: 60, // Defina a altura
                child: TextField(
                  controller: latitudeController,
                  decoration: const InputDecoration(
                    labelText: 'Latitude Encontrada',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 300, // Defina a largura
                height: 60, // Defina a altura
                child: TextField(
                  controller: longitudeController,
                  decoration: const InputDecoration(
                    labelText: 'Longitude Encontrada',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text('Temperatura: $textTemperatura'),
              Text('Umidade Relativa: $textUmidade'),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: buscaGEO,
                child: const Text('Buscar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void buscaGEO() async {
    Position position = await _determinePosition();
    String Lat = '${position.latitude}';
    String Lon = '${position.longitude}';

    //  String latitude = latitudeController.text;
    //  String longitude = longitudeController.text;

    String url =
        'https://api.open-meteo.com/v1/forecast?latitude=$Lat&longitude=$Lon&current=temperature_2m,relative_humidity_2m&forecast_days=1';

    final resposta = await http.get(Uri.parse(url));
    if (resposta.body.length <= 21) {
      setState(() {
        latitudeController.clear();
        longitudeController.clear();
      });
    } else if (resposta.statusCode == 200) {
      // resposta 200 OK
      // o body contém JSON
      final jsonDecodificado = jsonDecode(resposta.body);
      final jsonTempoAtual = jsonDecodificado['current'];
      final valores = Current.fromJson(jsonTempoAtual);
      setState(() {
        textTemperatura = valores.temperatura.toString();
        textUmidade = valores.umidadeRelativa.toString();
        latitudeController.text = Lat;
        longitudeController.text = Lon;
      });
    } else {
      // diferente de 200
      throw Exception('Falha no carregamento.');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
