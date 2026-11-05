import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final Stream<User?> authStateChanges = _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> register(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('You need to sign in first.');
    }
    final email = user.email;
    if (email == null || email.isEmpty) {
      throw StateError('This account does not have an email address.');
    }

    // Verify the current password, including for recently signed-in users.
    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);

    try {
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (error) {
      if (error.code != 'requires-recent-login') rethrow;
      // Recover if Firebase still requires a newer sign-in.
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    }
  }
}

String friendlyAuthError(FirebaseAuthException error) {
  switch (error.code) {
    case 'email-already-in-use':
      return 'This email is already registered. Try signing in.';
    case 'invalid-email':
      return 'Enter a valid email address.';
    case 'weak-password':
      return 'Choose a stronger password.';
    case 'wrong-password':
    case 'user-not-found':
    case 'invalid-credential':
    case 'invalid-login-credentials':
      return 'The email or password could not be verified.';
    case 'too-many-requests':
      return 'Too many attempts. Please try again later.';
    case 'network-request-failed':
      return 'Network error. Check your connection and try again.';
    case 'user-disabled':
      return 'This account is unavailable. Contact support.';
    case 'operation-not-allowed':
      return 'Email/Password sign-in is not enabled in Firebase.';
    case 'requires-recent-login':
      return 'Please sign in again before changing your password.';
    default:
      return 'Something went wrong. Please try again.';
  }
}
