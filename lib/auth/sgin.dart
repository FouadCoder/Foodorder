import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/auth/auth_sevice.dart';
import 'package:food_app/core/colors.dart';
import 'package:food_app/cubit/cubit_cubit.dart';
import 'package:food_app/pages/nointernet.dart';
import 'package:food_app/widgets/button.dart';
import 'package:food_app/widgets/textfromfeild.dart';
import 'package:lottie/lottie.dart';

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

    bool loadingGoogle = false;
    bool loadingLogin = false;
    
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
                  TextboxAuth(textfield: "  Email", color: Colors.white,controller: emailcontroller, maxLength: 250,),
                  // Text Password
                  TextboxAuth(textfield: "  Password", color: Colors.white,controller: passwordcontroller, maxLength: 100,),
                  // Text confirm password
                  TextboxAuth(textfield: "  Confirm Password" , color: Colors.white ,controller: confirmcontroller, maxLength: 100,),

                  // Button Login
                  loadingLogin ?
                  Center(child: Lottie.asset("assets/loading5.json" ,height: 100, width: 100, fit: BoxFit.contain, )) :
                  ClassButton(textbutton: "Sign up" , imageicon: "assets/food.login.png" ,color: redC,onPressed: () async{
                    if(emailcontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty && confirmcontroller.text.isNotEmpty){
                      if(passwordcontroller.text == confirmcontroller.text){
                        if(emailcontroller.text.endsWith("@gmail.com")){
                          if(passwordcontroller.text.length >= 10){
                            // CREATE ACCOUNT
                            try{
                              setState(() {loadingLogin = true;});
                              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: emailcontroller.text.trim(),
                                password:passwordcontroller.text.trim());
                                setState(() {loadingLogin = false;});
                                // here what to do after success create account // Verify email first 
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pushNamed("Verify");
                            }
                              on FirebaseAuthException catch(e){
                                // Stop loading 
                                setState(() {loadingLogin = false;});
                                // if password was weak
                                if(e.code == 'weak-password'){
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password is weak. Try adding numbers and symbols." , style: TextStyle(color: Colors.white),) , backgroundColor: redC,));
                                } else if(e.code == 'email-already-in-use'){
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This email is already registered. Please log in." , style: TextStyle(color: Colors.white),) , backgroundColor: redC,));
                                } else{
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong. Please try again in a bit." , style: TextStyle(color: Colors.white),) , backgroundColor: redC,));
                                }
                              }
                          }
                          // if password was less 20 letters
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("The password must be at least 10 letters" , style: TextStyle(color: Colors.white),) , backgroundColor: redC,));
                          }
                        } 
                        // if email didn't end with Gmail.conm
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("The email should end with @gmail.com" , style: TextStyle(color: Colors.white),) , backgroundColor: redC,));
                        }
                      } 
                      // if password don't match
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password and Confirm Password don't match" , style: TextStyle(color: Colors.white),) , backgroundColor: redC,));
                      }
                    } 
                    // if empty 
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Can't be empty" , style: TextStyle(color: Colors.white),) , backgroundColor: redC,));
                    }
                  },),



                  // Login Google 
                  loadingGoogle ? 
                  Center(child: Lottie.asset("assets/loading5.json" ,height: 100, width: 100, fit: BoxFit.contain, )) :
                  ClassButton(textbutton: "Sign up with Google" , imageicon: "assets/google.png" ,color: brownColor,onPressed: ()async {
                                    // if the login passed , this will work to take him Main page
                    setState(() {loadingGoogle = true;});
                    UserCredential? user = await AuthService().signInWithGoogle();
                    if(user != null){
                      setState(() {loadingGoogle = false;});
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushNamedAndRemoveUntil("MainPage", (route)=> false);
                    }
                    else{
                      setState(() {loadingGoogle = false;});
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
