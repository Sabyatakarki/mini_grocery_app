import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mini_grocery/core/constants/hive_table_constant.dart';
import 'package:mini_grocery/features/auth/data/models/auth_hive_model.dart';
import 'package:mini_grocery/features/profile/data/models/profile_hive_model.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});
class HiveService {
  static bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.profileTypeId)) {
      Hive.registerAdapter(ProfileHiveModelAdapter());
    }

    if (!Hive.isBoxOpen(HiveTableConstant.authTable)) {
      await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    }

    if (!Hive.isBoxOpen(HiveTableConstant.profileTable)) {
      await Hive.openBox<ProfileHiveModel>(HiveTableConstant.profileTable);
    }

    _initialized = true;
  }

  Box<AuthHiveModel> get _authBox => Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  Box<ProfileHiveModel> get _profileBox => Hive.box<ProfileHiveModel>(HiveTableConstant.profileTable);

  // ================= AUTH =================
  Future<AuthHiveModel> register(AuthHiveModel user) async {
    await init();
    await _authBox.put(user.authId, user);
    return user;
  }

  AuthHiveModel? login(String email, String password) {
    try {
      return _authBox.values.firstWhere(
        (user) =>
            user.email.trim().toLowerCase() == email.trim().toLowerCase() &&
            user.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  AuthHiveModel? getUserById(String authId) => _authBox.get(authId);

  Future<AuthHiveModel?> getUserByEmail(String email) async {
    try {
      return _authBox.values.firstWhere(
        (user) => user.email.trim().toLowerCase() == email.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> updateUser(AuthHiveModel user) async {
    if (_authBox.containsKey(user.authId)) {
      await _authBox.put(user.authId, user);
      return true;
    }
    return false;
  }

  Future<void> deleteUser(String authId) async {
    await _authBox.delete(authId);
  }

  // ================= PROFILE =================
  Future<ProfileHiveModel?> getProfileByUserId(String userId) async {
    await init();
    try {
      return _profileBox.get(userId);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProfile(ProfileHiveModel profile) async {
    await init();
    await _profileBox.put(profile.userId, profile);
  }

  Future<bool> updateProfile(ProfileHiveModel profile) async {
    await init();
    if (profile.userId != null && _profileBox.containsKey(profile.userId)) {
      await _profileBox.put(profile.userId, profile);
      return true;
    }
    return false;
  }

  Future<void> deleteProfile(String userId) async {
    await init();
    await _profileBox.delete(userId);
  }

  // ================= SESSION =================
  Future<void> setLoginSession(String userId) async {
    await init();
    final sessionBox = await Hive.openBox<String>('session');
    await sessionBox.put('loggedInUserId', userId);
  }

  Future<void> clearLoginSession() async {
    final sessionBox = await Hive.openBox<String>('session');
    await sessionBox.delete('loggedInUserId');
  }

  Future<bool> isLoggedIn() async {
    final sessionBox = await Hive.openBox<String>('session');
    return sessionBox.containsKey('loggedInUserId');
  }

  Future<String?> getLoggedInUserId() async {
    final sessionBox = await Hive.openBox<String>('session');
    return sessionBox.get('loggedInUserId');
  }
}

