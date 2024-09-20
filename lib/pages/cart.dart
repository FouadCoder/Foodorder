
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/colors.dart';
import 'package:food_app/cubit/cubit_cubit.dart';
import 'package:food_app/pages/nointernet.dart';
import 'package:food_app/widgets/cartitem.dart';
import 'package:food_app/widgets/normal_button.dart';
import 'package:food_app/widgets/showdialog.dart';
import 'package:lottie/lottie.dart';

class CartPage extends StatefulWidget{
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  // show Dolog 
  void showdoilgtoGoProfile (String message , BuildContext context){
    showDialog(context: context,
    barrierColor: Colors.grey.withOpacity(0.7), // to make the background fog
      builder: (BuildContext context){
        return ShowdialogSuccess(message: message ,mainText: "Warning ! ",buttomText: "Go To Profile",stateImage: "assets/warning3.png" ,onPressed: () {
          Navigator.of(context).pushReplacementNamed("EditProfile");
        },);
      });
  }
  String userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    // Bloc for Check internet
  return BlocBuilder<ConnectivityCubit , ConnectivityStatus>(
    builder: (context , state) {
      if(state == ConnectivityStatus.offline){
        return const Nointernet();
      }
      return Scaffold(
        appBar: AppBar(),
            body: StreamBuilder<QuerySnapshot>(
              // To get the item in cart User
              stream: FirebaseFirestore.instance.collection("Cart")
              .where("userId" , isEqualTo: userId)
              .snapshots(),
              builder: (context, snapshot) {
                // ERROR message here
                if(snapshot.hasError){
                  return  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Center(
                child: Image.asset("assets/sad.png" ,
                height: 150,
                width: 150),
              ),
              const SizedBox(height: 20),
              const Text("We're sorry, but we couldn't load your cart data at this moment. Please try again later." ,
                style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20))],
            );
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                  child: Lottie.asset(
                    "assets/loading5.json",
                    height: 150,
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                );
                }
                final cartitems = snapshot.data!.docs; // To add the date that has comes from Cart Collect
                    return Stack(
                      children: [
                        Cartitem(cartdate: cartitems),
                        // Button For order Food and will take him to last page "PYAMNET"
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: NormalButton(textbutton: "Checkout", backgroundColor: brownColor, onPressed: () async {
                              if(cartitems.isNotEmpty){
                                // check if user has add adress in Profile or not 
                                String userId =  FirebaseAuth.instance.currentUser!.uid;
                                QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Users").where("id" , isEqualTo: userId).get();
                                if(querySnapshot.docs.isNotEmpty){
                                  // Go to Payment page if he has date in Profile 
                                  if(context.mounted){
                                    Navigator.of(context).pushNamed("Payment");
                                  } 
                                } else {
                                  if(context.mounted){
                                    showdoilgtoGoProfile("Please add your profile date before proceeding to checkout.", context);
                                  }
                                }
                                
                              }
                              // if the cart is Empty 
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Your cart is empty. Please add items before proceeding to checkout.") ,backgroundColor: redC)
                                );
                              }
                              
                            })),
                        )
                      ],
                    );
                  }
            ),
      );
    }
  );
  }
}