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
        /// 🔥 TOP HEADER BAR
        Container(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/logo/homelogo.png', height: 48),

              Row(
                children: [
                  /// 🏷️ ORDER TYPE BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDineIn ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isDineIn ? 'DINE IN' : 'TAKEAWAY',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  /// 🏠 HOME BUTTON
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      borderRadius: BorderRadius.circular(16),
                      splashColor: Colors.white.withOpacity(0.2),
                      highlightColor: Colors.transparent,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF8C42), Color(0xFFFF6A00)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.4),
                              blurRadius: 12,
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
          "🎉 Hurrey! There is an update in the menu. If you want new items, go to Home.",
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
