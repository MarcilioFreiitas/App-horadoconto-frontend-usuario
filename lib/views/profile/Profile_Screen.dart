import 'package:flutter/material.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/widgets/custom_Bottom_Nav_Bar.dart';
import 'package:hora_do_conto/widgets/enums.dart';
import 'package:hora_do_conto/widgets/theme.dart';

import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key, required this.livros});
  final List<Livro> livros;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme(context),
      child: Scaffold(
        appBar: null,
        body: Padding(
          padding: const EdgeInsets.only(top: 50.0), // Espaço no topo
          child: Body(),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedMenu: MenuState.profile,
          livros: livros,
        ),
      ),
    );
  }
}
