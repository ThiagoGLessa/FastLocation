import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/endereco_model.dart';

class CepService {
  Future<Endereco?> consultarCep(String cep) async {
    String url = "https://viacep.com.br/ws/$cep/json/";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('erro')) {
          return null; // CEP inválido
        } else {
          return Endereco.fromJson(data);
        }
      } else {
        throw Exception("Erro na consulta do CEP");
      }
    } catch (e) {
      throw Exception("Erro: $e");
    }
  }
}