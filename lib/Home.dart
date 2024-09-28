import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController txtcep = new TextEditingController();
  String resultado;

  _consultarCep() async {
    print("teste");
    String cep = txtcep.text;

    String url = "https://viacep.com.br/ws/${cep}/json/";

    http.Response response;

    response = await http.get(url);

    Map<String, dynamic> retorno = json.decode(response.body);

    String logradouro = retorno["logradouro"];
    String cidade = retorno["localidade"];
    String bairro = retorno["bairro"];
    print("${logradouro}, ${bairro}, ${cidade}");
    setState(() {
      resultado = "${logradouro}, ${bairro}, ${cidade}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultando um CEP via API"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Digite o Cep ex: 89107000",
              ),
              style: TextStyle(fontSize: 15),
              controller: txtcep,
            ),
            Text(
              "Resultado: ${resultado}",
              style: TextStyle(fontSize: 25),
            ),
            ElevatedButton(
              child: const Text(
                "Consultar",
                style: TextStyle(fontSize: 15),
              ),
              onPressed: _consultarCep,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}