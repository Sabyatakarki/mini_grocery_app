import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 20),
            _offerBanner(),
            const SizedBox(height: 20),
            _categories(),
            const SizedBox(height: 20),
            const Text(
              "Irresistible offers",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'OpenSansRegular'
                
              ),
            ),
            const SizedBox(height: 12),
            _productGrid(),
          ],
        ),
      ),
    );
  }

  // 🔔 Header
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Make your life\nhealthy!!",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'OpenSansbold'
          ),
        ),
        Icon(Icons.notifications_none, size: 28),
      ],
    );
  }

  // 🟡 Offer Banner
  Widget _offerBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF4F66A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Get your veggies\nat 15% off",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'OpenSansRegular'
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffC7E85E),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("Buy now"),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Image.asset(
              'assets/images/veggies.png',
              height: 110,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  // 🧺 Categories
  Widget _categories() {
    final categories = [
      {"icon": Icons.fastfood, "label": "Snacks"},
      {"icon": Icons.set_meal, "label": "Meat"},
      {"icon": Icons.local_drink, "label": "Beverage"},
      {"icon": Icons.eco, "label": "Veggies"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: categories.map((cat) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xffF4F66A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(cat["icon"] as IconData),
              ),
              const SizedBox(height: 6),
              Text(cat["label"] as String),
            ],
          );
        }).toList(),
      ),
    );
  }

  // 🛒 Product Grid
  Widget _productGrid() {
    final products = [
      {"name": "Apples", "price": "Rs 225/-"},
      {"name": "Tomato", "price": "Rs 130/-"},
      {"name": "Juice", "price": "Rs 130/-"},
      {"name": "Banana", "price": "Rs 130/-"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final product = products[index];

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "15% Off",
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Center(
                    child: Image.asset(
                      _getProductImage(product["name"]!),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Text(
                  product["name"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  product["price"]!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffC7E85E),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("Add to cart"),
                    ),
                    const Icon(Icons.favorite_border),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔹 Helper: Map product names to image assets
  String _getProductImage(String name) {
    switch (name) {
      case "Apples":
        return "assets/images/apple.jpg";
      case "Tomato":
        return "assets/images/tomato.jpg";
      case "Banana":
        return "assets/images/banana.jpg";
      case "Juice":
        return "assets/images/juices.jpg";
      default:
        return "assets/images/apple.jpg";
    }
  }
}
