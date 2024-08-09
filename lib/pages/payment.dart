
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/colors.dart';
import 'package:food_app/cubit/cubit_cubit.dart';
import 'package:food_app/cubit/cubit_state.dart';
import 'package:food_app/pages/nointernet.dart';
import 'package:food_app/widgets/normal_button.dart';
import 'package:food_app/widgets/showdialog.dart';
import 'package:food_app/widgets/textfromfeild.dart';
import 'package:food_app/widgets/twotext_oneline.dart';
import 'package:lottie/lottie.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List dateProfile = [];
  String? payment; // For the payment
  bool? paymentselected = false;
  final TextEditingController noteAddress = TextEditingController();

  // Void to tell the user that order has add Successfully
  void showdialogSuccessOrder(BuildContext context, String message) {
    showDialog(
        barrierDismissible: false, // To make him cannot close the show
        context: context,
        barrierColor:
            Colors.grey.withOpacity(0.7), // to make the background fog
        builder: (BuildContext context) {
          return ShowdialogSuccess(
              message: message,
              mainText: " Success ! ",
              buttomText: "Go Back",
              stateImage: "assets/true.png",
              onPressed: () {
                // Take him to Main Page

                Navigator.of(context)
                    .pushNamedAndRemoveUntil("MainPage", (route) => false);
              });
        });
  }

  @override
  void initState() {
    super.initState();
    context.read<ConutTotalCubit>().totalNumber();
    context.read<DateProfileCubit>().showDateProfile();
  }

  @override
  void dispose() {
    super.dispose();
    noteAddress.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // check internet
    return BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
        builder: (context, state) {
      if (state == ConnectivityStatus.offline) {
        return const Nointernet();
      }
      return Scaffold(
        appBar: AppBar(),
        body: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02, // %5 OF WIDTH
            vertical: MediaQuery.of(context).size.height * 0.02, // %5 OF Height
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text Address
                const Text(
                  "Delivery Address",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),
                // Address
                BlocBuilder<DateProfileCubit, DateForProfileState>(
                    builder: (context, state) {
                  // Loading
                  if (state is DateProfileLLoading) {
                    return Center(
                      child: Lottie.asset(
                        "assets/loading5.json",
                        height: 150,
                        width: 150,
                        fit: BoxFit.contain,
                      ),
                    );
                  } else if (state is ProfileError) {
                    // ignore: unnecessary_string_interpolations
                    return const Text("${"Faild to get the Address"}");
                  }
                  // if the date comes successfully
                  else if (state is DateProfileLoaded) {
                    dateProfile = state.userDate; // to get the date Profile
                  }
                  if (dateProfile.isNotEmpty) {
                    return ListTile(
                      // Icon for ADDRESS
                      leading: const Icon(
                        Icons.location_on,
                        size: 35,
                      ),
                      // Address, NOTE: chnage it later to get the address from Profile
                      title: Text("${dateProfile[0]["Address"]}"),
                    );
                  } else {
                    return const Text("No Address Found");
                  }
                }),
                // button note for Delivery
                TextboxAuth(
                    textfield: "Note for Delivery",
                    controller: noteAddress,
                    maxLength: 70,
                    color: Colors.white),
                const SizedBox(height: 30),

                // Text Payment
                const Text(
                  "Payment",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                // Cash
                RadioListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Text for the payment way
                        const Text(
                          "Payment upon delivery",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 15),
                        // Photo like Cash or Vias
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: Image.asset("assets/cash.png"),
                        )
                      ],
                    ),
                    activeColor: brownColor,
                    value: "Cash",
                    groupValue: payment,
                    onChanged: (val) {
                      setState(() {
                        payment = val;
                        paymentselected = true;
                      });
                    }),
                // Visa
                RadioListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Text for the payment way
                        const Text(
                          "Credit card",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 15),
                        // Photo like Cash or Vias
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: Image.asset("assets/card.png"),
                        )
                      ],
                    ),
                    activeColor: brownColor,
                    value: "Credit card",
                    groupValue: payment,
                    onChanged: (val) {
                      setState(() {
                        payment = val;
                        paymentselected = true;
                      });
                    }),
                const SizedBox(height: 40),
                Container(
                  height: 2,
                  color: Colors.grey,
                ),
                const SizedBox(height: 40),

                // Row For Total and Price
                // Build here to get the price from Cubit
                BlocBuilder<ConutTotalCubit, CountTotalState>(
                    builder: (context, state) {
                  if (state is CountTotalLoading) {
                    return const Center(
                        child: Text("Calculating the total ...."));
                  } else if (state is CountTotalLoaded) {
                    final totalprice = state.totalPrice;
                    double deliveryprice = 20;
                    double grandTotal = totalprice + deliveryprice;
                    String totalPriceString = totalprice.toStringAsFixed(2);
                    String grandTotalString = grandTotal.toStringAsFixed(2);
                    return Column(
                      children: [
                        TwotextOneline(
                            leftText: "Total: ",
                            rightText: "\$$totalPriceString"),
                        // For the Price of delivery
                        const SizedBox(height: 25),
                        TwotextOneline(
                            leftText: "Delivery: ",
                            rightText: "\$$deliveryprice"),
                        const SizedBox(height: 20),
                        Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 20),
                        // For Text Grand Total
                        TwotextOneline(
                            leftText: "Grand Total: ",
                            rightText: "\$$grandTotalString"),
                        const SizedBox(height: 30),
                      ],
                    );
                  } else {
                    const Text("Error calculating total.");
                  }
                  return Container();
                }),
                // Buttom
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: BlocListener<OrderFoodCubit, OrderFoodState>(
                        listener: (context, state) {
                      if (state is OrderFoodLoaded) {
                        // if order has finish successfullu
                        showdialogSuccessOrder(
                          context,
                          "Your order has been placed successfully. Thank you for choosing our service ❤️",
                        );
                      } else if (state is OrderFoodError) {
                        // if there any error in order
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              "We're sorry, but we're unable to process your order at this time. Please try again later."),
                          backgroundColor: redC,
                        ));
                      }
                    } // Child Listener
                        , child: BlocBuilder<OrderFoodCubit, OrderFoodState>(
                      builder: (context, stateBuild) {
                        if(stateBuild is OrderFoodLoading){
                          return Center(
                          child: Lottie.asset("assets/loading5.json" ,
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain, 
                          )
                        );
                        } else {
                          return  NormalButton(
                            textbutton: "ORDER NOW",
                            backgroundColor: brownColor,
                            onPressed: () {
                              if (paymentselected == true) {
                                // to see if he choose payment or not
                                final address = dateProfile[0]["Address"];
                                final name = dateProfile[0]["name"];
                                final email = dateProfile[0]["email"];
                                final paymentWay = payment;
                                // For the note
                                String note;
                                if (noteAddress.text.isNotEmpty) {
                                  note = noteAddress.text;
                                } else {
                                  note = "";
                                }
                                context.read<OrderFoodCubit>().sendTheOrder(
                                    name, email, address, note, paymentWay!);
                              }
                              // else if paymentselectd == false
                              else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      "Please choose a payment method such as cash or Credit card."),
                                  backgroundColor: redC,
                                ));
                              }
                            });
                        }
                      },
                    )))
              ],
            ),
          ),
        ),
      );
    });
  }
}
