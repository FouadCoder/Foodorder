import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/auth/auth_sevice.dart';
import 'package:food_app/auth/login.dart';
import 'package:food_app/auth/sgin.dart';
import 'package:food_app/cubit/cubit_cubit.dart';
import 'package:food_app/pages/cart.dart';
import 'package:food_app/pages/edit_profile.dart';
import 'package:food_app/pages/main_page.dart';
import 'package:food_app/pages/payment.dart';
import 'package:food_app/pages/profile.dart';
import 'package:food_app/pages/verify_email.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

// This widget is the root of your applicatio
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<FooditemCubit>(create: (context)=> FooditemCubit()),
      BlocProvider<ProfileCubit>(create: (context)=> ProfileCubit()),
      BlocProvider<DateProfileCubit>(create: (context)=> DateProfileCubit()),
      BlocProvider<AddItemCartCubit>(create: (context)=> AddItemCartCubit()),
      BlocProvider<UpdateCartItemCubit>(create: (context) => UpdateCartItemCubit()),
      BlocProvider<ConutTotalCubit>(create: (context) => ConutTotalCubit()),
      BlocProvider<OrderFoodCubit>(create: (context) => OrderFoodCubit()),
      BlocProvider<ConnectivityCubit>(create: (context) => ConnectivityCubit(Connectivity())),
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const CheckAcuuontAuth(),
        routes: {
          "Login": (context)=> const Login(),
          "Sign": (context)=> const SignUp(),
          "MainPage": (context)=>const MainPage(),
          "Payment":(context)=>const PaymentPage(),
          "EditProfile":(context)=>const EditProfile(),
          "Profile":(context)=>const ProfilPage(),
          "CartPage": (context)=> const CartPage(),
          "Verify" : (context)=> const VerifyEmail()
        },
      ),
    );
  }
  }