import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/auth/login.dart';
import 'package:food_app/pages/main_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';


class AuthService{
  // Google
Future<UserCredential?> signInWithGoogle() async {
  try{
      // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  if(googleUser == null){
    return null;
  }
  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential

  return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  catch(e){
  return null;
  }
}
}

class CheckAcuuontAuth extends StatefulWidget{
  const CheckAcuuontAuth({super.key});

  @override
  State<CheckAcuuontAuth> createState() => _CheckAcuuontAuthState();
}

class _CheckAcuuontAuthState extends State<CheckAcuuontAuth> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context , snapshot){
              // Loading
              if(snapshot.connectionState == ConnectionState.waiting){
                Center(
                  child:Lottie.asset(
                    "assets/loading5.json",
                    height: 150,
                    width: 150,
                    fit: BoxFit.contain,
                ));
              }
              if(snapshot.hasData){
                User? user = snapshot.data;
                if(user != null && user.emailVerified){
                  return const MainPage();
                } else {
                  return const Login();
                }
                
              } else{
                return const Login();
              }
            })
    );
}
}