// Define an enum for user roles
enum UserRoles { ADMIN, USER }

class Usuario {
  final int? id;
  final String? nome;
  final String? sobreNome;
  final String? cpf;
  final String? email;
  final String? senha; // Consider storing a secure hash instead of plain text
  final UserRoles? role;

  Usuario({
    this.id,
    this.nome,
    this.sobreNome,
    this.cpf,
    this.email,
    this.senha,
    this.role,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] != null ? json['id'] as int : null,
      nome: json['nome'] as String?,
      sobreNome: json['sobreNome'] as String?,
      cpf: json['cpf'] as String?,
      email: json['email'] as String?,
      senha: json['senha'] as String?, // Consider secure storage
      role: UserRoles.values.firstWhere(
        (element) => element.toString() == 'UserRoles.${json['role']}',
        orElse: () => UserRoles.USER,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'sobreNome': sobreNome,
      'cpf': cpf,
      'email': email,
      'senha': senha, // Consider secure storage
      'role': role.toString().split('.').last,
    };
  }
}
