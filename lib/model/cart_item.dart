import 'package:hive_flutter/hive_flutter.dart';
part 'cart_item.g.dart';


@HiveType(typeId: 1)
class CartItem extends HiveObject{

  @HiveField(0)
  String id;

  @HiveField(1)
  int price;

  @HiveField(2)
  String title;

  @HiveField(3)
  int quantity;

  @HiveField(4)
  String imageUrl;

  @HiveField(5)
  int total;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.total,
  });

  factory CartItem.fromJson(Map<String, dynamic> json){
    return CartItem(
        title: json['title'],
        id: json['id'],
        imageUrl: json['imageUrl'],
        price: json['price'],
        quantity: json['quantity'],
        total: json['total']
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'title': this.title,
      'id': this.id,
      'imageUrl': this.imageUrl,
      'price': this.price,
      'quantity': this.quantity,
      'total': this.total
    };
  }


}