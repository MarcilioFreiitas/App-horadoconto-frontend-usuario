import 'package:hora_do_conto/views/home/components/Icon_Bnt_with_Counter.dart';
import 'package:hora_do_conto/views/home/components/SearchField.dart';
import 'package:hora_do_conto/views/my_borrowings/my_borrowings.dart';
import 'package:hora_do_conto/views/notifications/notifications_screen.dart';
import 'package:hora_do_conto/widgets/size_config.dart';
import 'package:flutter/material.dart';
import 'package:hora_do_conto/models/livro.dart';

class HomeHeader extends StatelessWidget {
  final List<Livro> livros; // Lista de livros recebida como parâmetro

  const HomeHeader({
    super.key,
    required this.livros, // Certificando-se de que livros sejam passados para o HomeHeader
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(
              livros: livros), // Passando a lista de livros para o SearchField
          IconBtnWithCounter(
            svgSrc: "assets/icons/Clipboard.svg",
            press: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyBorrowingsScreen()),
            ),
          ),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Notification.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
