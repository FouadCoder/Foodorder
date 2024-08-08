
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/colors.dart';
import 'package:food_app/cubit/cubit_cubit.dart';
import 'package:food_app/cubit/cubit_state.dart';
import 'package:food_app/widgets/button.dart';
import 'package:food_app/widgets/listtile_profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';


class ProfilPage extends StatefulWidget{
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  void initState() {
    super.initState();
    context.read<DateProfileCubit>().showDateProfile(); // Call the function here
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05, // 5% Of With
            vertical: MediaQuery.of(context).size.height * 0.05, // 5% Of height
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              BlocBuilder<DateProfileCubit , DateForProfileState>(
                builder: (context, state) {
                  // Loading
                  if( state is DateProfileLLoading){
                    return Center(
                          child: Lottie.asset("assets/loading5.json" ,
                          height: 150,
                          width: 150,
                          fit: BoxFit.contain, 
                          )
                        );
                  }
                  else if (state is DateProfileLoaded){
                    final userdate = state.userDate; 
                    return Column(
                  children: [
                    // Photo 
                    Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(child: userdate.isNotEmpty ?
                   userdate[0]["UrlImage"] != null ? // To check if it's not null
                  CachedNetworkImage(
                                        imageUrl: "${userdate[0]["UrlImage"]}",
                                       placeholder: (context, url) => const CircularProgressIndicator(color: redC,), // Placeholder widget
                                        errorWidget: (context, url, error) => const Icon(Icons.error), // Error widget
                                        fit: BoxFit.cover,
                                      ) :
                    Image.asset("assets/user1.png" , fit: BoxFit.cover) :
                    Image.asset("assets/user1.png" , fit: BoxFit.cover)
                    )
                ),
              ),
                ListtileProfile(textmain: userdate.isNotEmpty ?"${userdate[0]["name"]}" : "", texttype: "Name",),
                ListtileProfile(textmain: userdate.isNotEmpty ?"${userdate[0]["email"]}" : "" , texttype: "Email",),
                ListtileProfile(textmain: userdate.isNotEmpty ?"${userdate[0]["Address"]}" : "", texttype: "Address",),
                ListtileProfile(textmain: userdate.isNotEmpty ?"${userdate[0]["Dietary"]}": "", texttype: "Dietary Preferences",),
                  ],
                );
                  }
                  // if there any error 
                  else if(state is DateProfileError){
                    return Center(child: SizedBox(
                      height: 400,
                      width: 400,
                      child: Lottie.asset("assets/profile1.json"),
                    ));
                  }
                  return const SizedBox(height: 100,);
                  }),
              // Logout
              const SizedBox(height: 20),
              ClassButton(textbutton: "Logout", imageicon: "assets/logout.png", color: redC,onPressed: (){
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                Navigator.of(context).pushReplacementNamed("Login");
              }),
              // Edit Profile
              ClassButton(textbutton: "Edit Profile", imageicon: "assets/edit.png",color: brownColor, onPressed: (){
                Navigator.of(context).pushNamed("EditProfile");
              })
            ],
          ),
        ),
      )// 
  );
  }
}