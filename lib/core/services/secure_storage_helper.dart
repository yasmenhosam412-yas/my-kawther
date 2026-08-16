import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> safeRead(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      debugPrint("SecureStorage read error for key [$key]: $e");
      if (e.toString().contains('BAD_DECRYPT') ||
          e.toString().contains('BadPaddingException')) {
        await _storage.delete(key: key);
        debugPrint("Cleared corrupted key: $key");
      }
      return null;
    }
  }

  Future<void> safeWrite(String key, String? value) async {
    if (value == null) return;
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      debugPrint("SecureStorage write error for key [$key]: $e");
    }
  }

  Future<void> delete(String key) async => _storage.delete(key: key);

  Future<void> clearAll() async => _storage.deleteAll();
}
