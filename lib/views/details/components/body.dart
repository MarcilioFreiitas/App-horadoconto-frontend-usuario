import 'package:flutter/material.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/views/details/components/book_description.dart';
import 'package:hora_do_conto/views/details/components/book_images.dart';
import 'package:hora_do_conto/views/details/components/top_Rounded_Container.dart';
import 'package:hora_do_conto/views/finish_borrowing/borrowing_screen.dart';
import 'package:hora_do_conto/widgets/default_button.dart';
import 'package:hora_do_conto/widgets/size_config.dart';

class Body extends StatelessWidget {
  final Livro book;
  final List<Livro> livros;

  const Body({super.key, required this.book, required this.livros});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Adicionando scroll para evitar overflow
      child: Column(
        children: [
          BookImages(book: book),
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                BookDescription(
                  book: book,
                ),
                TopRoundedContainer(
                  color: Color(0xFFF6F7F9), // Cor do segundo TopRounded
                  child: Padding(
                    // Modificando padding para diminuir altura
                    padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(
                          5), // Reduzindo o padding vertical
                    ),
                    child: Column(
                      children: [
                        // Aqui vai o TopRoundedContainer branco
                        TopRoundedContainer(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.screenWidth * 0.15,
                              right: SizeConfig.screenWidth * 0.15,
                              bottom: getProportionateScreenHeight(10),
                            ),
                            child: DefaultButton(
                              text: book.disponibilidade == 'true'
                                  ? "Realizar Empréstimo"
                                  : "Indisponível",
                              press: () {
                                if (book.disponibilidade == 'true') {
                                  // Prosseguir para a tela de finalização do empréstimo
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Borrowing(
                                        book: book,
                                        livros: livros,
                                      ),
                                    ),
                                  );
                                } else {
                                  // Se o livro estiver indisponível, exibe uma mensagem
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'O livro está indisponível no momento.'),
                                    ),
                                  );
                                }
                              },
                              color: book.disponibilidade == 'true'
                                  ? Colors.black
                                  : Colors.grey, // Cor do botão
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
