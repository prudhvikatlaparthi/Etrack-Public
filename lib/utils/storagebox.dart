import 'package:e_track/utils/encryption.dart';
import 'package:get_storage/get_storage.dart';

class StorageBox {
  StorageBox._singleton();

  static final StorageBox instance = StorageBox._singleton();

  final _box = GetStorage();

  Future<void> setFullName(String? value) async {
    await _box.write("FullName", value);
  }

  String getFullName() {
    return _box.read("FullName") ?? '';
  }

  Future<void> setUsername(String value) async {
    await _box.write("Username", aesEncrypt(value));
  }

  String getUsername() {
    return aesDecrypt(_box.read("Username")) ?? '';
  }

  Future<void> setPassword(String value) async {
    await _box.write("Password", value);
  }

  String getPassword() {
    return _box.read("Password") ?? '';
  }

  Future<void> setUserType(String? value) async {
    await _box.write("UserType", value);
  }

  String getUserType() {
    return _box.read("UserType") ?? '';
  }

  Future<void> setDeviceID(String? value) async {
    await _box.write("DEVICE_ID", value);
  }

  String getDeviceID() {
    return _box.read("DEVICE_ID") ?? '';
  }

  Future<void> setStopSync(bool value) async {
    await _box.write("StopSync", value);
  }

  bool isStopSync() {
    return _box.read("StopSync") ?? false;
  }

  Future<void> setProfilePic(String? value) async {
    await _box.write("ProfilePic", value);
  }

  String? getProfilePic() {
    return _box.read("ProfilePic");
  }

  Future<void> setImei(String? value) async {
    await _box.write("IMEI", value);
  }

  String? getImei() {
    return _box.read("IMEI");
  }

  Future<void> setUserId(String? value) async {
    await _box.write("UserId", value);
  }

  String? getUserId() {
    return _box.read("UserId");
  }

  Future<void> clear() async {
    await _box.erase();
  }

  Future<void> setIsLaunched(bool value) async {
    await _box.write("IsLaunched", value);
  }

  bool isLaunched() {
    return _box.read("IsLaunched") ?? false;
  }
}
