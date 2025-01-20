import 'package:flutter/material.dart';
import 'package:hora_do_conto/views/home/components/Book_Section2.dart';
import 'package:hora_do_conto/views/home/components/Special_offers.dart';
import 'package:hora_do_conto/views/home/components/home_header.dart';
import 'package:hora_do_conto/views/home/components/logo_banner.dart';

import 'package:hora_do_conto/widgets/size_config.dart';
import 'package:hora_do_conto/models/livro.dart';

class Body extends StatelessWidget {
  final List<Livro> livros; // Recebe a lista de livros

  const Body({
    Key? key,
    required this.livros, // Adiciona o parâmetro obrigatório de livros
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Lista de livros recebida:");
    print(livros);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenWidth(25)),
            HomeHeader(
              livros: livros,
            ), // Cabeçalho da página
            SizedBox(height: getProportionateScreenWidth(2)),
            const LogoBanner(), // Banner com logo
            SizedBox(height: getProportionateScreenWidth(2)),
            SpecialOffers(livros: livros),
            SizedBox(height: getProportionateScreenWidth(15)),
            // Seção de Livros Populares
            BookSection(
              text: 'Livros Populares',
              books: livros, // Passa a lista de livros diretamente
            ),
            SizedBox(height: getProportionateScreenWidth(5)),
            // Adicione mais seções aqui se necessário
          ],
        ),
      ),
    );
  }
}
