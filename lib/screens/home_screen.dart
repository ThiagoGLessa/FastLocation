import 'package:flutter/material.dart';
import '../services/cep_service.dart';
import '../controllers/historico_controller.dart';
import '../models/endereco_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController txtcep = TextEditingController();
  final CepService _cepService = CepService();
  final HistoricoController _historicoController = HistoricoController();

  String resultado = "";
  String enderecoParaMaps = "";
  List<String> historico = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  _consultarCep() async {
    String cep = txtcep.text;

    if (cep.isEmpty) {
      setState(() {
        resultado = "Por favor, insira um CEP válido.";
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    Endereco? endereco = await _cepService.consultarCep(cep);

    if (endereco == null) {
      setState(() {
        resultado = "CEP não encontrado.";
      });
    } else {
      setState(() {
        resultado = "${endereco.logradouro}, ${endereco.bairro}, ${endereco.cidade}";
        enderecoParaMaps = resultado;
      });

      await _historicoController.adicionarAoHistorico(resultado);
      _carregarHistorico();
    }

    setState(() {
      isLoading = false;
    });
  }

  _carregarHistorico() async {
    List<String> hist = await _historicoController.carregarHistorico();
    setState(() {
      historico = hist;
    });
  }

  _abrirNoMaps(String endereco) async {
    String query = Uri.encodeComponent(endereco);
    String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$query";

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
        title: const Text("Consulta de CEP"),
        backgroundColor: Colors.indigo,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: txtcep,
                    decoration: InputDecoration(
                      labelText: "Digite o Cep ex: 89107000",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  ElevatedButton(onPressed: _consultarCep, child: const Text("Consultar")),
                  if (resultado.isNotEmpty) Text(resultado),
                  const Divider(),
                  Text("Histórico de consultas:"),
                  if (historico.isEmpty)
                    const Text("Nenhum histórico disponível"),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: historico.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(historico[index]),
                        onTap: () => _abrirNoMaps(historico[index]),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}