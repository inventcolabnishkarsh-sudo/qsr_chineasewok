import 'package:get/get.dart';
import '../../app/modules/home/home_controller.dart';

class OrderSessionService extends GetxService {
  final Rx<OrderType?> _orderType = Rx<OrderType?>(null);

  OrderType? get orderType => _orderType.value;

  bool get isDineIn => _orderType.value == OrderType.dineIn;
  bool get isTakeAway => _orderType.value == OrderType.takeaway;

  void setOrderType(OrderType type) {
    _orderType.value = type;
  }

  void clear() {
    _orderType.value = null;
  }
}
