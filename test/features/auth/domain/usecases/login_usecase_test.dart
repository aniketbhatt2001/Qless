import 'package:canteen_mangement/features/auth/domain/entities/auth_result_entity.dart';
import 'package:canteen_mangement/features/auth/domain/entities/user_entity.dart';
import 'package:canteen_mangement/features/auth/domain/repositories/auth_repository.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'login_usecase_test.mocks.dart';

/// Unit tests for LoginUseCase.
///
/// Tests the business logic of user login without depending on
/// data layer implementation or UI layer.
/// Follows Flutter Playbook testing guidelines.
@GenerateMocks([AuthRepository])
void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  group('LoginUseCase', () {
    const tPhone = '1234567890';
    const tPassword = 'password123';
    const tToken = 'test_token_123';
    const tUser = UserEntity(
      id: '1',
      name: 'Test User',
      phone: tPhone,
    );
    final tAuthResult = AuthResultEntity(user: tUser, token: tToken);

    test('should return AuthResultEntity when login is successful', () async {
      // Arrange: Set up mock to return successful result
      when(mockRepository.login(tPhone, tPassword))
          .thenAnswer((_) async => tAuthResult);

      // Act: Execute the use case
      final result = await useCase(
        const LoginParams(phone: tPhone, password: tPassword),
      );

      // Assert: Verify the result matches expected values
      expect(result.user, tUser);
      expect(result.token, tToken);
      verify(mockRepository.login(tPhone, tPassword));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when repository throws', () async {
      // Arrange: Set up mock to throw exception
      when(mockRepository.login(tPhone, tPassword))
          .thenThrow(Exception('Login failed'));

      // Act & Assert: Verify exception is propagated
      expect(
        () => useCase(const LoginParams(phone: tPhone, password: tPassword)),
        throwsException,
      );
      verify(mockRepository.login(tPhone, tPassword));
    });
  });
}
