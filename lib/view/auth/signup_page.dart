import 'package:ecommerce_store/provider/common_provider.dart';
import 'package:ecommerce_store/view/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../common_widgets/snack_show.dart';
import '../../provider/userProvider.dart';

class SignUpPage extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff36EEE0),
        body: Consumer(builder: (context, ref, child) {
          final isLoad = ref.watch(loadingProvider);
          final image = ref.watch(imageProvider);
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.h),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 4.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Sign Up',
                            style: TextStyle(
                              fontSize: 35.sp,
                              fontFamily: 'Poppins',
                            )),
                        Text(
                          'Fill up the credential to Sign Up',
                          style:
                              TextStyle(fontFamily: 'Poppins', fontSize: 12.sp),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    TextFormField(
                      controller: nameController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'please provide username';
                        } else if (val.length > 15) {
                          return 'maximum character is 15';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Full Name',
                          hintStyle: TextStyle(
                              color: Color(0xff4C5270),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                          prefixIcon: Icon(Icons.person),
                          prefixIconColor: Color(0xff4C5270),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                    SizedBox(
                      height: 2.h,
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
                          hintText: 'Email',
                          hintStyle: TextStyle(
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
                          hintText: 'Password',
                          hintStyle: TextStyle(
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
                                      .userSignup(
                                          full_name: nameController.text.trim(),
                                          email: mailController.text.trim(),
                                          password: passController.text.trim());
                                  ref.read(loadingProvider.notifier).toggle();
                                  if (response != 'success') {
                                    SnackBarShow.showFailureSnack(
                                        context, response);
                                  } else {
                                    SnackBarShow.showSuccessSnack(
                                        context, 'successfully user signed up');
                                    Get.back();
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
                                    style: TextStyle(fontSize: 12.sp),
                                  )
                                ],
                              )
                            : Text('Submit')),
                    SizedBox(
                      height: 5.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Already Have an account?',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.to(() => LoginPage());
                            },
                            child: Text(
                              'Login',
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
