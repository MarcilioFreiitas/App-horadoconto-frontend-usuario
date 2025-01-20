import 'package:flutter/material.dart';
import 'package:hora_do_conto/widgets/size_config.dart';

class CustomTopRoundedContainer extends StatelessWidget {
  final Color color;
  final Widget child;
  final double? heightFactor; // Novo parâmetro para controlar a altura

  const CustomTopRoundedContainer({
    super.key,
    required this.color,
    required this.child,
    this.heightFactor, // Altura opcional
  });

  @override
  Widget build(BuildContext context) {
    double height = heightFactor ?? 0.2; // Valor padrão de altura

    return Container(
      margin: EdgeInsets.only(top: getProportionateScreenWidth(20)),
      padding: EdgeInsets.only(top: getProportionateScreenWidth(20)),
      width: double.infinity,
      height: SizeConfig.screenHeight * height, // Controla a altura
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: child,
    );
  }
}
