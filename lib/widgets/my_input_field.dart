import 'package:flutter/material.dart';

class MyinputField extends StatelessWidget {
  final bool isSenhaField;
  final String placeholder;
  final String label;
  final Function onChange;
  const MyinputField({
    super.key,
    required this.placeholder,
    required this.label,
    this.isSenhaField = false,
    required this.onChange,
    required String? Function(dynamic value) validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 10,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(blurRadius: 5, color: Colors.black26),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            obscureText: isSenhaField,
            onChanged: (value) {
              this.onChange(value);
            },
            decoration: InputDecoration(
              hintText: placeholder,
              border: InputBorder.none,
            ),
          )
        ],
      ),
    );
  }
}
