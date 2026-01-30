import 'package:get/get.dart';
import 'order_summary_controller.dart';

class OrderSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrderSummaryController());
  }
}
