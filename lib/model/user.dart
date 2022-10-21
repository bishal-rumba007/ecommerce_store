import 'package:hive_flutter/hive_flutter.dart';
part 'user.g.dart';


@HiveType(typeId: 0)
class User extends HiveObject{

  @HiveField(0)
  String token;

  @HiveField(1)
  String id;

  @HiveField(2)
  String email;

  @HiveField(3)
  String username;

  User({
    required this.id,
    required this.username,
    required this.token,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      username: json['username'],
      token: json['token'],
      email: json['email']
    );
  }





}