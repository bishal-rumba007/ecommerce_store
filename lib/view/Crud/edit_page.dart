import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../common_widgets/snack_show.dart';
import '../../model/product.dart';
import '../../provider/common_provider.dart';
import '../../provider/crud_provider.dart';


class EditPage extends StatelessWidget {
  final Product product;
  EditPage(this.product);

  final _form = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final detailController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _form,
              child: ListView(
                children: [
                  Text('Create Form', style: TextStyle(fontSize: 17),),
                  SizedBox(height: 25,),
                  TextFormField(
                    controller:titleController..text = product.product_name,
                    validator: (val){
                      if(val!.isEmpty){
                        return 'please provider title';
                      }else if(val.length > 55){
                        return 'maximum character is 55';

                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Title'
                    ),
                  ),
                  SizedBox(height: 15,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (val){
                      if(val!.isEmpty){
                        return 'please provide price';
                      }
                      return null;
                    },
                    controller: priceController..text = product.price.toString(),
                    decoration: InputDecoration(
                        hintText: 'Price'
                    ),
                  ),

                  SizedBox(height: 15,),
                  TextFormField(
                    validator: (val){
                      if(val!.isEmpty){
                        return 'please provide detail';
                      }
                      return null;
                    },
                    controller: detailController..text = product.product_detail,
                    decoration: InputDecoration(
                        hintText: 'Detail'
                    ),
                  ),


                  SizedBox(height: 15,),
                  Consumer(
                      builder: (context,ref, child) {
                        final image = ref.watch(imageProvider);
                        final isLoad = ref.watch(loadingProvider);
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                ref.read(imageProvider.notifier)
                                    .pick_image();
                              },
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                child: image == null ? Image.network(
                                    product.image) : Image.file(
                                    File(image.path)),
                              ),
                            ),


                            SizedBox(height: 15,),
                            ElevatedButton(
                                onPressed: isLoad ? null : () async {
                                  _form.currentState!.save();
                                  //   print(mailController.text.replaceAll(RegExp(r"\s+"), " "));
                                  if (_form.currentState!.validate()) {
                                    if (image == null) {
                                      ref.read(loadingProvider.notifier)
                                          .toggle();
                                      final response = await ref.read(
                                          crudProvider).updateProducts(
                                          product_name: titleController.text
                                              .trim(),
                                          product_detail: detailController
                                              .text.trim(),
                                          price: int.parse(
                                              priceController.text.trim()),
                                          id: product.id);
                                      ref.refresh(productProvider);
                                      ref.read(loadingProvider.notifier)
                                          .toggle();
                                      if (response != 'success') {
                                        SnackBarShow.showFailureSnack(
                                            context, response);
                                      } else {
                                        Get.back();
                                      }
                                    } else {
                                      ref.read(loadingProvider.notifier).toggle();
                                      final response = await ref.read(crudProvider).updateProducts(
                                          product_name: titleController.text.trim(),
                                          product_detail: detailController.text.trim(),
                                          image: image,
                                          imageId: product.imageId,
                                          price: int.parse(priceController.text.trim()),
                                          id: product.id
                                      );
                                      ref.refresh(productProvider);
                                      ref.read(loadingProvider.notifier)
                                          .toggle();
                                      if (response != 'success') {
                                        SnackBarShow.showFailureSnack(
                                            context, response);
                                      } else {
                                        Get.back();
                                      }
                                    }
                                  }
                                }, child: isLoad ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10,),
                                Text('Loading',
                                  style: TextStyle(fontSize: 17),)
                              ],
                            ) : Text('Submit')
                            ),

                          ],
                        );
                      }
                  ),

                  SizedBox(height: 15,),

                ],
              ),
            ),
          ),
        )
    );
  }
}