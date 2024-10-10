class Cao {
  final int? id;
  final String nome;
  final String raca;
  final int idade;

  Cao({
    this.id,
    required this.nome,
    required this.raca,
    required this.idade,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'raca': raca,
      'idade': idade,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Cao{id: $id, nome: $nome, raca: $raca, idade: $idade}';
  }
}
