import 'package:flutter/material.dart';
import 'package:mini_grocery/core/utils/snackbar_utils.dart';
import 'package:mini_grocery/features/auth/presentation/pages/createaccountscreen.dart';
import 'package:mini_grocery/screens/dashboard_screen.dart';
import 'package:mini_grocery/features/onboarding/presentation/pages/onboardingscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: screenHeight,
          child: Column(
            children: [
              // BACK BUTTON
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Onboardingscreen(),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // TITLE
              const Column(
                children: [
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 33,
                      fontFamily: 'OpenSansBold',
                      color: Color.fromARGB(255, 72, 138, 31),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Get back to your shopping right away",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.04),

              // FORM
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth > 600 ? 120 : 25,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Enter your email:"),
                      const SizedBox(height: 8),

                      // EMAIL FIELD
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: const Color(0xFFF7FFCF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Email is required";
                          }
                          if (!RegExp(r'@')
                              .hasMatch(value.trim())) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      const Text("Enter your password:"),
                      const SizedBox(height: 8),

                      // PASSWORD FIELD
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF7FFCF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Password is required";
                          }
                          if (value.trim().length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      Center(
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // LOGIN BUTTON
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // 1️⃣ Inline validation
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            // 2️⃣ Fake auth check (replace later with Firebase/API)
                            final email = _emailController.text.trim();
                            final password =
                                _passwordController.text.trim();

                            if (email != "sabyata@gmail.com" ||
                                password != "123456") {
                              SnackbarUtils.showError(
                                  context, "Incorrect email or password");
                              return;
                            }

                            // 3️⃣ Success
                            SnackbarUtils.showSuccess(
                                context, "Login successful");

                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DashboardScreen(),
                                ),
                              );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6BAA44),
                            minimumSize: const Size(180, 45),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            "Log in",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don’t have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const Createaccountscreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Create one.",
                              style: TextStyle(
                                color: Color(0xFF6BAA44),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
