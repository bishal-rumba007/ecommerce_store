# ecommerce_store

A new Flutter project about Ecommerce app. admin side only. the API does not have role based access.
so it is okay to say that the project is either admin or vendor view but also has features of client view.
they can create product, customize product, delete product, add to cart, and check out.

## Getting Started
The API is integrated carefully with all the get, post, patch and delete function.

## Start here
When user signs up and creates new account, the user info is saved locally using Hive.
The Hive stores token, full name, email and password. it is only then stored in database
which is MongoDb. 

Every API fetch requires to use Bearer token so the token is saved locally in Hive user Box.
besides user, there is also a product box.


## <<<<< IMPORTANT!!!!! >>>>>
It is very important to know how the data are stored locally in hive.
it is done by following steps:

1. Generate type Adapter (See user and cart_item model)
2. this code is used to generate type adapter for the first time (flutter pub run build_runner watch --delete-conflicting-outputs)
3. to generate type adapter again for different model just use (flutter pub run build_runner build)
4. Register the type adapter in main.dart file (see line 21-14)
5. need to override the boxes inside runAPP() (see line 25-29)
6. the user, product and cart_item have their models
7. crud provider is for saving, removing, single item save, single item remove of cart items locally in hive Box