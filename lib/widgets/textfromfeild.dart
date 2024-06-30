import 'package:flutter/material.dart';


class TextboxAuth extends StatelessWidget{
  final String textfield;
  final Color color;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const TextboxAuth({super.key, required this.textfield, required this.controller, this.validator, required this.color});
  @override
  Widget build(BuildContext context) {
  return Container(
            height: 55,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01, // 2% of screen height
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10)
            ),
            child: TextFormField(
              maxLength: 50,
              controller: controller,
              validator: validator,
              decoration: InputDecoration(
                counterText: "",
                hintText: textfield, 
                contentPadding: const EdgeInsets.all(7),
                hintStyle: const TextStyle(fontSize: 20),
                border: InputBorder.none),
            ),
          );
  }
  
}