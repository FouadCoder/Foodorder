import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/auth/auth_sevice.dart';
import 'package:food_app/core/colors.dart';
import 'package:food_app/cubit/cubit_cubit.dart';
import 'package:food_app/pages/nointernet.dart';
import 'package:food_app/widgets/button.dart';
import 'package:food_app/widgets/textfromfeild.dart';
import 'package:google_sign_in/google_sign_in.dart';



class Login extends StatefulWidget{
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
Future signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacementNamed("MainPage");
}
  final TextEditingController emailcontroller = TextEditingController();

  final TextEditingController passwordcontroller = TextEditingController();

  final fromkey = GlobalKey<FormState>();

  @override
  void dispose(){
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return BlocBuilder<ConnectivityCubit,ConnectivityStatus>(
    // check the internet
    builder: (context , state) {
      if(state == ConnectivityStatus.offline){
        return const Nointernet();
      }
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05, // 5% of screen width
              vertical: MediaQuery.of(context).size.height * 0.05,// 5% of screen height
              ),
              child: Form(
                key: fromkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // The main name Food
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(
                      child: Text("Food" , style: TextStyle(fontSize: 50 , fontWeight: FontWeight.bold , color: redC),),
                                ),
                    ),
                  // Text Login in your Account 
                  SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                  const Text("Login in your Account" , style: TextStyle(fontSize: 17 , fontWeight: FontWeight.bold),),
                  const SizedBox(height: 20,),
                  // Text Email
                  TextboxAuth(textfield: "  Email", controller: emailcontroller , color: Colors.white, validator: (val){
                    if(val == null || val.isEmpty){
                      return "Please enter your Email";
                    }
                    return null;
                  },),
                  // Text Password
                  TextboxAuth(textfield: "  Password", controller: passwordcontroller, color: Colors.white,validator: (val){
                    if (val == null || val.isEmpty){
                      return "Please enter your Password";
                    }
                    return null;
                  }),
                  // Button Login
                  ClassButton(textbutton: "Login" , imageicon: "assets/food.login.png",color: redC,onPressed: (){
                    if(fromkey.currentState!.validate()){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Sorry, login with email is currently unavailable. Please use Google login for now."))
                      ); // Note: change it later when you add firebase
                    } 
                    else{
                      // write code here what if validate is false
                    }
                  },),
                  // Login Google 
                  ClassButton(textbutton: "Login with Google" , imageicon: "assets/google.png",color: brownColor,onPressed: () async{
                    // if the login passed , this will work to take him Main page
                    UserCredential? user = await AuthService().signInWithGoogle();
                    if(user != null){
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushReplacementNamed("MainPage");
                    }
                    else{
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: 
                      Text("Unable to Login with Google, Please try later.")));
                    }
                  },),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  // Text to go Sign in page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "), 
                      GestureDetector(onTap: (){
                        Navigator.pushReplacementNamed(context, "Sign");
                      },child: const Text("Sign in", style: TextStyle(color: redbutton),),)
                        
                    ],
                  )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  );
  }
}