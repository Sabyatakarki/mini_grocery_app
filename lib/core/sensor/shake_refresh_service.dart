import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeRefreshService {
  StreamSubscription<AccelerometerEvent>? _subscription;
  DateTime? _lastShakeTime;

  void start({
    required Future<void> Function() onShake,
  }) {
    _subscription = accelerometerEvents.listen((event) async {
      final double shakeStrength =
          event.x.abs() + event.y.abs() + event.z.abs();

      if (shakeStrength > 30) {
        final now = DateTime.now();

        if (_lastShakeTime != null &&
            now.difference(_lastShakeTime!) < const Duration(seconds: 2)) {
          return;
        }

        _lastShakeTime = now;
        await onShake();
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}