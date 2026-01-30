import 'package:get/get.dart';
import 'finalize_order_controller.dart';

class FinalizeOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FinalizeOrderController());
  }
}
