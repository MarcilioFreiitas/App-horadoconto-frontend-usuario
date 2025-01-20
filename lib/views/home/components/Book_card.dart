import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/widgets/Config.dart';
import 'package:hora_do_conto/widgets/size_config.dart';
import 'package:hora_do_conto/widgets/constants.dart';

class BookCard extends StatefulWidget {
  const BookCard({
    Key? key,
    this.width = 130,
    this.aspectRatio = 0.8,
    required this.book,
    required this.press,
  }) : super(key: key);

  final double width;
  final double aspectRatio;
  final Livro book;
  final GestureTapCallback press;

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: widget.press,
        child: SizedBox(
          width: getProportionateScreenWidth(widget.width),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: widget.aspectRatio,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.network(
                    '${Config.baseUrl}' + widget.book.imagem_capa,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.red);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // Defina uma altura mínima para o título
              Container(
                height: getProportionateScreenWidth(
                    40), // Ajuste conforme necessário
                child: Text(
                  widget.book.titulo,
                  style: const TextStyle(color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, // Para evitar overflow
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.book.disponibilidade == 'true'
                        ? "Disponível"
                        : "Indisponível",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(16),
                      fontWeight: FontWeight.w600,
                      color: widget.book.disponibilidade == 'true'
                          ? const Color(0xFF34942c)
                          : const Color(0xFFcb0c0c),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      setState(() {
                        widget.book.toggleFavorite();
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                      width: getProportionateScreenWidth(25),
                      height: getProportionateScreenWidth(25),
                      decoration: BoxDecoration(
                        color: widget.book.isFavorite
                            ? kPrimaryColor.withOpacity(0.15)
                            : kSecondaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/Heart Icon_2.svg",
                        colorFilter: ColorFilter.mode(
                          widget.book.isFavorite
                              ? const Color(0xFFFF4848)
                              : const Color(0xFFDBDEE4),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
