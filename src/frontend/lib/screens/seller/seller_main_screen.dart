import 'package:flutter/material.dart';

class SellerMainScreen extends StatefulWidget {
  const SellerMainScreen({super.key});

  @override
  State<SellerMainScreen> createState() => _SellerMainScreenState();
}

class _SellerMainScreenState extends State<SellerMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("Seller"));
  }
}
