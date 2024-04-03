import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_gallery/core/providers/user_provider.dart';
import 'package:my_gallery/core/utils/core_utils.dart';
import 'package:my_gallery/src/auth/data/models/user_modal.dart';
import 'package:my_gallery/src/auth/presntation/bloc/auth_bloc.dart';
import 'package:sizer/sizer.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late TextEditingController emailController;

  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: ExactAssetImage("assets/images/login_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
          ),
          Positioned(
            top: -150,
            left: -120,
            child: Image.asset("assets/images/login_img.png"),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  CoreUtils.showSnackBar(context, state.message);
                } else if (state is SignedIn) {
                  context
                      .read<UserProvider>()
                      .initUser(state.user as UserModel);
                  Navigator.of(context).pushNamed("/gallery");
                }
              },
              builder: (context, state) {
                return Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Text(
                        "My\n Gallery",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: 20.w,
                          height: 45.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white.withOpacity(0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "LOG IN",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: "Username",
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(90),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(90),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(90),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(90),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    hintText: "Password",
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                if (state is AuthLoading)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                else
                                  ElevatedButton(
                                    onPressed: () {
                                      if (emailController.text.isEmpty ||
                                          passwordController.text.isEmpty) {
                                        CoreUtils.showSnackBar(context,
                                            "Please fill all the fields");
                                        return;
                                      }
                                      BlocProvider.of<AuthBloc>(context).add(
                                        SignInEvent(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      minimumSize: Size(double.infinity, 5.h),
                                      // maximumSize: Size(double.infinity, 4.h),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
