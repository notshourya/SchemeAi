import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

import '../models/user_form_data.dart';
import '../models/scheme_recommendation.dart';

class FirebaseService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();

    _auth.authStateChanges().listen((User? firebaseUser) {
      user.value = firebaseUser;
    });
  }

  
  bool get isLoggedIn => user.value != null;

  
  User? get currentUser => user.value;

  String? get currentUserId => user.value?.uid;

  Future<UserCredential?> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      print('🔄 Starting user registration for: $email');
      
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ Firebase Auth registration successful for: $email');

      
      await result.user?.updateDisplayName(name);
      print('✅ Display name updated: $name');

      
      if (result.user != null) {
        print('🔄 Creating user profile in Firestore...');
        await _createUserProfile(result.user!, name);
        print('✅ User profile created successfully');
      }

      return result;
    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthException during registration:');
      print('   Code: ${e.code}');
      print('   Message: ${e.message}');
      print('   Details: $e');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ Unexpected error during registration: $e');
      print('   Type: ${e.runtimeType}');
      throw 'An unexpected error occurred during registration: $e';
    }
  }


  Future<UserCredential?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }


  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result = await _auth.signInWithCredential(credential);

      
      if (result.additionalUserInfo?.isNewUser == true && result.user != null) {
        await _createUserProfile(result.user!, result.user!.displayName ?? '');
      }

      return result;
    } catch (e) {
      throw 'Google sign-in failed. Please try again.';
    }
  }

 
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw 'Sign out failed. Please try again.';
    }
  }

  
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> _createUserProfile(User user, String name) async {
    try {
      print('Creating user profile for: ${user.email}');
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': user.email,
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print('User profile created successfully');
    } catch (e) {
      print('Error creating user profile: $e');
     
    }
  }


  Future<void> saveUserFormData(UserFormData formData) async {
    if (currentUserId == null) throw 'User not authenticated';

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('formData')
        .doc('latest')
        .set({
      ...formData.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  
  Future<UserFormData?> getUserFormData() async {
    if (currentUserId == null) return null;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('formData')
          .doc('latest')
          .get();

      if (doc.exists && doc.data() != null) {
        return UserFormData.fromJson(doc.data()!);
      }
    } catch (e) {
      print('Error fetching user form data: $e');
    }
    return null;
  }

  // Save scheme recommendations
  Future<void> saveSchemeRecommendations(
    List<SchemeRecommendation> recommendations,
    UserFormData formData,
  ) async {
    if (currentUserId == null) throw 'User not authenticated';

    final batch = _firestore.batch();

   
    final sessionRef = _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('searchSessions')
        .doc();

    batch.set(sessionRef, {
      'formData': formData.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
      'recommendationsCount': recommendations.length,
    });

    
    for (int i = 0; i < recommendations.length; i++) {
      final recRef = sessionRef.collection('recommendations').doc();
      batch.set(recRef, {
        ...recommendations[i].toJson(),
        'order': i,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  
  Future<List<Map<String, dynamic>>> getSearchHistory({int limit = 10}) async {
    if (currentUserId == null) return [];

    try {
      final query = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('searchSessions')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return query.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e) {
      print('Error fetching search history: $e');
      return [];
    }
  }

  Future<List<SchemeRecommendation>> getSessionRecommendations(String sessionId) async {
    if (currentUserId == null) return [];

    try {
      final query = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('searchSessions')
          .doc(sessionId)
          .collection('recommendations')
          .orderBy('order')
          .get();

      return query.docs
          .map((doc) => SchemeRecommendation.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching session recommendations: $e');
      return [];
    }
  }


  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    if (currentUserId == null) throw 'User not authenticated';

    await _firestore.collection('users').doc(currentUserId).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
}
