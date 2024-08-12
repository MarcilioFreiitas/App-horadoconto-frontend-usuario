import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/models/usuario.dart';

enum EmprestimoStatus {
  ATRASADO,
  REJEITADO,
  PENDENTE,
  EMPRESTADO
} // Assuming StatusEmprestimo is an enum

class Emprestimo {
  final int id;
  final Usuario usuario;
  final Livro livro;
  final DateTime dataRetirada;
  final DateTime dataDevolucao;
  final EmprestimoStatus status;

  Emprestimo({
    required this.id,
    required this.usuario,
    required this.livro,
    required this.dataRetirada,
    required this.dataDevolucao,
    required this.status,
  });

  factory Emprestimo.fromJson(Map<String, dynamic> json) => Emprestimo(
        id: json['id'] as int,
        usuario: Usuario.fromJson(json['usuario'] as Map<String, dynamic>),
        livro: Livro.fromJson(json['livro'] as Map<String, dynamic>),
        dataRetirada: DateTime.parse(json['dataRetirada'] as String),
        dataDevolucao: DateTime.parse(json['dataDevolucao'] as String),
        status: EmprestimoStatus.values.firstWhere(
            (element) =>
                element.toString() ==
                'EmprestimoStatus.${json['statusEmprestimo']}',
            orElse: () => EmprestimoStatus.PENDENTE),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuario': usuario.toJson(),
        'livro': livro.toJson(),
        'dataRetirada': dataRetirada.toIso8601String(),
        'dataDevolucao': dataDevolucao.toIso8601String(),
        'status': status.toString().split('.').last,
      };
}
