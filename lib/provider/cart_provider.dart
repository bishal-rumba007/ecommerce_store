import 'package:ecommerce_store/main.dart';
import 'package:ecommerce_store/model/cart_item.dart';
import 'package:ecommerce_store/model/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';


final cartProvider = StateNotifierProvider<CartProvider, List<CartItem>>((ref) => CartProvider(ref.watch(boxB)));

class CartProvider extends StateNotifier<List<CartItem>>{
  CartProvider(super.state);


  String addProductToCart(Product product){
    if(state.isEmpty){
      final newCartItem = CartItem(
          id: product.id,
          title: product.product_name,
          price: product.price,
          imageUrl: product.image,
          quantity: 1,
          total: product.price
      );

      Hive.box<CartItem>('carts').add(newCartItem);
      state = [newCartItem];
      return 'successfully added to cart';
    } else{
      final cartItem = state.firstWhere((element) => element.id == product.id, orElse: (){
        return CartItem(id: '', price: 0, title: 'no-data', imageUrl: '', quantity: 0, total: 0);
      });
      if(cartItem.title == 'no-data'){
        final newCartItem = CartItem(
            id: product.id,
            price: product.price,
            title: product.product_name,
            imageUrl: product.image,
            quantity: 1,
            total: product.price
        );
        Hive.box<CartItem>('carts').add(newCartItem);
        state = [...state,  newCartItem];
        return 'successfully added to cart';
      }else{
        return 'already added to cart';
      }
    }
  }


  void singleAdd(CartItem cartItem) {
    cartItem.quantity = cartItem.quantity + 1;
    cartItem.total = cartItem.price * cartItem.quantity ;
    cartItem.save();
    state = [...state];
  }


  void singleRemove(CartItem cartItem) {
    if(cartItem.quantity > 1){
      cartItem.quantity = cartItem.quantity - 1;
      cartItem.total = cartItem.price * cartItem.quantity ;
      cartItem.save();
      state = [...state];
    }

  }


  void removeItem(CartItem cartItem) {
    cartItem.delete();
    state.remove(cartItem);
    state = [...state];
  }


  int get getTotal  {
    int total = 0;
    for (final cartItem in state) {
      total += cartItem.quantity * cartItem.price;
    }
    return total;
  }


  void clear() {
    Hive.box<CartItem>('carts').clear();
    state = [];
  }



}