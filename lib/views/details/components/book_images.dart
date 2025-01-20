import 'package:flutter/material.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/widgets/Config.dart';
import 'package:hora_do_conto/widgets/size_config.dart';

class BookImages extends StatefulWidget {
  const BookImages({
    super.key,
    required this.book,
  });

  final Livro book;

  @override
  State<BookImages> createState() => _BookImagesState();
}

class _BookImagesState extends State<BookImages> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: getProportionateScreenWidth(12)),
          child: SizedBox(
            width: getProportionateScreenWidth(238),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                '${Config.baseUrl}${widget.book.imagem_capa}',
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.red);
                },
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [BuildSmallPreviw()],
        )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Container BuildSmallPreviw() {
    return Container(
      margin: EdgeInsets.only(
        right: getProportionateScreenWidth(15),
        top: getProportionateScreenWidth(15),
      ),
      padding: EdgeInsets.all(getProportionateScreenHeight(8)),
      height: getProportionateScreenWidth(48),
      width: getProportionateScreenWidth(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF303030)),
      ),
      child: Image.network(
        '${Config.baseUrl}${widget.book.imagem_capa}',
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error, color: Colors.red);
        },
      ),
    );
  }
}
