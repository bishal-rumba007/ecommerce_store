import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/dashboard/cart_page.dart';


class SnackBarShow{

  static showSuccessSnack(BuildContext context, String message){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: Colors.black),),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
        )
    );
  }


  static showFailureSnack(BuildContext context, String message){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: Colors.black),),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.redAccent,
        )
    );
  }


  static cartSuccessSnack(BuildContext context, String message){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Colors.greenAccent,
            action: SnackBarAction(label: 'Go to Cart', onPressed: (){
              Get.to(() => CartPage(), transition:  Transition.leftToRight);
            }),
            content: Text(message, style: TextStyle(color:Colors.black),)));
  }



  static cartAlreadySnack(BuildContext context, String message){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Colors.black,
            action: SnackBarAction(label: 'Go to Cart', onPressed: (){
              Get.to(() => CartPage(), transition:  Transition.leftToRight);
            }),
            content: Text(message, style: TextStyle(color:Colors.white),)));
  }


}