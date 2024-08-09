import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/colors.dart';
import 'package:food_app/cubit/cubit_cubit.dart';
import 'package:food_app/cubit/cubit_state.dart';
import 'package:food_app/pages/nointernet.dart';
import 'package:food_app/widgets/normal_button.dart';
import 'package:food_app/widgets/showdialog.dart';
import 'package:lottie/lottie.dart';

class InsideFood extends StatefulWidget {
  final List<QueryDocumentSnapshot> foodItems; // To get the date
  final int indexfood; // to get the same index of Food
  const InsideFood(
      {super.key, required this.foodItems, required this.indexfood});
  @override
  State<InsideFood> createState() => _InsideFoodState();
}

class _InsideFoodState extends State<InsideFood>
    with SingleTickerProviderStateMixin {
  // to show Message after add any food to Cart
  void showDialogCart(BuildContext context, String message) {
    showDialog(
        context: context,
        barrierColor:
            Colors.grey.withOpacity(0.7), // to make the background fog
        builder: (BuildContext context) {
          return ShowdialogSuccess(
              message: message,
              mainText: "Success ! ",
              buttomText: "Go Back",
              stateImage: "assets/true.png",
              onPressed: () {
                Navigator.of(context).pop();
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
        builder: (context, state) {
      if (state == ConnectivityStatus.offline) {
        return const Nointernet();
      }
      return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal:
                  MediaQuery.of(context).size.width * 0.02, // 2% OF SCREEN
              vertical: MediaQuery.of(context).size.height * 0.03, // Height
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // For Image
                AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl:
                        "${widget.foodItems[widget.indexfood]["URLimage"]}",
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(
                      color: redC,
                    ), // Placeholder widget
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error), // Error widget
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Main Text
                Text(
                  "${widget.foodItems[widget.indexfood]["name"]}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                // Text description
                Text(
                  "${widget.foodItems[widget.indexfood]["description2"]}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 50),
                // Row for Price and Order now button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price // Note: Chnage it later to take the number from Firebase
                    Container(
                        width: 75,
                        height: 60,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: redC,
                        ),
                        // Price
                        child: Center(
                            child: Text(
                          "\$${widget.foodItems[widget.indexfood]["price"]}",
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ))),
                    // Listenter to Additem to cart
                    BlocListener<AddItemCartCubit, AddItemCartState>(
                      listener: (context, state) {
                        // to show if the ADD to cart had finish successfully
                        if (state is AddItemCartLoaded) {
                          showDialogCart(context,
                              "The item is now in your cart. Happy shopping!");
                        }
                        // If there any error , this one wil work
                        else if (state is AddItemCartError) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                "Failed to add item to cart. Please try again later."),
                            backgroundColor: Colors.red,
                          ));
                        }
                      },
                      child: BlocBuilder<AddItemCartCubit, AddItemCartState>(
                        builder: (context, stateLoading) {
                          if(stateLoading is AddItemCartLoading){
                            return  SizedBox(
                          child: Lottie.asset("assets/loading5.json" ,
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain, 
                          )
                        );
                          } // End loading 
                          else {
                            return  Expanded(
                              child: NormalButton(
                            textbutton: "Add to cart",
                            backgroundColor: brownColor,
                            onPressed: () {
                              String name =
                                  "${widget.foodItems[widget.indexfood]["name"]}";
                              String idFood =
                                  "${widget.foodItems[widget.indexfood]["id"]}";
                              String category =
                                  "${widget.foodItems[widget.indexfood]["category"]}";
                              String urlImage =
                                  "${widget.foodItems[widget.indexfood]["URLimage"]}";
                              int quantity = 1;
                              context.read<AddItemCartCubit>().addNewItemToCart(
                                  idFood, name, category, quantity, urlImage);
                            },
                          ));
                          }
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
