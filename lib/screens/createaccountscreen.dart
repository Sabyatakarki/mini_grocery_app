import 'package:flutter/material.dart';
import 'package:mini_grocery/screens/dashboard_screen.dart';
import 'package:mini_grocery/screens/loginpagescreen.dart';

class Createaccountscreen extends StatefulWidget {
  const Createaccountscreen({super.key});

  @override
  State<Createaccountscreen> createState() => _CreateaccountscreenState();
}

class _CreateaccountscreenState extends State<Createaccountscreen> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          children: [
            // BACK BUTTON
            Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.04,
                left: screenWidth * 0.02,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),

            // MAIN CONTENT
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.01),

                    Text(
                      "Create Account",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6BAA44),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    Text(
                      "Join us and start your fresh shopping journey",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // FULL NAME
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Full Name:", style: TextStyle(fontSize: 14))),
                    SizedBox(height: screenHeight * 0.008),

                    TextFormField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outline),
                        filled: true,
                        fillColor: const Color(0xFFF7FFCF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter full name";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // EMAIL
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Email:", style: TextStyle(fontSize: 14))),
                    SizedBox(height: screenHeight * 0.008),

                    TextFormField(
                      controller: emailController,
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
                          return "Please enter email";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // PASSWORD
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Password:", style: TextStyle(fontSize: 14))),
                    SizedBox(height: screenHeight * 0.008),

                    TextFormField(
                      controller: passController,
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
                          return "Please enter password";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // CONFIRM PASSWORD
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Confirm Password:",
                            style: TextStyle(fontSize: 14))),
                    SizedBox(height: screenHeight * 0.008),

                    TextFormField(
                      controller: confirmPassController,
                      obscureText: !_confirmPasswordVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
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
                          return "Please confirm password";
                        }
                        if (value != passController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.015),

                    // TERMS CHECKBOX
                    Row(
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          onChanged: (value) {
                            setState(() {
                              _acceptTerms = value!;
                            });
                          },
                          activeColor: const Color(0xFF6BAA44),
                        ),
                        Expanded(
                          child: Text(
                            "By signing up, you agree to our Terms & Privacy Policy.",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),

                    // SIGN UP BUTTON
                   ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() && _acceptTerms) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardScreen(),
                            ),
                          );
                        } else {
                          setState(() {});
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6BAA44),
                        minimumSize: Size(screenWidth * 0.45, 45),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Log in.",
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
    );
  }
}
