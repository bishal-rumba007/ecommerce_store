



class Api{
  static const baseUrl = 'https://basketplace.herokuapp.com';

  // static const baseUrl = 'http://192.168.0.102:3000';
  static const userLogin = '$baseUrl/api/userLogin';
  static const userRegister = '$baseUrl/api/userSignUp';
  static const addProduct = '$baseUrl/api/create_products';
  static const updateProduct = '$baseUrl/product/update';
  static const removeProduct = '$baseUrl/products/remove';
  static const orderCreate = '$baseUrl/order/order_create';
  static const getOrderHistory = '$baseUrl/order/history';


}