
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/cubit/cubit_state.dart';

// To show the food in main page
class FooditemCubit extends Cubit<Fooditemstate> {
  FooditemCubit() : super(FoodItemInitial());

  void getDateFooditem() async{
    try{
    emit(FooditemLoading());
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Fooditem").get();
    List<QueryDocumentSnapshot> foodItems = querySnapshot.docs;
    if(foodItems.isEmpty){
    emit(FooditemError("THERE NO DATE"));
    }
    else{
      emit(FooditemLoaded(foodItems));
    }
    }
    catch(e){
      emit(FooditemError("ERRRRRRRRRRRRROR$e"));
    }
  }
}
// To edit the date for Profile  , if there date will make update , if there not , will add new date 
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  
  void newdatProfile (String name , String address , String dietary , File? photo) async {

    String userId = FirebaseAuth.instance.currentUser!.uid;
    String? email = FirebaseAuth.instance.currentUser!.email;
    try{
      emit(ProfileLoading());
      // check if there date or not 
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Users").where("id", isEqualTo: userId).limit(1).get();
      // PHOTO 
      String? urlImage;
      if(photo != null){
        String fillName = "Profile$userId.jpg";
        var image = FirebaseStorage.instance.ref("UsersPictrue/$fillName");
        await image.putFile(photo);
        urlImage = await image.getDownloadURL();
      }
      if(querySnapshot.docs.isNotEmpty){
        // Make Update 
        await FirebaseFirestore.instance.collection("Users").doc(querySnapshot.docs.first.id).update({
      "name": name,
      "id": userId,
      "email": email,
      "Address": address,
      "Dietary" : dietary,
      "UrlImage": urlImage,
        }
        );
      }
      else{
        // Add new date 
      await FirebaseFirestore.instance.collection("Users").add({
      "name": name,
      "id": userId,
      "email": email,
      "Address": address,
      "Dietary" : dietary,
      "UrlImage": urlImage,
    });
      }
    emit(ProfileLoaded());
    }
    catch(e){
    emit(ProfileError("ERROR WHILE ADD DATE: $e"));
    }
  }
}
// To show the show the date in Profile Page
class DateProfileCubit extends Cubit<DateForProfileState>{
  DateProfileCubit(): super(DateProfileInitial());

  void showDateProfile() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try{
      emit(DateProfileLLoading());
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Users").where("id" , isEqualTo: userId).limit(1).get();
      List<QueryDocumentSnapshot> userDate = querySnapshot.docs;
      if(userDate.isEmpty){
        emit(DateProfileError("THE USER DATE IS EMPTY"));
      }
      else{
        emit(DateProfileLoaded(userDate));
      }
    }
    catch(e){
      emit(DateProfileError("Error in date:$e"));
    }

  }
}

// To add or update the items in Cart Collection 
class AddItemCartCubit extends Cubit<AddItemCartState> {
  AddItemCartCubit() : super(AddItemCartInitial());

  void addNewItemToCart (String idFood , String name , String category, int quantity , String urlImage) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;


    try{
      AddItemCartLoading();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Cart")
      .where("userId" , isEqualTo: userId)
      .where("idFood" , isEqualTo: idFood).get();
  if(querySnapshot.docs.isEmpty){
        await FirebaseFirestore.instance.collection("Cart").add({
        "name": name,
        "idFood": idFood,
        "category": category,
        "userId": userId,
        "quantity" : quantity,
        "URLimage": urlImage
      });
  }
  else{
    DocumentSnapshot  existingItem = querySnapshot.docs.first;
    // like user has already add this before , so if he order it again , we will save the last quantity and add one more 
    int currnetQuantity = existingItem["quantity"]; // this one to get the currnetQuantiy 
    await FirebaseFirestore.instance.collection("Cart").doc(existingItem.id).update({
      "quantity" : currnetQuantity + quantity
    });
  }
      emit(AddItemCartLoaded());
    }
    catch(e){
      emit(AddItemCartError("Error adding item to cart: ${e.toString()}"));
    }
  }
}

// To update the item like add more food , LKIE 2 burger and user want to add more or loss more
class UpdateCartItemCubit extends Cubit<UpdateCartItemState> {
  UpdateCartItemCubit() : super(UpdateCartItemInitial());
  // to add more quantity
  void addmoreFood (String idFood) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try{
      emit(UpdateCartItemLoading());
      QuerySnapshot querySnapshot =  await FirebaseFirestore.instance.collection("Cart")
      .where("userId" , isEqualTo: userId)
      .where("idFood" , isEqualTo: idFood).get();

      if(querySnapshot.docs.isNotEmpty){
        DocumentSnapshot existingItem = querySnapshot.docs.first;
        int currnetQuantiy = existingItem["quantity"];
        FirebaseFirestore.instance.collection("Cart").doc(existingItem.id).update({
          "quantity": currnetQuantiy + 1,
        });
        emit(UpdateCartItemLoaded());
      }
    }
    catch(e){emit(UpdateCartItemError("rror updating item quantity: ${e.toString()}"));}
  }
  // to delete the Food from the cart or update less , 3 to become 2
  void removeFoodCart (String idFood) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try{
      emit(UpdateCartItemLoading());
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Cart")
      .where("userId" , isEqualTo: userId)
      .where("idFood" , isEqualTo: idFood).get();
    if(querySnapshot.docs.isNotEmpty){
      DocumentSnapshot existingItem = querySnapshot.docs.first;
      int currnetQuantiy = existingItem["quantity"];
      if(currnetQuantiy > 1){
        FirebaseFirestore.instance.collection("Cart").doc(existingItem.id).update({
          "quantity": currnetQuantiy - 1,
        });
      }
      else {
        FirebaseFirestore.instance.collection("Cart").doc(existingItem.id).delete();
      }
      emit(UpdateCartItemLoaded());
    }
    }
    catch(e){
      emit(UpdateCartItemError("ERROR IN CART PAGE WHLIE DELETE OR UPDATE THE DATE: ${e.toString()}"));
    }
  }
} 

// Count the total For payment Page
class ConutTotalCubit extends Cubit<CountTotalState> {
    ConutTotalCubit() : super(CountTotalInitial());

    void totalNumber () async {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      try{
      emit(CountTotalLoading());
      QuerySnapshot cartquerySnapshot = await FirebaseFirestore.instance.collection("Cart")
      .where("userId" , isEqualTo: userId).get();
      // Check if the cart is Empty 
        if (cartquerySnapshot.docs.isEmpty) {
                emit(CountTotalLoaded(0.0));
                return;
            }
      final caritems = cartquerySnapshot.docs;
      double totalprice = 0.0;
      for(final cartItem in caritems){
          String foodid = cartItem["idFood"];
          int quantity = cartItem["quantity"];
          // try because this code maybe will throw error
          try{
            QuerySnapshot foodquerySnapshot = await FirebaseFirestore.instance.collection("Fooditem")
          .where("id" , isEqualTo: foodid).get();
          if(foodquerySnapshot.docs.isNotEmpty){
            final fooditem = foodquerySnapshot.docs.first;
            double price = double.parse(fooditem["price"]);
            totalprice += price * quantity;
          }
          }
          catch(e){
            emit(CountTotalEror("CANNOT GET THE TOTAL"));
          }
      }
      emit(CountTotalLoaded(totalprice));
      }
      catch(e){
        emit(CountTotalEror("FAILDED TO COUNT THE TOTAL"));
      }
    }
}

// Order Food 
class OrderFoodCubit extends Cubit<OrderFoodState> {
  OrderFoodCubit() : super(OrderFoodInitial());

  void sendTheOrder(String name , String email , String address , String noteDelivery , String payment) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    List<Map<String, dynamic>> itemsList = []; // to add evert item in th list and send the final List to Orders
    double grandTotal = 0;
    try{
      QuerySnapshot cartquerySnapshot = await FirebaseFirestore.instance.collection("Cart")
      .where("userId" , isEqualTo:  userId).get();
      // if the cart is Empty , the Code will stop here 
      if(cartquerySnapshot.docs.isEmpty){
        emit(OrderFoodError("Your cart is Empty"));
        return;
      }
      for(final cartitem in cartquerySnapshot.docs){
        String foodId = cartitem["idFood"];
        int qunitity = cartitem["quantity"];
        // to get the price
          QuerySnapshot foodquerySnapshot = await FirebaseFirestore.instance.collection("Fooditem")
          .where("id" , isEqualTo: foodId).limit(1).get();
          final fooditem = foodquerySnapshot.docs.first;
          final pricefood = fooditem["price"];
          double priceDouble = double.parse(fooditem["price"]);
          // to get the total but for one item 
          double totalPriceItem = priceDouble * qunitity; // Total but for each food
          grandTotal += totalPriceItem; // The Grand Total
          // Map to add item
            Map<String, dynamic> item = {
              "name" : cartitem["name"],
              "category": cartitem["category"],
              "price": pricefood,
              "quantity": cartitem["quantity"],
              "total": totalPriceItem
            };
            itemsList.add(item);
      } // end of loob
      var orderId = FirebaseFirestore.instance.collection("Orders").doc();
      FirebaseFirestore.instance.collection("Orders").add({
        "name" : name,
        "email": email,
        "Address" : address,
        "Order Id": orderId,
        "userId" : userId,
        "itemList" : itemsList,
        "Grand Total" : grandTotal,
        "Time" : FieldValue.serverTimestamp(),
        "Note Delivery" : noteDelivery,
        "Payment" : payment
      });
      // delete every item in Cart
      for(final deleteCart in cartquerySnapshot.docs){
        await FirebaseFirestore.instance.collection("Cart").doc(deleteCart.id).delete();
      }
      emit(OrderFoodLoaded());
    }
    catch(e){
      emit(OrderFoodError("Error while Order============="));
    }
  }
}
 // check internet 
enum ConnectivityStatus { online, offline }

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  final Connectivity connectivity;

  ConnectivityCubit(this.connectivity) : super(ConnectivityStatus.offline) {

    connectivity.onConnectivityChanged.listen((result) {
      emit(result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)
          ? ConnectivityStatus.online
          : ConnectivityStatus.offline);
    });
  }

  Future<void> checkConnectivity() async {
    var result = await connectivity.checkConnectivity();
    emit(result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)
        ? ConnectivityStatus.online
        : ConnectivityStatus.offline);
  }
}
