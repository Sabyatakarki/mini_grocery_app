import 'package:flutter/material.dart';
import 'package:mini_grocery/screens/getstartedscreen.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 40, left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: Colors.black,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GetStartedScreen(),
                    ),
                  );
                },
              ),
            ),
          ),

        
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 20), // reduces top space

                // Welcome Back text
                Center(
                  child: Text(
                    "Welcome Back",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6BAA44),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    "Get back to your shopping right away",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),

               
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter your email:",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: const Color(0xFFF7FFCF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

          
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter your password:",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: const Icon(Icons.visibility_off),
                    filled: true,
                    fillColor: const Color(0xFFF7FFCF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                const SizedBox(height: 20),

                
                ElevatedButton(
                  onPressed: () {},
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

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account? "),
                    Text(
                      "Create one.",
                      style: const TextStyle(
                        color: Color(0xFF6BAA44),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/loginpage.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
