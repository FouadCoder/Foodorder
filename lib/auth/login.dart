
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/auth/auth_sevice.dart';
import 'package:food_app/core/colors.dart';
import 'package:food_app/cubit/cubit_cubit.dart';
import 'package:food_app/pages/nointernet.dart';
import 'package:food_app/widgets/button.dart';
import 'package:food_app/widgets/showdialog.dart';
import 'package:food_app/widgets/textfromfeild.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';



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
}
  final TextEditingController emailcontroller = TextEditingController();

  final TextEditingController passwordcontroller = TextEditingController();

  bool loadingGoogle = false;
  bool loadingLogin = false;
  bool loadingForgetPassword = false;
  @override
  void dispose(){
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

   // to ask user if he want to verify email 
void verifayEmail(BuildContext context){
  showDialog(context: context, builder: (BuildContext context){
    return ShowdialogSuccess(message: "It looks like your email hasn't been verified yet. Would you like to verify it now to continue?",
    onPressed: (){Navigator.of(context).pushNamed("Verify");}, stateImage: "assets/email.yellow.red.png", mainText: "Email Not Verified", buttomText: "Verify");
  });
}

DateTime? _lastrequest;
  int? _requstConut;
  int conter = 0;
  Timer? _timer;
  
  @override
  void initState(){
    super.initState();
    getLastrequest();
  }


// get the date of how many user asked verify 
  Future<void> getLastrequest() async {
    // Loading while check the date 
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    DateTime lastrequestdate = DateTime.parse(sharedPreferences.getString("_lastrequestPassword") ?? DateTime.now().toString()); // get the last request time
    int requstConutdate = sharedPreferences.getInt("_requstConutPassword") ?? 0 ;

    // get the time 
    final now = DateTime.now();
    final differentTime = now.difference(lastrequestdate);
    // check if the different time is more than one day 
    if(differentTime.inDays > 1){
      requstConutdate = 0;
    }

    setState(() {
      _lastrequest = lastrequestdate;
      _requstConut = requstConutdate;
    });
    startTimer();
  }

// update the date in SharedPreferences 
  Future<void> upddatLastrequst() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("_lastrequestPassword", DateTime.now().toString()); // date time
    sharedPreferences.setInt("_requstConutPassword", _requstConut! + 1);
    await getLastrequest();
  }
// count the time 
  int _isuserCanRequstverify(){
    final now = DateTime.now();
    final differentTime = now.difference(_lastrequest!); // the different between now and last request 
    int requerTime = 0;
    if(_lastrequest == null || _requstConut == 0){return 0;}
    else if(_requstConut == 1 ){requerTime = 10 * 60;} // 10  Minutes
    else if(_requstConut == 2 ){requerTime = 20  * 60;}// 20 Minutes
    else if(_requstConut == 3 ){requerTime = 60 * 60;} //  1 Hour
    else if(_requstConut! >= 4){requerTime = 360 * 60;} // 6 Hours

    final differentSEC = differentTime.inSeconds; // get the different in sec
    final remainigTime = requerTime - differentSEC;
    return remainigTime > 0 ? remainigTime : 0;
  }

  
// send rest password
  Future<void> _sendrestPassword(String emailRest) async {
          // send verify 
          try{
            // Loading true while send the rest password
            setState(() {loadingForgetPassword = true;});
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailRest); // send rest password
      // Stop the loading
      setState(() {loadingForgetPassword = false;});
      await upddatLastrequst(); // to update last date 
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password reset link sent!" , style: TextStyle(color: Colors.white),) , backgroundColor: Colors.green,));
      }
      
          }
          on FirebaseAuthException {
            setState(() {loadingForgetPassword = false;});
            if(mounted){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong. Please try again in a bit.", style: TextStyle(color: Colors.white)) , backgroundColor: Colors.red,));
            }
            
          }
  }

    // Timer
    void startTimer(){
      int rmingTime = _isuserCanRequstverify();
      setState(() {
        conter = rmingTime;
      });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer){
      if(mounted){
        setState(() {
        if(conter <= 0){
          _timer!.cancel();
        } else {
          conter--;
        }
      });
      }
      
    });
  }

    // make it in nice way String Time minutes and sec
  String getFormattedTime() {
  int minutes = conter ~/ 60;
  int seconds = conter % 60;
  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = seconds.toString().padLeft(2, '0');
  return '$minutesStr:$secondsStr';
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
                TextboxAuth(textfield: "  Email", controller: emailcontroller , maxLength: 250  ,color: Colors.white,),
                // Text Password
                TextboxAuth(textfield: "  Password", controller: passwordcontroller,maxLength: 100 ,color: Colors.white,),


                // Forgot password
                const SizedBox(height: 10,),
                Row(
                  children: [
                  const Spacer(),
                  // check the loading and conter 
                  loadingForgetPassword?
                  const CircularProgressIndicator(color: redC) : 
                  conter == 0 ?
                  GestureDetector(
                    onTap: (){
                      if(emailcontroller.text.isNotEmpty){
                        if(emailcontroller.text.trim().endsWith("@gmail.com")){
                          _sendrestPassword(emailcontroller.text.trim());
                        }
                        // if email don't end with @gmail.com
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("The email should end with @gmail.com" , style: TextStyle(color: Colors.white),) , backgroundColor: redC,));
                        }
                      }
                      // if email was empty
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please write your email" , style: TextStyle(color: Colors.white),) , backgroundColor: redC,));
                      }
                    },
                    child: const Text("Forgot Password? " , style: TextStyle(fontWeight: FontWeight.bold , color: redC),)) : 
                    // if conter != 0
                    Text(getFormattedTime() , style: const TextStyle(fontSize: 18),) 
                ],),
                const SizedBox(height: 5,),
              
              
              
                // Button Login
                loadingLogin ?
                Center(child: Lottie.asset("assets/loading5.json" ,height: 100, width: 100, fit: BoxFit.contain, )) :
                ClassButton(textbutton: "Sign In" , imageicon: "assets/food.login.png",color: redC,onPressed: () async {
                  if(emailcontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty){
                    if(emailcontroller.text.endsWith("@gmail.com")){
                      // Login 
                      try{
                      setState(() {loadingLogin = true;});
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailcontroller.text.trim(), 
                        password: passwordcontroller.text.trim());
                        // check if user has verify has email or not 
                        User? user = FirebaseAuth.instance.currentUser;
                        if(user != null && user.emailVerified){
                          setState(() {loadingLogin = false;});
                          if(context.mounted){
                            Navigator.of(context).pushNamedAndRemoveUntil("MainPage", (route)=> false);
                          }
                          
                        }
                        // if user == null
                        else {
                        setState(() {loadingLogin = false;});
                        // ignore: use_build_context_synchronously
                        verifayEmail(context);
                        }
                      }
                      on FirebaseException catch(e){
                        setState(() {loadingLogin = false;});
                         // if email or password is worng
              if(e.code == 'invalid-credential'){
                if(context.mounted){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text( "Wrong email or password. Try again.", style: TextStyle(color: Colors.white),) , backgroundColor: Colors.red,));}
                // too many requsets
              } else if(e.code == 'too-many-requests'){
                if(context.mounted){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Too many attempts. Please try again later" , style: TextStyle(color: Colors.white),) , backgroundColor: Colors.red,));}
                // any error else 
              } else {
                if(context.mounted){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text( "Something went wrong. Please try again in a bit.", style: TextStyle(color: Colors.white),) , backgroundColor: Colors.red,));}
              }

                      }
                    }
                    // if not end with @gmail.com
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("The email should end with @gmail.com" , style: TextStyle(color: Colors.white),) , backgroundColor: redC,));
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
                ClassButton(textbutton: "Log In with Google" , imageicon: "assets/google.png",color: brownColor,onPressed: () async{
                  // if the login passed , this will work to take him Main page
                  setState(() {loadingGoogle = true;});
                  UserCredential? user = await AuthService().signInWithGoogle();
                  if(user != null){
                    setState(() {loadingGoogle = false;});
                    if(context.mounted){Navigator.of(context).pushNamedAndRemoveUntil("MainPage", (route)=> false);}
                  }
                  else{
                    setState(() {loadingGoogle = false;});
                    if(context.mounted){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: 
                    Text("Unable to Login with Google, Please try later.")));}
                    
                  }
                },),
              
              
                // don't have account ?
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                // Text to go Sign in page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "), 
                    GestureDetector(onTap: (){
                      Navigator.pushReplacementNamed(context, "Sign");
                    },child: const Text("Sign Up", style: TextStyle(color: redbutton),),)
                      
                  ],
                )
                ],
              ),
            ),
          ),
        ),
      );
    }
  );
  }
}