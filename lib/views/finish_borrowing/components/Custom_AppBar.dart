import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hora_do_conto/views/home/home_screen.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/widgets/constants.dart';
import 'package:hora_do_conto/widgets/size_config.dart';

class CustomAppBar extends StatelessWidget {
  final List<Livro> livros;

  const CustomAppBar({
    Key? key,
    required this.livros,
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
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(livros: livros), // Passa a lista de livros
                    ),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/Back ICon.svg",
                    height: 15,
                  ),
                ),
              ),

              // Texto centralizado
              Text(
                "Finalização",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),

              // Placeholder vazio para balancear o layout
              SizedBox(
                height: getProportionateScreenWidth(40),
                width: getProportionateScreenWidth(40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
