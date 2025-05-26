class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? photoUrl;
  final Map<String, dynamic>? preferences;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.photoUrl,
    this.preferences,
  });
  
  // Create a copy with some fields changed
  UserModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      preferences: preferences ?? this.preferences,
    );
  }
  
  // Convert to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'preferences': preferences,
    };
  }
  
  // Create from a Firestore document
  static UserModel fromMap(String docId, Map<String, dynamic> map) {
    return UserModel(
      id: docId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
      photoUrl: map['photoUrl'],
      preferences: map['preferences'],
    );
  }
  
  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, photoUrl: $photoUrl, preferences: $preferences)';
  }
}