import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hora_do_conto/views/home/home_screen.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/widgets/constants.dart';
import 'package:hora_do_conto/widgets/size_config.dart';

class CustomAppBar extends StatelessWidget {
  final List<Livro> livros; // Adicione a lista de livros como parâmetro
  final String isbn; // Adicione o valor do ISBN como parâmetro

  const CustomAppBar({
    Key? key,
    required this.livros, // Recebe a lista de livros
    required this.isbn, // Recebe o valor do ISBN
  }) : super(key: key);

  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getProportionateScreenWidth(15)),
      child: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botão de Voltar
              SizedBox(
                height: getProportionateScreenWidth(40),
                width: getProportionateScreenWidth(40),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    foregroundColor: kDefaultIconLightColor,
                    backgroundColor: kSecondaryColor.withOpacity(0.1),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    "assets/icons/Back ICon.svg",
                    height: 15,
                  ),
                ),
              ),

              // ISBN com o mesmo estilo do botão de voltar
              SizedBox(
                height: getProportionateScreenWidth(40),
                width: getProportionateScreenWidth(80), // Largura ajustável
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    foregroundColor: kDefaultIconLightColor,
                    backgroundColor: kSecondaryColor.withOpacity(0.1),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    // Ação para o ISBN, se necessário
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        double.parse(isbn).toStringAsFixed(1), // Formata o ISBN
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: getProportionateScreenWidth(
                                  12), // Ajusta o tamanho
                              fontWeight:
                                  FontWeight.w600, // Mantém o peso da fonte
                              color: Colors.black87, // Sobrescreve a cor
                            ),
                      ),
                      SizedBox(width: getProportionateScreenWidth(5)),
                      SvgPicture.asset(
                        "assets/icons/Star Icon.svg", // Ícone de estrela
                        height: getProportionateScreenWidth(16),
                        color: Colors.yellow, // Cor da estrela
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
