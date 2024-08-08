import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/auth/auth_sevice.dart';
import 'package:food_app/core/colors.dart';
import 'package:food_app/cubit/cubit_cubit.dart';
import 'package:food_app/pages/nointernet.dart';
import 'package:food_app/widgets/button.dart';
import 'package:food_app/widgets/textfromfeild.dart';

class SignUp extends StatefulWidget{
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
      final fromkey = GlobalKey<FormState>();
    final TextEditingController emailcontroller = TextEditingController();
    final TextEditingController passwordcontroller = TextEditingController();
    final TextEditingController confirmcontroller = TextEditingController();
    
    @override
    void dispose(){
      emailcontroller.dispose();
      passwordcontroller.dispose();
      confirmcontroller.dispose();
      super.dispose();
    }
    
  @override
  Widget build(BuildContext context) {
  return  BlocBuilder<ConnectivityCubit,ConnectivityStatus>(
    // check internet
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
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                      child: Text("Food" , style: TextStyle(fontSize: 50 , fontWeight: FontWeight.bold , color: redC),),
                                ),
                    ),
                  // Text Login in your Account 
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  const Text("Create your Account" , style: TextStyle(fontSize: 17 , fontWeight: FontWeight.bold),),
                  const SizedBox(height: 20,),
                  // Text Email
                  TextboxAuth(textfield: "  Email", color: Colors.white,controller: emailcontroller, validator: (val){
                    if(val == null || val.isEmpty){
                      return "Please enter your Email";
                    }
                    return null;
                  },),
                  // Text Password
                  TextboxAuth(textfield: "  Password", color: Colors.white,controller: passwordcontroller,validator: (val){
                    if(val == null || val.isEmpty){
                      return "Please enter your Password";
                    }
                    return null;
                  },),
                  // Text confirm password
                  TextboxAuth(textfield: "  Confirm Password" , color: Colors.white ,controller: confirmcontroller,validator: (val){
                    if(val == null || val.isEmpty){
                      return "Please enter your Password";
                    }
                    return null;
                  },),
                  // Button Login
                  ClassButton(textbutton: "Sign up" , imageicon: "assets/food.login.png" ,color: redC,onPressed: (){
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Sorry, login with email is currently unavailable. Please use Google login for now."))
                      ); // Note: change it later when you add firebase
                  },),
                  // Login Google 
                  ClassButton(textbutton: "Sign up with Google" , imageicon: "assets/google.png" ,color: brownColor,onPressed: ()async {
                                    // if the login passed , this will work to take him Main page
                    UserCredential? user = await AuthService().signInWithGoogle();
                    if(user != null){
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushNamedAndRemoveUntil("MainPage", (route)=> false);
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
                      const Text("Have an account? "), 
                      GestureDetector(onTap: (){
                        Navigator.pushReplacementNamed(context, "Login");
                      },child: const Text("Login", style: TextStyle(color: redbutton),),)
                        
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
