import 'package:flutter/material.dart';
import 'package:mini_grocery/screens/loginpagescreen.dart';

class Onboardingscreen extends StatefulWidget {
  const Onboardingscreen({super.key});

  @override
  State<Onboardingscreen> createState() => _OnboardingscreenState();
}

class _OnboardingscreenState extends State<Onboardingscreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/screen.jpg",
      "title": "Fresh Groceries, Every Time",
      "subtitle":
          "Get farm-fresh fruits, veggies, and essentials delivered right to your doorstep."
    },
    {
      "image": "assets/images/screen2.jpg",
      "title": "Shop in a Snap",
      "subtitle":
          "Browse, add to cart, and checkout in just a few taps. Shopping made simple."
    },
    {
      "image": "assets/images/screen3.jpg",
      "title": "Fast & Reliable Delivery",
      "subtitle":
          "Your groceries arrive on time, every time, so you never run out of essentials."
    },
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 28),
                      onPressed: () {
                        _controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                    ),
                ],
              ),
            ),

            
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        // APP TITLE
                        Text(
                          "Fresh picks",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                            fontFamily: 'Poppins',
                          ),
                        ),

                        const SizedBox(height: 20),

                        // IMAGE
                        Image.asset(
                          onboardingData[index]["image"]!,
                          height: height * 0.35,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(height: 25),

                        // TITLE
                        Text(
                          onboardingData[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // SUBTITLE
                        Text(
                          onboardingData[index]["subtitle"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // BUTTON
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: width * 0.8,
                child: ElevatedButton(
                  onPressed: () {
                   if (_currentPage == onboardingData.length - 1) {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
                    }
                    else {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 133, 208, 86),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage == onboardingData.length - 1
                        ? "Start"
                        : "Next",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
