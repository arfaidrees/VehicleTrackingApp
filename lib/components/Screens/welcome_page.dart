import 'package:flutter/material.dart';
import 'package:vehicle_tracking_app/components/Screens/signup_page.dart';
import '../common/custom_scaffold.dart';
import '../common/welcome_button.dart';
import 'login_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 40.0,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 'Welcome to' text in the center
                    Text(
                      'Welcome to',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff520521),
                      ),
                    ),
                    // 'Vehicle Tracking App' with smaller font
                    const SizedBox(height: 20.0), // Add gap between the texts
                    Text(
                      'Vehicle Tracking App',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23.0,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff520521),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: WelcomeButton(
                        buttonText: 'Sign in',
                        onTap: LoginPage(),
                        color: Colors.transparent,
                        textColor: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10), // Reduced space between buttons
                    Container(
                      width: 130,
                      height: 70,
                      child: WelcomeButton(
                        buttonText: 'Sign up',
                        onTap: const SignupPage(),
                        color: const Color(0xff520521),
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
