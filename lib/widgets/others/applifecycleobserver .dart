import 'package:flutter/widgets.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      print('Ứng dụng đang tạm dừng hoặc thoát.');
    }
  }
}
