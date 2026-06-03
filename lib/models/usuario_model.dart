class UsuarioModel {
  final String id;
  final String nome;
  final String email;
  final String perfil;

  UsuarioModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.perfil,
  });

  // Transforma os dados vindos do Firebase em um "Objeto" no Flutter
  factory UsuarioModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UsuarioModel(
      id: documentId,
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      perfil: map['perfil'] ?? 'analista', // Padrão é analista se não vier nada
    );
  }

  // Prepara o "Objeto" do Flutter para ser salvo no Firebase
  Map<String, dynamic> toMap() {
    return {'nome': nome, 'email': email, 'perfil': perfil};
  }
}
