  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:qsr_chineasewok_kiosk/app/modules/home/widgets/ordercard.dart';
  import '../splash/menu_data_service.dart';
  import 'home_controller.dart';

  class HomeView extends GetView<HomeController> {
    const HomeView({super.key});

    @override
    Widget build(BuildContext context) {
      final menuService = Get.find<MenuDataService>();

      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                // 🖤 HEADER
                SizedBox(
                  height: 140,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 140,
                        color: Colors.black,
                      ),

                      Positioned(
                        top: -60,
                        right: -60,
                        child: RotationTransition(
                          turns: controller.rotationAnimation,
                          child: Image.asset(
                            'assets/images/homeimg.png',
                            width: 220,
                            height: 220,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            'assets/images/logo/homelogo.png',
                            height: 70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔴 RED DIVIDER (brand accent)
                Container(
                  width: double.infinity,
                  height: 3, // 👈 thin & clean
                  color: Colors.red,
                ),
                SizedBox(height: 50),

                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Order ',
                                style: GoogleFonts.pacifico(
                                  fontSize: 48,
                                  letterSpacing: 3,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: 'Here',
                                style: GoogleFonts.pacifico(
                                  fontSize: 48,
                                  letterSpacing: 3,
                                  color: Colors.red,
                                ),
                              ),
                              TextSpan(
                                text: ' !',
                                style: GoogleFonts.pacifico(
                                  fontSize: 48,
                                  letterSpacing: 3,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        Text(
                          'Where would you like to eat?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 40),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OrderCard(
                              title: 'Take Away',
                              subtitle: 'Take your favourite meals to go',
                              imagePath: 'assets/images/takeaway.jpg',
                              onTap: () {
                                if (menuService.isUpdating.value) return;
                                controller.onOrderSelected(OrderType.takeaway);
                              },
                            ),

                            const SizedBox(width: 20),
                            OrderCard(
                              title: 'Dine In',
                              subtitle: 'Enjoy fresh food in our outlet',
                              imagePath: 'assets/images/dinein.jpg',
                              onTap: () {
                                if (menuService.isUpdating.value) return;
                                controller.onOrderSelected(OrderType.dineIn);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                //   buildAdScroller(),
                buildFooter(),
              ],
            ),

            /// 🔴 UPDATE OVERLAY
            Obx(() {
              if (!menuService.isUpdating.value) {
                return const SizedBox.shrink();
              }

              return Positioned.fill(
                child: AbsorbPointer(
                  // 🔒 blocks all touches
                  absorbing: true,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: menuService.isUpdating.value ? 1 : 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.75),
                      child: Center(
                        child: Container(
                          width: 420,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 40,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 30,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// 🔥 BRAND IMAGE (Replace path)
                              Image.asset(
                                'assets/images/logo/homelogo.png', // 👈 your asset
                                height: 80,
                              ),

                              const SizedBox(height: 30),

                              /// 🔄 Animated loader
                              const SizedBox(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.red,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30),

                              const Text(
                                "Updating Menu",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 10),

                              const Text(
                                "Please wait while we refresh\nthe latest items for you.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      );
    }

    Widget buildFooter() {
      return SizedBox(
        height: 80,
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              const Spacer(),
              const Text(
                'Follow us for a\nFoodgasmic Experience',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.3,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 24),
              Row(
                children: [
                  _socialIcon('assets/images/instagram.png'),
                  const SizedBox(width: 14),
                  _socialIcon('assets/images/twitter.png'),
                  const SizedBox(width: 14),
                  _socialIcon('assets/images/youtube.png'),
                  const SizedBox(width: 14),
                  _socialIcon('assets/images/linkedin.png'),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget buildAdScroller() {
      return SizedBox(
        height: 500,
        child: PageView.builder(
          padEnds: false,
          controller: controller.adPageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.ads.length,
          itemBuilder: (context, index) {
            return SizedBox.expand(
              child: Image.asset(
                controller.ads[index],
                fit: BoxFit.fill,
                filterQuality: FilterQuality.low,
              ),
            );
          },
        ),
      );
    }

    Widget _socialIcon(String asset) {
      return Image.asset(asset, width: 22, height: 22);
    }
  }
