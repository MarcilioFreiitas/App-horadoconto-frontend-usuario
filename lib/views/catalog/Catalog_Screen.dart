import 'package:flutter/material.dart';
import 'package:hora_do_conto/views/catalog/components/body.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/widgets/theme.dart';

class CatalogScreen extends StatelessWidget {
  static String routeName = "/catalog";
  final List<Livro> livros; // Recebe a lista de livros

  const CatalogScreen({
    Key? key,
    required this.livros, // Adiciona o parâmetro obrigatório de livros
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme(context),
      child: Scaffold(
        body: Body(livros: livros), // Passa a lista para o Body
      ),
    );
  }
}
