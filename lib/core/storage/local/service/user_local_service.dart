import 'package:hive/hive.dart';

import '../hive_storage_service.dart';
import '../models/user/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserLocalService {
  final HiveStorageService _storage;
  final String _boxName = 'userBox';
  final String _userKey = 'user';

  UserLocalService(this._storage);

  Future<void> init() async {
    await _storage.getValue('init', boxName: _boxName);
  }

  Future<UserModel?> getCurrentUser() async {
    final box = Hive.box<UserModel>(_boxName);
    return box.get(_userKey);
  }

  Future<void> saveUser(UserModel user) async {
    final box = Hive.box<UserModel>(_boxName);
    await box.put(_userKey, user);
  }
  
  Future<void> updateUser({
    String? name,
    String? email,
    String? incomeRange,
    String? ageGroup,
    String? financialGoals,
    double? currentBalance,
  }) async {
    final currentUser = await getCurrentUser();
    if (currentUser == null) return;
    
    final updatedUser = UserModel(
      uid: currentUser.uid,
      email: email ?? currentUser.email,
      name: name ?? currentUser.name,
      incomeRange: incomeRange ?? currentUser.incomeRange,
      ageGroup: ageGroup ?? currentUser.ageGroup,
      financialGoals: financialGoals ?? currentUser.financialGoals,
      currentBalance: currentBalance ?? currentUser.currentBalance,
    );
    
    await saveUser(updatedUser);
  }

  Future<void> clearUser() async {
    final box = Hive.box<UserModel>(_boxName);
    await box.delete(_userKey);
  }
  
  Future<bool> isUserLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }
  
  Future<void> syncWithFirebaseUser(User? firebaseUser) async {
    if (firebaseUser == null) {
      await clearUser();
      return;
    }
    
    final existingUser = await getCurrentUser();
    if (existingUser != null && existingUser.uid == firebaseUser.uid) {
      // User already exists and matches, no need to update
      return;
    }
    
    // Create new user or update existing one
    final userModel = UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? 'User',
    );
    
    await saveUser(userModel);
  }
}