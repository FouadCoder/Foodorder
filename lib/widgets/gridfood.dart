import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/core/colors.dart';
import 'package:food_app/pages/inside_food.dart';
import 'package:cached_network_image/cached_network_image.dart';


class Gridfood extends StatelessWidget {
  final  List<QueryDocumentSnapshot> fooditems; // To get the date from Fooditems in Home Page
  double calculateChildAspectRatio(double screenWidth) {
  if (screenWidth >= 800) { // Large screens
    return 0.7; // Adjust as needed
  } else {
    return 0.6; // Adjust as needed
  }
}
  const Gridfood({super.key, required this.fooditems});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 25,
                        crossAxisSpacing: 10,
                        childAspectRatio:  calculateChildAspectRatio(MediaQuery.of(context).size.width), 
                      ),
                      itemCount: fooditems.length,
                      itemBuilder: (context , index){
                        // Go to inside food 
                        return GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context)=> InsideFood(foodItems: fooditems ,indexfood: index,))
                            );
                          }, 
                          // Child For GestureDetector
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              boxShadow: const [
                                // Shadow for every box
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(2, 2),
                                  blurRadius: 5,
                                  blurStyle: BlurStyle.outer
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-2, 0),
                                  blurRadius: 5,
                                  blurStyle: BlurStyle.outer
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    // Image
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: CachedNetworkImage(
                                        imageUrl: "${fooditems[index]["URLimage"]}",
                                       placeholder: (context, url) => const CircularProgressIndicator(color: redC,), // Placeholder widget
                                        errorWidget: (context, url, error) => const Icon(Icons.error), // Error widget
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ), 
                                  const SizedBox(height: 20),
                                  // Main Text and description
                                  Flexible(child: Text("${fooditems[index]["name"] ?? ""}", style: const TextStyle(fontWeight: FontWeight.bold , fontSize: 15 ), overflow: TextOverflow.ellipsis,)),
                                  const SizedBox(height: 10),
                                  Text("${fooditems[index]["description"] ?? ""}" , style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis,),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Rata Text
                                      Text("⭐ ${fooditems[index]["rating"] ?? ""}" , style: const TextStyle(fontWeight: FontWeight.bold),),
                                       // for Icon Food
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset("assets/food.login.png"),
                                      )
                                    ],
                                  )
                                ],
                              ),
                          ),
                        );
                      });
  }
}