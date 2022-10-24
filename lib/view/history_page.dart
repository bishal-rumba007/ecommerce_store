import 'package:ecommerce_store/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class HistoryPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Consumer(
        builder: (context, ref, child) {
          final orderData = ref.watch(orderHistory);
          return orderData.when(
              data: (data){
                if( data.isEmpty) return Center(child: Text("Nothing here", style: TextStyle(fontSize: 18),));
                else return ListView.builder(
                  itemCount: data.length,
                    itemBuilder: (context, index) {
                      DateTime now = DateTime.parse(data[index].dateTime);
                      String formattedDate = DateFormat('yMd').format(now);
                      String time = DateFormat('jm').format(now).toString();
                      return ExpansionTile(
                        title: Text('$formattedDate $time'),
                        children: [
                          Column(
                            children: data[index].products.map((e){
                              return Padding(
                                padding: EdgeInsets.all(1.h),
                                child: Row(
                                  children: [
                                    Image.network(e.imageUrl, height: 20.h, width: 20.h, fit: BoxFit.cover,),
                                    Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(1.h),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(e.title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),),
                                              SizedBox(height: 20, ),
                                              Text('${e.quantity} X ${e.price}', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),),
                                              SizedBox(height: 2.h,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text('Total:-', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400)),
                                                  SizedBox(width: 2.h,),
                                                  Text('${data[index].amount}', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400)),
                                                ],
                                          )
                                            ],
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    },
                );
              },
              error: (err, stack) => Text('$err'),
              loading: () => Center(child: CircularProgressIndicator()),
          );
        },
      ),

    );
  }
}
