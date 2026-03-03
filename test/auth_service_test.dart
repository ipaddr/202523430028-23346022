import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/services/auth_service.dart';

void main() {
  test('AuthService can be created', () {
    final authService = AuthService();
    expect(authService, isNotNull);
  });
}