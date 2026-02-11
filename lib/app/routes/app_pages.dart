import 'package:get/get.dart';
import '../modules/finalizeorder/finalize_order_binding.dart';
import '../modules/finalizeorder/finalize_order_view.dart';
import '../modules/groupmenu/group_menu_binding.dart';
import '../modules/groupmenu/group_menu_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/idelscreen/idle_screen.dart';
import '../modules/order_summary/order_summary_binding.dart';
import '../modules/order_summary/order_summary_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.groupMenu,
      page: () => const GroupMenuView(),
      binding: GroupMenuBinding(),
    ),
    GetPage(
      name: AppRoutes.orderSummary,
      page: () => const OrderSummaryView(),
      binding: OrderSummaryBinding(),
    ),
    GetPage(
      name: AppRoutes.finalizeOrder,
      page: () => const FinalizeOrderView(),
      binding: FinalizeOrderBinding(),
    ),
    GetPage(name: AppRoutes.idleScreen, page: () => const IdleScreen()),
  ];
}
