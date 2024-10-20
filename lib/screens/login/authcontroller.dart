import 'package:e_track/models/auth_response.dart';
import 'package:e_track/screens/home/homecontroller.dart';
import 'package:e_track/utils/encryption.dart';
import 'package:e_track/utils/storagebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../network/api_service.dart';
import '../../utils/global.dart';
import '../../utils/strings.dart';
import '../home/home_screen.dart';

class AuthController extends GetxController {
  final emailTextController = TextEditingController(text: '');
  final passwordTextController = TextEditingController(text: "");
  final version = 'App Version:'.obs;

  void doLogin() async {
    final email = emailTextController.text;
    String? password = passwordTextController.text;
    if (email.isEmpty || password.isEmpty) {
      showToast(message: "Please enter Username/Password");
      return;
    }
    password = aesEncrypt(password);
    await authenticate(email, password);
  }

  Future<void> authenticate(String email, String? password) async {
    showLoader();
    try {
      final response = await ApiService.instance.request(
        '/user/user_secure_login',
        DioMethod.post,
        formData: {
          'mobile_number': email,
          'user_type': 'Customer',
          'password': password,
          'device_token': await StorageBox.instance.getDeviceID()
        },
        contentType: 'application/json',
      );
      dismissLoader();
      if (response.statusCode == 200) {
        AuthResponse authResponse = AuthResponse.fromJson(response.data);
        if (authResponse.status == true) {
          AuthData authData = authResponse.data![0];
          await StorageBox.instance.setUsername(email);
          await StorageBox.instance.setPassword(password!);
          await StorageBox.instance
              .setFullName("${authData.firstName} ${authData.lastName}");
          await StorageBox.instance.setProfilePic(authData.profileImage);
          await StorageBox.instance.setUserId(authData.userId);
          await StorageBox.instance.setUserType(authData.userType);
          Get.delete<HomeController>();
          Get.off(() => const HomeScreen());
          Get.delete<AuthController>();
        } else {
          showToast(message: response.data['message']);
        }
      } else {
        showToast(message: response.statusMessage ?? networkErrorMsg);
      }
    } catch (e) {
      dismissLoader();
      showToast(message: e.toString());
    }
  }

  Future<void> autoLogin() async {
    final username = await StorageBox.instance.getUsername();
    final password = await StorageBox.instance.getPassword();
    emailTextController.text = username;
    passwordTextController.text = aesDecrypt(password) ?? '';
    authenticate(username, password);
  }

  Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    version.value =  'App Version: ${info.version}';
  }
}
