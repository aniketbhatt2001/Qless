import 'package:canteen_mangement/core/usecases/usecase.dart';
import 'package:canteen_mangement/features/auth/domain/repositories/auth_repository.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_usecase_test.mocks.dart';

/// Unit tests for LogoutUseCase.

@GenerateMocks([AuthRepository])
void main() {
  late LogoutUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LogoutUseCase(mockRepository);
  });

  group('LogoutUseCase', () {
    test('should complete successfully when logout succeeds', () async {
      // Arrange: Set up mock to complete successfully
      when(mockRepository.logout()).thenAnswer((_) async => Future.value());

      // Act: Execute the use case
      await useCase(const NoParams());

      // Assert: Verify logout was called
      verify(mockRepository.logout());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when repository throws', () async {
      // Arrange: Set up mock to throw exception
      when(mockRepository.logout()).thenThrow(Exception('Logout failed'));

      // Act & Assert: Verify exception is propagated
      expect(
        () => useCase(const NoParams()),
        throwsException,
      );
      verify(mockRepository.logout());
    });
  });
}
