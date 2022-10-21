import 'cart_item.dart';

class Order {
  final int amount;
  final String dateTime;
  final List<CartItem> products;
  final String userId;

  Order({
    required this.amount,
    required this.dateTime,
    required this.products,
    required this.userId
  });


  factory Order.fromJson(Map<String, dynamic> json){
    return Order(
        amount: json['amount'],
        dateTime: json['dateTime'],
        products: (json['products'] as List).map((e) => CartItem.fromJson(e)).toList(),
        userId: json['userId']
    );
  }
}