import 'package:shared_preferences/shared_preferences.dart';

class HistoricoController {
  Future<List<String>> carregarHistorico() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('historico') ?? [];
  }

  Future<void> adicionarAoHistorico(String logradouro) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> historico = await carregarHistorico();
    historico.add(logradouro);
    await prefs.setStringList('historico', historico);
  }
}