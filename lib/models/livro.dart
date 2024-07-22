enum Disponibilidade { disponivel, emprestado, reservado }

class Livro {
  final int id;
  final String titulo;
  final String autor;
  final String genero;
  final String sinopse;
  final String isbn;
  final String imagem_capa;
  final String disponibilidade;

  Livro(
      {required this.id,
      required this.titulo,
      required this.autor,
      required this.genero,
      required this.sinopse,
      required this.isbn,
      required this.imagem_capa,
      required this.disponibilidade});

  factory Livro.fromJson(Map<String, dynamic> json) {
    return Livro(
      id: json['id'],
      titulo: json['titulo'],
      autor: json['autor'],
      genero: json['genero'],
      sinopse: json['sinopse'],
      isbn: json['isbn'],
      imagem_capa: json['imagem_capa'],
      disponibilidade: json['disponibilidade'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'genero': genero,
      'sinopse': sinopse,
      'isbn': isbn,
      'imagem_capa': imagem_capa,
      'disponibilidade': disponibilidade.toString(),
    };
  }
}
