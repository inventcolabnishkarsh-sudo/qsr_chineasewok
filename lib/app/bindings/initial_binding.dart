import 'package:get/get.dart';
import '../../core/network/dio_client.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    /// 🌐 Network (single instance)
    Get.put<DioClient>(DioClient(), permanent: true);
  }
}
