class Endereco {
  final String logradouro;
  final String bairro;
  final String cidade;

  Endereco({
    required this.logradouro,
    required this.bairro,
    required this.cidade,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      logradouro: json['logradouro'] ?? "Não informado",
      bairro: json['bairro'] ?? "Não informado",
      cidade: json['localidade'] ?? "Não informado",
    );
  }
}