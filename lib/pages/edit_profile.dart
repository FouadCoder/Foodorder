import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/core/colors.dart';
import 'package:food_app/cubit/cubit_cubit.dart';
import 'package:food_app/cubit/cubit_state.dart';
import 'package:food_app/pages/nointernet.dart';
import 'package:food_app/widgets/button.dart';
import 'package:food_app/widgets/showdialog.dart';
import 'package:food_app/widgets/textfromfeild.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';


class EditProfile extends StatefulWidget {

  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
    final GlobalKey<FormState> fromkey = GlobalKey<FormState>();
    final TextEditingController namecontroller = TextEditingController();
    final TextEditingController deliveryaddresscontroller = TextEditingController();
    final TextEditingController dietarycontroller = TextEditingController();
  File? selectImage; 
   // For Image from Gallrey
  void dipose(){
    super.dispose();
    namecontroller.dispose();
    deliveryaddresscontroller.dispose();
    dietarycontroller.dispose();
  }

  // Void for chooes photo from Gallrey
    Future<void> selectImagefromGallrey() async{
    
    final pickphoto = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(pickphoto != null){
        selectImage = File(pickphoto.path);
      }
      else{
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You cancelled the photo selection" , selectionColor: redC,))
        );
      }
    setState(() {});
    // to close the Sheet bottom after choose photo 
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    }
    // Void to take photo from Camara
    Future<void> selectImagefromCamara() async{
    
    final pickphoto = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      if(pickphoto != null){
        selectImage = File(pickphoto.path);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You cancelled the photo selection" , selectionColor: redC,))
        );
      }
    });
    //to close the Sheet bottom after choose photo
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    }
  // to show dialog it's done
    void showdialogForDone (BuildContext context , String message ){
    showDialog(context: context,
    barrierColor: Colors.grey.withOpacity(0.7), // to make the background fog
      builder: (BuildContext context){
        return ShowdialogSuccess(message: message ,mainText: "Success ! ",buttomText: "Go Back",stateImage: "assets/true.png" ,onPressed: () {
          Navigator.of(context).pushReplacementNamed("MainPage");
        },);
      });
  }
  // For bottom to choose Camara or Gallray 
    void sheetbottomPhoto(BuildContext content){
    showModalBottomSheet(context: context, builder: (BuildContext context){
    return Container(
      decoration: const BoxDecoration(
      color: sheetbottomColor,
      borderRadius: BorderRadius.only(
      topLeft:Radius.circular(20),
      topRight: Radius.circular(20),
        )
        ),
      height: 220 ,
      width: MediaQuery.of(context).size.width,
      // Child For all sheet
    child: Column(
      children: [
        // Text New Profile Picture
        Container(
          margin: const EdgeInsets.all(10),
          child: const Text("New Profile Picture" , style: TextStyle(fontSize: 17 , fontWeight: FontWeight.bold ,color: Colors.white),)),
        // Button to take photo from gallery
        ClassButton(textbutton: "Choose from Gallery", imageicon: "assets/gallray.png",color: sheetbottomColor,onPressed: (){selectImagefromGallrey();}),
        // Button to take photo from Camara 
        ClassButton(textbutton: "Capture with Camera", color: sheetbottomColor, imageicon: "assets/camara.png", onPressed: (){selectImagefromCamara();})
      ],
    ));
      });
    }
  
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit,ConnectivityStatus>(
      builder: (context , state) {
        if(state == ConnectivityStatus.offline){
          return const Nointernet();
        }
        return Scaffold(
          appBar: AppBar(backgroundColor: redC),
          // Bloc
          body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            showdialogForDone(context, "Your profile has been updated successfully.");
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sorry, Please try again later") , backgroundColor: redC,));
          }
        },
        // FOR Loading
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(
                child: Lottie.asset(
                  "assets/loading5.json",
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                ),
              );
            } 
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.95,
                child: Stack(
                  children: [
                    Container(color: redC,),
                    // white color
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(22),
                            topRight: Radius.circular(22)
                          )
                        ),
                        height: MediaQuery.of(context).size.height * 0.75,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05, // 5% Of With
                    vertical: MediaQuery.of(context).size.height * 0.10, // 5% Of height
                    ),
                      child: Form(
                        key: fromkey,
                        // To make the screen good for every size 
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // IMAGE
                              Center(
                                child: GestureDetector(
                                  onTap: (){
                                    sheetbottomPhoto(context);
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ) ,
                                    child: ClipOval(child: selectImage == null ?
                                      Image.asset("assets/user1.png") :
                                      Image.file(File(selectImage!.path) , fit: BoxFit.cover,)),
                                  ),
                                ),
                              ),
                              // Text Edit Picture 
                              const SizedBox(height: 10),
                              Center(child: GestureDetector( onTap: (){ sheetbottomPhoto(context);} ,child: const Text("Edit picture" , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 17),))),
                              const SizedBox(height: 30),
                              // Name
                            const Text("Name" , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 16),),
                          TextboxAuth(textfield: "", controller: namecontroller , color: Colors.blueGrey, validator: (val){
                            if(val == null || val.isEmpty){
                              return "Please enter your name";
                            } else if (val.length < 5){
                              return "Please enter more than 5 letters";
                            }
                            return null;
                          },),
                          // Dietary Preferences
                          const Text("Dietary Preferences" , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 16)),
                          TextboxAuth(textfield: "", controller: dietarycontroller, color: Colors.blueGrey, validator: (val){
                            if(val == null || val.isEmpty){
                              return "Please enter your Dietary Preferences";
                            } else if (val.length < 5){
                              return "Please enter more than 5 letters";
                            }
                            return null;
                          },),
                          //Delivery address
                            const Text("Delivery address",  style: TextStyle(fontWeight: FontWeight.bold , fontSize: 16)),
                            TextboxAuth(textfield: "", controller: deliveryaddresscontroller , color:Colors.blueGrey,validator: (val){
                              if(val == null || val.isEmpty){
                                return "Please enter your address";
                              } else if (val.length < 20){
                              return "Please enter more than 20 letters";
                            }
                              return null;
                            },),
                            ClassButton(textbutton: "Save", imageicon: "assets/food.login.png",color: redC ,onPressed: (){
                              if(fromkey.currentState!.validate()){
                                String name = namecontroller.text;
                                String address = deliveryaddresscontroller.text;
                                String dietary = dietarycontroller.text;
                                File? photo = selectImage;
                                // Very Imprtant , that make cubit work
                                context.read<ProfileCubit>().newdatProfile(name, address, dietary , photo);
                                
                              }
                            })
                          ],),
                        ),
                      )),
                  ],
                ),
              ); // Return your actual content here if there's no loading state
          },
        ),
          ),
        );
      }
    );
}
}