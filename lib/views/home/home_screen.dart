import 'package:flutter/material.dart';
import 'package:hora_do_conto/widgets/custom_Bottom_Nav_Bar.dart';
import 'package:hora_do_conto/widgets/enums.dart';
import 'package:hora_do_conto/views/home/components/body.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/widgets/theme.dart';

class HomeScreen extends StatelessWidget {
  final List<Livro> livros; // Recebe a lista de livros

  const HomeScreen({
    Key? key,
    required this.livros, // Adiciona o parâmetro obrigatório de livros
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme(context),
      child: Scaffold(
        body: Body(livros: livros), // Passa a lista para o Body
        bottomNavigationBar: CustomBottomNavBar(
          selectedMenu: MenuState.home,
          livros: livros,
        ),
      ),
    );
  }
}
