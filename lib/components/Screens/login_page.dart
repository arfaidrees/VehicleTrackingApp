// login_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vehicle_tracking_app/components/Screens/signup_page.dart';

import '../../Location/location.dart';
import '../../Repository/firebaseRepository.dart';
import 'Navi.dart';
import 'forget_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberPassword = true;
  bool isPasswordVisible = false;
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  final _locationController = Get.put(LocationController());
  RxBool isLoading = false.obs;

  Future<void> _handleLoginUser() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Submitting data...')),
    );
    if (_loginFormKey.currentState!.validate()) {
      isLoading.value = true;
      String? errorMessage =
          await _firebaseRepository.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (errorMessage == null) {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          _locationController.initFirebaseAndLocation();
          Get.off(menustack());
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF1F3),
      body: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(height: 10),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff520521),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          hintText: 'Enter Email',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      TextFormField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            child: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color(0xFF520521),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberPassword,
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberPassword = value!;
                                  });
                                },
                                activeColor: const Color(0xff520521),
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(color: Colors.black45),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgetPasswordPage(),
                              ),
                            ),
                            child: const Text(
                              'Forget password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff520521),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff520521),
                            foregroundColor: Colors.white, // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _handleLoginUser,
                          child: Obx(
                            () => isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text('Login'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(color: Colors.black45),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupPage(),
                              ),
                            ),
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff520521),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
