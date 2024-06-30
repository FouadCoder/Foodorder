import 'package:flutter/material.dart';
class Nointernet extends StatelessWidget {
  const Nointernet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical:  MediaQuery.of(context).size.height * 0.05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image For internet 
            Center(
              child: Image.asset("assets/internet.png",
              height: 150,
              width: 150,
              fit: BoxFit.contain),
            ),
            const SizedBox(height: 50),
              const Text("Please turn on the internet to use the app." ,
              style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}