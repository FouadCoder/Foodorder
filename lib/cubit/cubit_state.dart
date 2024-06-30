
import 'package:cloud_firestore/cloud_firestore.dart';
// To show the food in main page
abstract class Fooditemstate{}
class FoodItemInitial extends Fooditemstate{}
class FooditemLoading extends Fooditemstate{}
class FooditemLoaded extends Fooditemstate{
  final List<QueryDocumentSnapshot> foodItems;
  FooditemLoaded(this.foodItems);
}
class FooditemError extends Fooditemstate{
  final String meassage;
  FooditemError(this.meassage);
}
// To edit the date for Profile 
abstract class ProfileState{}
class ProfileInitial extends ProfileState{}
class ProfileLoading extends ProfileState{}
class ProfileLoaded extends ProfileState{}
class ProfileError extends ProfileState{

  final String message;
  ProfileError(this.message);
}
// To show the show the date in Profile Page
abstract class DateForProfileState{}
class DateProfileInitial extends DateForProfileState{}
class DateProfileLLoading extends DateForProfileState{}
class DateProfileLoaded extends DateForProfileState{
  final List<QueryDocumentSnapshot> userDate;
  DateProfileLoaded(this.userDate);
}
class DateProfileError extends DateForProfileState{
  final String meassage;
  DateProfileError(this.meassage);
}
// To add the items in Cart Collection 
abstract class AddItemCartState{}
class AddItemCartInitial extends AddItemCartState{}
class AddItemCartLoading extends AddItemCartState{}
class AddItemCartLoaded extends AddItemCartState{}
class AddItemCartError extends AddItemCartState{
  String message;
  AddItemCartError(this.message);
}
// To get the item date from Cart
//Update the state of Cart like Add more or Loss more 
abstract class UpdateCartItemState{}
class UpdateCartItemInitial extends UpdateCartItemState{}
class UpdateCartItemLoading extends UpdateCartItemState{}
class UpdateCartItemLoaded extends UpdateCartItemState{}
class UpdateCartItemError extends UpdateCartItemState{
  String message;
  UpdateCartItemError(this.message);
}
// To count total in Payment Page 
abstract class CountTotalState{}
class CountTotalInitial extends CountTotalState{}
class CountTotalLoading extends CountTotalState{}
class CountTotalLoaded extends CountTotalState{
  double totalPrice;
  CountTotalLoaded(this.totalPrice);
}
class CountTotalEror extends CountTotalState{

  String meassage;
  CountTotalEror(this.meassage);
}
// To order Food 
abstract class OrderFoodState{}
class OrderFoodInitial extends OrderFoodState{}
class OrderFoodLoading extends OrderFoodState{}
class OrderFoodLoaded extends OrderFoodState{}
class OrderFoodError extends OrderFoodState{
  String meassage;
  OrderFoodError(this.meassage);
}