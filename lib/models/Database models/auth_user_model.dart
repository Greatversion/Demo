import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoUrl,
    required this.lastlogIn,
    this.dob,
    this.phoneNumber,
    this.gender,
    this.location,
    this.preferences,
  });

  final String uid;
  final String email;
  final String displayName;
  final String photoUrl;
  final DateTime lastlogIn;
  final DateTime? dob;
  final String? phoneNumber;
  final String? gender;
  final String? location;
  final List<String>? preferences;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'lastlogIn': lastlogIn.toUtc(),
      'dob': dob?.toUtc(),
      'phoneNumber': phoneNumber,
      'gender': gender,
      'location': location,
      'preferences': preferences ?? [],
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String,
      photoUrl: map['photoUrl'] as String,
      lastlogIn: (map['lastlogIn'] as Timestamp).toDate(),
      dob: map['dob'] != null ? (map['dob'] as Timestamp).toDate() : null,
      phoneNumber: map['phoneNumber'] as String?,
      gender: map['gender'] != null ? map['gender'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
      preferences: map['preferences'] != null
          ? List<String>.from(map['preferences'] as List)
          : [],
    );
  }

  // Define the copyWith method
  UserModel copyWith({
    String? uid,
    String? photoUrl,
    String? email,
    String? displayName,
    String? phoneNumber,
    DateTime? dob,
    DateTime? lastlogIn,
    String? gender,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
      lastlogIn: lastlogIn ?? this.lastlogIn,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
    );
  }
}
