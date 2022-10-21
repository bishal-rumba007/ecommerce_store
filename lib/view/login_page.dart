import 'package:ecommerce_store/provider/common_provider.dart';
import 'package:ecommerce_store/provider/userProvider.dart';
import 'package:ecommerce_store/view/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../common_widgets/snack_show.dart';

class LoginPage extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final mailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff36EEE0),
        body: Consumer(builder: (context, ref, child) {
          final isLoad = ref.watch(loadingProvider);
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.h),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text('Welcome',
                        style: TextStyle(
                          fontSize: 35.sp,
                          fontFamily: 'Poppins',
                        )),
                    Text(
                      'Fill up the credential to Sign in',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 12.sp),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'email required';
                        } else if (!val.contains('@')) {
                          return 'please provide valid email';
                        }
                        return null;
                      },
                      controller: mailController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: Color(0xff4C5270),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                          prefixIcon: Icon(Icons.mail),
                          prefixIconColor: Color(0xff4C5270),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'password required';
                        } else if (val.length > 15) {
                          return 'maximum character is 15';
                        }
                        return null;
                      },
                      controller: passController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              color: Color(0xff4C5270),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                          prefixIcon: Icon(Icons.key),
                          prefixIconColor: Color(0xff4C5270),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xfff652a0),
                            minimumSize: Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            )),
                        onPressed: isLoad
                            ? null
                            : () async {
                                _form.currentState!.save();
                                FocusScope.of(context).unfocus();
                                if (_form.currentState!.validate()) {
                                  ref.read(loadingProvider.notifier).toggle();
                                  final response = await ref
                                      .read(userProvider.notifier)
                                      .userLogin(
                                        email: mailController.text.trim(),
                                        password: passController.text.trim(),
                                      );
                                  ref.read(loadingProvider.notifier).toggle();
                                  if (response != 'success') {
                                    SnackBarShow.showFailureSnack(
                                        context, response);
                                  } else {
                                    SnackBarShow.showSuccessSnack(
                                        context, 'successfully user login');
                                  }
                                }
                              },
                        child: isLoad
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Loading',
                                    style: TextStyle(fontSize: 17.sp),
                                  )
                                ],
                              )
                            : Text(
                                'Submit',
                              )),
                    SizedBox(
                      height: 5.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account ?',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.to(() => SignUpPage());
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Color(0xfff652a0),
                                fontSize: 12.sp,
                                decoration: TextDecoration.underline,
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
