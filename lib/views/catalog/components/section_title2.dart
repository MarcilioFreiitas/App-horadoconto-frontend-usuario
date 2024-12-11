import "package:flutter/material.dart";
import "package:hora_do_conto/widgets/size_config.dart";

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,
              style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.black)),
        ],
      ),
    );
  }
}
