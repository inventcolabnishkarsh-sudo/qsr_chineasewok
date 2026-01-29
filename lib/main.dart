import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/modules/splash/menu_data_service.dart';
import 'app/routes/app_pages.dart';
import 'app/bindings/initial_binding.dart';
import 'app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final menuService = Get.put(MenuDataService(), permanent: true);
  await menuService.loadFromFile(); // ✅ LOAD FILE FIRST

  /// 🔹 Full-screen immersive kiosk mode
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  /// 🔹 Lock app to PORTRAIT only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'QSR Kiosk',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}
