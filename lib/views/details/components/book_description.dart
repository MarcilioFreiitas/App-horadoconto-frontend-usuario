import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/widgets/size_config.dart';

class BookDescription extends StatefulWidget {
  final Livro book;

  const BookDescription({
    super.key,
    required this.book,
  });

  @override
  _BookDescriptionState createState() => _BookDescriptionState();
}

class _BookDescriptionState extends State<BookDescription> {
  bool _isExpanded = false; // Controla se o texto está expandido ou não

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Text(
            widget.book.titulo,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 24, // Aumenta o tamanho da fonte do título
                  fontWeight: FontWeight.normal, // Deixa o título sem negrito
                ),
            maxLines: 2, // Limita o título a 2 linhas
            overflow: TextOverflow
                .ellipsis, // Adiciona reticências se o texto ultrapassar 2 linhas
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        // Ícone de coração funcional com o tamanho especificado
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              setState(() {
                widget.book.toggleFavorite(); // Alterna o estado de favorito
              });
            },
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(12)),
              width: getProportionateScreenWidth(64),
              decoration: BoxDecoration(
                color: widget.book.isFavorite
                    ? const Color(0xFFFFE6E6) // Cor de fundo quando favorito
                    : const Color(
                        0xFFF5F6F9), // Cor de fundo quando não favorito
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: SvgPicture.asset(
                "assets/icons/Heart Icon_2.svg",
                color: widget.book.isFavorite
                    ? const Color(0xFFFF4848) // Cor do coração quando favorito
                    : const Color(
                        0xFFDBDEE4), // Cor do coração quando não favorito
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        // Texto da sinopse com expansão
        Padding(
          padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(64)),
          child: Text(
            widget.book.sinopse,
            maxLines:
                _isExpanded ? null : 3, // Mostra 3 linhas ou todas as linhas
            overflow: _isExpanded
                ? TextOverflow.visible
                : TextOverflow.ellipsis, // Controla a visualização
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: 10,
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded; // Alterna o estado de expansão
              });
            },
            child: Row(
              children: [
                Text(
                  _isExpanded
                      ? "Mostrar Menos"
                      : "Ver Mais", // Altera o texto conforme o estado
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
