import 'package:get/get.dart';
import 'group_menu_controller.dart';

class GroupMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupMenuController>(() => GroupMenuController());
  }
}
