import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima Guadalajara',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _temperatura = 'Cargando...';
  String _descripcion = 'Cargando...';
  String _iconoClima =
      ''; // Nueva variable para almacenar el código del icono del clima

  Future<void> _actualizarClima() async {
    final respuesta = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=Guadalajara,Jalisco,MX&appid=4f12c64b03492410a9adfac5bc012246&units=metric'));

    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
      final temperatura = datos['main']['temp'];
      final descripcion = datos['weather'][0]['description'];
      final icono = datos['weather'][0]['icon']; // Obtiene el código del icono

      setState(() {
        _temperatura = temperatura.toStringAsFixed(1) + ' °C';
        _descripcion = descripcion;
        _iconoClima = icono; // Actualiza la variable _iconoClima
      });
    } else {
      print('Error al obtener datos del clima');
    }
  }

  @override
  void initState() {
    super.initState();
    _actualizarClima();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima Guadalajara'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              // Nueva fila para la imagen y la temperatura
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  // Muestra la imagen del clima
                  'http://openweathermap.org/img/wn/$_iconoClima@2x.png',
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 20),
                Text(
                  _temperatura,
                  style: TextStyle(fontSize: 48),
                ),
              ],
            ),
            Text(
              _descripcion,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _actualizarClima,
              child: Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
