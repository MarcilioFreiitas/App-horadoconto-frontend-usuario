import 'package:hora_do_conto/widgets/constants.dart';
import 'package:hora_do_conto/widgets/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconBtnWithCounter extends StatelessWidget {
  const IconBtnWithCounter({
    super.key,
    required this.svgSrc,
    this.numOfItens = 0,
    required this.press,
  });
  final String svgSrc;
  final int numOfItens;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: BorderRadius.circular(50),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(12)),
            height: getProportionateScreenWidth(46),
            width: getProportionateScreenWidth(46),
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(svgSrc),
          ),
          if (numOfItens != 0)
            Positioned(
              top: -3,
              right: 0,
              child: Container(
                height: getProportionateScreenWidth(16),
                width: getProportionateScreenWidth(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4848),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    "$numOfItens",
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(10),
                        height: 1,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
