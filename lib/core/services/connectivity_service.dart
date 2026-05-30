import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final isConnected = true.obs;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() {
    _connectivity.checkConnectivity().then((result) {
      isConnected.value = !result.contains(ConnectivityResult.none);
    });
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      isConnected.value = !result.contains(ConnectivityResult.none);
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
