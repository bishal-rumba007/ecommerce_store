

class Product{

  final String id;
  final String product_name;
  final String product_detail;
  final String image;
  final String imageId;
  final int price;

  Product({
    required this.price,
    required this.id,
    required this.product_detail,
    required this.product_name,
    required this.image,
    required this.imageId
  });


  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
        price: json['price'],
        id: json['_id'],
        product_name: json['product_name'],
        product_detail: json['product_detail'],
        imageId: json['public_id'],
        image: json['image']
    );
  }

}