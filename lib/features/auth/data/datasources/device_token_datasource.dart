import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/supabase/supabase_client.dart';

class DeviceTokenDataSource {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<void> registerDeviceToken() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;

      final token = await _messaging.getToken();
      if (token == null) return;

      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final deviceName = await _getDeviceName();

      await supabase.from('user_devices').upsert({
        'user_id': userId,
        'fcm_token': token,
        'platform': Platform.isIOS ? 'ios' : 'android',
        'device_name': deviceName,
        'is_active': true,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id,fcm_token');

      _messaging.onTokenRefresh.listen((newToken) async {
        await supabase.from('user_devices').upsert({
          'user_id': userId,
          'fcm_token': newToken,
          'platform': Platform.isIOS ? 'ios' : 'android',
          'device_name': deviceName,
          'is_active': true,
          'updated_at': DateTime.now().toIso8601String(),
        }, onConflict: 'user_id,fcm_token');
      });
    } catch (e) {
      print('DeviceTokenDataSource error: $e');
    }
  }

  Future<void> deactivateDeviceToken() async {
    try {
      final token = await _messaging.getToken();
      if (token == null) return;

      await supabase
          .from('user_devices')
          .update({
            'is_active': false,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('fcm_token', token);
    } catch (e) {
      print('DeviceTokenDataSource deactivate error: $e');
    }
  }

  Future<String> _getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        return '${info.brand} ${info.model}';
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        return info.isPhysicalDevice ? info.name : 'iOS Simulator';
      }
    } catch (_) {}
    return 'unknown';
  }
}
