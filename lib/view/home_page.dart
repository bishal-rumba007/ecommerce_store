import 'package:ecommerce_store/provider/crud_provider.dart';
import 'package:ecommerce_store/provider/userProvider.dart';
import 'package:ecommerce_store/view/cart_page.dart';
import 'package:ecommerce_store/view/customize_page.dart';
import 'package:ecommerce_store/view/detail_page.dart';
import 'package:ecommerce_store/view/history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'create_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final userData = ref.watch(userProvider);
        final productData = ref.watch(productProvider);
        return Scaffold(
          appBar: AppBar(
            title: Text('Welcome, ${userData[0].username}'),
            backgroundColor: Color(0xFF4BBBBB),
            actions: [
              IconButton(
                  onPressed: (){
                    Get.to(() => CartPage());
                  },
                  icon: Icon(Icons.shopping_cart)
              )
            ],
          ),
          drawer: Drawer(
            backgroundColor: Color(0xFF4BBBBB),
            child: ListView(
              children: [
                DrawerHeader(child: Text(userData[0].username, style: TextStyle(color: Colors.white),)),
                ListTile(
                  leading: Icon(Icons.mail),
                    title: Text(userData[0].email, style: TextStyle(color: Colors.white),),
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('add products', style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Navigator.of(context).pop();
                    Get.to(() => CreatePage(), transition: Transition.leftToRight);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.dashboard_customize),
                  title: Text('Customize Products', style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Navigator.of(context).pop();
                    Get.to(() => CustomizePage());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Order History', style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Navigator.of(context).pop();
                    Get.to(() => HistoryPage(), transition: Transition.leftToRight);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Log out', style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Navigator.of(context).pop();
                    ref.read(userProvider.notifier).userLogout();
                  },
                ),
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
            child: Container(
              child: productData.when(
                  data: (data) {
                    return GridView.builder(
                      itemCount: data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 2.h,
                            crossAxisSpacing: 2.h,
                            childAspectRatio: 2/3, // 1.2 for crossAxis count 1
                        ),
                      itemBuilder: (content, index){
                        return InkWell(
                          onTap: (){
                            Get.to(() => DetailPage(data[index]), transition:  Transition.leftToRight);
                          },
                          child: GridTile(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Hero(
                                  transitionOnUserGestures: true,
                                    tag: data[index].id,
                                    child: Image.network(data[index].image, fit: BoxFit.cover,)
                                ),
                              ),
                            footer: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              height: 50,
                              color: Colors.black45,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data[index].product_name,
                                    style: TextStyle(
                                        color: Colors.white,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                  Text('Rs. ${data[index].price}',
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (err, stack) => Center(child: Text('${err}'),) ,
                  loading: () => Center(child: CircularProgressIndicator(),)
              ),
            ),
          ),
        );
      }
    );
  }
}
