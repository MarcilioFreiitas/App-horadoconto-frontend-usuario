import 'package:flutter/material.dart';
import 'package:hora_do_conto/widgets/size_config.dart';

class TopRoundedContainer extends StatelessWidget {
  const TopRoundedContainer({
    super.key,
    required this.color,
    required this.child,
  });
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: getProportionateScreenWidth(10)),
      padding: EdgeInsets.only(top: getProportionateScreenWidth(20)),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: child,
    );
  }
}
