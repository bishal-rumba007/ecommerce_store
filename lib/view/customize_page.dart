import 'package:ecommerce_store/provider/crud_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'edit_page.dart';


class CustomizePage extends StatelessWidget {
  const CustomizePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final productData = ref.watch(productProvider);
        return Scaffold(
          appBar: AppBar(
            title: Text('Customize Your Shop'),
          ),
          body: SafeArea(
              child: Container(
                child: productData.when(
                    data: (data){
                      return ListView.builder(
                        itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 0 ),
                              child: Container(
                                child: ListTile(
                                  leading: Container(
                                    height: 100,
                                    width: 100,
                                    child: Image.network(data[index].image, fit: BoxFit.cover,),
                                  ),
                                  title: Text(data[index].product_name),
                                  trailing: Container(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                            onPressed: (){
                                              Get.to(() => EditPage(data[index]), transition: Transition.leftToRight);
                                            },
                                            icon: Icon(Icons.edit)
                                        ),
                                        IconButton(
                                            onPressed: (){
                                              // Get.defaultDialog(
                                              //     title: 'Hold On',
                                              //     content: Text('Are you sure you want to remove post'),
                                              //     actions: [
                                              //       TextButton(onPressed: () async{
                                              //         final response = await ref.read(crudProvider).removeProduct(
                                              //             id: data[index].id,
                                              //             imageId: data[index].imageId
                                              //         );
                                              //         Navigator.of(context).pop();
                                              //         if(response != 'success'){
                                              //           SnackBarShow.showFailureSnack(context, response);
                                              //         } else{
                                              //           SnackBarShow.showSuccessSnack(context, response);
                                              //           Get.back();
                                              //         }
                                              //       }, child: Text('Yes')),
                                              //       TextButton(onPressed: (){
                                              //         Get.back();
                                              //       }, child: Text('No')),
                                              //     ]
                                              // );
                                              // ref.refresh(productProvider);

                                              Get.defaultDialog(
                                                  title: 'Are you sure',
                                                  content: Text('You want to remove this post'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () async{
                                                          Navigator.of(context).pop();
                                                          await ref.read(crudProvider).removeProduct(
                                                              imageId: data[index].imageId,
                                                              id: data[index].id
                                                          );
                                                          ref.refresh(productProvider);
                                                        }, child: Text('yes')),
                                                    TextButton(
                                                        onPressed: (){
                                                          Navigator.of(context).pop();
                                                        }, child: Text('no')),
                                                  ]
                                              );
                                            },
                                            icon: Icon(Icons.delete)
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                      );
                    },
                    error: (err, stack) => Text('${err}'),
                    loading: () => Center(child: CircularProgressIndicator(),)
                ),
              )
          ),
        );
      }
    );
  }
}
