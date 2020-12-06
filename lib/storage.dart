import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  // Logger Head value

  // Secure Storage
  final _storage = FlutterSecureStorage();

  static const String _token_identifier = '_token_identifier';

  SecureStorageHelper() {
    print('SecureStorageHelper constructes');
  }

  Future<String> getAuthToken() async {
    try {
      return await _storage.read(key: _token_identifier);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> setAuthToken(String token) async {
    try {
      await _storage.write(key: _token_identifier, value: token);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future deleteAll() => _storage.deleteAll();
}
