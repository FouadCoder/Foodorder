import 'package:flutter/material.dart';

class NormalButton extends StatelessWidget {
  final String textbutton;
  final Color backgroundColor;
  final VoidCallback onPressed;
  const NormalButton({super.key, required this.textbutton, required this.backgroundColor, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22)
          )
        ),
        child: Text(textbutton , style: const TextStyle(fontSize: 16 , color: Colors.white , fontWeight: FontWeight.bold),),
      ),
    );
  }
}