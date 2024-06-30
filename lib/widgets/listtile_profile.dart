import 'package:flutter/material.dart';

class ListtileProfile extends StatelessWidget {
  final String textmain;
  final String texttype;
  const ListtileProfile({super.key, required this.textmain, required this.texttype});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(texttype ,style:  TextStyle(fontSize: 13 , fontWeight: FontWeight.w600,color: Colors.grey[600]),),
                  Text(textmain , style: const TextStyle(fontSize: 17 , fontWeight: FontWeight.bold,color: Colors.black),),
                  Container(
                    height: 2,
                    color: Colors.grey[100],
                    margin: const EdgeInsets.only(
                      top: 5,
                      bottom: 5
                    ),
                  )
                ],
              ),
            );
  }
}