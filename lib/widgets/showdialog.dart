import 'package:flutter/material.dart';
import 'package:food_app/core/colors.dart';
import 'package:food_app/widgets/normal_button.dart';

class ShowdialogSuccess extends StatelessWidget {
  final String message;
  final String mainText;
  final String buttomText;
  final VoidCallback onPressed;
  final String stateImage;
  const ShowdialogSuccess({super.key, required this.message, required this.onPressed, required this.stateImage, required this.mainText, required this.buttomText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 250,
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon success
            SizedBox(
              height: 80,
              width: 80,
              child: Image.asset(stateImage),
            ),
            const SizedBox(height: 20),
            // Text Success
            Text( mainText , style: const TextStyle(fontSize: 25 , fontWeight: FontWeight.bold , color: redC),),
            const SizedBox(height: 10,),
            Text(message , style: TextStyle(fontSize: 15 , color: Colors.grey.shade600),),
            const SizedBox(height: 10,)
          ],
        ),
      ) ,
      actions: [
        // Bottom Success
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: NormalButton(textbutton: buttomText, backgroundColor: redC, onPressed: onPressed))
      ],
    );
  }
}