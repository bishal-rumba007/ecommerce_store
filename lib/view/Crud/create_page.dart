import 'dart:io';

import 'package:ecommerce_store/common_widgets/snack_show.dart';
import 'package:ecommerce_store/provider/crud_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../provider/common_provider.dart';

class CreatePage extends StatelessWidget {


  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final detailController = TextEditingController();
  final priceController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer(
            builder: (context, ref, child) {
              final image = ref.watch(imageProvider);
              final isLoad = ref.watch(loadingProvider);
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _form,
                    child: ListView(
                      children: [
                        Text('Create Form', style: TextStyle(fontSize: 17),),
                        SizedBox(height: 25,),
                        TextFormField(
                          controller: nameController,
                          validator: (val){
                            if(val!.isEmpty){
                              return 'please provide name';
                            }else if(val.length > 55){
                              return 'maximum character is 55';

                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: 'Product Name'
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
                          controller: detailController,
                          decoration: InputDecoration(
                              hintText: 'Detail'
                          ),
                        ),
                        SizedBox(height: 15,),

                        TextFormField(
                          validator: (val){
                            if(val!.isEmpty){
                              return 'please provide price';
                            }
                            return null;
                          },
                          controller: priceController,
                          decoration: InputDecoration(
                              hintText: 'Price'
                          ),
                        ),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: (){
                            ref.read(imageProvider.notifier).pick_image();
                          },
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            child: image == null ?Center(child: Text('please select an image')) : Image.file(File(image.path)),
                          ),
                        ),
                        SizedBox(height: 15,),
                        ElevatedButton(
                            onPressed: isLoad ? null : () async{
                              _form.currentState!.save();
                              if(_form.currentState!.validate()){
                                if(image ==  null){
                                  Get.defaultDialog(
                                      title: 'image required',
                                      content: Text('please select an image'),
                                      actions: [
                                        TextButton(onPressed: (){
                                          Navigator.of(context).pop();
                                        }, child: Text('close'))
                                      ]
                                  );
                                }else{
                                  ref.read(loadingProvider.notifier).toggle();
                                  final response = await ref.read(crudProvider).createProducts(
                                      product_name: nameController.text.trim(),
                                      product_detail: detailController.text.trim(),
                                      price: int.parse(priceController.text.trim()),
                                      image: image,
                                  );
                                  ref.refresh(productProvider);
                                  ref.read(loadingProvider.notifier).toggle();
                                  if(response != 'success'){
                                    SnackBarShow.showFailureSnack(context, response);
                                  }else{
                                    Get.back();
                                  }
                                }
                              }

                            },
                            child:isLoad  ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10,),
                                Text('Loading', style: TextStyle(fontSize: 17),)
                              ],
                            ): Text('Submit')
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        )
    );
  }
}



