// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tube_vibe/service/user_service.dart';
import 'package:tube_vibe/service/video_service.dart';
import 'package:tube_vibe/model/user_model.dart';
import 'package:tube_vibe/model/video_model.dart';
import 'package:tube_vibe/view/core/snackbar.dart';
import 'package:tube_vibe/view/screens/login/login_screen.dart';
import 'package:tube_vibe/view/screens/main_screen.dart';

class UserProvider with ChangeNotifier {
  UserService userService;

  VideoService videoService = VideoService();
  UserProvider(this.userService);

  final picker = ImagePicker();

  bool _isLoading = false;
  String _error = '';
  UserModel _user = UserModel(name: '', email: '', subscribers: []);
  final List _userModels = [];
  List<UserModel> _searchList = [];
  bool _pickedprofile = false;
  File? _profileFile;

  bool get isLoading => _isLoading;
  String get error => _error;
  UserModel get user => _user;
  List get userModels => _userModels;
  List<UserModel> get searchList => _searchList;
  bool get pickedprofile => _pickedprofile;
  File? get profileFile => _profileFile;
  // Signup
  Future<void> signup(UserModel user, String password, context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;

      await auth
          .createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      )
          .then(
        (value) async {
          if (value.user != null) {
            // Store the user details to new collection
            await value.user?.updateDisplayName(user.name);
            await value.user?.updatePhotoURL(user.profileImg);
            await value.user?.verifyBeforeUpdateEmail(user.email);
            await db.collection('users').doc(value.user?.uid).set(user.toMap());
            await db
                .collection('users')
                .doc(value.user?.uid)
                .update({'id': value.user?.uid});
            _isLoading = false;
            notifyListeners();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MainScreen(),
              ),
            );
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _error = 'Email already in use';
        _isLoading = false;

        notifyListeners();
      } else if (e.code == 'invalid-email') {
        _error = 'Email is invalid';
        _isLoading = false;

        notifyListeners();
      } else if (e.code == 'weak-password') {
        _error = 'Password must be 6 character';
        _isLoading = false;

        notifyListeners();
      } else {
        _error = '${e.message}';
        _isLoading = false;

        notifyListeners();
      }
    }
  }

  Future<void> loginMethod(email, password, context) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Initialize Firebase Authentication
      final FirebaseAuth auth = FirebaseAuth.instance;
      // final FirebaseFirestore db = FirebaseFirestore.instance;
      // Attempt to sign in with the provided email and password
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve the signed-in user from the credential
      final User? user = credential.user;

      // Check if the user is null (not found)
      if (user == null) {
        _isLoading = true;
        notifyListeners();
        // Show a snackbar indicating that the user was not found
        // snackBar(context: context, msg: "User not found");
      }
      _error = '';
      _isLoading = false;
      notifyListeners();
      // Navigate to the MainPage on successful login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        showSnackBar(context, "Email is invalid");
        _isLoading = false;
        notifyListeners();
      } else if (e.code == 'user-not-found') {
        showSnackBar(context, "User not found");

        _isLoading = false;
        notifyListeners();
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, "Wrong password");
        _isLoading = false;
        notifyListeners();
      } else {
        showSnackBar(context, "Wrong password or email");

        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> getUser(userId) async {
    _isLoading = true;

    _user = await userService.getUser(userId);
    _isLoading = false;
    notifyListeners();
  }

  // Future<void> getUsersName(List<VideoModel> userId) async {
  //   // _userModels = await userService.getUsersName(userId);
  //   _isLoading = false;
  //   notifyListeners();
  // }

  Future<void> searchUsers(String query) async {
    _searchList = await userService.searchUsers(query);
    notifyListeners();
  }

  Future<void> logout(context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> subscribeChannel(String currentUserId, String userId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final db = FirebaseFirestore.instance;

      if (docSnapshot.exists) {
        final subByUser =
            docSnapshot.data()!['subscribers']?.contains(currentUserId) ??
                false;

        if (!subByUser) {
          db.collection('users').doc(userId).update({
            'subscribers': FieldValue.arrayUnion([currentUserId]),
          });
          getUser(userId);
        } else {
          db.collection('users').doc(userId).update({
            'subscribers': FieldValue.arrayRemove([currentUserId]),
          });
          getUser(userId);
        }
      }
      // getUser(currentUserId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateName(String userId, String newName) async {
    await userService.updateName(userId, newName);
    await getUser(userId);
    notifyListeners();
  }

  Future<void> updateProfile(userId) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _isLoading = true;
      notifyListeners();

      File imageFile = File(pickedFile.path);
      String profileFileName =
          'profile/${DateTime.now().millisecondsSinceEpoch}.jpg';
      String profileUrl = await videoService.uploadFile(
        imageFile,
        profileFileName,
        (p0) {},
      );

      await userService.updateProfilePic(userId, profileUrl);
      getUser(userId);
      _pickedprofile = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> updateProfilePic(String userId) async {
  //   String profileFileName =
  //       'profile/${DateTime.now().millisecondsSinceEpoch}.jpg';
  //   String profileUrl =
  //       await videoService.uploadFile(profileFile!, profileFileName);

  //   await userService.updateProfilePic(userId, profileUrl);
  //   getUser(userId);
  //   notifyListeners();
  // }
}
