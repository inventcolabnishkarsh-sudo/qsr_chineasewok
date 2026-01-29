import 'package:get/get.dart';
import '../modules/groupmenu/group_menu_binding.dart';
import '../modules/groupmenu/group_menu_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
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
  ];
}
