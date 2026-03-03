import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth get _firebaseAuth => FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  Future<UserCredential> register({
  required String email,
  required String password,
}) async {
  try {
    final credential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user?.sendEmailVerification();

    print("Email verification sent to ${email}");

    return credential;
  } catch (e) {
    print("Register error: $e");
    rethrow;
  }
}

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}