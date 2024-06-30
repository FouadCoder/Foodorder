import 'package:flutter/material.dart';

class TwotextOneline extends StatelessWidget {
  final String leftText;
  final String rightText;
  const TwotextOneline({super.key, required this.leftText, required this.rightText});

  @override
  Widget build(BuildContext context) {
    return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text( leftText , style: const TextStyle(fontSize: 18 , fontWeight: FontWeight.bold)),
                    Text(rightText ,  style: const TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),)
                  ],
                );
  }
}