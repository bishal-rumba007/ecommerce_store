import 'package:ecommerce_store/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../common_widgets/snack_show.dart';
import '../provider/cart_provider.dart';
import '../provider/common_provider.dart';

enum ActionType { delete }

class CartPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final cartData = ref.watch(cartProvider);
    final total = ref.watch(cartProvider.notifier).getTotal;
    final isLoad = ref.watch(loadingProvider);
    return Scaffold(
        body: Container(
      child: cartData.isEmpty
          ? Center(child: Text('Add some product'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: cartData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.h, vertical: 2.h),
                          child: Row(
                            children: [
                              Container(
                                  height: 21.h,
                                  width: 21.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      cartData[index].imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                              Expanded(
                                child: Container(
                                  height: 21.h,
                                  child: Padding(
                                    padding: EdgeInsets.all(1.h),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              cartData[index].title,
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            PopupMenuButton(onSelected: (val) {
                                              Get.defaultDialog(
                                                  title: 'Hold On',
                                                  content: Text(
                                                      'Are you sure you want to remove post'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          ref
                                                              .read(cartProvider
                                                                  .notifier)
                                                              .removeItem(
                                                                  cartData[
                                                                      index]);
                                                        },
                                                        child: Text('Yes')),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('No')),
                                                  ]);
                                            }, itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                    value: ActionType.delete,
                                                    child: Text('Remove')),
                                              ];
                                            }),
                                          ],
                                        ),
                                        Text('Rs. ${cartData[index].total}'),
                                        Row(
                                          children: [
                                            OutlinedButton(
                                                onPressed: () {
                                                  ref
                                                      .read(
                                                          cartProvider.notifier)
                                                      .singleAdd(
                                                          cartData[index]);
                                                },
                                                child: Icon(Icons.add)),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Text(
                                                  '${cartData[index].quantity}'),
                                            ),
                                            OutlinedButton(
                                                onPressed: () {
                                                  ref
                                                      .read(
                                                          cartProvider.notifier)
                                                      .singleRemove(
                                                          cartData[index]);
                                                },
                                                child: Icon(Icons.remove)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Total :',
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins'),
                          ),
                          Text('$total',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins'))
                        ],
                      ),
                      SizedBox(height: 2.h,),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          height: 6.h,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4BBBBB),
                            ),
                              onPressed: isLoad
                                  ? null
                                  : () async {
                                      ref.read(loadingProvider.notifier).toggle();
                                      final response = await ref
                                          .read(orderProvider)
                                          .addOrder(
                                              totalAmount: total,
                                              products: cartData);
                                      ref.read(loadingProvider.notifier).toggle();
                                      ref.read(cartProvider.notifier).clear();
                                      if (response != 'success') {
                                        SnackBarShow.showFailureSnack(
                                            context, response);
                                      } else {
                                        SnackBarShow.showSuccessSnack(
                                            context, 'successfully send to server');
                                      }
                                    },
                              child: isLoad
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Loading',
                                          style: TextStyle(fontSize: 17),
                                        )
                                      ],
                                    )
                                  : Text('Check Out')),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    ));
  }
}
