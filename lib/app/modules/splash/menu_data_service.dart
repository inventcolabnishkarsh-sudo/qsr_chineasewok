import 'package:get/get.dart';

class MenuDataService extends GetxService {
  dynamic outletMenuResponse;

  void setData(dynamic data) {
    outletMenuResponse = data;
  }

  dynamic get data => outletMenuResponse;

  bool get hasData => outletMenuResponse != null;
}
