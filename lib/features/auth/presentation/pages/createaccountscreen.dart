import 'package:flutter/material.dart';
import 'package:mini_grocery/core/utils/snackbar_utils.dart';
import 'package:mini_grocery/features/auth/presentation/pages/loginpagescreen.dart';


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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.04),
                Align(
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

                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'OpenSansBold',
                    color: Color.fromARGB(255, 72, 138, 31),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Join us and start your fresh shopping journey",
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.03),

                // FULL NAME
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Full Name:", style: TextStyle(fontSize: 14)),
                ),
                const SizedBox(height: 8),
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
                    if (value == null || value.trim().isEmpty) {
                      return "Full name is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),

                // EMAIL
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Email:", style: TextStyle(fontSize: 14)),
                ),
                const SizedBox(height: 8),
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
                    if (value == null || value.trim().isEmpty) {
                      return "Email is required";
                    }
                    // optional: basic email format check
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenHeight * 0.02),

                // PASSWORD
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Password:", style: TextStyle(fontSize: 14)),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
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
                SizedBox(height: screenHeight * 0.02),

                // CONFIRM PASSWORD
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("Confirm Password:", style: TextStyle(fontSize: 14)),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: confirmPassController,
                  obscureText: !_confirmPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_confirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
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
                      return "Confirm your password";
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
                    const Expanded(
                      child: Text(
                        "By signing up, you agree to our Terms & Privacy Policy.",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.015),

                // SIGN UP BUTTON
                ElevatedButton(
                  onPressed: () {
                    // Check inline validation first
                    if (_formKey.currentState!.validate()) {
                      if (!_acceptTerms) {
                        SnackbarUtils.showWarning(context, "Please accept Terms & Privacy Policy");
                        return;
                      }

                      // Success
                      SnackbarUtils.showSuccess(context, "Account Created Successfully");

                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      });
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

                const SizedBox(height: 15),
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
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
