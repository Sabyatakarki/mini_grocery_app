import 'package:flutter/material.dart';
import 'package:mini_grocery/screens/createaccountscreen.dart';
import 'package:mini_grocery/screens/dashboard_screen.dart';
import 'package:mini_grocery/screens/onboardingscreen.dart';

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
                  color: Colors.black,
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
              Column(
                children: const [
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6BAA44),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Get back to your shopping right away",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.04),

              // FORM STARTS HERE
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth > 600 ? 120 : 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text("Enter your email:"),
                      const SizedBox(height: 8),

                      // EMAIL TEXTFORMFIELD
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
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      const Text("Enter your password:"),
                      const SizedBox(height: 8),

                      // PASSWORD TEXTFORMFIELD
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
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      Center(
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // LOGIN BUTTON
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DashboardScreen(),
                                ),
                              );
                            }
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
