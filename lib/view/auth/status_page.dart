import 'package:ecommerce_store/provider/userProvider.dart';
import 'package:ecommerce_store/view/dashboard/home_page.dart';
import 'package:ecommerce_store/view/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class StatusPage extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ref) {
    final userData = ref.watch(userProvider);
    return userData.isEmpty ? LoginPage() : HomePage();
  }
}
