import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This is Categories screen'),
    );
  }
}