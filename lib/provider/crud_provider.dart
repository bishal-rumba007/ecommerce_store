import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_store/api.dart';
import 'package:ecommerce_store/api_exception.dart';
import 'package:ecommerce_store/model/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../model/user.dart';


final productProvider = FutureProvider((ref) => CrudProvider.getProducts());
final crudProvider = Provider((ref) => CrudProvider());

class CrudProvider{

  final box =  Hive.box<User>('user').values.toList();

  static Future<List<Product>> getProducts() async{
    final dio = Dio();
    try{
      final response = await dio.get(Api.baseUrl);
      return (response.data as List).map((e) => Product.fromJson(e)).toList();
    }on DioError catch(err){
      throw DioException().getDioError(err);
    }

  }

  Future<String> createProducts({
    required String product_name, required String product_detail,
    required int price, required XFile image
  }) async{
    final dio = Dio();
    final cloudinary = CloudinaryPublic('dffxg51gf', 'picture_store', cache: false);
    try{
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path, resourceType: CloudinaryResourceType.Image),
      );

      final response1 = await dio.post(Api.addProduct, data: {
        "product_name": product_name,
        "product_detail": product_detail,
        "price": price,
        "imageUrl": response.secureUrl,
        "public_id": response.publicId
      }, options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ${box[0].token}',
            // 'Content-Type': 'application/json',
            // 'Accept': 'application/json'
          }
      ));

      return 'success';
    }on DioError catch(err){
      print(err.response);
      print(err.message);
      return DioException().getDioError(err);
    }on CloudinaryException catch (e){
      return '${e.message}';
    }

  }



  Future<String> updateProducts({required String product_name, required String product_detail,
    required int price, XFile? image, String? imageId, required String? id}) async{

    final dio = Dio();
    final cloudinary = CloudinaryPublic('dffxg51gf', 'picture_store', cache: false);
    late CloudinaryResponse response;
    
    try{
      if(image == null){
        final response = await dio.patch('${Api.updateProduct}/$id', data: {
          "photo": "no need",
          "product_name": product_name,
          "product_detail": product_detail,
          "price": price,
        }, options: Options(
          headers:{
            HttpHeaders.authorizationHeader: 'Bearer ${box[0].token}'
          }
        ));
        
      } else{
        response = await cloudinary.uploadFile(CloudinaryFile.fromFile(image.path, resourceType: CloudinaryResourceType.Image));

        final response1 = await dio.patch('${Api.updateProduct}/$id', data: {
          "photo": response.secureUrl,
          "product_name": product_name,
          "product_detail": product_detail,
          "price": price,
          "product_id": response.publicId,
          "oldImageId": imageId
        }, options: Options(
            headers:{
              HttpHeaders.authorizationHeader: 'Bearer ${box[0].token}'
            }
        ));
      }
      return 'success';
    } on DioError catch(err){
      return DioException().getDioError(err);
    } on CloudinaryException catch(e){
      return '${e.message}';
    }

  }

  Future<String> removeProduct({required String imageId, required String id
  }) async{
    try{
      final dio = Dio();
      final response = await dio.delete('${Api.removeProduct}/$id', data: {
        "public_id": imageId
      }, options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ${box[0].token}',
            // 'Content-Type': 'application/json',
            // 'Accept': 'application/json'
          }
      ));
      return 'success';
    }on DioError catch(err){
      return DioException().getDioError(err);
    }
  }





}

