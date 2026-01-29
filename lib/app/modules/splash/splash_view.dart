import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// 🔹 Center Logo + Loader
          Center(
            child: AnimatedBuilder(
              animation: controller.animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: controller.fadeAnimation.value,
                  child: Transform.scale(
                    scale: controller.scaleAnimation.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 🔰 Logo
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/logo/logo.png',
                              width: 120,
                              height: 120,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 🏷️ App Name
                        const Text(
                          'QSR Kiosk',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // 📝 Tagline
                        Text(
                          'Fast • Easy • Self Ordering',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            letterSpacing: 0.8,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ⏳ Loading Indicator
                        Obx(() {
                          if (controller.isLoading.value) {
                            return const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation(
                                Colors.deepOrange,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// 🔻 Footer (bottom)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Text(
              '© Powered by Lipi Data Systems Ltd• 2026',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
