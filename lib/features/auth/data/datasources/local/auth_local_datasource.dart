import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/services/hive/hive_service.dart';
import 'package:mini_grocery/core/services/storage/user_session_service.dart';
import 'package:mini_grocery/features/auth/data/models/auth_hive_model.dart';

//Provider
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return AuthLocalDataSource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});


class AuthLocalDataSource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  AuthLocalDataSource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  })  : _hiveService = hiveService,
        _userSessionService = userSessionService;

  /// Login user
  Future<AuthHiveModel?> login(String email, String password) async {
    final user = _hiveService.login(email, password);
    if (user != null) {
      await _userSessionService.saveUserSession(
        userId: user.authId,
        email: user.email,
        fullName: user.fullName,
        username: user.username,
        phoneNumber: user.phoneNumber,
      );
    }
    return user;
  }

  /// Get current logged in user
  Future<AuthHiveModel?> getCurrentUser() async {
    final loggedIn = _userSessionService.isLoggedIn();
    if (!loggedIn) return null;

    final userId = _userSessionService.getCurrentUserId();
    if (userId == null) return null;

    return _hiveService.getUserById(userId);
  }

  /// Logout user
  Future<bool> logout() async {
    try {
      await _userSessionService.clearSession();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Register new user
  Future<void> register(AuthHiveModel user) async {
    await _hiveService.register(user);
  }

  /// Update user info
  Future<bool> updateUser(AuthHiveModel user) async {
    return await _hiveService.updateUser(user);
  }

  /// Delete user
  Future<bool> deleteUser(String authId) async {
    try {
      await _hiveService.deleteUser(authId);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Get user by email
  Future<AuthHiveModel?> getUserByEmail(String email) async {
    return await _hiveService.getUserByEmail(email);
  }

  /// Get user by ID
  Future<AuthHiveModel?> getUserById(String authId) async {
    return _hiveService.getUserById(authId);
  }
}
