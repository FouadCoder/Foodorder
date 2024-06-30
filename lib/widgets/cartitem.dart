
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/cubit/cubit_cubit.dart';

class Cartitem extends StatefulWidget {
  final List<QueryDocumentSnapshot> cartdate;
      const Cartitem({super.key, required this.cartdate});

  @override
  State<Cartitem> createState() => _CartitemState();
}

class _CartitemState extends State<Cartitem> {
  @override
  Widget build(BuildContext context) {
        return ListView.builder(
          itemCount: widget.cartdate.length,
          itemBuilder: (BuildContext context , index) {
            // To get IdFood
            final food = "${widget.cartdate[index]["idFood"]}";
             // Find the corresponding food item in foodItems
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("Fooditem").where("id", isEqualTo: food).snapshots(),
                  builder: (context , snapshot) {
                    if(snapshot.hasError){
                      return Text("Error in Date Price${snapshot.error}");
                    }
                    // 
                    final foodDate = snapshot.data?.docs[0];
                    if(foodDate == null ){
                      // if it was null
                      return const Center(child: Text(""));
                    }
                    // Here you get th price 
                    final food2 = foodDate["price"];
                    // To count the Price
                    double foodint = double.parse(food2);
                    double quantity = double.parse("${widget.cartdate[index]["quantity"]}");
                    double foodprice = foodint * quantity;
                    String totalPrice = foodprice.toStringAsFixed(2);


                    return Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      // Shadow
                                      boxShadow: const [
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
                                      ]
                                    ),

                                    // Row For all Item Cart 
                                    child: Row(
                                      children: [
                                        // Photo 
                                        SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: Image.network("${widget.cartdate[index]["URLimage"]}" , fit: BoxFit.contain,),
                                        ),
                                        const SizedBox(width: 10),
                                        // Main Text and Price
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${widget.cartdate[index]["name"]}" , style: const TextStyle( fontSize: 16 , color: Colors.black , fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
                                              // ignore: unnecessary_brace_in_string_interps
                                              Text("\$${totalPrice}" , style: const TextStyle(fontSize: 18 , color: Colors.black , fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                        ),
                                        // ADD AND MIN AND TEXT NUMBER
                                        const Spacer(),
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              // ADD
                                              GestureDetector(onTap: (){
                                                String idFood = "${widget.cartdate[index]["idFood"]}";
                                                context.read<UpdateCartItemCubit>().addmoreFood(idFood);
                                              } , child: const Icon(Icons.add ),),
                                              const SizedBox(width: 10,),
                                              Text("${widget.cartdate[index]["quantity"]}" , style: const TextStyle(fontWeight: FontWeight.bold),),
                                              const SizedBox(width: 10,),
                                              // LOSS  OR DELETE 
                                              GestureDetector(onTap: () async{
                                                String idFood = "${widget.cartdate[index]["idFood"]}";
                                                context.read<UpdateCartItemCubit>().removeFoodCart(idFood);
                                              } , child: const Icon(Icons.do_not_disturb_on_total_silence),),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                  }
                );
              }
            );
  }
}