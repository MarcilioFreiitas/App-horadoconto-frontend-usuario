import 'package:flutter/material.dart';
import 'package:hora_do_conto/models/livro.dart';

class LivroSearch extends SearchDelegate<String> {
  final List<Livro> livros;

  LivroSearch(this.livros);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Livro> suggestions = query.isEmpty
        ? livros
        : livros.where((Livro livro) {
            return livro.titulo.toLowerCase().contains(query.toLowerCase()) ||
                livro.autor.toLowerCase().contains(query.toLowerCase());
          }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index].titulo),
          subtitle: Text('Autor: ' + suggestions[index].autor),
          onTap: () {
            close(context, suggestions[index].titulo);
          },
        );
      },
    );
  }
}
