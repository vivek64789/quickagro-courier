import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickagrocourier/provider/user_profile_provider.dart';
import 'package:get/get.dart';
import 'package:quickagrocourier/screens/login.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FingerprintProvider extends ChangeNotifier {
  LocalAuthentication _localAuthentication = LocalAuthentication();
  bool? _canCheckBiometrics; // it will check if user can login using biometrics
  List<BiometricType>?
      _availableBiometrics; // it will store all available biometrics such as fingerprint, face or iris
  String? _authorized = "Not Authorized";
  bool isLoading = false;
  bool isAuthenticated = false;
  bool isFingerprintEnabled = false;
  String uid = "";

  changeIsFingerprintEnabled(bool newIsFingerprintEnabled) {
    isFingerprintEnabled = newIsFingerprintEnabled;
    notifyListeners();
  }

  getIsFingerprintEnabled() {
    return isFingerprintEnabled;
  }

  enableFingerprint() async {
    changeIsFingerprintEnabled(true);
    this.uid =
        Provider.of<UserProfileProvider>(Get.context!, listen: false).userId;
    await setFingerprintSharedPreferences();
    notifyListeners();
  }

  disableFingerprint() async {
    changeIsFingerprintEnabled(false);
    this.uid = "";
    await setFingerprintSharedPreferences();
    notifyListeners();
  }

  setFingerprintSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("fingerprint", isFingerprintEnabled);
    prefs.setString("uid", uid);
  }

  getFingerprintSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFingerprintEnabled = prefs.getBool("fingerprint") == null
        ? false
        : prefs.getBool("fingerprint")!;

    this.uid = prefs.getString("uid") == null ? "" : prefs.getString("uid")!;
  }

  // Finger print

  getCanCheckBiometrics() {
    return _canCheckBiometrics;
  }

  getAvailableBiometrics() {
    return _availableBiometrics;
  }

  getAuthorized() {
    return _authorized;
  }

  getIsAuthenticated() {
    return isAuthenticated;
  }

  // Function to allow the user to login using biometrics
  Future<void> checkBiometrics() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    _canCheckBiometrics = canCheckBiometrics;
    notifyListeners();
  }

  // get available biometrics sensor in the user device
  Future<void> fetchAvailableBiometrics() async {
    List<BiometricType>? availableBiometrics;
    try {
      availableBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    _availableBiometrics = availableBiometrics;
    notifyListeners();
  }

  // main function that will allow to authenticate the user
  Future<void> authenticateUser() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: "Please authenticate to continue",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    _authorized = authenticated ? "Authorized" : "Not Authorized";
    isAuthenticated = authenticated;
    notifyListeners();
  }
}
