import 'package:ecommerce_store/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../../common_widgets/snack_show.dart';
import '../../model/product.dart';



class DetailPage extends StatelessWidget {
  final Product product;
  DetailPage(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF4BBBBB),
        body: SafeArea(
          child: Container(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))
                  ),
                  margin: EdgeInsets.only(top: 30.h),
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 12.h, left: 2.h, right: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(product.product_detail,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey
                        ),
                      ),
                      SizedBox(height: 30.h,),
                      Consumer(
                        builder: (context, ref, child) {
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 50),
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  )
                              ),
                              onPressed: () {
                                final response = ref.read(cartProvider.notifier)
                                    .addProductToCart(product);
                                if (response == 'successfully added to cart') {
                                  SnackBarShow.cartSuccessSnack(
                                      context, response);
                                } else {
                                  SnackBarShow.cartAlreadySnack(
                                      context, response);
                                }
                              },
                              child: Text('Add To Cart',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                ),
                              )
                          );
                        }
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 38.h,
                    padding: EdgeInsets.only(top: 4.h,left: 2.h, right: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(product.product_name, style: TextStyle(color: Colors.white, fontSize: 20),),
                        Row(
                          children: [
                            Text('Rs. ${product.price}',  style: TextStyle(color: Colors.white, fontSize: 17)),
                            SizedBox(width: 100,),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Hero(
                                  tag: product.id,
                                  transitionOnUserGestures: true,
                                  child: Image.network(product.image,
                                    height: 24.h, fit: BoxFit.cover,),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}

