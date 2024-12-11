import 'package:flutter/material.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/views/home/components/Book_card.dart';

class GenreSection extends StatelessWidget {
  final String genre;
  final List<Livro> books;

  const GenreSection({
    Key? key,
    required this.genre,
    required this.books,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            genre,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200, // Ajuste a altura conforme necessário
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              return BookCard(
                book: books[index],
                press: () {
                  // Ação quando o card do livro for pressionado
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
