import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import 'dart:async';

class IdleScreen extends StatefulWidget {
  const IdleScreen({super.key});

  @override
  State<IdleScreen> createState() => _IdleScreenState();
}

class _IdleScreenState extends State<IdleScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;
  Timer? _sliderTimer;

  final List<String> banners = [
    'assets/images/Chowmein.jpg',
    'assets/images/Kurkure.jpg',
    'assets/images/KV.jpg',
    'assets/images/Superbowl.jpg',
  ];

  @override
  void initState() {
    super.initState();

    _sliderTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      currentPage = (currentPage + 1) % banners.length;
      _controller.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.offAllNamed(AppRoutes.home);
      },
      child: Scaffold(
        body: SizedBox.expand(
          child: PageView.builder(
            controller: _controller,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              return Image.asset(banners[index], fit: BoxFit.fill);
            },
          ),
        ),
      ),
    );
  }
}
