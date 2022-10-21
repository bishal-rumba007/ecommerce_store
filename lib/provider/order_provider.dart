import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce_store/api_exception.dart';
import 'package:ecommerce_store/model/order.dart';
import 'package:ecommerce_store/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../api.dart';
import '../model/cart_item.dart';


final orderProvider = Provider((ref) => OrderProvider());
final orderHistory = FutureProvider.autoDispose((ref) => OrderProvider().getOrder());

class OrderProvider{

  final dio = Dio();
  final box = Hive.box<User>('user').values.toList();

  Future<String> addOrder({required int totalAmount, required List<CartItem> products}) async{

    try{
      final response = await dio.post(Api.orderCreate, data: {
        "amount": totalAmount,
        "dateTime": DateTime.now().toString(),
        "products": products.map((e) => e.toJson()).toList(),
        "userId": box[0].id
      }, options: Options(
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${box[0].token}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      )
      );
      return 'success';
    } on DioError catch(err){
      return DioException().getDioError(err);
    }

  }
  
  
  Future<List<Order>> getOrder() async{
    
    try{
      final response = await dio.get('${Api.getOrderHistory}/${box[0].id}',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ${box[0].token}',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }
        )
      );
      final data = (response.data as List).map((e) => Order.fromJson(e)).toList();
      return data;
    } on DioError catch(err){
      throw DioException().getDioError(err);
      
    }
  }



}