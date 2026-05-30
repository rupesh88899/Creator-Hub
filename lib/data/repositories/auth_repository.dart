import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const _sessionKey = 'user_session';

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  Stream<UserModel?> get authState {
    return _authService.authStateChanges.map((user) {
      if (user != null) {
        _firestoreService.getUser(user.uid).then((doc) {
          if (doc.exists) {
            _currentUser = UserModel.fromMap(
              doc.data() as Map<String, dynamic>,
            );
          }
        });
      } else {
        _currentUser = null;
      }
      return _currentUser;
    });
  }

  Future<void> checkSession() async {
    final session = await _secureStorage.read(key: _sessionKey);
    if (session != null && _authService.currentUser != null) {
      final doc = await _firestoreService.getUser(_authService.currentUser!.uid);
      if (doc.exists) {
        _currentUser = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    }
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final credential = await _authService.signUp(
      email: email,
      password: password,
    );
    await _firestoreService.createUser(
      uid: credential.user!.uid,
      email: email,
      name: name,
    );
    await _secureStorage.write(key: _sessionKey, value: credential.user!.uid);
    _currentUser = UserModel(
      uid: credential.user!.uid,
      email: email,
      name: name,
    );
    return _currentUser!;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _authService.login(
      email: email,
      password: password,
    );
    final doc = await _firestoreService.getUser(credential.user!.uid);
    if (!doc.exists) {
      await _firestoreService.createUser(
        uid: credential.user!.uid,
        email: email,
        name: credential.user!.displayName ?? email.split('@').first,
      );
    }
    await _secureStorage.write(key: _sessionKey, value: credential.user!.uid);
    final userData = doc.exists
        ? doc.data() as Map<String, dynamic>
        : {'uid': credential.user!.uid, 'email': email, 'name': email.split('@').first};
    _currentUser = UserModel.fromMap(userData);
    return _currentUser!;
  }

  Future<void> logout() async {
    await _authService.logout();
    await _secureStorage.delete(key: _sessionKey);
    _currentUser = null;
  }
}
