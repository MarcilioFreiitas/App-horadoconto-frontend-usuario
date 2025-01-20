import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hora_do_conto/widgets/constants.dart';
import 'package:hora_do_conto/widgets/size_config.dart';

class CustomAppBar extends StatefulWidget {
  final Function(String) onSearchChanged; // Função de callback para pesquisa

  const CustomAppBar({
    Key? key,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

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

              // Título "Meus Empréstimos"
              isSearching
                  ? Expanded(
                      child: TextField(
                        controller: searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Pesquisar...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor:
                              Colors.grey[200], // Cor de fundo mais clara
                          contentPadding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenWidth(8),
                            horizontal: getProportionateScreenWidth(12),
                          ), // Ajuste o padding para reduzir a altura
                        ),
                        style: TextStyle(color: Colors.black),
                        onChanged: widget.onSearchChanged,
                      ),
                    )
                  : Text(
                      "Meus Empréstimos",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),

              // Lupa para ativar pesquisa
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
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                      if (!isSearching) {
                        searchController.clear();
                        widget.onSearchChanged('');
                      }
                    });
                  },
                  child: SvgPicture.asset(
                    "assets/icons/Search Icon.svg",
                    height: 15,
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
