import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/colors.dart';
import 'package:food_app/cubit/cubit_cubit.dart';
import 'package:food_app/pages/home.dart';
import 'package:food_app/pages/nointernet.dart';
import 'package:food_app/pages/profile.dart';
import 'package:food_app/widgets/svgcolor.dart';

class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int indexBottomNavigat = 1; // For BottomNavigationBar
   // For BottomNavigationBar
  void onTapitem (int index){
    // To Go to cart Page 
    if(index ==  2){
      Navigator.of(context).pushNamed("CartPage");
      return;
    }
    setState(() {
      indexBottomNavigat = index;
    });
  }
 // List for the pages to go , like if the index was 1 , will go to Home 
  final List<Widget> pages=[
  const ProfilPage(),
  const Homepage(),
  ];

  @override
  Widget build(BuildContext context) {
  return BlocBuilder<ConnectivityCubit,ConnectivityStatus >(
    builder: (context , state) {
      if(state == ConnectivityStatus.offline){
        return const Nointernet();
      }
      return Scaffold(
        backgroundColor: backgroundHome,
        appBar: AppBar(
          backgroundColor: backgroundHome,
          title: Container(
              margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05, // 5% of screen width
              vertical: MediaQuery.of(context).size.height * 0.05,// 5% of screen height
              ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  // Text Food and order for APP BAR
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ Text("Food" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color: redC),),
                  Text("Order your favourite food!" , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.w400),)
                  ],
                ),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset("assets/food.login.png"),
                )
              ],
            ),
          ),
        ), // End of appbar
        bottomNavigationBar: BottomNavigationBar(
          currentIndex:  indexBottomNavigat,
          onTap: onTapitem,
          backgroundColor: redC,
          selectedItemColor: redC,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(icon: SizedBox(height: 30,width: 30,child:
            ColorableSvg(svgAsset: "assets/person.svg", isSelected: indexBottomNavigat == 0,selectedColor: Colors.white,) ,) , label: ""), // Profile
            BottomNavigationBarItem(icon: SizedBox(height: 30,width: 30,child:
             ColorableSvg(svgAsset: "assets/home2.svg" , isSelected: indexBottomNavigat == 1 , selectedColor: Colors.white,)) , label: ""), // Home
            BottomNavigationBarItem(icon: SizedBox(height: 30,width: 30,child:
              ColorableSvg(svgAsset: "assets/cart.svg" , isSelected: indexBottomNavigat == 2,selectedColor: Colors.white, ))  , label: ""),// Favourite
          ],
        ),
        body: pages[indexBottomNavigat],
      );
    }
  );
  }
}