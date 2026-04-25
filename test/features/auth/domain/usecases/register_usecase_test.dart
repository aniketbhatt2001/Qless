import 'package:canteen_mangement/features/auth/domain/entities/auth_result_entity.dart';
import 'package:canteen_mangement/features/auth/domain/entities/user_entity.dart';
import 'package:canteen_mangement/features/auth/domain/repositories/auth_repository.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_usecase_test.mocks.dart';

/// Unit tests for RegisterUseCase.
///
/// Tests user registration business logic in isolation.
/// Follows Flutter Playbook testing guidelines.
@GenerateMocks([AuthRepository])
void main() {
  late RegisterUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterUseCase(mockRepository);
  });

  group('RegisterUseCase', () {
    const tName = 'Test User';
    const tPhone = '1234567890';
    const tPassword = 'password123';
    const tToken = 'test_token_123';
    const tUser = UserEntity(
      id: '1',
      name: tName,
      phone: tPhone,
    );
    final tAuthResult = AuthResultEntity(user: tUser, token: tToken);

    test('should return AuthResultEntity when registration is successful',
        () async {
      // Arrange: Set up mock to return successful result
      when(mockRepository.register(tName, tPhone, tPassword))
          .thenAnswer((_) async => tAuthResult);

      // Act: Execute the use case
      final result = await useCase(
        const RegisterParams(
          name: tName,
          phone: tPhone,
          password: tPassword,
        ),
      );

      // Assert: Verify the result matches expected values
      expect(result.user.name, tName);
      expect(result.user.phone, tPhone);
      expect(result.token, tToken);
      verify(mockRepository.register(tName, tPhone, tPassword));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when repository throws', () async {
      // Arrange: Set up mock to throw exception
      when(mockRepository.register(tName, tPhone, tPassword))
          .thenThrow(Exception('Registration failed'));

      // Act & Assert: Verify exception is propagated
      expect(
        () => useCase(
          const RegisterParams(
            name: tName,
            phone: tPhone,
            password: tPassword,
          ),
        ),
        throwsException,
      );
      verify(mockRepository.register(tName, tPhone, tPassword));
    });
  });
}
