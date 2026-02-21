import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/signalr_service.dart';
import '../../home/home_controller.dart';

class Header extends StatelessWidget {
  final OrderType orderType;
  const Header(this.orderType);

  @override
  Widget build(BuildContext context) {
    final isDineIn = orderType == OrderType.dineIn;
    final signalR = Get.find<SignalRService>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: const BoxDecoration(color: Colors.black),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// 🏷️ LOGO
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/logo/homelogo.png',
                        height: 50,
                      ),
                    ],
                  ),

                  /// RIGHT SECTION
                  Row(
                    children: [
                      /// 🟢 ORDER TYPE BADGE (Premium Pill)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF8C42), Color(0xFFFF6A00)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          isDineIn ? 'DINE IN' : 'TAKEAWAY',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      const SizedBox(width: 24),

                      /// 🏠 HOME BUTTON (Premium Circular Style)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                          },
                          child: Ink(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF8C42), Color(0xFFFF6A00)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.home_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        /// 🔥 UPDATE BANNER (AUTO REACTIVE)
        Obx(() {
          if (!signalR.hasPendingUpdate.value) {
            return const SizedBox();
          }

          return Container(
            height: 36,
            color: Colors.red.shade700,
            child: const _ScrollingText(),
          );
        }),
      ],
    );
  }
}

/// 🔥 Animated Scrolling Text
class _ScrollingText extends StatefulWidget {
  const _ScrollingText();

  @override
  State<_ScrollingText> createState() => _ScrollingTextState();
}

class _ScrollingTextState extends State<_ScrollingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(1 - _controller.value * 2, 0),
          child: child,
        );
      },
      child: const Center(
        child: Text(
          "🎉 Hurreeyy! A new menu update is available. Head to the Home screen to update now.",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
