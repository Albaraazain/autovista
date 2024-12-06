// lib/models/user_model.dart
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String location;
  final String? profileImageUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.location,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'location': location,
      'profile_image_url': profileImageUrl ?? '',
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      location: map['location'] ?? '',
      profileImageUrl: map['profile_image_url'],
    );
  }
}
