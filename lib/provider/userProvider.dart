import 'package:dio/dio.dart';
import 'package:ecommerce_store/api.dart';
import 'package:ecommerce_store/api_exception.dart';
import 'package:ecommerce_store/main.dart';
import 'package:ecommerce_store/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final userProvider = StateNotifierProvider<UserProvider ,List<User>>((ref) => UserProvider(ref.watch(boxA)));


class UserProvider extends StateNotifier<List<User>>{
  UserProvider(super.state);

  final dio = Dio();

  Future<String> userLogin({required String email, required String password}) async{
    try{
      final response = await dio.post(Api.userLogin, data: {
        "email": email,
        "password": password,
      });
      final newUser = User.fromJson(response.data);
      Hive.box<User>('user').add(newUser);
      state = [newUser];
      return 'success';
    } on DioError catch(err){
      return DioException().getDioError(err);
    }

  }


  Future<String> userSignup({required String full_name, required String email, required String password}) async{
    try{
      final response = await dio.post(Api.userRegister, data: {
        "full_name": full_name,
        "email": email,
        "password": password,
      });

      return 'success';
    } on DioError catch(err){
      return DioException().getDioError(err);
    }
  }

  void userLogout() async{
    Hive.box<User>('user').clear();
    state = [];
  }

}