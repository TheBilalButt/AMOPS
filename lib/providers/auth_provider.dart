/// ================================================
/// File    : auth_provider.dart
/// Module  : Providers
/// Desc    : Authentication state management
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../core/utils/shared_prefs_helper.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthNotifier() : super(AuthState()) {
    _checkSession();
  }

  Future<void> _checkSession() async {
    state = state.copyWith(isLoading: true);
    final uid = await SharedPrefsHelper.getUserUid();
    if (uid != null) {
      try {
        final doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists) {
          state = state.copyWith(
            user: UserModel.fromMap(doc.data()!),
            isLoading: false,
          );
          return;
        }
      } catch (e) {
        state = state.copyWith(error: e.toString(), isLoading: false);
      }
    }
    state = state.copyWith(isLoading: false);
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final doc = await _firestore.collection('users').doc(credential.user!.uid).get();
      if (doc.exists) {
        final userModel = UserModel.fromMap(doc.data()!);
        await SharedPrefsHelper.saveUserSession(userModel.uid, userModel.role);
        state = state.copyWith(user: userModel, isLoading: false);
        return true;
      }
      state = state.copyWith(error: "User profile not found", isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password, String role) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final userModel = UserModel(
        uid: credential.user!.uid,
        name: name,
        email: email,
        role: role,
      );
      
      await _firestore.collection('users').doc(userModel.uid).set(userModel.toMap());
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await SharedPrefsHelper.clearSession();
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
