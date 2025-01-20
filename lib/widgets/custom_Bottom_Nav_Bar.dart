import "package:hora_do_conto/models/livro.dart";
import "package:hora_do_conto/views/Favorites/favorites_screen.dart";
import "package:hora_do_conto/views/contact/contact_screen.dart";
import "package:hora_do_conto/views/home/home_screen.dart";
import "package:hora_do_conto/views/profile/Profile_Screen.dart";
import "package:hora_do_conto/views/profile/tela_perfil.dart";
import "package:hora_do_conto/widgets/enums.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.selectedMenu,
    required this.livros,
  });
  final MenuState selectedMenu;
  final List<Livro> livros;
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_declarations
    final Color inActiveColor = const Color(0xFFB6B6B6);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -15),
              blurRadius: 20,
              color: const Color(0xFFDADADA).withOpacity(0.15),
            )
          ]),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  //Rota Home
                  builder: (context) => HomeScreen(
                      livros: livros), // Ajuste conforme sua tela de catálogo
                ),
              ),
              icon: SvgPicture.asset(
                "assets/icons/Shop Icon.svg",
                colorFilter: ColorFilter.mode(
                    MenuState.home == selectedMenu
                        ? const Color(0xFF343434)
                        : inActiveColor,
                    BlendMode.srcIn),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    //Rota cátalogo
                    builder: (context) => FavoriteScreen(
                        livros: livros) // Ajuste conforme sua tela de catálogo
                    ),
              ),
              icon: SvgPicture.asset(
                "assets/icons/Heart Icon.svg",
                colorFilter: ColorFilter.mode(
                    MenuState.favourite == selectedMenu
                        ? const Color(0xFF343434)
                        : inActiveColor,
                    BlendMode.srcIn),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  //Rota cátalogo
                  builder: (context) => ContactScreen(
                    livros: livros,
                  ), // Ajuste conforme sua tela de catálogo
                ),
              ),
              icon: SvgPicture.asset(
                "assets/icons/Chat bubble Icon.svg",
                colorFilter: ColorFilter.mode(
                    MenuState.message == selectedMenu
                        ? const Color(0xFF343434)
                        : inActiveColor,
                    BlendMode.srcIn),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  //Rota cátalogo
                  builder: (context) => ProfileScreen(
                    livros: livros,
                  ),
                ),
              ),
              icon: SvgPicture.asset(
                "assets/icons/User Icon.svg",
                colorFilter: ColorFilter.mode(
                    MenuState.profile == selectedMenu
                        ? const Color(0xFF343434)
                        : inActiveColor,
                    BlendMode.srcIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
