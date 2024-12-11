import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget {
  final String titulo;

  const CustomAppBar({Key? key, required this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Botão de Voltar
              SizedBox(
                height: 40,
                width: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black.withOpacity(0.1),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    "assets/icons/Back ICon.svg",
                    height: 15,
                  ),
                ),
              ),
              SizedBox(width: 16),
              // Título do livro
              Expanded(
                child: Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow:
                      TextOverflow.ellipsis, // Para lidar com títulos longos
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
