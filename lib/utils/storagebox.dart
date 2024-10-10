import 'package:e_track/utils/encryption.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

class StorageBox {
  final lock = Lock();

  StorageBox._singleton();

  static final StorageBox instance = StorageBox._singleton();

  Future<void> setFullName(String? value) async {
    await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      await sp.setString("FullName", value ?? '');
    });
  }

  Future<String> getFullName() async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      return sp.getString("FullName") ?? '';
    });
  }

  Future<void> setUsername(String value) async {
    await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      await sp.setString("Username", aesEncrypt(value) ?? '');
    });
  }

  Future<String> getUsername() async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      return aesDecrypt(sp.getString("Username")) ?? '';
    });
  }

  Future<void> setPassword(String value) async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      await sp.setString("Password", value);
    });
  }

  Future<String> getPassword() async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      return sp.getString("Password") ?? '';
    });
  }

  Future<void> setUserType(String? value) async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      await sp.setString("UserType", value ?? '');
    });
  }

  Future<String> getUserType() async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      return sp.getString("UserType") ?? '';
    });
  }

  Future<void> setDeviceID(String? value) async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      await sp.setString("DEVICE_ID", value ?? '');
    });
  }

  Future<String> getDeviceID() async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      return sp.getString("DEVICE_ID") ?? '';
    });
  }

  Future<void> setStopSync(bool value) async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      await sp.setBool("StopSync", value);
    });
  }

  Future<bool> isStopSync() async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      return sp.getBool("StopSync") ?? false;
    });
  }

  Future<void> setProfilePic(String? value) async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      await sp.setString("ProfilePic", value ?? '');
    });
  }

  Future<String?> getProfilePic() async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      return sp.getString("ProfilePic");
    });
  }

  Future<void> setImei(String? value) async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      await sp.setString("IMEI", value ?? '');
    });
  }

  Future<String?> getImei() async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      return sp.getString("IMEI");
    });
  }

  Future<void> setUserId(String? value) async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      await sp.setString("UserId", value ?? '');
    });
  }

  Future<String?> getUserId() async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      return sp.getString("UserId");
    });
  }

  Future<void> clear() async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      await sp.clear();
    });
  }

  Future<void> setIsLaunched(bool value) async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      await sp.setBool("IsLaunched", value);
    });
  }

  Future<bool> isLaunched() async {
    return await lock.synchronized(() async {
      final sp = await SharedPreferences.getInstance();
      return sp.getBool("IsLaunched") ?? false;
    });
  }
}
