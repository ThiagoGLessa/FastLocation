import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController txtcep = TextEditingController();
  String resultado = "";
  String enderecoParaMaps = "";
  List<String> historico = [];
  bool isLoading = false; // Variável para controlar o estado de carregamento

  @override
  void initState() {
    super.initState();
    _carregarHistorico(); // Carregar o histórico ao iniciar
  }

  // Função para consultar o CEP
  _consultarCep() async {
    String cep = txtcep.text;

    if (cep.isEmpty) {
      setState(() {
        resultado = "Por favor, insira um CEP válido.";
      });
      return;
    }

    setState(() {
      isLoading = true; // Iniciar o carregamento
    });

    String url = "https://viacep.com.br/ws/$cep/json/";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> retorno = json.decode(response.body);

        if (retorno.containsKey('erro')) {
          setState(() {
            resultado = "CEP não encontrado.";
          });
        } else {
          String logradouro = retorno["logradouro"] ?? "Não informado";
          String cidade = retorno["localidade"] ?? "Não informado";
          String bairro = retorno["bairro"] ?? "Não informado";

          setState(() {
            resultado = "$logradouro, $bairro, $cidade";
            enderecoParaMaps =
                "$logradouro, $bairro, $cidade"; // Endereço para o Maps
          });

          // Adicionar ao histórico e salvar localmente
          _adicionarAoHistorico(resultado);
        }
      } else {
        setState(() {
          resultado = "Erro na consulta do CEP.";
        });
      }
    } catch (e) {
      setState(() {
        resultado = "Erro: $e";
      });
    }

    setState(() {
      isLoading = false; // Finalizar o carregamento
    });
  }

  // Função para carregar o histórico do armazenamento local
  _carregarHistorico() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      historico = prefs.getStringList('historico') ?? [];
    });
  }

  // Função para adicionar um novo logradouro ao histórico
  _adicionarAoHistorico(String logradouro) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    historico.add(logradouro);
    await prefs.setStringList('historico', historico);
  }

  // Função para abrir o Google Maps com o endereço
  _abrirNoMaps(String endereco) async {
    String query = Uri.encodeComponent(endereco);
    String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw "Não foi possível abrir o endereço no Google Maps.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Consulta de CEP",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body:
          isLoading // Se estiver carregando, exibe o indicador de carregamento
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors
                        .indigo, // Cor personalizada do indicador de progresso
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Informe o CEP para consulta:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Digite o Cep ex: 89107000",
                            labelStyle: const TextStyle(color: Colors.indigo),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Colors.indigo),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Colors.indigo, width: 2),
                            ),
                          ),
                          style: const TextStyle(fontSize: 18),
                          controller: txtcep,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _consultarCep,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          child: const Text(
                            "Consultar",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 30),
                        if (resultado.isNotEmpty)
                          Column(
                            children: [
                              Card(
                                elevation: 8,
                                shadowColor: Colors.indigo.withOpacity(0.3),
                                margin: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Resultado:",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        resultado,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 20),
                        const Divider(),
                        Text(
                          "Histórico de consultas:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (historico.isEmpty)
                          const Text("Nenhum histórico disponível"),
                        if (historico.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: historico.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 4,
                                shadowColor: Colors.grey.withOpacity(0.5),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: Icon(Icons.location_on,
                                      color: Colors.indigo),
                                  title: Text(historico[index]),
                                  tileColor: Colors.grey[100],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
      floatingActionButton: resultado.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _abrirNoMaps(enderecoParaMaps),
              backgroundColor: Colors.green,
              child: const Icon(Icons.map, color: Colors.white),
              tooltip: "Abrir no Google Maps",
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
