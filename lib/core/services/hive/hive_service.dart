import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mini_grocery/core/constants/hive_table_constant.dart';
import 'package:mini_grocery/features/auth/data/models/auth_hive_model.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // Initialize Hive database
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);

    _registerAdapter();
    await _openBoxes();
  }

  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }

  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
  }

  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  // ================= AUTH =================

  /// Register new user
  Future<void> register(AuthHiveModel user) async {
    await _authBox.put(user.authId, user);
  }

  /// Login user (returns AuthHiveModel if credentials match)
  AuthHiveModel? login(String email, String password) {
    try {
      return _authBox.values.firstWhere(
        (user) => user.email == email && (user.password ?? '') == password,
      );
    } catch (_) {
      return null;
    }
  }

  /// Check if email is already registered
  bool isEmailRegistered(String email) {
    return _authBox.values.any((user) => user.email == email);
  }

  /// Get user by ID
  AuthHiveModel? getUserById(String authId) {
    return _authBox.get(authId);
  }

  /// Get user by email
  AuthHiveModel? getUserByEmail(String email) {
    try {
      return _authBox.values.firstWhere((user) => user.email == email);
    } catch (_) {
      return null;
    }
  }

  /// Update user
  Future<bool> updateUser(AuthHiveModel user) async {
    if (_authBox.containsKey(user.authId)) {
      await _authBox.put(user.authId, user);
      return true;
    }
    return false;
  }

  /// Delete user
  Future<void> deleteUser(String authId) async {
    await _authBox.delete(authId);
  }

  // ================= SESSION =================

  /// Save login session
  Future<void> setLoginSession(String authId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('loggedInUserId', authId);
  }

  /// Clear login session
  Future<void> clearLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('loggedInUserId');
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  /// Get currently logged in user ID
  Future<String?> getLoggedInUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUserId');
  }
}
