
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/colors.dart';
import 'package:food_app/cubit/cubit_cubit.dart';
import 'package:food_app/cubit/cubit_state.dart';
import 'package:food_app/widgets/gridfood.dart';
import 'package:lottie/lottie.dart';
class Homepage extends StatefulWidget{

  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  // Categries List
  final List<String> categries = [ "All" , "Pizza" , "sandwiches" ,"salad" , "Sweet Delights" , ];
  String selectedCategory = "All";
  // To make GetDateFooditem works
  @override
  void initState() {
    super.initState();
    context.read<FooditemCubit>().getDateFooditem(); // Call the function here
  }




  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox( // Category
              height: 50, // Listview for Categries 
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categries.length , // Note: change it later 
                itemBuilder:(context , index){
                  final category = categries[index];
                  final iselected = category == selectedCategory;
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    //Child for the Text category
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        // shadow
                        boxShadow: const [BoxShadow(
                      color: Colors.black12,
                    offset: Offset(3, 3),
                    blurRadius: 10,
                    blurStyle: BlurStyle.inner
                    )],
                        color: iselected ? redForText : Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                        // ignore: unnecessary_string_interpolations
                        child: Text( "${categries[index]}", style: TextStyle(fontSize: 16 , fontWeight: iselected? FontWeight.bold: FontWeight.normal),), //
                    ),                            
                  );
                }),
            ),
            const SizedBox(height: 20,),




            //Expanded to make it take all the space 
            Expanded(
              child: Container(
                margin:EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03, // 3% OF SCREEN
                      ),
                  // Listview for List of Food
                  child: BlocBuilder<FooditemCubit, Fooditemstate>(
                    builder:(context , state) {
                      // Loading
                      if(state is FooditemLoading){
                        return Center(
                          child: Lottie.asset("assets/loading5.json" ,
                          height: 150,
                          width: 150,
                          fit: BoxFit.contain, 
                          )
                        );
                      } else if (state is FooditemLoaded)
                      {
                        // that's for categoyr , like if he choose salad , show salad 
                        final fooditems = state.foodItems.where((item){
                          if(selectedCategory == "All") return true;
                        return item['category'] == selectedCategory;
                        }).toList();
                        // to show date 
                        return Gridfood(fooditems: fooditems);
                        // if there any ERROR
                      } else if(state is FooditemError){
                        return  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Center(
                child: Image.asset("assets/sad.png" ,
                height: 150,
                width: 150),
              ),
              const SizedBox(height: 20),
              const Text("Sorry, we encountered an error while trying to display the food. Please try again later." ,
                style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20))],
            );
                      }
                      else{
                        return Container();
                      }
                    }
                  ),
              ),
            ),
          ],
        ),
  );
  }
}