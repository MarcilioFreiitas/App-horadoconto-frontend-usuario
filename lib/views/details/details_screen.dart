import 'package:flutter/material.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/views/details/components/body.dart';
import 'package:hora_do_conto/views/details/components/Custom_AppBar.dart';
import 'package:hora_do_conto/widgets/theme.dart'; // Import do tema

class DetailsScreen extends StatelessWidget {
  final Livro book;
  final List<Livro> livros;

  const DetailsScreen({Key? key, required this.book, required this.livros})
      : super(key: key);

  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme(context), // Aplica o tema personalizado
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F9),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: CustomAppBar(
            livros: livros,
            isbn: book.isbn,
          ),
        ),
        body: Body(
          book: book,
          livros: livros,
        ),
      ),
    );
  }
}
