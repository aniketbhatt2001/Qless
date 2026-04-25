import 'package:canteen_mangement/core/usecases/usecase.dart';
import 'package:canteen_mangement/features/auth/domain/repositories/auth_repository.dart';
import 'package:canteen_mangement/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_account_usecase_test.mocks.dart';

/// Unit tests for DeleteAccountUseCase.


@GenerateMocks([AuthRepository])
void main() {
  late DeleteAccountUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = DeleteAccountUseCase(mockRepository);
  });

  group('DeleteAccountUseCase', () {
    test('should complete successfully when account deletion succeeds',
        () async {
      // Arrange: Set up mock to complete successfully
      when(mockRepository.deleteAccount())
          .thenAnswer((_) async => Future.value());

      // Act: Execute the use case
      await useCase(const NoParams());

      // Assert: Verify deleteAccount was called
      verify(mockRepository.deleteAccount());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when repository throws', () async {
      // Arrange: Set up mock to throw exception
      when(mockRepository.deleteAccount())
          .thenThrow(Exception('Deletion failed'));

      // Act & Assert: Verify exception is propagated
      expect(
        () => useCase(const NoParams()),
        throwsException,
      );
      verify(mockRepository.deleteAccount());
    });
  });
}
