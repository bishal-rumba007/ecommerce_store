import 'package:ecommerce_store/model/cart_item.dart';
import 'package:ecommerce_store/view/auth/status_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'model/user.dart';



final boxA = Provider<List<User>>((ref) => []);
final boxB = Provider<List<CartItem>>((ref) => []);



void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CartItemAdapter());
  final userBox =  await Hive.openBox<User>('user');
  final cartBox = await Hive.openBox<CartItem>('carts');
  runApp(ProviderScope(
      overrides: [
        boxA.overrideWithValue(userBox.values.toList()),
        boxB.overrideWithValue(cartBox.values.toList())
      ],
      child: Home()));
}


class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            home: AnimatedSplashScreen(
                duration: 2000,
                splash: 'assets/icon/deviant-art.png',
                splashIconSize: 100,
                nextScreen: StatusPage(),
                splashTransition: SplashTransition.fadeTransition,
                pageTransitionType: PageTransitionType.leftToRight,
                backgroundColor: Colors.white
            ),
        );
      }
    );
  }
}
