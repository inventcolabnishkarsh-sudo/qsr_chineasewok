import 'package:get/get.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../../app/modules/splash/menu_data_service.dart';
import '../../app/routes/app_routes.dart';
import '../../core/constants/api_constants.dart';

class SignalRService extends GetxService {
  late HubConnection _hubConnection;

  final RxBool isConnected = false.obs;

  /// ✅ NEW FLAG
  final RxBool hasPendingUpdate = false.obs;
  Future<SignalRService> init() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(ApiConstants.signalR, options: HttpConnectionOptions())
        .withAutomaticReconnect()
        .build();
    _hubConnection.serverTimeoutInMilliseconds = 30000;
    _hubConnection.keepAliveIntervalInMilliseconds = 15000;

    /// 🔹 Listen to server events
    _hubConnection.on("ReceiveNotification", (arguments) async {
      if (arguments == null || arguments.isEmpty) return;

      final message = arguments.first.toString();
      print("📩 Notification: $message");

      if (message == "UpdateMe") {
        final currentRoute = Get.currentRoute;

        if (currentRoute == AppRoutes.home ||
            currentRoute == AppRoutes.idleScreen) {
          print("📍 On Home/Idle → Refreshing Now");

          final menuService = Get.find<MenuDataService>();
          await menuService.refreshMenuFromServer();
        } else {
          print("⛔ Not on Home/Idle → Marking Pending Update");

          /// 🔥 MARK UPDATE AS PENDING
          hasPendingUpdate.value = true;
        }
      }
    });

    /// 🔄 When reconnecting
    _hubConnection.onreconnecting(({Exception? error}) {
      print("🔄 SignalR Reconnecting...");
      print("Error: $error");
      print("State: ${_hubConnection.state}");
      isConnected.value = false;
    });

    /// 🟢 When reconnected
    _hubConnection.onreconnected(({String? connectionId}) {
      print("🟢 SignalR Reconnected");
      print("ConnectionId: $connectionId");
      print("State: ${_hubConnection.state}");
      isConnected.value = true;
    });

    /// ❌ When closed
    _hubConnection.onclose(({error}) {
      print("❌ SignalR Closed: $error");
      print("State: ${_hubConnection.state}");
      isConnected.value = false;
    });

    await _startConnection();

    return this;
  }

  Future<void> checkPendingIfOnValidScreen() async {
    if (!hasPendingUpdate.value) return;

    final currentRoute = Get.currentRoute;

    if (currentRoute == AppRoutes.home ||
        currentRoute == AppRoutes.idleScreen) {
      print("🚀 Processing Pending Update On Route Change");

      hasPendingUpdate.value = false;

      final menuService = Get.find<MenuDataService>();
      await menuService.refreshMenuFromServer();
    }
  }

  Future<void> checkAndProcessPendingUpdate() async {
    if (!hasPendingUpdate.value) return;

    print("🚀 Processing Pending Menu Update");

    hasPendingUpdate.value = false;

    final menuService = Get.find<MenuDataService>();
    await menuService.refreshMenuFromServer();
  }

  Future<void> _startConnection() async {
    try {
      print("🔌 Connecting to SignalR...");
      await _hubConnection.start();

      isConnected.value = true;

      print("🟢 SignalR Connected Successfully");
      print("State: ${_hubConnection.state}");
    } catch (e) {
      isConnected.value = false;

      print("🔴 SignalR Error: $e");
      print("State: ${_hubConnection.state}");
    }
  }

  Future<void> send(String method, List<Object> args) async {
    if (isConnected.value) {
      await _hubConnection.invoke(method, args: args);
    }
  }

  @override
  void onClose() {
    _hubConnection.stop();
    super.onClose();
  }
}
