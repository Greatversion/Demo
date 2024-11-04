import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mambo/models/Database%20models/auth_user_model.dart';
import '../services/Database Functions/user_service.dart';

class UserProfileProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _userModel;
  bool _isEditing = false;
  bool _isLoading = false;

  // Getters
  UserModel? get userModel => _userModel;
  bool get isEditing => _isEditing;
  bool get isLoading => _isLoading;

  // Text Editing Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String? selectedGender;

  // Fetch user profile data from Firestore and update the text fields
  Future<void> fetchUserProfile() async {
    _setLoading(true);
    try {
      User? firebaseUser = _auth.currentUser;

      if (firebaseUser != null) {
        _userModel = await _firestoreService.getUser(firebaseUser.email!);
        _initializeTextFields();
      }
    } catch (e) {
      debugPrint("Error fetching user profile: $e");
    } finally {
      _setLoading(false);
    }
  }

  // Initialize text fields with existing user data
  void _initializeTextFields() {
    if (_userModel != null) {
      nameController.text = _userModel!.displayName;
      emailController.text = _userModel!.email;
      phoneController.text = _userModel!.phoneNumber ?? '';
      dobController.text = _userModel!.dob != null
          ? _userModel!.dob!.toLocal().toString().split(' ')[0]
          : '';
      selectedGender = _userModel!.gender;
      notifyListeners();
    }
  }

  // Check if any changes have been made to the form
  void checkIfEditing() {
    if (nameController.text != (_userModel?.displayName ?? '') ||
        emailController.text != (_userModel?.email ?? '') ||
        phoneController.text != (_userModel?.phoneNumber ?? '') ||
        dobController.text !=
            (_userModel?.dob?.toLocal().toString().split(' ')[0] ?? '') ||
        selectedGender != _userModel?.gender) {
      _isEditing = true;
    } else {
      _isEditing = false;
    }
    notifyListeners();
  }

  // Update user profile data in Firestore
  Future<void> updateUserProfile() async {
    if (_userModel != null && _isEditing) {
      _setLoading(true);
      _userModel = _userModel!.copyWith(
        displayName: nameController.text,
        phoneNumber: phoneController.text,
        dob: DateTime.tryParse(dobController.text),
        gender: selectedGender,
      );

      try {
        await _firestoreService.updateUser(_userModel!);
        _isEditing = false;
        debugPrint("User profile updated successfully");
      } catch (e) {
        debugPrint("Error updating user profile: $e");
      } finally {
        _setLoading(false);
      }
    }
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
