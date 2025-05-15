import 'package:finney/core/storage/local/models/user/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_storage_service.dart';
class UserCloudService {
  final FirebaseStorageService _storage;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collection = 'user_profiles';
  
  UserCloudService(this._storage);
  
  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Get current user profile from Firestore
  Future<UserModel?> getCurrentUserProfile() async {
    if (currentUserId == null) return null;
    
    final userData = await _storage.getDocument(_collection, currentUserId!);
    if (userData == null) return null;
    
    return UserModel.fromMap(userData);
  }
  
  // Create or update user profile
  Future<void> createOrUpdateUserProfile(UserModel user) async {
    if (currentUserId == null) throw Exception('User not logged in');
    
    await _storage.setDocument(
      _collection, 
      currentUserId!, 
      user.toMap(),
      merge: true
    );
  }
  
  // Update specific user fields
  Future<void> updateUserFields(Map<String, dynamic> fields) async {
    if (currentUserId == null) throw Exception('User not logged in');
    
    await _storage.updateDocument(
      _collection,
      currentUserId!,
      fields,
    );
  }
  
  // Stream user profile for real-time updates
  Stream<UserModel?> streamUserProfile() {
    if (currentUserId == null) return Stream.value(null);
    
    return _storage.streamDocument(_collection, currentUserId!)
      .map((userData) => userData != null ? UserModel.fromMap(userData) : null);
  }
  
  // Set user's financial information
  Future<void> updateFinancialInfo({
    String? incomeRange,
    String? ageGroup,
    String? financialGoals,
    double? currentBalance,
  }) async {
    if (currentUserId == null) throw Exception('User not logged in');
    
    final updates = <String, dynamic>{};
    if (incomeRange != null) updates['incomeRange'] = incomeRange;
    if (ageGroup != null) updates['ageGroup'] = ageGroup;
    if (financialGoals != null) updates['financialGoals'] = financialGoals;
    if (currentBalance != null) updates['currentBalance'] = currentBalance;
    
    if (updates.isNotEmpty) {
      await _storage.updateDocument(_collection, currentUserId!, updates);
    }
  }
  
  // Update user profile details
  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) async {
    if (currentUserId == null) throw Exception('User not logged in');
    
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (email != null) updates['email'] = email;
    if (phone != null) updates['phone'] = phone;
    if (photoUrl != null) updates['photoUrl'] = photoUrl;
    
    if (updates.isNotEmpty) {
      await _storage.updateDocument(_collection, currentUserId!, updates);
    }
  }
  
  // Delete user profile
  Future<void> deleteUserProfile() async {
    if (currentUserId == null) return;
    
    await _storage.deleteDocument(_collection, currentUserId!);
  }
}